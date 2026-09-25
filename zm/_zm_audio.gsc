#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_audio;

/*
	Name: __init__sytem__
	Namespace: zm_audio
	Checksum: 0x42D46E52
	Offset: 0x758
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_audio
	Checksum: 0x830BA0F9
	Offset: 0x798
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "charindex", 1, 3, "int");
	clientfield::register("toplayer", "isspeaking", 1, 1, "int");
	/#
		println("Dev Block strings are not supported");
	#/
	level.audio_get_mod_type = &get_mod_type;
	level zmbVox();
	callback::on_connect(&init_audio_functions);
	level thread sndAnnouncer_Init();
}

/*
	Name: SetExertVoice
	Namespace: zm_audio
	Checksum: 0x59D1B587
	Offset: 0x890
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function SetExertVoice(exert_id)
{
	self.player_exert_id = exert_id;
	self clientfield::set("charindex", self.player_exert_id);
}

/*
	Name: playerExert
	Namespace: zm_audio
	Checksum: 0x1E24A43E
	Offset: 0x8D8
	Size: 0x1E3
	Parameters: 2
	Flags: None
*/
function playerExert(EXERT, notifywait)
{
	if(!isdefined(notifywait))
	{
		notifywait = 0;
	}
	if(isdefined(self.isSpeaking) && self.isSpeaking || (isdefined(self.isexerting) && self.isexerting))
	{
		return;
	}
	if(isdefined(self.beastmode) && self.beastmode)
	{
		return;
	}
	id = level.exert_sounds[0][EXERT];
	if(isdefined(self.player_exert_id))
	{
		if(!isdefined(level.exert_sounds) || !isdefined(level.exert_sounds[self.player_exert_id]) || !isdefined(level.exert_sounds[self.player_exert_id][EXERT]))
		{
			return;
		}
		if(IsArray(level.exert_sounds[self.player_exert_id][EXERT]))
		{
			id = Array::random(level.exert_sounds[self.player_exert_id][EXERT]);
		}
		else
		{
			id = level.exert_sounds[self.player_exert_id][EXERT];
		}
	}
	if(isdefined(id))
	{
		self.isexerting = 1;
		if(notifywait)
		{
			self PlaySoundWithNotify(id, "done_exerting");
			self waittill("done_exerting");
			self.isexerting = 0;
		}
		else
		{
			self thread exert_timer();
			self playsound(id);
		}
	}
}

/*
	Name: exert_timer
	Namespace: zm_audio
	Checksum: 0x6010C3FA
	Offset: 0xAC8
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function exert_timer()
{
	self endon("disconnect");
	wait(RandomFloatRange(1.5, 3));
	self.isexerting = 0;
}

/*
	Name: zmbVox
	Namespace: zm_audio
	Checksum: 0xB6E8CA47
	Offset: 0xB08
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function zmbVox()
{
	level.votimer = [];
	level.vox = zmbVoxCreate();
	if(isdefined(level._zmbVoxLevelSpecific))
	{
		level thread [[level._zmbVoxLevelSpecific]]();
	}
	if(isdefined(level._zmbVoxGametypeSpecific))
	{
		level thread [[level._zmbVoxGametypeSpecific]]();
	}
	announcer_ent = spawn("script_origin", (0, 0, 0));
	level.vox zmbVoxInitSpeaker("announcer", "vox_zmba_", announcer_ent);
	level.exert_sounds[0]["burp"] = "evt_belch";
	level.exert_sounds[0]["hitmed"] = "null";
	level.exert_sounds[0]["hitlrg"] = "null";
	if(isdefined(level.setupCustomCharacterExerts))
	{
		[[level.setupCustomCharacterExerts]]();
	}
}

/*
	Name: init_audio_functions
	Namespace: zm_audio
	Checksum: 0xEBFB6660
	Offset: 0xC40
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function init_audio_functions()
{
	self thread zombie_behind_vox();
	self thread player_killstreak_timer();
	if(isdefined(level._custom_zombie_oh_shit_vox_func))
	{
		self thread [[level._custom_zombie_oh_shit_vox_func]]();
	}
	else
	{
		self thread oh_shit_vox();
	}
}

/*
	Name: zombie_behind_vox
	Namespace: zm_audio
	Checksum: 0x27DFF9B7
	Offset: 0xCB8
	Size: 0x2F7
	Parameters: 0
	Flags: None
*/
function zombie_behind_vox()
{
	level endon("unloaded");
	self endon("death_or_disconnect");
	if(!isdefined(level._zbv_vox_last_update_time))
	{
		level._zbv_vox_last_update_time = 0;
		level._audio_zbv_shared_ent_list = zombie_utility::get_zombie_array();
	}
	while(1)
	{
		wait(1);
		t = GetTime();
		if(t > level._zbv_vox_last_update_time + 1000)
		{
			level._zbv_vox_last_update_time = t;
			level._audio_zbv_shared_ent_list = zombie_utility::get_zombie_array();
		}
		zombs = level._audio_zbv_shared_ent_list;
		played_sound = 0;
		for(i = 0; i < zombs.size; i++)
		{
			if(!isdefined(zombs[i]))
			{
				continue;
			}
			if(zombs[i].isdog)
			{
				continue;
			}
			dist = 150;
			z_dist = 50;
			alias = level.vox_behind_zombie;
			if(isdefined(zombs[i].zombie_move_speed))
			{
				switch(zombs[i].zombie_move_speed)
				{
					case "walk":
					{
						dist = 150;
						break;
					}
					case "run":
					{
						dist = 175;
						break;
					}
					case "sprint":
					{
						dist = 200;
						break;
					}
				}
			}
			if(DistanceSquared(zombs[i].origin, self.origin) < dist * dist)
			{
				yaw = self zm_utility::GetYawToSpot(zombs[i].origin);
				z_diff = self.origin[2] - zombs[i].origin[2];
				if(yaw < -95 || yaw > 95 && Abs(z_diff) < 50)
				{
					zombs[i] notify("bhtn_action_notify", "behind");
					played_sound = 1;
					break;
				}
			}
		}
		if(played_sound)
		{
			wait(3.5);
		}
	}
}

/*
	Name: oh_shit_vox
	Namespace: zm_audio
	Checksum: 0x96B82E50
	Offset: 0xFB8
	Size: 0x16D
	Parameters: 0
	Flags: None
*/
function oh_shit_vox()
{
	self endon("death_or_disconnect");
	while(1)
	{
		wait(1);
		players = GetPlayers();
		zombs = zombie_utility::get_round_enemy_array();
		if(players.size >= 1)
		{
			close_zombs = 0;
			for(i = 0; i < zombs.size; i++)
			{
				if(isdefined(zombs[i].favoriteenemy) && zombs[i].favoriteenemy == self || !isdefined(zombs[i].favoriteenemy))
				{
					if(DistanceSquared(zombs[i].origin, self.origin) < 62500)
					{
						close_zombs++;
					}
				}
			}
			if(close_zombs > 4)
			{
				self create_and_play_dialog("general", "oh_shit");
				wait(4);
			}
		}
	}
}

/*
	Name: player_killstreak_timer
	Namespace: zm_audio
	Checksum: 0x3B238D26
	Offset: 0x1130
	Size: 0x1DF
	Parameters: 0
	Flags: None
*/
function player_killstreak_timer()
{
	self endon("disconnect");
	self endon("death");
	if(GetDvarString("zombie_kills") == "")
	{
		SetDvar("zombie_kills", "7");
	}
	if(GetDvarString("zombie_kill_timer") == "")
	{
		SetDvar("zombie_kill_timer", "5");
	}
	kills = GetDvarInt("zombie_kills");
	time = GetDvarInt("zombie_kill_timer");
	if(!isdefined(self.timerIsrunning))
	{
		self.timerIsrunning = 0;
		self.killcounter = 0;
	}
	while(1)
	{
		self waittill("zom_kill", zomb);
		if(isdefined(zomb._black_hole_bomb_collapse_death) && zomb._black_hole_bomb_collapse_death == 1)
		{
			continue;
		}
		if(isdefined(zomb.microwavegun_death) && zomb.microwavegun_death)
		{
			continue;
		}
		self.killcounter++;
		if(self.timerIsrunning != 1)
		{
			self.timerIsrunning = 1;
			self thread timer_actual(kills, time);
		}
	}
}

/*
	Name: player_zombie_kill_vox
	Namespace: zm_audio
	Checksum: 0xB068737E
	Offset: 0x1318
	Size: 0x1B3
	Parameters: 4
	Flags: None
*/
function player_zombie_kill_vox(HIT_LOCATION, player, mod, zombie)
{
	weapon = player GetCurrentWeapon();
	dist = DistanceSquared(player.origin, zombie.origin);
	if(!isdefined(level.zombie_vars[player.team]["zombie_insta_kill"]))
	{
		level.zombie_vars[player.team]["zombie_insta_kill"] = 0;
	}
	instakill = level.zombie_vars[player.team]["zombie_insta_kill"];
	death = [[level.audio_get_mod_type]](HIT_LOCATION, mod, weapon, zombie, instakill, dist, player);
	if(!isdefined(death))
	{
		return undefined;
	}
	if(!(isdefined(player.force_wait_on_kill_line) && player.force_wait_on_kill_line))
	{
		player.force_wait_on_kill_line = 1;
		player create_and_play_dialog("kill", death);
		wait(2);
		if(isdefined(player))
		{
			player.force_wait_on_kill_line = 0;
		}
	}
}

/*
	Name: get_response_chance
	Namespace: zm_audio
	Checksum: 0x2DEF7C6
	Offset: 0x14D8
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function get_response_chance(event)
{
	if(!isdefined(level.response_chances[event]))
	{
		return 0;
	}
	return level.response_chances[event];
}

/*
	Name: get_mod_type
	Namespace: zm_audio
	Checksum: 0x6A6BCB82
	Offset: 0x1510
	Size: 0x369
	Parameters: 7
	Flags: None
*/
function get_mod_type(impact, mod, weapon, zombie, instakill, dist, player)
{
	close_dist = 4096;
	med_dist = 15376;
	far_dist = 160000;
	if(weapon.name == "hero_annihilator")
	{
		return "annihilator";
	}
	if(zm_utility::is_placeable_mine(weapon))
	{
		if(!instakill)
		{
			return "betty";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(zombie.damageWeapon.name == "cymbal_monkey")
	{
		if(instakill)
		{
			return "weapon_instakill";
		}
		else
		{
			return "monkey";
		}
	}
	if(weapon.name == "ray_gun" && dist > far_dist)
	{
		if(!instakill)
		{
			return "raygun";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(zm_utility::is_headshot(weapon, impact, mod) && dist >= far_dist)
	{
		return "headshot";
	}
	if(mod == "MOD_MELEE" || mod == "MOD_UNKNOWN" && dist < close_dist)
	{
		if(!instakill)
		{
			return "melee";
		}
		else
		{
			return "melee_instakill";
		}
	}
	if(zm_utility::is_explosive_damage(mod) && weapon.name != "ray_gun" && (!isdefined(zombie.is_on_fire) && zombie.is_on_fire))
	{
		if(!instakill)
		{
			return "explosive";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(weapon.doesFireDamage && (mod == "MOD_BURNED" || mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH"))
	{
		if(!instakill)
		{
			return "flame";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(!isdefined(impact))
	{
		impact = "";
	}
	if(mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET")
	{
		if(!instakill)
		{
			return "bullet";
		}
		else
		{
			return "weapon_instakill";
		}
	}
	if(instakill)
	{
		return "default";
	}
	if(mod != "MOD_MELEE" && zombie.missingLegs)
	{
		return "crawler";
	}
	if(mod != "MOD_BURNED" && dist < close_dist)
	{
		return "close";
	}
	return "default";
}

/*
	Name: timer_actual
	Namespace: zm_audio
	Checksum: 0xDF07C9C
	Offset: 0x1888
	Size: 0xCF
	Parameters: 2
	Flags: None
*/
function timer_actual(kills, time)
{
	self endon("disconnect");
	self endon("death");
	timer = GetTime() + time * 1000;
	while(GetTime() < timer)
	{
		if(self.killcounter > kills)
		{
			self create_and_play_dialog("kill", "streak");
			wait(1);
			self.killcounter = 0;
			timer = -1;
		}
		wait(0.1);
	}
	wait(10);
	self.killcounter = 0;
	self.timerIsrunning = 0;
}

/*
	Name: zmbVoxCreate
	Namespace: zm_audio
	Checksum: 0xA2589B20
	Offset: 0x1960
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function zmbVoxCreate()
{
	vox = spawnstruct();
	vox.speaker = [];
	return vox;
}

/*
	Name: zmbVoxInitSpeaker
	Namespace: zm_audio
	Checksum: 0xFFCC5613
	Offset: 0x19A0
	Size: 0xB3
	Parameters: 3
	Flags: None
*/
function zmbVoxInitSpeaker(speaker, prefix, ent)
{
	ent.zmbVoxID = speaker;
	if(!isdefined(self.speaker[speaker]))
	{
		self.speaker[speaker] = spawnstruct();
		self.speaker[speaker].alias = [];
	}
	self.speaker[speaker].prefix = prefix;
	self.speaker[speaker].ent = ent;
}

/*
	Name: custom_kill_damaged_VO
	Namespace: zm_audio
	Checksum: 0xE97141B5
	Offset: 0x1A60
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function custom_kill_damaged_VO(player)
{
	self notify("sound_damage_player_updated");
	self endon("death");
	self endon("sound_damage_player_updated");
	self.sound_damage_player = player;
	wait(2);
	self.sound_damage_player = undefined;
}

/*
	Name: loadPlayerVoiceCategories
	Namespace: zm_audio
	Checksum: 0x420AC1DC
	Offset: 0x1AB8
	Size: 0x23B
	Parameters: 1
	Flags: None
*/
function loadPlayerVoiceCategories(table)
{
	level.votimer = [];
	level.sndPlayerVox = [];
	index = 0;
	for(row = TableLookupRow(table, index); isdefined(row);  = TableLookupRow(table, index))
	{
		category = checkStringValid(row[0]);
		subcategory = checkStringValid(row[1]);
		suffix = checkStringValid(row[2]);
		percentage = Int(row[3]);
		if(percentage <= 0)
		{
			percentage = 100;
		}
		response = checkStringTrue(row[4]);
		if(isdefined(response) && response)
		{
			for(i = 0; i < 4; i++)
			{
				zmbVoxAdd(category, subcategory + "_resp_" + i, suffix + "_resp_" + i, 50, 0);
			}
		}
		delayBeforePlayAgain = checkIntValid(row[5]);
		zmbVoxAdd(category, subcategory, suffix, percentage, response, delayBeforePlayAgain);
		index++;
	}
}

/*
	Name: checkStringValid
	Namespace: zm_audio
	Checksum: 0x229354A2
	Offset: 0x1D00
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function checkStringValid(STR)
{
	if(STR != "")
	{
		return STR;
	}
	return undefined;
}

/*
	Name: checkStringTrue
	Namespace: zm_audio
	Checksum: 0xF88A98B7
	Offset: 0x1D30
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function checkStringTrue(STR)
{
	if(!isdefined(STR))
	{
		return 0;
	}
	if(STR != "")
	{
		if(ToLower(STR) == "true")
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: checkIntValid
	Namespace: zm_audio
	Checksum: 0x7817D175
	Offset: 0x1D90
	Size: 0x61
	Parameters: 2
	Flags: None
*/
function checkIntValid(value, defaultValue)
{
	if(!isdefined(defaultValue))
	{
		defaultValue = 0;
	}
	if(!isdefined(value))
	{
		return defaultValue;
	}
	if(value == "")
	{
		return defaultValue;
	}
	return Int(value);
}

/*
	Name: zmbVoxAdd
	Namespace: zm_audio
	Checksum: 0x9B960C06
	Offset: 0x1E00
	Size: 0x1F3
	Parameters: 6
	Flags: None
*/
function zmbVoxAdd(category, subcategory, suffix, percentage, response, delayBeforePlayAgain)
{
	if(!isdefined(delayBeforePlayAgain))
	{
		delayBeforePlayAgain = 0;
	}
	/#
		Assert(isdefined(category));
	#/
	/#
		Assert(isdefined(subcategory));
	#/
	/#
		Assert(isdefined(suffix));
	#/
	/#
		Assert(isdefined(percentage));
	#/
	/#
		Assert(isdefined(response));
	#/
	/#
		Assert(isdefined(delayBeforePlayAgain));
	#/
	vox = level.sndPlayerVox;
	if(!isdefined(vox[category]))
	{
		vox[category] = [];
	}
	vox[category][subcategory] = spawnstruct();
	vox[category][subcategory].suffix = suffix;
	vox[category][subcategory].percentage = percentage;
	vox[category][subcategory].response = response;
	vox[category][subcategory].delayBeforePlayAgain = delayBeforePlayAgain;
	zm_utility::create_vox_timer(subcategory);
}

/*
	Name: create_and_play_dialog
	Namespace: zm_audio
	Checksum: 0xF6A81C8F
	Offset: 0x2000
	Size: 0x223
	Parameters: 3
	Flags: None
*/
function create_and_play_dialog(category, subcategory, force_variant)
{
	if(!isdefined(level.sndPlayerVox))
	{
		return;
	}
	if(!isdefined(level.sndPlayerVox[category]))
	{
		return;
	}
	if(!isdefined(level.sndPlayerVox[category][subcategory]))
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				println("Dev Block strings are not supported" + category + "Dev Block strings are not supported" + subcategory + "Dev Block strings are not supported");
			}
		#/
		return;
	}
	if(isdefined(level.sndVoxOverride) && level.sndVoxOverride || (isdefined(self.isSpeaking) && self.isSpeaking && (!isdefined(self.b_wait_if_busy) && self.b_wait_if_busy)))
	{
		return;
	}
	suffix = level.sndPlayerVox[category][subcategory].suffix;
	percentage = level.sndPlayerVox[category][subcategory].percentage;
	prefix = shouldPlayerSpeak(self, category, subcategory, percentage);
	if(!isdefined(prefix))
	{
		return;
	}
	sound_to_play = self zmbVoxGetLineVariant(prefix, suffix, force_variant);
	if(isdefined(sound_to_play))
	{
		self thread do_player_or_npc_playvox(sound_to_play, category, subcategory);
	}
	else
	{
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			iprintln("Dev Block strings are not supported");
		}
	}
	/#
	#/
}

/*
	Name: do_player_or_npc_playvox
	Namespace: zm_audio
	Checksum: 0x958E9326
	Offset: 0x2230
	Size: 0x32B
	Parameters: 3
	Flags: None
*/
function do_player_or_npc_playvox(sound_to_play, category, subcategory)
{
	self endon("death_or_disconnect");
	if(self flag::exists("in_beastmode") && self flag::get("in_beastmode"))
	{
		return;
	}
	if(!isdefined(self.isSpeaking))
	{
		self.isSpeaking = 0;
	}
	if(self.isSpeaking)
	{
		return;
	}
	waitTime = 1;
	if(!self areNearbySpeakersActive() || (isdefined(self.ignoreNearbySpkrs) && self.ignoreNearbySpkrs))
	{
		self.speakingLine = sound_to_play;
		self.isSpeaking = 1;
		if(isPlayer(self))
		{
			self clientfield::set_to_player("isspeaking", 1);
		}
		playbackTime = soundgetplaybacktime(sound_to_play);
		if(!isdefined(playbackTime))
		{
			return;
		}
		if(playbackTime >= 0)
		{
			playbackTime = playbackTime * 0.001;
		}
		else
		{
			playbackTime = 1;
		}
		if(isdefined(level._do_player_or_npc_playvox_override))
		{
			self thread [[level._do_player_or_npc_playvox_override]](sound_to_play, playbackTime);
			wait(playbackTime);
		}
		else if(!self IsTestClient())
		{
			self PlaySoundOnTag(sound_to_play, "J_Head");
			wait(playbackTime);
		}
		if(isPlayer(self) && isdefined(self.last_vo_played_time))
		{
			if(GetTime() < self.last_vo_played_time + 5000)
			{
				self.last_vo_played_time = GetTime();
				waitTime = 7;
			}
		}
		wait(waitTime);
		self.isSpeaking = 0;
		if(isPlayer(self))
		{
			self clientfield::set_to_player("isspeaking", 0);
		}
		if(!level flag::get("solo_game") && (isdefined(level.sndPlayerVox[category][subcategory].response) && level.sndPlayerVox[category][subcategory].response))
		{
			if(isdefined(level.vox_response_override) && level.vox_response_override)
			{
				level thread setup_response_line_override(self, category, subcategory);
			}
			else
			{
				level thread setup_response_line(self, category, subcategory);
			}
		}
	}
}

/*
	Name: setup_response_line_override
	Namespace: zm_audio
	Checksum: 0xF039DD3C
	Offset: 0x2568
	Size: 0x12F
	Parameters: 3
	Flags: None
*/
function setup_response_line_override(player, category, subcategory)
{
	if(isdefined(level._audio_custom_response_line))
	{
		self thread [[level._audio_custom_response_line]](player, category, subcategory);
		break;
	}
	switch(player.characterindex)
	{
		case 0:
		{
			level setup_hero_rival(player, 1, 2, category, subcategory);
			break;
		}
		case 1:
		{
			level setup_hero_rival(player, 2, 3, category, subcategory);
			break;
		}
		case 3:
		{
			level setup_hero_rival(player, 0, 1, category, subcategory);
			break;
		}
		case 2:
		{
			level setup_hero_rival(player, 3, 0, category, subcategory);
			break;
		}
	}
	return;
}

/*
	Name: setup_hero_rival
	Namespace: zm_audio
	Checksum: 0x1FB0577E
	Offset: 0x26A0
	Size: 0x2DB
	Parameters: 5
	Flags: None
*/
function setup_hero_rival(player, hero, rival, category, type)
{
	players = GetPlayers();
	hero_player = undefined;
	rival_player = undefined;
	foreach(ent in players)
	{
		if(ent.characterindex == hero)
		{
			hero_player = ent;
			continue;
		}
		if(ent.characterindex == rival)
		{
			rival_player = ent;
		}
	}
	if(isdefined(hero_player) && isdefined(rival_player))
	{
		if(RandomInt(100) > 50)
		{
			hero_player = undefined;
		}
		else
		{
			rival_player = undefined;
		}
	}
	if(isdefined(hero_player) && DistanceSquared(player.origin, hero_player.origin) < 250000)
	{
		if(isdefined(player.isSamantha) && player.isSamantha)
		{
			hero_player create_and_play_dialog(category, type + "_s");
		}
		else
		{
			hero_player create_and_play_dialog(category, type + "_hr");
		}
	}
	else if(isdefined(rival_player) && DistanceSquared(player.origin, rival_player.origin) < 250000)
	{
		if(isdefined(player.isSamantha) && player.isSamantha)
		{
			rival_player create_and_play_dialog(category, type + "_s");
		}
		else
		{
			rival_player create_and_play_dialog(category, type + "_riv");
		}
	}
}

/*
	Name: setup_response_line
	Namespace: zm_audio
	Checksum: 0xF3E7AECE
	Offset: 0x2988
	Size: 0x113
	Parameters: 3
	Flags: None
*/
function setup_response_line(player, category, subcategory)
{
	players = Array::get_all_closest(player.origin, level.activePlayers);
	players_that_can_respond = Array::exclude(players, player);
	if(players_that_can_respond.size == 0)
	{
		return;
	}
	player_to_respond = players_that_can_respond[0];
	if(DistanceSquared(player.origin, player_to_respond.origin) < 250000)
	{
		player_to_respond create_and_play_dialog(category, subcategory + "_resp_" + player.characterindex);
	}
}

/*
	Name: shouldPlayerSpeak
	Namespace: zm_audio
	Checksum: 0xE6B8352C
	Offset: 0x2AA8
	Size: 0x1CB
	Parameters: 4
	Flags: None
*/
function shouldPlayerSpeak(player, category, subcategory, percentage)
{
	if(!isdefined(player))
	{
		return undefined;
	}
	if(!player zm_utility::is_player())
	{
		return undefined;
	}
	if(player zm_utility::is_player())
	{
		if(player.sessionstate != "playing")
		{
			return undefined;
		}
		if(player laststand::player_is_in_laststand() && (subcategory != "revive_down" || subcategory != "revive_up"))
		{
			return undefined;
		}
		if(player IsPlayerUnderwater())
		{
			return undefined;
		}
	}
	if(isdefined(player.dontspeak) && player.dontspeak)
	{
		return undefined;
	}
	if(percentage < randomIntRange(1, 101))
	{
		return undefined;
	}
	if(isVoxOnCooldown(player, category, subcategory))
	{
		return undefined;
	}
	index = zm_utility::get_player_index(player);
	if(isdefined(player.isSamantha) && player.isSamantha)
	{
		index = 4;
	}
	return "vox_plr_" + index + "_";
}

/*
	Name: isVoxOnCooldown
	Namespace: zm_audio
	Checksum: 0x4389C05A
	Offset: 0x2C80
	Size: 0x123
	Parameters: 3
	Flags: None
*/
function isVoxOnCooldown(player, category, subcategory)
{
	if(level.sndPlayerVox[category][subcategory].delayBeforePlayAgain <= 0)
	{
		return 0;
	}
	fullname = category + subcategory;
	if(!isdefined(player.voxTimer))
	{
		player.voxTimer = [];
	}
	if(!isdefined(player.voxTimer[fullname]))
	{
		player.voxTimer[fullname] = GetTime();
		return 0;
	}
	time = GetTime();
	if(time - player.voxTimer[fullname] <= level.sndPlayerVox[category][subcategory].delayBeforePlayAgain * 1000)
	{
		return 1;
	}
	player.voxTimer[fullname] = time;
	return 0;
}

/*
	Name: zmbVoxGetLineVariant
	Namespace: zm_audio
	Checksum: 0x1B9E86EB
	Offset: 0x2DB0
	Size: 0x209
	Parameters: 3
	Flags: None
*/
function zmbVoxGetLineVariant(prefix, suffix, force_variant)
{
	if(!isdefined(self.sound_dialog))
	{
		self.sound_dialog = [];
		self.sound_dialog_available = [];
	}
	if(!isdefined(self.sound_dialog[suffix]))
	{
		num_variants = zm_spawner::get_number_variants(prefix + suffix);
		if(num_variants <= 0)
		{
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					println("Dev Block strings are not supported" + prefix + suffix);
				}
			#/
			return undefined;
		}
		for(i = 0; i < num_variants; i++)
		{
			self.sound_dialog[suffix][i] = i;
		}
		self.sound_dialog_available[suffix] = [];
	}
	if(self.sound_dialog_available[suffix].size <= 0)
	{
		for(i = 0; i < self.sound_dialog[suffix].size; i++)
		{
			self.sound_dialog_available[suffix][i] = self.sound_dialog[suffix][i];
		}
	}
	Variation = Array::random(self.sound_dialog_available[suffix]);
	ArrayRemoveValue(self.sound_dialog_available[suffix], Variation);
	if(isdefined(force_variant))
	{
		Variation = force_variant;
	}
	return prefix + suffix + "_" + Variation;
}

/*
	Name: areNearbySpeakersActive
	Namespace: zm_audio
	Checksum: 0xD5B923AD
	Offset: 0x2FC8
	Size: 0x1AD
	Parameters: 1
	Flags: None
*/
function areNearbySpeakersActive(radius)
{
	if(!isdefined(radius))
	{
		radius = 1000;
	}
	nearbySpeakerActive = 0;
	speakers = GetPlayers();
	foreach(person in speakers)
	{
		if(self == person)
		{
			continue;
		}
		if(person zm_utility::is_player())
		{
			if(person.sessionstate != "playing")
			{
				continue;
			}
			if(person laststand::player_is_in_laststand())
			{
				continue;
			}
		}
		if(isdefined(person.isSpeaking) && person.isSpeaking && (!isdefined(person.ignoreNearbySpkrs) && person.ignoreNearbySpkrs))
		{
			if(DistanceSquared(self.origin, person.origin) < radius * radius)
			{
				nearbySpeakerActive = 1;
			}
		}
	}
	return nearbySpeakerActive;
}

/*
	Name: musicState_Create
	Namespace: zm_audio
	Checksum: 0xD95FDC5F
	Offset: 0x3180
	Size: 0x2C3
	Parameters: 8
	Flags: None
*/
function musicState_Create(stateName, playType, musName1, musName2, musName3, musName4, musName5, musName6)
{
	if(!isdefined(playType))
	{
		playType = 1;
	}
	if(!isdefined(level.musicSystem))
	{
		level.musicSystem = spawnstruct();
		level.musicSystem.Queue = 0;
		level.musicSystem.currentPlaytype = 0;
		level.musicSystem.currentSet = undefined;
		level.musicSystem.states = [];
	}
	level.musicSystem.states[stateName] = spawnstruct();
	level.musicSystem.states[stateName].playType = playType;
	level.musicSystem.states[stateName].musArray = Array();
	if(isdefined(musName1))
	{
		Array::add(level.musicSystem.states[stateName].musArray, musName1);
	}
	if(isdefined(musName2))
	{
		Array::add(level.musicSystem.states[stateName].musArray, musName2);
	}
	if(isdefined(musName3))
	{
		Array::add(level.musicSystem.states[stateName].musArray, musName3);
	}
	if(isdefined(musName4))
	{
		Array::add(level.musicSystem.states[stateName].musArray, musName4);
	}
	if(isdefined(musName5))
	{
		Array::add(level.musicSystem.states[stateName].musArray, musName5);
	}
	if(isdefined(musName6))
	{
		Array::add(level.musicSystem.states[stateName].musArray, musName6);
	}
}

/*
	Name: sndMusicSystem_CreateState
	Namespace: zm_audio
	Checksum: 0x7E4F223C
	Offset: 0x3450
	Size: 0x1D3
	Parameters: 4
	Flags: None
*/
function sndMusicSystem_CreateState(State, stateName, playType, delay)
{
	if(!isdefined(playType))
	{
		playType = 1;
	}
	if(!isdefined(delay))
	{
		delay = 0;
	}
	if(!isdefined(level.musicSystem))
	{
		level.musicSystem = spawnstruct();
		level.musicSystem.ent = spawn("script_origin", (0, 0, 0));
		level.musicSystem.Queue = 0;
		level.musicSystem.currentPlaytype = 0;
		level.musicSystem.currentState = undefined;
		level.musicSystem.states = [];
	}
	m = level.musicSystem;
	if(!isdefined(m.states[State]))
	{
		m.states[State] = spawnstruct();
		m.states[State] = Array();
	}
	m.states[State][m.states[State].size].stateName = stateName;
	m.states[State][m.states[State].size].playType = playType;
}

/*
	Name: sndMusicSystem_PlayState
	Namespace: zm_audio
	Checksum: 0x17260107
	Offset: 0x3630
	Size: 0x1B3
	Parameters: 1
	Flags: None
*/
function sndMusicSystem_PlayState(State)
{
	if(!isdefined(level.musicSystem))
	{
		return;
	}
	m = level.musicSystem;
	if(!isdefined(m.states[State]))
	{
		return;
	}
	s = level.musicSystem.states[State];
	playType = s.playType;
	if(m.currentPlaytype > 0)
	{
		if(playType == 1)
		{
			continue;
		}
		else if(playType == 2)
		{
			level thread sndMusicSystem_QueueState(State);
		}
		else if(playType > m.currentPlaytype || (playType == 3 && m.currentPlaytype == 3))
		{
			if(isdefined(level.musicSystemOverride) && level.musicSystemOverride && playType != 5)
			{
				return;
			}
			else
			{
				level sndMusicSystem_StopAndFlush();
				level thread playState(State);
			}
		}
	}
	else if(!isdefined(level.musicSystemOverride) && level.musicSystemOverride || playType == 5)
	{
		level thread playState(State);
	}
}

/*
	Name: playState
	Namespace: zm_audio
	Checksum: 0xD6A025BF
	Offset: 0x37F0
	Size: 0x1F5
	Parameters: 1
	Flags: None
*/
function playState(State)
{
	level endon("sndStateStop");
	m = level.musicSystem;
	musArray = level.musicSystem.states[State].musArray;
	if(musArray.size <= 0)
	{
		return;
	}
	musToPlay = musArray[randomIntRange(0, musArray.size)];
	m.currentPlaytype = m.states[State].playType;
	m.currentState = State;
	wait(0.1);
	if(isdefined(level.sndPlayStateOverride))
	{
		perplayer = level [[level.sndPlayStateOverride]](State);
		if(!(isdefined(perplayer) && perplayer))
		{
			music::setmusicstate(musToPlay);
		}
	}
	else
	{
		music::setmusicstate(musToPlay);
	}
	aliasname = "mus_" + musToPlay + "_intro";
	playbackTime = soundgetplaybacktime(aliasname);
	if(!isdefined(playbackTime) || playbackTime <= 0)
	{
		waitTime = 1;
	}
	else
	{
		waitTime = playbackTime * 0.001;
	}
	wait(waitTime);
	m.currentPlaytype = 0;
	m.currentState = undefined;
}

/*
	Name: sndMusicSystem_QueueState
	Namespace: zm_audio
	Checksum: 0x10FE1281
	Offset: 0x39F0
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function sndMusicSystem_QueueState(State)
{
	level endon("sndQueueFlush");
	m = level.musicSystem;
	count = 0;
	if(isdefined(m.Queue) && m.Queue)
	{
		return;
	}
	else
	{
		m.Queue = 1;
		while(m.currentPlaytype > 0)
		{
			wait(0.5);
			count++;
			if(count >= 25)
			{
				m.Queue = 0;
				return;
			}
		}
		level thread playState(State);
		m.Queue = 0;
	}
}

/*
	Name: sndMusicSystem_StopAndFlush
	Namespace: zm_audio
	Checksum: 0x7B074426
	Offset: 0x3AE8
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function sndMusicSystem_StopAndFlush()
{
	level notify("sndQueueFlush");
	level.musicSystem.Queue = 0;
	level notify("sndStateStop");
	level.musicSystem.currentPlaytype = 0;
	level.musicSystem.currentState = undefined;
}

/*
	Name: sndMusicSystem_IsAbleToPlay
	Namespace: zm_audio
	Checksum: 0x1D7CD718
	Offset: 0x3B48
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function sndMusicSystem_IsAbleToPlay()
{
	if(!isdefined(level.musicSystem))
	{
		return 0;
	}
	if(!isdefined(level.musicSystem.currentPlaytype))
	{
		return 0;
	}
	if(level.musicSystem.currentPlaytype >= 4)
	{
		return 0;
	}
	return 1;
}

/*
	Name: sndMusicSystem_LocationsInit
	Namespace: zm_audio
	Checksum: 0xAF6E6A86
	Offset: 0x3BA0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function sndMusicSystem_LocationsInit(locationArray)
{
	if(!isdefined(locationArray) || locationArray.size <= 0)
	{
		return;
	}
	level.musicSystem.locationArray = locationArray;
	level thread sndMusicSystem_Locations(locationArray);
}

/*
	Name: sndMusicSystem_Locations
	Namespace: zm_audio
	Checksum: 0x8A26EB8F
	Offset: 0x3C00
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function sndMusicSystem_Locations(locationArray)
{
	numCut = 0;
	level.sndLastZone = undefined;
	m = level.musicSystem;
	while(1)
	{
		level waittill("newzoneActive", activeZone);
		wait(0.1);
		if(!sndLocationShouldPlay(locationArray, activeZone))
		{
			continue;
		}
		level thread sndMusicSystem_PlayState(activeZone);
		locationArray = sndCurrentLocationArray(locationArray, activeZone, numCut, 3);
		level.sndLastZone = activeZone;
		if(numCut >= 3)
		{
			numCut = 0;
		}
		else
		{
			numCut++;
		}
		level waittill("between_round_over");
	}
}

/*
	Name: sndLocationShouldPlay
	Namespace: zm_audio
	Checksum: 0xBF707041
	Offset: 0x3D08
	Size: 0x127
	Parameters: 2
	Flags: None
*/
function sndLocationShouldPlay(Array, activeZone)
{
	shouldPlay = 0;
	if(level.musicSystem.currentPlaytype >= 3)
	{
		level thread sndLocationQueue(activeZone);
		return shouldPlay;
	}
	foreach(place in Array)
	{
		if(place == activeZone)
		{
			shouldPlay = 1;
		}
	}
	if(shouldPlay == 0)
	{
		return shouldPlay;
	}
	if(zm_zonemgr::any_player_in_zone(activeZone))
	{
		shouldPlay = 1;
	}
	else
	{
		shouldPlay = 0;
	}
	return shouldPlay;
}

/*
	Name: sndCurrentLocationArray
	Namespace: zm_audio
	Checksum: 0x1E12A154
	Offset: 0x3E38
	Size: 0xE9
	Parameters: 4
	Flags: None
*/
function sndCurrentLocationArray(current_array, activeZone, numCut, num)
{
	if(numCut >= num)
	{
		current_array = level.musicSystem.locationArray;
	}
	foreach(place in current_array)
	{
		if(place == activeZone)
		{
			ArrayRemoveValue(current_array, place);
			break;
		}
	}
	return current_array;
}

/*
	Name: sndLocationQueue
	Namespace: zm_audio
	Checksum: 0x1171B9E8
	Offset: 0x3F30
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function sndLocationQueue(zone)
{
	level endon("newzoneActive");
	while(level.musicSystem.currentPlaytype >= 3)
	{
		wait(0.5);
	}
	level notify("newzoneActive", zone);
}

/*
	Name: sndMusicSystem_EESetup
	Namespace: zm_audio
	Checksum: 0x28AEC4E4
	Offset: 0x3F88
	Size: 0x309
	Parameters: 6
	Flags: None
*/
function sndMusicSystem_EESetup(State, origin1, origin2, origin3, origin4, origin5)
{
	var_3ced4bd3 = Array();
	if(isdefined(origin1))
	{
		if(!isdefined(var_3ced4bd3))
		{
			var_3ced4bd3 = [];
		}
		else if(!IsArray(var_3ced4bd3))
		{
			var_3ced4bd3 = Array(var_3ced4bd3);
		}
	}
	var_3ced4bd3[var_3ced4bd3.size] = origin1;
	if(isdefined(origin2))
	{
		if(!isdefined(var_3ced4bd3))
		{
			var_3ced4bd3 = [];
		}
		else if(!IsArray(var_3ced4bd3))
		{
			var_3ced4bd3 = Array(var_3ced4bd3);
		}
	}
	var_3ced4bd3[var_3ced4bd3.size] = origin2;
	if(isdefined(origin3))
	{
		if(!isdefined(var_3ced4bd3))
		{
			var_3ced4bd3 = [];
		}
		else if(!IsArray(var_3ced4bd3))
		{
			var_3ced4bd3 = Array(var_3ced4bd3);
		}
	}
	var_3ced4bd3[var_3ced4bd3.size] = origin3;
	if(isdefined(origin4))
	{
		if(!isdefined(var_3ced4bd3))
		{
			var_3ced4bd3 = [];
		}
		else if(!IsArray(var_3ced4bd3))
		{
			var_3ced4bd3 = Array(var_3ced4bd3);
		}
	}
	var_3ced4bd3[var_3ced4bd3.size] = origin4;
	if(isdefined(origin5))
	{
		if(!isdefined(var_3ced4bd3))
		{
			var_3ced4bd3 = [];
		}
		else if(!IsArray(var_3ced4bd3))
		{
			var_3ced4bd3 = Array(var_3ced4bd3);
		}
	}
	var_3ced4bd3[var_3ced4bd3.size] = origin5;
	if(var_3ced4bd3.size > 0)
	{
		level.var_8e46c49e = var_3ced4bd3.size;
		level.var_98528449 = 0;
		foreach(origin in var_3ced4bd3)
		{
			level thread sndMusicSystem_EEWait(origin, State);
		}
	}
}

/*
	Name: sndMusicSystem_EEWait
	Namespace: zm_audio
	Checksum: 0x19F65AF0
	Offset: 0x42A0
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function sndMusicSystem_EEWait(origin, State)
{
	temp_ent = spawn("script_origin", origin);
	temp_ent PlayLoopSound("zmb_meteor_loop");
	temp_ent thread secretUse("main_music_egg_hit", VectorScale((0, 1, 0), 255), &sndMusicSystem_EEOverride);
	temp_ent waittill("main_music_egg_hit", player);
	temp_ent StopLoopSound(1);
	player playsound("zmb_meteor_activate");
	level.var_98528449++;
	if(level.var_98528449 >= level.var_8e46c49e)
	{
		level notify("hash_a1b1dadb");
		level thread sndMusicSystem_PlayState(State);
	}
	temp_ent delete();
}

/*
	Name: sndMusicSystem_EEOverride
	Namespace: zm_audio
	Checksum: 0x498E176D
	Offset: 0x43F0
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function sndMusicSystem_EEOverride(arg1, arg2)
{
	if(isdefined(level.musicSystem.currentPlaytype) && level.musicSystem.currentPlaytype >= 4)
	{
		return 0;
	}
	return 1;
}

/*
	Name: secretUse
	Namespace: zm_audio
	Checksum: 0x81ADC26D
	Offset: 0x4440
	Size: 0x1A7
	Parameters: 5
	Flags: None
*/
function secretUse(notify_string, color, qualifier_func, arg1, arg2)
{
	waittillframeend;
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		/#
			print3d(self.origin, "Dev Block strings are not supported", color, 1);
		#/
		players = level.players;
		foreach(player in players)
		{
			qualifier_passed = 1;
			if(isdefined(qualifier_func))
			{
				qualifier_passed = player [[qualifier_func]](arg1, arg2);
			}
			if(qualifier_passed && DistanceSquared(self.origin, player.origin) < 4096)
			{
				if(player laststand::is_facing(self))
				{
					if(player useButtonPressed())
					{
						self notify(notify_string, player);
						return;
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: sndAnnouncer_Init
	Namespace: zm_audio
	Checksum: 0x5E163E76
	Offset: 0x45F0
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function sndAnnouncer_Init()
{
	if(!isdefined(level.zmAnnouncerPrefix))
	{
		level.zmAnnouncerPrefix = "vox_" + "zmba" + "_";
	}
	sndAnnouncerVoxAdd("carpenter", "powerup_carpenter_0");
	sndAnnouncerVoxAdd("insta_kill", "powerup_instakill_0");
	sndAnnouncerVoxAdd("double_points", "powerup_doublepoints_0");
	sndAnnouncerVoxAdd("nuke", "powerup_nuke_0");
	sndAnnouncerVoxAdd("full_ammo", "powerup_maxammo_0");
	sndAnnouncerVoxAdd("fire_sale", "powerup_firesale_0");
	sndAnnouncerVoxAdd("minigun", "powerup_death_machine_0");
	sndAnnouncerVoxAdd("boxmove", "event_magicbox_0");
	sndAnnouncerVoxAdd("dogstart", "event_dogstart_0");
}

/*
	Name: sndAnnouncerVoxAdd
	Namespace: zm_audio
	Checksum: 0xAB47A598
	Offset: 0x4750
	Size: 0x4D
	Parameters: 2
	Flags: None
*/
function sndAnnouncerVoxAdd(type, suffix)
{
	if(!isdefined(level.zmAnnouncerVox))
	{
		level.zmAnnouncerVox = Array();
	}
	level.zmAnnouncerVox[type] = suffix;
}

/*
	Name: sndAnnouncerPlayVox
	Namespace: zm_audio
	Checksum: 0x7C6AD48B
	Offset: 0x47A8
	Size: 0x153
	Parameters: 2
	Flags: None
*/
function sndAnnouncerPlayVox(type, player)
{
	if(!isdefined(level.zmAnnouncerVox[type]))
	{
		return;
	}
	prefix = level.zmAnnouncerPrefix;
	suffix = level.zmAnnouncerVox[type];
	if(!(isdefined(level.zmAnnouncerTalking) && level.zmAnnouncerTalking))
	{
		if(!isdefined(player))
		{
			level.zmAnnouncerTalking = 1;
			temp_ent = spawn("script_origin", (0, 0, 0));
			temp_ent PlaySoundWithNotify(prefix + suffix, prefix + suffix + "wait");
			temp_ent waittill(prefix + suffix + "wait");
			wait(0.05);
			temp_ent delete();
			level.zmAnnouncerTalking = 0;
		}
		else
		{
			player playsoundtoplayer(prefix + suffix, player);
		}
	}
}

/*
	Name: zmbAIVox_NotifyConvert
	Namespace: zm_audio
	Checksum: 0x45B62A5E
	Offset: 0x4908
	Size: 0x2E9
	Parameters: 0
	Flags: None
*/
function zmbAIVox_NotifyConvert()
{
	self endon("death");
	self endon("disconnect");
	level endon("game_ended");
	self thread zmbAIVox_PlayDeath();
	self thread zmbAIVox_PlayElectrocution();
	while(1)
	{
		self waittill("bhtn_action_notify", notify_string);
		switch(notify_string)
		{
			case "pain":
			{
				level thread zmbAIVox_PlayVox(self, notify_string, 1, 9);
				break;
			}
			case "death":
			{
				if(isdefined(self.bgb_tone_death) && self.bgb_tone_death)
				{
					level thread zmbAIVox_PlayVox(self, "death_whimsy", 1, 10);
				}
				else
				{
					level thread zmbAIVox_PlayVox(self, notify_string, 1, 10);
				}
				break;
			}
			case "behind":
			{
				level thread zmbAIVox_PlayVox(self, notify_string, 1, 9);
				break;
			}
			case "attack_melee":
			{
				if(!isdefined(self.animName) || (self.animName != "zombie" && self.animName != "quad_zombie"))
				{
					level thread zmbAIVox_PlayVox(self, notify_string, 1, 8, 1);
				}
				break;
			}
			case "attack_melee_zhd":
			{
				level thread zmbAIVox_PlayVox(self, "attack_melee", 1, 8, 1);
				break;
			}
			case "electrocute":
			{
				level thread zmbAIVox_PlayVox(self, notify_string, 1, 7);
				break;
			}
			case "close":
			{
				level thread zmbAIVox_PlayVox(self, notify_string, 1, 6);
				break;
			}
			case "ambient":
			case "crawler":
			case "sprint":
			case "taunt":
			case "teardown":
			{
				level thread zmbAIVox_PlayVox(self, notify_string, 0);
				break;
			}
			case default:
			{
				if(isdefined(level._zmbAIVox_SpecialType))
				{
					if(isdefined(level._zmbAIVox_SpecialType[notify_string]))
					{
						level thread zmbAIVox_PlayVox(self, notify_string, 0);
					}
				}
				break;
			}
		}
	}
}

/*
	Name: zmbAIVox_PlayVox
	Namespace: zm_audio
	Checksum: 0x3A8838C8
	Offset: 0x4C00
	Size: 0x36F
	Parameters: 5
	Flags: None
*/
function zmbAIVox_PlayVox(zombie, type, override, priority, delayAmbientVox)
{
	if(!isdefined(delayAmbientVox))
	{
		delayAmbientVox = 0;
	}
	zombie endon("death");
	if(!isdefined(zombie))
	{
		return;
	}
	if(!isdefined(zombie.voicePrefix))
	{
		return;
	}
	if(!isdefined(priority))
	{
		priority = 1;
	}
	if(!isdefined(zombie.currentvoxpriority))
	{
		zombie.currentvoxpriority = 1;
	}
	if(!isdefined(self.delayAmbientVox))
	{
		self.delayAmbientVox = 0;
	}
	if(type == "ambient" || type == "sprint" || type == "crawler" && (isdefined(self.delayAmbientVox) && self.delayAmbientVox))
	{
		return;
	}
	if(delayAmbientVox)
	{
		self.delayAmbientVox = 1;
		self thread zmbAIVox_AmbientDelay();
	}
	alias = "zmb_vocals_" + zombie.voicePrefix + "_" + type;
	if(sndIsNetworkSafe())
	{
		if(isdefined(override) && override)
		{
			if(isdefined(zombie.currentvox) && priority > zombie.currentvoxpriority)
			{
				zombie stopSound(zombie.currentvox);
			}
			if(type == "death" || type == "death_whimsy")
			{
				zombie playsound(alias);
				return;
			}
		}
		if(zombie.talking === 1 && priority < zombie.currentvoxpriority)
		{
			return;
		}
		zombie.talking = 1;
		if(zombie is_last_zombie() && type == "ambient")
		{
			alias = alias + "_loud";
		}
		zombie.currentvox = alias;
		zombie.currentvoxpriority = priority;
		zombie PlaySoundOnTag(alias, "j_head");
		playbackTime = soundgetplaybacktime(alias);
		if(!isdefined(playbackTime))
		{
			playbackTime = 1;
		}
		if(playbackTime >= 0)
		{
			playbackTime = playbackTime * 0.001;
		}
		else
		{
			playbackTime = 1;
		}
		wait(playbackTime);
		zombie.talking = 0;
		zombie.currentvox = undefined;
		zombie.currentvoxpriority = 1;
	}
}

/*
	Name: zmbAIVox_PlayDeath
	Namespace: zm_audio
	Checksum: 0x5ED9DB76
	Offset: 0x4F78
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function zmbAIVox_PlayDeath()
{
	self endon("disconnect");
	self waittill("death", attacker, meansOfDeath);
	if(isdefined(self))
	{
		if(isdefined(self.bgb_tone_death) && self.bgb_tone_death)
		{
			level thread zmbAIVox_PlayVox(self, "death_whimsy", 1);
		}
		else
		{
			level thread zmbAIVox_PlayVox(self, "death", 1);
		}
	}
}

/*
	Name: zmbAIVox_PlayElectrocution
	Namespace: zm_audio
	Checksum: 0x1884F579
	Offset: 0x5020
	Size: 0x109
	Parameters: 0
	Flags: None
*/
function zmbAIVox_PlayElectrocution()
{
	self endon("disconnect");
	self endon("death");
	while(1)
	{
		self waittill("damage", amount, attacker, direction_vec, point, type, tagName, modelName, partName, weapon);
		if(weapon.name == "zombie_beast_lightning_dwl" || weapon.name == "zombie_beast_lightning_dwl2" || weapon.name == "zombie_beast_lightning_dwl3")
		{
			self notify("bhtn_action_notify", "electrocute");
		}
	}
}

/*
	Name: zmbAIVox_AmbientDelay
	Namespace: zm_audio
	Checksum: 0xB69D0B99
	Offset: 0x5138
	Size: 0x47
	Parameters: 0
	Flags: None
*/
function zmbAIVox_AmbientDelay()
{
	self notify("sndAmbientDelay");
	self endon("sndAmbientDelay");
	self endon("death");
	self endon("disconnect");
	wait(2);
	self.delayAmbientVox = 0;
}

/*
	Name: networkSafeReset
	Namespace: zm_audio
	Checksum: 0x366AA0DC
	Offset: 0x5188
	Size: 0x2F
	Parameters: 0
	Flags: None
*/
function networkSafeReset()
{
	while(1)
	{
		level._numZmbAIVox = 0;
		util::wait_network_frame();
	}
}

/*
	Name: sndIsNetworkSafe
	Namespace: zm_audio
	Checksum: 0xB8CC1B77
	Offset: 0x51C0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function sndIsNetworkSafe()
{
	if(!isdefined(level._numZmbAIVox))
	{
		level thread networkSafeReset();
	}
	if(level._numZmbAIVox >= 2)
	{
		return 0;
	}
	level._numZmbAIVox++;
	return 1;
}

/*
	Name: is_last_zombie
	Namespace: zm_audio
	Checksum: 0x504D9BCE
	Offset: 0x5210
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function is_last_zombie()
{
	if(zombie_utility::get_current_zombie_count() <= 1)
	{
		return 1;
	}
	return 0;
}

/*
	Name: sndRadioSetup
	Namespace: zm_audio
	Checksum: 0x33228CA2
	Offset: 0x5240
	Size: 0x465
	Parameters: 7
	Flags: None
*/
function sndRadioSetup(alias_prefix, is_sequential, origin1, origin2, origin3, origin4, origin5)
{
	if(!isdefined(is_sequential))
	{
		is_sequential = 0;
	}
	radio = spawnstruct();
	radio.counter = 1;
	radio.alias_prefix = alias_prefix;
	radio.isplaying = 0;
	radio.Array = Array();
	if(isdefined(origin1))
	{
		if(!isdefined(radio.Array))
		{
			radio.Array = [];
		}
		else if(!IsArray(radio.Array))
		{
			radio.Array = Array(radio.Array);
		}
	}
	radio.Array[radio.Array.size] = origin1;
	if(isdefined(origin2))
	{
		if(!isdefined(radio.Array))
		{
			radio.Array = [];
		}
		else if(!IsArray(radio.Array))
		{
			radio.Array = Array(radio.Array);
		}
	}
	radio.Array[radio.Array.size] = origin2;
	if(isdefined(origin3))
	{
		if(!isdefined(radio.Array))
		{
			radio.Array = [];
		}
		else if(!IsArray(radio.Array))
		{
			radio.Array = Array(radio.Array);
		}
	}
	radio.Array[radio.Array.size] = origin3;
	if(isdefined(origin4))
	{
		if(!isdefined(radio.Array))
		{
			radio.Array = [];
		}
		else if(!IsArray(radio.Array))
		{
			radio.Array = Array(radio.Array);
		}
	}
	radio.Array[radio.Array.size] = origin4;
	if(isdefined(origin5))
	{
		if(!isdefined(radio.Array))
		{
			radio.Array = [];
		}
		else if(!IsArray(radio.Array))
		{
			radio.Array = Array(radio.Array);
		}
	}
	radio.Array[radio.Array.size] = origin5;
	if(radio.Array.size > 0)
	{
		for(i = 0; i < radio.Array.size; i++)
		{
			level thread sndRadioWait(radio.Array[i], radio, is_sequential, i + 1);
		}
	}
}

/*
	Name: sndRadioWait
	Namespace: zm_audio
	Checksum: 0x840AA86B
	Offset: 0x56B0
	Size: 0x243
	Parameters: 4
	Flags: None
*/
function sndRadioWait(origin, radio, is_sequential, num)
{
	temp_ent = spawn("script_origin", origin);
	temp_ent thread secretUse("sndRadioHit", VectorScale((0, 0, 1), 255), &sndRadio_Override, radio);
	temp_ent waittill("hash_678c47ee", player);
	if(!(isdefined(is_sequential) && is_sequential))
	{
		var_48a5e056 = num;
	}
	else
	{
		var_48a5e056 = radio.counter;
	}
	var_aae31f82 = radio.alias_prefix + var_48a5e056;
	var_c3d43d75 = zm_spawner::get_number_variants(var_aae31f82);
	if(var_c3d43d75 > 0)
	{
		radio.isplaying = 1;
		for(i = 0; i < var_c3d43d75; i++)
		{
			temp_ent playsound(var_aae31f82 + "_" + i);
			playbackTime = soundgetplaybacktime(var_aae31f82 + "_" + i);
			if(!isdefined(playbackTime))
			{
				playbackTime = 1;
			}
			if(playbackTime >= 0)
			{
				playbackTime = playbackTime * 0.001;
			}
			else
			{
				playbackTime = 1;
			}
			wait(playbackTime);
		}
	}
	radio.counter++;
	radio.isplaying = 0;
	temp_ent delete();
}

/*
	Name: sndRadio_Override
	Namespace: zm_audio
	Checksum: 0xFF325D57
	Offset: 0x5900
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function sndRadio_Override(arg1, arg2)
{
	if(isdefined(arg1) && arg1.isplaying == 1)
	{
		return 0;
	}
	return 1;
}

/*
	Name: sndPerksJingles_Timer
	Namespace: zm_audio
	Checksum: 0xC1938EE9
	Offset: 0x5948
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function sndPerksJingles_Timer()
{
	self endon("death");
	if(isdefined(self.sndJingleCooldown))
	{
		self.sndJingleCooldown = 0;
	}
	while(1)
	{
		wait(RandomFloatRange(30, 60));
		if(randomIntRange(0, 100) <= 10 && (!isdefined(self.sndJingleCooldown) && self.sndJingleCooldown))
		{
			self thread sndPerksJingles_Player(0);
		}
	}
}

/*
	Name: sndPerksJingles_Player
	Namespace: zm_audio
	Checksum: 0x5FF07620
	Offset: 0x59F0
	Size: 0x17F
	Parameters: 1
	Flags: None
*/
function sndPerksJingles_Player(type)
{
	self endon("death");
	if(!isdefined(self.sndJingleActive))
	{
		self.sndJingleActive = 0;
	}
	alias = self.script_sound;
	if(type == 1)
	{
		alias = self.script_label;
	}
	if(isdefined(level.musicSystem) && level.musicSystem.currentPlaytype >= 4)
	{
		return;
	}
	self.str_jingle_alias = alias;
	if(!(isdefined(self.sndJingleActive) && self.sndJingleActive))
	{
		self.sndJingleActive = 1;
		self PlaySoundWithNotify(alias, "sndDone");
		playbackTime = soundgetplaybacktime(alias);
		if(!isdefined(playbackTime) || playbackTime <= 0)
		{
			waitTime = 1;
		}
		else
		{
			waitTime = playbackTime * 0.001;
		}
		wait(waitTime);
		if(type == 0)
		{
			self.sndJingleCooldown = 1;
			self thread sndPerksJingles_Cooldown();
		}
		self.sndJingleActive = 0;
	}
}

/*
	Name: sndPerksJingles_Cooldown
	Namespace: zm_audio
	Checksum: 0x23DBBB7D
	Offset: 0x5B78
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function sndPerksJingles_Cooldown()
{
	self endon("death");
	if(isdefined(self.var_1afc1154))
	{
		while(isdefined(self.var_1afc1154) && self.var_1afc1154)
		{
			wait(1);
		}
	}
	wait(45);
	self.sndJingleCooldown = 0;
}

/*
	Name: sndConversation_Init
	Namespace: zm_audio
	Checksum: 0x56EF71D6
	Offset: 0x5BD0
	Size: 0x87
	Parameters: 2
	Flags: None
*/
function sndConversation_Init(name, specialEndon)
{
	if(!isdefined(specialEndon))
	{
		specialEndon = undefined;
	}
	if(!isdefined(level.sndConversations))
	{
		level.sndConversations = Array();
	}
	level.sndConversations[name] = spawnstruct();
	level.sndConversations[name].specialEndon = specialEndon;
}

/*
	Name: sndConversation_AddLine
	Namespace: zm_audio
	Checksum: 0xBB08D499
	Offset: 0x5C60
	Size: 0x2A5
	Parameters: 4
	Flags: None
*/
function sndConversation_AddLine(name, line, player_or_random, ignorePlayer)
{
	if(!isdefined(ignorePlayer))
	{
		ignorePlayer = 5;
	}
	thisConvo = level.sndConversations[name];
	if(!isdefined(thisConvo.line))
	{
		thisConvo.line = Array();
	}
	if(!isdefined(thisConvo.player))
	{
		thisConvo.player = Array();
	}
	if(!isdefined(thisConvo.ignorePlayer))
	{
		thisConvo.ignorePlayer = Array();
	}
	if(!isdefined(thisConvo.line))
	{
		thisConvo.line = [];
	}
	else if(!IsArray(thisConvo.line))
	{
		thisConvo.line = Array(thisConvo.line);
	}
	thisConvo.line[thisConvo.line.size] = line;
	if(!isdefined(thisConvo.player))
	{
		thisConvo.player = [];
	}
	else if(!IsArray(thisConvo.player))
	{
		thisConvo.player = Array(thisConvo.player);
	}
	thisConvo.player[thisConvo.player.size] = player_or_random;
	if(!isdefined(thisConvo.ignorePlayer))
	{
		thisConvo.ignorePlayer = [];
	}
	else if(!IsArray(thisConvo.ignorePlayer))
	{
		thisConvo.ignorePlayer = Array(thisConvo.ignorePlayer);
	}
	thisConvo.ignorePlayer[thisConvo.ignorePlayer.size] = ignorePlayer;
}

/*
	Name: sndConversation_Play
	Namespace: zm_audio
	Checksum: 0xE1CBFCFF
	Offset: 0x5F10
	Size: 0x28D
	Parameters: 1
	Flags: None
*/
function sndConversation_Play(name)
{
	thisConvo = level.sndConversations[name];
	level endon("sndConvoInterrupt");
	if(isdefined(thisConvo.specialEndon))
	{
		level endon(thisConvo.specialEndon);
	}
	while(isAnyoneTalking())
	{
		wait(0.5);
	}
	while(isdefined(level.sndVoxOverride) && level.sndVoxOverride)
	{
		wait(0.5);
	}
	level.sndVoxOverride = 1;
	for(i = 0; i < thisConvo.line.size; i++)
	{
		if(thisConvo.player[i] == 4)
		{
			speaker = getRandomCharacter(thisConvo.ignorePlayer[i]);
		}
		else
		{
			speaker = getSpecificCharacter(thisConvo.player[i]);
		}
		if(!isdefined(speaker))
		{
			continue;
		}
		if(isCurrentSpeakerAbleToTalk(speaker))
		{
			level.currentConvoPlayer = speaker;
			if(isdefined(level.vox_name_complete))
			{
				level.currentConvoLine = thisConvo.line[i];
			}
			else
			{
				level.currentConvoLine = "vox_plr_" + speaker.characterindex + "_" + thisConvo.line[i];
				speaker thread sndConvoInterrupt();
			}
			speaker PlaySoundOnTag(level.currentConvoLine, "J_Head");
			waitPlayBackTime(level.currentConvoLine);
			level notify("sndConvoLineDone");
		}
	}
	level.sndVoxOverride = 0;
	level notify("sndConversationDone");
	level.currentConvoLine = undefined;
	level.currentConvoPlayer = undefined;
}

/*
	Name: sndConvoStopCurrentConversation
	Namespace: zm_audio
	Checksum: 0x66A509E0
	Offset: 0x61A8
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function sndConvoStopCurrentConversation()
{
	level notify("sndConvoInterrupt");
	level notify("sndConversationDone");
	level.sndVoxOverride = 0;
	if(isdefined(level.currentConvoPlayer) && isdefined(level.currentConvoLine))
	{
		level.currentConvoPlayer stopSound(level.currentConvoLine);
		level.currentConvoLine = undefined;
		level.currentConvoPlayer = undefined;
	}
}

/*
	Name: waitPlayBackTime
	Namespace: zm_audio
	Checksum: 0xB70CDCB5
	Offset: 0x6228
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function waitPlayBackTime(alias)
{
	playbackTime = soundgetplaybacktime(alias);
	if(!isdefined(playbackTime))
	{
		playbackTime = 1;
	}
	if(playbackTime >= 0)
	{
		playbackTime = playbackTime * 0.001;
	}
	else
	{
		playbackTime = 1;
	}
	wait(playbackTime);
}

/*
	Name: isCurrentSpeakerAbleToTalk
	Namespace: zm_audio
	Checksum: 0xE56EF69F
	Offset: 0x62A8
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function isCurrentSpeakerAbleToTalk(player)
{
	if(!isdefined(player))
	{
		return 0;
	}
	if(player.sessionstate != "playing")
	{
		return 0;
	}
	if(isdefined(player.laststand) && player.laststand)
	{
		return 0;
	}
	return 1;
}

/*
	Name: getRandomCharacter
	Namespace: zm_audio
	Checksum: 0xC6C50B99
	Offset: 0x6318
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function getRandomCharacter(Ignore)
{
	Array = level.players;
	Array::randomize(Array);
	foreach(guy in Array)
	{
		if(guy.characterindex == Ignore)
		{
			continue;
		}
		return guy;
	}
	return undefined;
}

/*
	Name: getSpecificCharacter
	Namespace: zm_audio
	Checksum: 0x906DF99B
	Offset: 0x63E8
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function getSpecificCharacter(charIndex)
{
	foreach(guy in level.players)
	{
		if(guy.characterindex == charIndex)
		{
			return guy;
		}
	}
	return undefined;
}

/*
	Name: isAnyoneTalking
	Namespace: zm_audio
	Checksum: 0x91CF5572
	Offset: 0x6490
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function isAnyoneTalking()
{
	foreach(player in level.players)
	{
		if(isdefined(player.isSpeaking) && player.isSpeaking)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: sndConvoInterrupt
	Namespace: zm_audio
	Checksum: 0xD181A787
	Offset: 0x6538
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function sndConvoInterrupt()
{
	level endon("sndConvoLineDone");
	while(1)
	{
		if(!isdefined(self))
		{
			return;
		}
		max_dist_squared = 0;
		check_pos = self.origin;
		count = 0;
		foreach(player in level.players)
		{
			if(self == player)
			{
				continue;
			}
			if(Distance2DSquared(player.origin, self.origin) >= 810000)
			{
				count++;
			}
		}
		if(count == level.players.size - 1)
		{
			break;
		}
		wait(0.25);
	}
	level thread sndConvoStopCurrentConversation();
}

/*
	Name: water_vox
	Namespace: zm_audio
	Checksum: 0x7BA90ECD
	Offset: 0x6690
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function water_vox()
{
	self endon("death");
	self endon("disconnect");
	level endon("end_game");
	self.voxUnderwaterTime = 0;
	self.voxEmergeBreath = 0;
	self.voxDrowning = 0;
	while(1)
	{
		if(self IsPlayerUnderwater())
		{
			if(!self.voxUnderwaterTime && !self.voxEmergeBreath)
			{
				self vo_clear_underwater();
				self.voxUnderwaterTime = GetTime();
			}
			else if(self.voxUnderwaterTime)
			{
				if(GetTime() > self.voxUnderwaterTime + 3000)
				{
					self.voxUnderwaterTime = 0;
					self.voxEmergeBreath = 1;
				}
			}
		}
		else if(self.voxDrowning)
		{
			self playerExert("underwater_gasp");
			self.voxDrowning = 0;
			self.voxEmergeBreath = 0;
		}
		if(self.voxEmergeBreath)
		{
			self playerExert("underwater_emerge");
			self.voxEmergeBreath = 0;
		}
		else
		{
			self.voxUnderwaterTime = 0;
		}
		wait(0.05);
	}
}

/*
	Name: vo_clear_underwater
	Namespace: zm_audio
	Checksum: 0x3977F264
	Offset: 0x6808
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function vo_clear_underwater()
{
	if(level flag::exists("abcd_speaking"))
	{
		if(level flag::get("abcd_speaking"))
		{
			return;
		}
	}
	if(level flag::exists("shadowman_speaking"))
	{
		if(level flag::get("shadowman_speaking"))
		{
			return;
		}
	}
	self stopsounds();
	self notify("stop_vo_convo");
	self.str_vo_being_spoken = "";
	self.n_vo_priority = 0;
	self.isSpeaking = 0;
	level.sndVoxOverride = 0;
	b_in_a_e_speakers = 0;
	foreach(e_checkme in level.a_e_speakers)
	{
		if(e_checkme == self)
		{
			b_in_a_e_speakers = 1;
			break;
		}
	}
	if(isdefined(b_in_a_e_speakers) && b_in_a_e_speakers)
	{
		ArrayRemoveValue(level.a_e_speakers, self);
	}
}

/*
	Name: sndPlayerHitAlert
	Namespace: zm_audio
	Checksum: 0xEE82D5D8
	Offset: 0x69B8
	Size: 0xCB
	Parameters: 4
	Flags: None
*/
function sndPlayerHitAlert(e_victim, str_meansofdeath, e_inflictor, weapon)
{
	if(!(isdefined(level.sndZHDAudio) && level.sndZHDAudio))
	{
		return;
	}
	if(!isPlayer(self))
	{
		return;
	}
	if(!CheckForValidMod(str_meansofdeath))
	{
		return;
	}
	if(!CheckForValidWeapon(weapon))
	{
		return;
	}
	if(!CheckForValidAIType(e_victim))
	{
		return;
	}
	str_alias = "zmb_hit_alert";
	self thread sndPlayerHitAlert_PlaySound(str_alias);
}

/*
	Name: sndPlayerHitAlert_PlaySound
	Namespace: zm_audio
	Checksum: 0x52736E3
	Offset: 0x6A90
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function sndPlayerHitAlert_PlaySound(str_alias)
{
	self endon("disconnect");
	if(self.hitSoundTracker)
	{
		self.hitSoundTracker = 0;
		self playsoundtoplayer(str_alias, self);
		wait(0.05);
		self.hitSoundTracker = 1;
	}
}

/*
	Name: CheckForValidMod
	Namespace: zm_audio
	Checksum: 0xE1A1B2D1
	Offset: 0x6AF0
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function CheckForValidMod(str_meansofdeath)
{
	if(!isdefined(str_meansofdeath))
	{
		return 0;
	}
	switch(str_meansofdeath)
	{
		case "MOD_CRUSH":
		case "MOD_GRENADE_SPLASH":
		case "MOD_HIT_BY_OBJECT":
		case "MOD_MELEE":
		case "MOD_MELEE_ASSASSINATE":
		case "MOD_MELEE_WEAPON_BUTT":
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: CheckForValidWeapon
	Namespace: zm_audio
	Checksum: 0x472CCE52
	Offset: 0x6B60
	Size: 0xF
	Parameters: 1
	Flags: None
*/
function CheckForValidWeapon(weapon)
{
	return 1;
}

/*
	Name: CheckForValidAIType
	Namespace: zm_audio
	Checksum: 0x9E8FBC95
	Offset: 0x6B78
	Size: 0xF
	Parameters: 1
	Flags: None
*/
function CheckForValidAIType(e_victim)
{
	return 1;
}

