#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace namespace_9dd378ec;

/*
	Name: main
	Namespace: namespace_9dd378ec
	Checksum: 0x55B4A5A8
	Offset: 0x3C0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function main()
{
	level._blackhole_bomb_valid_area_check = &function_a0f14d15;
	level thread function_5b4692c9();
	level thread function_e32302e3();
	level thread radio_easter_eggs();
	level thread function_7624a208();
	level thread function_4947258a();
	level thread function_337aada8();
	level thread function_ba0eb696();
	level thread play_intro_music();
}

/*
	Name: play_intro_music
	Namespace: namespace_9dd378ec
	Checksum: 0xDBD49CF6
	Offset: 0x4A8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function play_intro_music()
{
	level waittill("hash_fd9adc1e");
	level thread zm_audio::sndMusicSystem_PlayState("round_start_first_lander");
}

/*
	Name: power_clangs
	Namespace: namespace_9dd378ec
	Checksum: 0x41C9ABC6
	Offset: 0x4E0
	Size: 0xAD
	Parameters: 0
	Flags: None
*/
function power_clangs()
{
	clangs = struct::get_array("amb_power_clang", "targetname");
	for(i = 0; i < clangs.size; i++)
	{
		playsoundatposition("zmb_circuit", clangs[i].origin);
		wait(RandomFloatRange(0.25, 0.7));
	}
}

/*
	Name: play_cosmo_announcer_vox
	Namespace: namespace_9dd378ec
	Checksum: 0xAFAE44F0
	Offset: 0x598
	Size: 0xFB
	Parameters: 3
	Flags: None
*/
function play_cosmo_announcer_vox(alias, var_33dae1e3, wait_override)
{
	if(!isdefined(alias))
	{
		return;
	}
	if(!isdefined(level.var_93826d64))
	{
		level.var_93826d64 = 0;
	}
	if(!isdefined(var_33dae1e3))
	{
		var_33dae1e3 = 0;
	}
	if(!isdefined(wait_override))
	{
		wait_override = 0;
	}
	if(level.var_93826d64 == 0 && wait_override == 0)
	{
		level.var_93826d64 = 1;
		if(!var_33dae1e3)
		{
			level play_initial_alarm();
		}
		level zm_utility::really_play_2D_sound(alias);
		level.var_93826d64 = 0;
	}
	else if(wait_override == 1)
	{
		level zm_utility::really_play_2D_sound(alias);
	}
}

/*
	Name: function_524d0ceb
	Namespace: namespace_9dd378ec
	Checksum: 0x49B769BA
	Offset: 0x6A0
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function function_524d0ceb(alias)
{
	if(!isdefined(alias))
	{
		return;
	}
	if(!isdefined(level.var_b81d5aac))
	{
		level.var_b81d5aac = 0;
	}
	if(level.var_b81d5aac == 0)
	{
		level.var_b81d5aac = 1;
		level zm_utility::really_play_2D_sound(alias);
		level.var_b81d5aac = 0;
	}
}

/*
	Name: play_initial_alarm
	Namespace: namespace_9dd378ec
	Checksum: 0xB23EBE59
	Offset: 0x718
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function play_initial_alarm()
{
	structs = struct::get_array("amb_warning_siren", "targetname");
	wait(1);
	for(i = 0; i < structs.size; i++)
	{
		playsoundatposition("evt_cosmo_alarm_single", structs[i].origin);
	}
	wait(0.5);
}

/*
	Name: function_e32302e3
	Namespace: namespace_9dd378ec
	Checksum: 0xEFFF50E0
	Offset: 0x7B8
	Size: 0x7D
	Parameters: 0
	Flags: None
*/
function function_e32302e3()
{
	wait(3);
	while(1)
	{
		level flag::wait_till("monkey_round");
		level thread play_cosmo_announcer_vox("vox_ann_monkey_begin");
		level waittill("between_round_over");
		level thread play_cosmo_announcer_vox("vox_ann_monkey_end");
		wait(10);
	}
}

/*
	Name: radio_easter_eggs
	Namespace: namespace_9dd378ec
	Checksum: 0xD5C51A1
	Offset: 0x840
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function radio_easter_eggs()
{
	var_385d0c76 = struct::get_array("radio_egg", "targetname");
	Array::thread_all(var_385d0c76, &function_5fd10b57);
}

/*
	Name: function_5fd10b57
	Namespace: namespace_9dd378ec
	Checksum: 0xC71C7D78
	Offset: 0x8A0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_5fd10b57()
{
	self zm_unitrigger::create_unitrigger();
	self waittill("trigger_activated");
	playsoundatposition("vox_radio_egg_" + self.script_int, self.origin);
}

/*
	Name: function_7624a208
	Namespace: namespace_9dd378ec
	Checksum: 0xBA8E27EF
	Offset: 0x900
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_7624a208()
{
	level thread namespace_52adc03e::function_e753d4f();
	level flag::wait_till("snd_song_completed");
	level thread zm_audio::sndMusicSystem_PlayState("abracadavre");
}

/*
	Name: function_337aada8
	Namespace: namespace_9dd378ec
	Checksum: 0x17F13715
	Offset: 0x968
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_337aada8()
{
	level.var_568da27 = 0;
	var_85d06ae4 = struct::get_array("egg_phone", "targetname");
	while(1)
	{
		level waittill("hash_b524a8eb");
		level.var_568da27++;
		if(level.var_568da27 == var_85d06ae4.size)
		{
			break;
		}
	}
	level notify("hash_2d7a77fa");
	level thread zm_audio::sndMusicSystem_PlayState("not_ready_to_die");
}

/*
	Name: function_10544d8
	Namespace: namespace_9dd378ec
	Checksum: 0xF0F7873
	Offset: 0xA10
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function function_10544d8()
{
	self endon("hash_58b9d0eb");
	self endon("timeout");
	self.t_damage = spawn("trigger_damage", self.origin, 0, 5, 5);
	while(1)
	{
		self.t_damage waittill("damage", n_amount, e_attacker, dir, point, str_means_of_death);
		if(!namespace_52adc03e::function_8090042c())
		{
			continue;
		}
		if(!isPlayer(e_attacker))
		{
			continue;
		}
		if(str_means_of_death != "MOD_MELEE")
		{
			continue;
		}
		if(DistanceSquared(e_attacker.origin, self.origin) > 4225)
		{
			continue;
		}
		break;
	}
	self.broken = 1;
	self notify("hash_b524a8eb");
	if(isdefined(self.var_48df29fd))
	{
		self.var_48df29fd delete();
	}
	level notify("hash_b524a8eb");
	playsoundatposition("zmb_redphone_destroy", self.origin);
	self.t_damage delete();
}

/*
	Name: function_4947258a
	Namespace: namespace_9dd378ec
	Checksum: 0xD73FE40A
	Offset: 0xBD0
	Size: 0x267
	Parameters: 0
	Flags: None
*/
function function_4947258a()
{
	level endon("hash_2d7a77fa");
	var_85d06ae4 = struct::get_array("egg_phone", "targetname");
	var_a008170d = Array(0, 1, 2, 3, 4, 5, 6, 7, 8);
	if(var_85d06ae4.size <= 0)
	{
		return;
	}
	var_693fabd9 = undefined;
	while(1)
	{
		wait(randomIntRange(90, 240));
		while(1)
		{
			var_9d999891 = Array::random(var_85d06ae4);
			ArrayRemoveValue(var_85d06ae4, var_9d999891);
			if(var_85d06ae4.size <= 0)
			{
				var_85d06ae4 = struct::get_array("egg_phone", "targetname");
			}
			if(isdefined(var_9d999891.broken) && var_9d999891.broken)
			{
				continue;
			}
			break;
		}
		activation = var_9d999891 function_de8ef595();
		if(isdefined(activation) && activation)
		{
			var_f1b4932d = Array::random(var_a008170d);
			ArrayRemoveValue(var_a008170d, var_f1b4932d);
			if(var_a008170d.size <= 0)
			{
				var_a008170d = Array(0, 1, 2, 3, 4, 5, 6, 7, 8);
			}
			playsoundatposition("vox_egg_redphone_" + var_f1b4932d, var_9d999891.origin);
			var_693fabd9 = var_f1b4932d;
			wait(30);
		}
	}
}

/*
	Name: function_de8ef595
	Namespace: namespace_9dd378ec
	Checksum: 0x55BE04C
	Offset: 0xE40
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_de8ef595()
{
	level endon("hash_2d7a77fa");
	self endon("hash_b524a8eb");
	self thread function_99199901();
	self thread function_d772340();
	self thread function_10544d8();
	self.var_a3f075d6 = 1;
	str_notify = self util::waittill_any_return("phone_activated", "timeout");
	self.var_a3f075d6 = 0;
	if(isdefined(self.t_damage))
	{
		self.t_damage delete();
	}
	if(str_notify === "timeout")
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_99199901
	Namespace: namespace_9dd378ec
	Checksum: 0x30ECC7A6
	Offset: 0xF30
	Size: 0x197
	Parameters: 0
	Flags: None
*/
function function_99199901()
{
	level endon("hash_2d7a77fa");
	self endon("timeout");
	self endon("hash_b524a8eb");
	self.var_7f6e3a35 = spawn("trigger_radius", self.origin - VectorScale((0, 0, 1), 200), 0, 75, 400);
	self.var_48df29fd = spawn("script_origin", self.origin);
	self.var_48df29fd PlayLoopSound("zmb_egg_phone_loop", 0.05);
	while(1)
	{
		self.var_7f6e3a35 waittill("trigger", who);
		if(!isPlayer(who))
		{
			wait(0.05);
			continue;
		}
		while(who istouching(self.var_7f6e3a35))
		{
			if(who useButtonPressed())
			{
				self notify("hash_58b9d0eb");
				self.var_7f6e3a35 delete();
				self.var_48df29fd delete();
				return;
			}
			wait(0.05);
		}
	}
}

/*
	Name: function_d772340
	Namespace: namespace_9dd378ec
	Checksum: 0x82CEB9D8
	Offset: 0x10D0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_d772340()
{
	level endon("hash_2d7a77fa");
	self endon("hash_58b9d0eb");
	self endon("hash_b524a8eb");
	wait(10);
	self notify("timeout");
	self.var_7f6e3a35 delete();
	self.var_48df29fd delete();
}

/*
	Name: function_ba0eb696
	Namespace: namespace_9dd378ec
	Checksum: 0xC2B93900
	Offset: 0x1148
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function function_ba0eb696()
{
	wait(10);
	for(i = 0; i < 4; i++)
	{
		ent = GetEnt("doll_egg_" + i, "targetname");
		if(!isdefined(ent))
		{
			return;
		}
		ent thread function_25d6399c(i);
	}
}

/*
	Name: function_25d6399c
	Namespace: namespace_9dd378ec
	Checksum: 0x984750
	Offset: 0x11E0
	Size: 0x1B5
	Parameters: 1
	Flags: None
*/
function function_25d6399c(num)
{
	if(!isdefined(self))
	{
		return;
	}
	self UseTriggerRequireLookAt();
	self setcursorhint("HINT_NOICON");
	alias = undefined;
	while(1)
	{
		self waittill("trigger", player);
		index = zm_utility::get_player_index(player);
		switch(index)
		{
			case 0:
			{
				alias = "vox_egg_doll_response_" + num + "_0";
				break;
			}
			case 1:
			{
				alias = "vox_egg_doll_response_" + num + "_1";
				break;
			}
			case 3:
			{
				alias = "vox_egg_doll_response_" + num + "_2";
				break;
			}
			case 2:
			{
				alias = "vox_egg_doll_response_" + num + "_3";
				break;
			}
		}
		self PlaySoundWithNotify(alias, "sounddone" + alias);
		self waittill("sounddone" + alias);
		player zm_audio::create_and_play_dialog("weapon_pickup", "dolls");
		wait(8);
	}
}

/*
	Name: function_a0f14d15
	Namespace: namespace_9dd378ec
	Checksum: 0xB0D56239
	Offset: 0x13A0
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function function_a0f14d15(grenade, model, player)
{
	var_7d5605b7 = GetEnt("sndzhdeggtrig", "targetname");
	if(!isdefined(var_7d5605b7))
	{
		return 0;
	}
	if(model istouching(var_7d5605b7))
	{
		model clientfield::set("toggle_black_hole_deployed", 1);
		level thread function_61c7f9a3(grenade, model, var_7d5605b7);
		return 1;
	}
	return 0;
}

/*
	Name: function_5b4692c9
	Namespace: namespace_9dd378ec
	Checksum: 0xF346DE0A
	Offset: 0x1468
	Size: 0x10D
	Parameters: 0
	Flags: None
*/
function function_5b4692c9()
{
	var_7533f11 = struct::get_array("s_ballerina_bhb", "targetname");
	if(var_7533f11.size <= 0)
	{
		return;
	}
	var_ead6e450 = Array::sort_by_script_int(var_7533f11, 1);
	foreach(var_6d450235 in var_ead6e450)
	{
		var_6d450235 function_2e4843da();
	}
	level flag::set("snd_zhdegg_activate");
	level._blackhole_bomb_valid_area_check = undefined;
}

/*
	Name: function_2e4843da
	Namespace: namespace_9dd378ec
	Checksum: 0xE2E95507
	Offset: 0x1580
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_2e4843da()
{
	self.var_ac086ffb = util::spawn_model(self.model, self.origin, self.angles);
	e_trig = spawn("trigger_radius", self.origin + VectorScale((0, 0, -1), 120), 0, 175, 200);
	e_trig.targetname = "sndzhdeggtrig";
	e_trig.s_target = self;
	e_trig waittill("hash_de264026");
	self.var_ac086ffb delete();
	e_trig delete();
}

/*
	Name: function_61c7f9a3
	Namespace: namespace_9dd378ec
	Checksum: 0x264A5D9E
	Offset: 0x1668
	Size: 0xF3
	Parameters: 3
	Flags: None
*/
function function_61c7f9a3(grenade, model, var_7d5605b7)
{
	wait(1);
	time = 3;
	var_7d5605b7.s_target.var_ac086ffb moveto(grenade.origin + VectorScale((0, 0, 1), 50), time, time - 0.05);
	wait(time);
	playsoundatposition("zmb_gersh_teleporter_out", grenade.origin + VectorScale((0, 0, 1), 50));
	model delete();
	var_7d5605b7 notify("hash_de264026");
}

