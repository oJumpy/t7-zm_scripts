#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_genesis_sound;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_sound
	Checksum: 0x7F1C1528
	Offset: 0x9C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_sound", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_sound
	Checksum: 0x1AFF0063
	Offset: 0xA08
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.sndPlayStateOverride = &function_de04b701;
}

/*
	Name: main
	Namespace: zm_genesis_sound
	Checksum: 0x62670F94
	Offset: 0xA30
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function main()
{
	level thread function_ae93bb6d();
	level thread function_7624a208();
	level thread function_c2fa1ebc();
}

/*
	Name: function_de04b701
	Namespace: zm_genesis_sound
	Checksum: 0x1DFB06F3
	Offset: 0xA88
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function function_de04b701(State)
{
	if(!function_b01e339d(State))
	{
		return 0;
	}
	level thread function_69f1cd9e(State);
	return 1;
}

/*
	Name: function_69f1cd9e
	Namespace: zm_genesis_sound
	Checksum: 0xFAB849C9
	Offset: 0xAD8
	Size: 0x179
	Parameters: 1
	Flags: None
*/
function function_69f1cd9e(State)
{
	foreach(player in level.players)
	{
		location = player function_5d99d675();
		num = function_d6870cf0(State, location);
		num = randomIntRange(1, num + 1);
		if(!isdefined(location))
		{
			return;
		}
		if(State == "round_start_short")
		{
			State = "round_start";
		}
		stateName = State + "_" + location;
		if(State != "game_over")
		{
			stateName = stateName + "_" + num;
		}
		music::setmusicstate(stateName, player);
	}
}

/*
	Name: function_b01e339d
	Namespace: zm_genesis_sound
	Checksum: 0x3207FBE0
	Offset: 0xC60
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_b01e339d(State)
{
	if(State == "round_start" || State == "round_start_short" || State == "round_end" || State == "game_over")
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_5d99d675
	Namespace: zm_genesis_sound
	Checksum: 0xEE6A57FF
	Offset: 0xCC0
	Size: 0x19D
	Parameters: 0
	Flags: None
*/
function function_5d99d675()
{
	str_player_zone = self zm_zonemgr::get_player_zone();
	if(!isdefined(str_player_zone))
	{
		return "genesis";
	}
	if(IsSubStr(str_player_zone, "zm_tomb"))
	{
		return "tomb";
	}
	if(IsSubStr(str_player_zone, "zm_prison"))
	{
		return "motd";
	}
	if(IsSubStr(str_player_zone, "zm_temple"))
	{
		if(str_player_zone == "zm_temple_undercroft_zone" || str_player_zone == "zm_temple_undercroft2_zone" || str_player_zone == "zm_temple_box_zone")
		{
			return "castle";
		}
		else
		{
			return "temple";
		}
	}
	if(IsSubStr(str_player_zone, "zm_castle"))
	{
		return "castle";
	}
	if(IsSubStr(str_player_zone, "zm_theater"))
	{
		return "theater";
	}
	if(IsSubStr(str_player_zone, "zm_asylum"))
	{
		return "asylum";
	}
	if(IsSubStr(str_player_zone, "zm_prototype"))
	{
		return "prototype";
	}
	return "genesis";
}

/*
	Name: function_d6870cf0
	Namespace: zm_genesis_sound
	Checksum: 0xFF0983BF
	Offset: 0xE68
	Size: 0x151
	Parameters: 2
	Flags: None
*/
function function_d6870cf0(State, location)
{
	switch(location)
	{
		case "castle":
		{
			if(State == "round_start")
			{
				return 1;
			}
			if(State == "round_end")
			{
				return 3;
			}
			break;
		}
		case "motd":
		{
			if(State == "round_start")
			{
				return 4;
			}
			if(State == "round_end")
			{
				return 1;
			}
			break;
		}
		case "genesis":
		{
			if(State == "round_start")
			{
				return 3;
			}
			if(State == "round_end")
			{
				return 1;
			}
			break;
		}
		case "tomb":
		{
			if(State == "round_start")
			{
				return 4;
			}
			if(State == "round_end")
			{
				return 1;
			}
		}
		case "theater":
		{
			if(State == "round_start")
			{
				return 2;
			}
			if(State == "round_end")
			{
				return 1;
			}
			break;
		}
	}
	return 1;
}

/*
	Name: function_3fee3760
	Namespace: zm_genesis_sound
	Checksum: 0x34E5A76
	Offset: 0xFC8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function function_3fee3760()
{
	level util::clientNotify("stpThm");
}

/*
	Name: function_ae93bb6d
	Namespace: zm_genesis_sound
	Checksum: 0x3A845AD5
	Offset: 0xFF8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_ae93bb6d()
{
	var_8e47507d = struct::get_array("sndusescare", "targetname");
	if(!isdefined(var_8e47507d))
	{
		return;
	}
	Array::thread_all(var_8e47507d, &function_d75eac4e);
}

/*
	Name: function_d75eac4e
	Namespace: zm_genesis_sound
	Checksum: 0xFB464200
	Offset: 0x1060
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function function_d75eac4e()
{
	if(self.script_sound == "zmb_usescare_sam_phono")
	{
		self thread function_44448bcb();
		return;
	}
	self zm_unitrigger::create_unitrigger(undefined, 35);
	while(1)
	{
		self waittill("trigger_activated");
		playsoundatposition(self.script_sound, self.origin);
		wait(200);
	}
}

/*
	Name: function_44448bcb
	Namespace: zm_genesis_sound
	Checksum: 0x58406DA6
	Offset: 0x10F8
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function function_44448bcb()
{
	var_bc15748 = spawn("trigger_radius_use", self.origin, 0, 100, 100);
	var_bc15748 setHintString("");
	var_bc15748 setcursorhint("HINT_NOICON");
	var_bc15748 TriggerIgnoreTeam();
	var_bc15748 UseTriggerRequireLookAt();
	var_bc15748 waittill("trigger");
	var_bc15748 playsound(self.script_sound);
	wait(120);
	var_bc15748 delete();
}

/*
	Name: function_b18c11d8
	Namespace: zm_genesis_sound
	Checksum: 0x11ABC9C7
	Offset: 0x11F0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_b18c11d8()
{
	level function_4b776d12();
	level thread function_8554d5da();
}

/*
	Name: function_8554d5da
	Namespace: zm_genesis_sound
	Checksum: 0xC7F480EF
	Offset: 0x1230
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function function_8554d5da()
{
	var_d0a6531d = struct::get("old_school_radio", "targetname");
	if(!isdefined(var_d0a6531d))
	{
		return;
	}
	var_99ff4537 = util::spawn_model(var_d0a6531d.model, var_d0a6531d.origin, var_d0a6531d.angles);
	var_99ff4537 SetCanDamage(1);
	var_99ff4537 thread function_2d4f4459();
	var_99ff4537 thread function_f184004e();
	while(1)
	{
		var_99ff4537.health = 1000000;
		var_99ff4537 waittill("damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(!isdefined(attacker) || !isPlayer(attacker))
		{
			continue;
		}
		if(type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE")
		{
			continue;
		}
		if(type == "MOD_MELEE")
		{
			var_99ff4537 notify("hash_dec13539");
		}
		else
		{
			var_99ff4537 notify("hash_34d24635");
		}
	}
}

/*
	Name: function_2d4f4459
	Namespace: zm_genesis_sound
	Checksum: 0x56453277
	Offset: 0x1430
	Size: 0xA7
	Parameters: 0
	Flags: None
*/
function function_2d4f4459()
{
	self.Trackname = undefined;
	self.tracknum = 0;
	while(1)
	{
		self waittill("hash_34d24635");
		if(isdefined(self.var_175c09e5))
		{
			self stopSound(self.var_175c09e5);
			wait(0.05);
		}
		self PlaySoundWithNotify("zmb_minor_skool_radio_switch", "sounddone");
		self waittill("sounddone");
		self thread function_c62f1c37();
	}
}

/*
	Name: function_c62f1c37
	Namespace: zm_genesis_sound
	Checksum: 0xFD0DAE9D
	Offset: 0x14E0
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function function_c62f1c37()
{
	self endon("hash_34d24635");
	self endon("hash_dec13539");
	self PlaySoundWithNotify(level.var_2ec01df2[self.tracknum], "songdone");
	self.var_175c09e5 = level.var_2ec01df2[self.tracknum];
	self.tracknum++;
	if(self.tracknum >= level.var_2ec01df2.size)
	{
		self.tracknum = 0;
	}
	self waittill("songdone");
	self notify("hash_34d24635");
}

/*
	Name: function_f184004e
	Namespace: zm_genesis_sound
	Checksum: 0x3F558359
	Offset: 0x1588
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function function_f184004e()
{
	while(1)
	{
		self waittill("hash_dec13539");
		self PlaySoundWithNotify("zmb_minor_skool_radio_off", "sounddone");
		if(isdefined(self.var_175c09e5))
		{
			self stopSound(self.var_175c09e5);
		}
	}
}

/*
	Name: function_4b776d12
	Namespace: zm_genesis_sound
	Checksum: 0xD7718641
	Offset: 0x15F8
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function function_4b776d12()
{
	level.var_2ec01df2 = Array("mus_genesis_radio_track_1", "mus_genesis_radio_track_2", "mus_genesis_radio_track_3", "mus_genesis_radio_track_4", "mus_genesis_radio_track_5", "mus_genesis_radio_track_6", "mus_genesis_radio_track_7", "mus_genesis_radio_track_8", "mus_genesis_radio_track_9", "mus_genesis_radio_track_10", "mus_genesis_radio_track_11", "mus_genesis_radio_track_12", "mus_genesis_radio_track_13", "mus_genesis_radio_track_14", "mus_genesis_radio_track_15", "mus_genesis_radio_track_16", "mus_genesis_radio_track_17", "mus_genesis_radio_track_18", "mus_genesis_radio_track_19", "mus_genesis_radio_track_20", "mus_genesis_radio_track_21", "mus_genesis_radio_track_22", "mus_genesis_radio_track_23", "mus_genesis_radio_track_24", "mus_genesis_radio_track_25", "mus_genesis_radio_track_26", "mus_genesis_radio_track_27", "mus_genesis_radio_track_28", "mus_genesis_radio_track_29", "mus_genesis_radio_track_30", "mus_genesis_radio_track_31", "mus_genesis_radio_track_33", "mus_genesis_radio_track_32");
}

/*
	Name: function_7624a208
	Namespace: zm_genesis_sound
	Checksum: 0x9CB82700
	Offset: 0x1728
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function function_7624a208()
{
	level.var_51d5c50c = 0;
	level.var_c911c0a2 = struct::get_array("side_ee_song_bear", "targetname");
	Array::thread_all(level.var_c911c0a2, &function_4b02c768);
	while(1)
	{
		level waittill("hash_c3f82290");
		if(level.var_51d5c50c == level.var_c911c0a2.size)
		{
			break;
		}
	}
	level thread function_3fee3760();
	level thread zm_audio::sndMusicSystem_PlayState("the_gift");
	wait(1);
	while(isdefined(level.musicSystem.currentState))
	{
		wait(1);
	}
	level util::clientNotify("strtthm");
}

/*
	Name: function_4b02c768
	Namespace: zm_genesis_sound
	Checksum: 0x1B8BD3D9
	Offset: 0x1840
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function function_4b02c768()
{
	e_origin = spawn("script_origin", self.origin);
	e_origin zm_unitrigger::create_unitrigger();
	e_origin PlayLoopSound("zmb_ee_mus_lp", 1);
	/#
	#/
	while(!(isdefined(e_origin.b_activated) && e_origin.b_activated))
	{
		e_origin waittill("trigger_activated");
		if(isdefined(level.musicSystem.currentPlaytype) && level.musicSystem.currentPlaytype >= 4 || (isdefined(level.musicSystemOverride) && level.musicSystemOverride))
		{
			continue;
		}
		e_origin activate_bear();
	}
	zm_unitrigger::unregister_unitrigger(e_origin.s_unitrigger);
	e_origin delete();
}

/*
	Name: activate_bear
	Namespace: zm_genesis_sound
	Checksum: 0xE4A95BE4
	Offset: 0x1980
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function activate_bear()
{
	if(!(isdefined(self.b_activated) && self.b_activated))
	{
		self.b_activated = 1;
		level.var_51d5c50c++;
		level notify("hash_c3f82290");
		self StopLoopSound(0.2);
	}
	self playsound("zmb_ee_mus_activate");
}

/*
	Name: function_936d084f
	Namespace: zm_genesis_sound
	Checksum: 0x402FB4E0
	Offset: 0x1A08
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_936d084f()
{
	level.musicSystemOverride = 1;
	music::setmusicstate("bossrush");
}

/*
	Name: function_e9341208
	Namespace: zm_genesis_sound
	Checksum: 0x39953B0A
	Offset: 0x1A40
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_e9341208()
{
	level.musicSystemOverride = 1;
	music::setmusicstate("finalfight_start");
}

/*
	Name: function_ecd49d9c
	Namespace: zm_genesis_sound
	Checksum: 0x620E3487
	Offset: 0x1A78
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_ecd49d9c()
{
	level.musicSystemOverride = 1;
	music::setmusicstate("finalfight");
}

/*
	Name: function_d73dcf42
	Namespace: zm_genesis_sound
	Checksum: 0xDAAE936A
	Offset: 0x1AB0
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_d73dcf42()
{
	level.musicSystemOverride = 0;
	music::setmusicstate("none");
}

/*
	Name: function_c2fa1ebc
	Namespace: zm_genesis_sound
	Checksum: 0x5A036F8B
	Offset: 0x1AE8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_c2fa1ebc()
{
	vending_triggers = GetEntArray("zombie_vending", "targetname");
	Array::thread_all(vending_triggers, &function_1d3f00e6);
}

/*
	Name: function_1d3f00e6
	Namespace: zm_genesis_sound
	Checksum: 0x60498EB1
	Offset: 0x1B48
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function function_1d3f00e6()
{
	self endon("hash_55cf60a4");
	var_3628045a = function_692ac4e1(self.script_noteworthy);
	if(!isdefined(var_3628045a))
	{
		return;
	}
	t_bump_trigger = self.bump;
	for(;;)
	{
		t_bump_trigger waittill("trigger", e_player);
		if(isdefined(e_player) && isPlayer(e_player))
		{
			if(isdefined(e_player.perks_active) && e_player.perks_active.size == 9 && (isdefined(self.sndJingleActive) && self.sndJingleActive))
			{
				e_player thread function_97997a8c(self, t_bump_trigger, var_3628045a);
				while(e_player istouching(t_bump_trigger))
				{
					wait(0.05);
				}
				e_player notify("hash_56e16440");
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_97997a8c
	Namespace: zm_genesis_sound
	Checksum: 0x97ACDA2E
	Offset: 0x1C88
	Size: 0x12B
	Parameters: 3
	Flags: None
*/
function function_97997a8c(perk_machine, t_bump_trigger, var_3628045a)
{
	self endon("death");
	self endon("disconnect");
	self endon("player_downed");
	self endon("hash_56e16440");
	while(!self meleeButtonPressed())
	{
		wait(0.05);
	}
	perk_machine notify("hash_55cf60a4");
	perk_machine.sndJingleCooldown = 1;
	perk_machine.var_1afc1154 = 1;
	perk_machine stopSound(perk_machine.str_jingle_alias);
	perk_machine playsound("vox_lyrics_bump");
	playsoundatposition(var_3628045a, t_bump_trigger.origin);
	wait(60);
	perk_machine.var_1afc1154 = 0;
	perk_machine.sndJingleCooldown = 0;
}

/*
	Name: function_692ac4e1
	Namespace: zm_genesis_sound
	Checksum: 0xD97EDB16
	Offset: 0x1DC0
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function function_692ac4e1(perk)
{
	switch(perk)
	{
		case "specialty_doubletap2":
		{
			str_alias = "vox_lyrics_dt";
			break;
		}
		case "specialty_armorvest":
		{
			str_alias = "vox_lyrics_jugg";
			break;
		}
		case "specialty_quickrevive":
		{
			str_alias = "vox_lyrics_revive";
			break;
		}
		case "specialty_fastreload":
		{
			str_alias = "vox_lyrics_speed";
			break;
		}
	}
	return str_alias;
}

