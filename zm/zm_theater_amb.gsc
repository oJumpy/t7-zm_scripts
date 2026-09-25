#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;

#namespace namespace_6d4f3e39;

/*
	Name: __init__sytem__
	Namespace: namespace_6d4f3e39
	Checksum: 0xDC89D6E2
	Offset: 0x410
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_theater_amb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_6d4f3e39
	Checksum: 0x6EF5503E
	Offset: 0x450
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "player_dust_mote", 21000, 1, "int");
}

/*
	Name: main
	Namespace: namespace_6d4f3e39
	Checksum: 0xE4E4FEB8
	Offset: 0x490
	Size: 0x257
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread setup_power_on_sfx();
	level thread play_projecter_loop();
	level thread play_projecter_soundtrack();
	level thread setup_meteor_audio();
	level thread setup_radio_egg_audio();
	level thread function_e11d1d5c();
	Array::thread_all(GetEntArray("portrait_egg", "targetname"), &portrait_egg_vox);
	Array::thread_all(GetEntArray("location_egg", "targetname"), &location_egg_vox);
	level thread function_8d1c7be1();
	level thread function_d43815df();
	var_3a067a8d = struct::get_array("trap_electric", "targetname");
	foreach(var_fdce40e2 in var_3a067a8d)
	{
		e_trap = GetEnt(var_fdce40e2.script_noteworthy, "target");
		e_trap thread function_57a1070b();
	}
	level thread function_71554606();
	level.sndTrapFunc = &function_448d83df;
	level.b_trap_start_custom_vo = 1;
}

/*
	Name: function_d43815df
	Namespace: namespace_6d4f3e39
	Checksum: 0xF333CD60
	Offset: 0x6F0
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_d43815df()
{
	level endon("hash_993b920d");
	wait(50);
	var_64ab0444 = GetEnt("amb_0_zombie", "targetname");
	var_64ab0444 PlayLoopSound(var_64ab0444.script_label);
	wait(35);
	while(1)
	{
		Int = randomIntRange(0, 40);
		if(Int == 10)
		{
			var_64ab0444 thread function_ae3642b4();
			level notify("hash_993b920d");
		}
		wait(10);
	}
}

/*
	Name: function_ae3642b4
	Namespace: namespace_6d4f3e39
	Checksum: 0xE769AB6B
	Offset: 0x7D0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_ae3642b4()
{
	self StopLoopSound(0.5);
	playsoundatposition(self.script_sound, self.origin);
}

/*
	Name: setup_power_on_sfx
	Namespace: namespace_6d4f3e39
	Checksum: 0x3DDD697A
	Offset: 0x820
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function setup_power_on_sfx()
{
	wait(5);
	sound_emitters = struct::get_array("amb_power", "targetname");
	level flag::wait_till("power_on");
	level thread play_evil_generator_audio();
	for(i = 0; i < sound_emitters.size; i++)
	{
		sound_emitters[i] thread play_emitter();
	}
}

/*
	Name: play_emitter
	Namespace: namespace_6d4f3e39
	Checksum: 0x69D26A6E
	Offset: 0x8E0
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function play_emitter()
{
	wait(randomIntRange(1, 3));
	playsoundatposition("amb_circuit", self.origin);
	wait(1);
	soundloop = spawn("script_origin", self.origin);
	soundloop PlayLoopSound(self.script_sound);
}

/*
	Name: play_evil_generator_audio
	Namespace: namespace_6d4f3e39
	Checksum: 0xFDC03E5F
	Offset: 0x978
	Size: 0xBD
	Parameters: 0
	Flags: None
*/
function play_evil_generator_audio()
{
	playsoundatposition("zmb_switch_flip", (-482, 1261, 44));
	playsoundatposition("evt_flip_sparks_left", (-544, 1320, 32));
	playsoundatposition("evt_flip_sparks_right", (-400, 1320, 32));
	wait(2);
	playsoundatposition("evt_crazy_power_left", (-304, 1120, 344));
	wait(13);
	level notify("generator_done");
}

/*
	Name: play_projecter_soundtrack
	Namespace: namespace_6d4f3e39
	Checksum: 0xCB2F27EF
	Offset: 0xA40
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function play_projecter_soundtrack()
{
	level waittill("generator_done");
	wait(20);
	speaker = spawn("script_origin", (32, 1216, 592));
	speaker PlayLoopSound("amb_projecter_soundtrack");
}

/*
	Name: play_projecter_loop
	Namespace: namespace_6d4f3e39
	Checksum: 0x68173613
	Offset: 0xAB0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function play_projecter_loop()
{
	level waittill("generator_done");
	projecter = spawn("script_origin", (-72, -144, 384));
	projecter PlayLoopSound("amb_projecter");
}

/*
	Name: setup_meteor_audio
	Namespace: namespace_6d4f3e39
	Checksum: 0x4C3C5636
	Offset: 0xB18
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function setup_meteor_audio()
{
	level thread function_1da885f0();
	level thread namespace_52adc03e::function_e753d4f();
	level flag::wait_till("snd_song_completed");
	level thread zm_audio::sndMusicSystem_PlayState("115");
	wait(4);
	a_e_players = GetPlayers();
	a_e_players = Array::randomize(a_e_players);
	a_e_players[0] thread zm_audio::create_and_play_dialog("eggs", "music_activate");
}

/*
	Name: function_1da885f0
	Namespace: namespace_6d4f3e39
	Checksum: 0x54C58B68
	Offset: 0xC00
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function function_1da885f0()
{
	while(1)
	{
		level waittill("hash_9b53c751", e_player);
		var_c661f4ef = level.var_2a0600f - 1;
		if(var_c661f4ef < 0)
		{
			var_c661f4ef = 0;
		}
		if(isdefined(e_player))
		{
			e_player thread zm_audio::create_and_play_dialog("eggs", "meteors", var_c661f4ef);
		}
	}
}

/*
	Name: function_71554606
	Namespace: namespace_6d4f3e39
	Checksum: 0x70D6A89B
	Offset: 0xC90
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function function_71554606()
{
	level flag::wait_till("start_zombie_round_logic");
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] clientfield::set_to_player("player_dust_mote", 1);
	}
}

/*
	Name: portrait_egg_vox
	Namespace: namespace_6d4f3e39
	Checksum: 0xBF8E5189
	Offset: 0xD18
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function portrait_egg_vox()
{
	if(!isdefined(self))
	{
		return;
	}
	self UseTriggerRequireLookAt();
	self setcursorhint("HINT_NOICON");
	while(1)
	{
		self waittill("trigger", player);
		if(!(isdefined(player.isSpeaking) && player.isSpeaking))
		{
			break;
		}
	}
	type = "portrait_" + self.script_noteworthy;
	player zm_audio::create_and_play_dialog("eggs", type);
}

/*
	Name: location_egg_vox
	Namespace: namespace_6d4f3e39
	Checksum: 0x2753C3FB
	Offset: 0xDF8
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function location_egg_vox()
{
	self waittill("trigger", player);
	if(randomIntRange(0, 101) >= 90)
	{
		type = "room_" + self.script_noteworthy;
		player zm_audio::create_and_play_dialog("eggs", type);
	}
}

/*
	Name: play_radio_egg
	Namespace: namespace_6d4f3e39
	Checksum: 0x40401F46
	Offset: 0xE80
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function play_radio_egg(delay)
{
	if(isdefined(delay))
	{
		wait(delay);
	}
	if(isdefined(self.target))
	{
		s_target = struct::get(self.target, "targetname");
		playsoundatposition("vox_kino_radio_" + level.radio_egg_counter, s_target.origin);
	}
	else
	{
		self playsound("vox_kino_radio_" + level.radio_egg_counter);
	}
	level.radio_egg_counter++;
}

/*
	Name: setup_radio_egg_audio
	Namespace: namespace_6d4f3e39
	Checksum: 0x39E41C12
	Offset: 0xF48
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function setup_radio_egg_audio()
{
	wait(1);
	level.radio_egg_counter = 0;
	Array::thread_all(GetEntArray("audio_egg_radio", "targetname"), &radio_egg_trigger);
}

/*
	Name: radio_egg_trigger
	Namespace: namespace_6d4f3e39
	Checksum: 0x39C51DC6
	Offset: 0xFA8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function radio_egg_trigger()
{
	if(!isdefined(self))
	{
		return;
	}
	self waittill("trigger", who);
	self thread play_radio_egg(undefined);
}

/*
	Name: function_8d1c7be1
	Namespace: namespace_6d4f3e39
	Checksum: 0xF77BDD89
	Offset: 0xFF0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_8d1c7be1()
{
	var_1e717ab1 = GetEnt("alley_door2", "target");
	exploder::stop_exploder("lgt_exploder_crematorium_door");
	var_1e717ab1 waittill("door_opened");
	exploder::exploder("lgt_exploder_crematorium_door");
}

/*
	Name: function_57a1070b
	Namespace: namespace_6d4f3e39
	Checksum: 0x42BC0775
	Offset: 0x1070
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_57a1070b()
{
	level flag::wait_till("power_on");
	var_a58a7b24 = self.target + "_flashes";
	while(1)
	{
		self waittill("trap_done");
		exploder::exploder(var_a58a7b24);
	}
}

/*
	Name: function_448d83df
	Namespace: namespace_6d4f3e39
	Checksum: 0x56EDE9F4
	Offset: 0x10E8
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function function_448d83df(trap, var_cab8c90c)
{
	if(!(isdefined(var_cab8c90c) && var_cab8c90c))
	{
		return;
	}
	player = trap.activated_by_player;
	if(isdefined(trap._trap_type) && trap._trap_type == "fire")
	{
		return;
	}
	else
	{
		player zm_audio::create_and_play_dialog("trap", "start");
	}
}

/*
	Name: function_e11d1d5c
	Namespace: namespace_6d4f3e39
	Checksum: 0xE8AB8AE4
	Offset: 0x1190
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function function_e11d1d5c()
{
	var_8e7ce497 = GetEnt("sndzhd_knocker", "targetname");
	if(!isdefined(var_8e7ce497))
	{
		return;
	}
	while(1)
	{
		wait(randomIntRange(60, 180));
		var_adc6a71a = level function_57f2b10e(var_8e7ce497);
		if(!(isdefined(var_adc6a71a) && var_adc6a71a))
		{
			continue;
		}
		wait(1);
		var_adc6a71a = level function_57f2b10e(var_8e7ce497);
		if(!(isdefined(var_adc6a71a) && var_adc6a71a))
		{
			continue;
		}
		wait(1);
		var_adc6a71a = level function_57f2b10e(var_8e7ce497);
		if(!(isdefined(var_adc6a71a) && var_adc6a71a))
		{
			continue;
		}
		break;
	}
	level flag::set("snd_zhdegg_activate");
}

/*
	Name: function_57f2b10e
	Namespace: namespace_6d4f3e39
	Checksum: 0x8E3E45F8
	Offset: 0x12C8
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_57f2b10e(var_8e7ce497)
{
	var_6140b6dd = level function_314be731();
	level function_5c13c705(var_6140b6dd, var_8e7ce497);
	success = level function_7f30e34a(var_6140b6dd, var_8e7ce497);
	return success;
}

/*
	Name: function_5c13c705
	Namespace: namespace_6d4f3e39
	Checksum: 0xB0BFBAAA
	Offset: 0x1350
	Size: 0x97
	Parameters: 2
	Flags: None
*/
function function_5c13c705(var_6140b6dd, var_8e7ce497)
{
	for(var_918879b9 = 0; var_918879b9 < 3; var_918879b9++)
	{
		wait(1.5);
		for(n_count = 0; n_count < var_6140b6dd[var_918879b9]; n_count++)
		{
			var_8e7ce497 playsound("zmb_zhd_knocker_door");
			wait(0.75);
		}
	}
}

/*
	Name: function_7f30e34a
	Namespace: namespace_6d4f3e39
	Checksum: 0xC90A63D7
	Offset: 0x13F0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function function_7f30e34a(var_6140b6dd, var_8e7ce497)
{
	level thread function_47cc6622(var_6140b6dd, var_8e7ce497);
	str_notify = util::waittill_any_return("zhd_knocker_success", "zhd_knocker_timeout");
	if(str_notify == "zhd_knocker_timeout")
	{
		var_8e7ce497 thread function_702e84d0();
		return 0;
	}
	return 1;
}

/*
	Name: function_47cc6622
	Namespace: namespace_6d4f3e39
	Checksum: 0xEAF9E097
	Offset: 0x1488
	Size: 0x1DD
	Parameters: 2
	Flags: None
*/
function function_47cc6622(var_6140b6dd, var_8e7ce497)
{
	level endon("hash_a0b8e4d9");
	for(var_918879b9 = 0; var_918879b9 < 3; var_918879b9++)
	{
		level thread function_e497b291(3000);
		n_count = 0;
		while(n_count < var_6140b6dd[var_918879b9])
		{
			var_8e7ce497 waittill("damage", damage, attacker, dir, loc, str_type, model, tag, part, weapon, flags);
			if(!isdefined(attacker) || !isPlayer(attacker))
			{
				continue;
			}
			if(isdefined(str_type) && str_type != "MOD_MELEE")
			{
				continue;
			}
			var_8e7ce497 playsound("zmb_zhd_knocker_plr");
			level notify("hash_a5e68e5c");
			n_count++;
			level thread function_e497b291(1000);
		}
		level thread function_4f9527ef(1000);
	}
	wait(0.05);
	level notify("hash_1e121de9");
}

/*
	Name: function_e497b291
	Namespace: namespace_6d4f3e39
	Checksum: 0x41AD9EE1
	Offset: 0x1670
	Size: 0x91
	Parameters: 1
	Flags: None
*/
function function_e497b291(n_max)
{
	level notify("hash_165b5152");
	level endon("hash_165b5152");
	level endon("hash_a5e68e5c");
	level endon("hash_a0b8e4d9");
	level endon("hash_1e121de9");
	var_c9cd8e88 = GetTime();
	n_max = n_max + var_c9cd8e88;
	while(GetTime() < n_max)
	{
		wait(0.05);
	}
	level notify("hash_a0b8e4d9");
}

/*
	Name: function_4f9527ef
	Namespace: namespace_6d4f3e39
	Checksum: 0x27D30769
	Offset: 0x1710
	Size: 0x85
	Parameters: 1
	Flags: None
*/
function function_4f9527ef(n_min)
{
	level notify("hash_b0b21488");
	level endon("hash_b0b21488");
	level endon("hash_a0b8e4d9");
	level endon("hash_1e121de9");
	var_c9cd8e88 = GetTime();
	n_min = n_min + var_c9cd8e88;
	level waittill("hash_a5e68e5c");
	if(GetTime() < n_min)
	{
		level notify("hash_a0b8e4d9");
	}
}

/*
	Name: function_314be731
	Namespace: namespace_6d4f3e39
	Checksum: 0x69CC72FB
	Offset: 0x17A0
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function function_314be731()
{
	var_6140b6dd = Array((1, 1, 5), (9, 3, 5), VectorScale((1, 1, 1), 6), (2, 4, 1), (1, 2, 1), (5, 3, 4), (3, 2, 1), (5, 1, 2), (1, 4, 3), (6, 2, 4));
	var_6140b6dd = Array::randomize(var_6140b6dd);
	return var_6140b6dd[0];
}

/*
	Name: function_702e84d0
	Namespace: namespace_6d4f3e39
	Checksum: 0x30F79F79
	Offset: 0x1878
	Size: 0x4D
	Parameters: 0
	Flags: None
*/
function function_702e84d0()
{
	for(n_count = 0; n_count < 6; n_count++)
	{
		self playsound("zmb_zhd_knocker_door");
		wait(0.25);
	}
}

