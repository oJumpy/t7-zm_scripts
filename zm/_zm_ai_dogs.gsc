#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_ai_dogs;

/*
	Name: __init__sytem__
	Namespace: zm_ai_dogs
	Checksum: 0x81AA3C41
	Offset: 0x678
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_dogs", &__init__, undefined, "aat");
}

/*
	Name: __init__
	Namespace: zm_ai_dogs
	Checksum: 0x779F1EFB
	Offset: 0x6B8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("actor", "dog_fx", 1, 1, "int");
	init_dog_fx();
	init();
}

/*
	Name: init
	Namespace: zm_ai_dogs
	Checksum: 0x2267E41
	Offset: 0x718
	Size: 0x2C3
	Parameters: 0
	Flags: None
*/
function init()
{
	level.dogs_enabled = 1;
	level.dog_rounds_enabled = 0;
	level.dog_round_count = 1;
	level.dog_spawners = [];
	level flag::init("dog_clips");
	if(GetDvarString("zombie_dog_animset") == "")
	{
		SetDvar("zombie_dog_animset", "zombie");
	}
	if(GetDvarString("scr_dog_health_walk_multiplier") == "")
	{
		SetDvar("scr_dog_health_walk_multiplier", "4.0");
	}
	if(GetDvarString("scr_dog_run_distance") == "")
	{
		SetDvar("scr_dog_run_distance", "500");
	}
	level.melee_range_sav = GetDvarString("ai_meleeRange");
	level.melee_width_sav = GetDvarString("ai_meleeWidth");
	level.melee_height_sav = GetDvarString("ai_meleeHeight");
	zombie_utility::set_zombie_var("dog_fire_trail_percent", 50);
	level thread AAT::register_immunity("zm_aat_blast_furnace", "zombie_dog", 0, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "zombie_dog", 0, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "zombie_dog", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "zombie_dog", 0, 0, 1);
	level thread AAT::register_immunity("zm_aat_turned", "zombie_dog", 1, 1, 1);
	dog_spawner_init();
	level thread dog_clip_monitor();
}

/*
	Name: init_dog_fx
	Namespace: zm_ai_dogs
	Checksum: 0x8F236E8A
	Offset: 0x9E8
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function init_dog_fx()
{
	level._effect["lightning_dog_spawn"] = "zombie/fx_dog_lightning_buildup_zmb";
	level._effect["dog_eye_glow"] = "zombie/fx_dog_eyes_zmb";
	level._effect["dog_gib"] = "zombie/fx_dog_explosion_zmb";
	level._effect["dog_trail_fire"] = "zombie/fx_dog_fire_trail_zmb";
}

/*
	Name: enable_dog_rounds
	Namespace: zm_ai_dogs
	Checksum: 0x9665787C
	Offset: 0xA68
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function enable_dog_rounds()
{
	level.dog_rounds_enabled = 1;
	if(!isdefined(level.dog_round_track_override))
	{
		level.dog_round_track_override = &dog_round_tracker;
	}
	level thread [[level.dog_round_track_override]]();
}

/*
	Name: dog_spawner_init
	Namespace: zm_ai_dogs
	Checksum: 0x91A8F7EB
	Offset: 0xAB8
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function dog_spawner_init()
{
	level.dog_spawners = GetEntArray("zombie_dog_spawner", "script_noteworthy");
	later_dogs = GetEntArray("later_round_dog_spawners", "script_noteworthy");
	level.dog_spawners = ArrayCombine(level.dog_spawners, later_dogs, 1, 0);
	if(level.dog_spawners.size == 0)
	{
		return;
	}
	for(i = 0; i < level.dog_spawners.size; i++)
	{
		if(zm_spawner::is_spawner_targeted_by_blocker(level.dog_spawners[i]))
		{
			level.dog_spawners[i].is_enabled = 0;
			continue;
		}
		level.dog_spawners[i].is_enabled = 1;
		level.dog_spawners[i].script_forcespawn = 1;
	}
	/#
		Assert(level.dog_spawners.size > 0);
	#/
	level.DOG_HEALTH = 100;
	Array::thread_all(level.dog_spawners, &spawner::add_spawn_function, &dog_init);
}

/*
	Name: dog_round_spawning
	Namespace: zm_ai_dogs
	Checksum: 0x49C5D0DB
	Offset: 0xC70
	Size: 0x4A7
	Parameters: 0
	Flags: None
*/
function dog_round_spawning()
{
	level endon("intermission");
	level endon("end_of_round");
	level endon("restart_round");
	level.dog_targets = GetPlayers();
	for(i = 0; i < level.dog_targets.size; i++)
	{
		level.dog_targets[i].hunted_by = 0;
	}
	level endon("kill_round");
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 2 || GetDvarInt("Dev Block strings are not supported") >= 4)
		{
			return;
		}
	#/
	if(level.intermission)
	{
		return;
	}
	level.dog_intermission = 1;
	level thread dog_round_aftermath();
	players = GetPlayers();
	Array::thread_all(players, &play_dog_round);
	wait(1);
	level thread zm_audio::sndAnnouncerPlayVox("dogstart");
	wait(6);
	if(level.dog_round_count < 3)
	{
		max = players.size * 6;
	}
	else
	{
		max = players.size * 8;
	}
	/#
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
		{
			max = GetDvarInt("Dev Block strings are not supported");
		}
	#/
	level.zombie_total = max;
	dog_health_increase();
	count = 0;
	while(1)
	{
		level flag::wait_till("spawn_zombies");
		while(zombie_utility::get_current_zombie_count() >= level.zombie_ai_limit || level.zombie_total <= 0)
		{
			wait(0.1);
		}
		for(num_player_valid = zm_utility::get_number_of_valid_players(); zombie_utility::get_current_zombie_count() >= num_player_valid * 2;  = zm_utility::get_number_of_valid_players())
		{
			wait(2);
		}
		players = GetPlayers();
		favorite_enemy = get_favorite_enemy();
		if(isdefined(level.dog_spawn_func))
		{
			spawn_loc = [[level.dog_spawn_func]](level.dog_spawners, favorite_enemy);
			ai = zombie_utility::spawn_zombie(level.dog_spawners[0]);
			if(isdefined(ai))
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_loc thread dog_spawn_fx(ai, spawn_loc);
				level.zombie_total--;
				count++;
				level flag::set("dog_clips");
			}
		}
		else
		{
			spawn_point = dog_spawn_factory_logic(favorite_enemy);
			ai = zombie_utility::spawn_zombie(level.dog_spawners[0]);
			if(isdefined(ai))
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx(ai, spawn_point);
				level.zombie_total--;
				count++;
				level flag::set("dog_clips");
			}
		}
		waiting_for_next_dog_spawn(count, max);
	}
}

/*
	Name: waiting_for_next_dog_spawn
	Namespace: zm_ai_dogs
	Checksum: 0xF607A242
	Offset: 0x1120
	Size: 0xCD
	Parameters: 2
	Flags: None
*/
function waiting_for_next_dog_spawn(count, max)
{
	default_wait = 1.5;
	if(level.dog_round_count == 1)
	{
		default_wait = 3;
	}
	else if(level.dog_round_count == 2)
	{
		default_wait = 2.5;
	}
	else if(level.dog_round_count == 3)
	{
		default_wait = 2;
	}
	else
	{
		default_wait = 1.5;
	}
	default_wait = default_wait - count / max;
	default_wait = max(default_wait, 0.05);
	wait(default_wait);
}

/*
	Name: dog_round_aftermath
	Namespace: zm_ai_dogs
	Checksum: 0xE6932B08
	Offset: 0x11F8
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function dog_round_aftermath()
{
	level waittill("last_ai_down", e_last);
	level thread zm_audio::sndMusicSystem_PlayState("dog_end");
	power_up_origin = level.last_dog_origin;
	if(isdefined(e_last))
	{
		power_up_origin = e_last.origin;
	}
	if(isdefined(power_up_origin))
	{
		level thread zm_powerups::specific_powerup_drop("full_ammo", power_up_origin);
	}
	wait(2);
	util::clientNotify("dog_stop");
	wait(6);
	level.dog_intermission = 0;
}

/*
	Name: dog_spawn_fx
	Namespace: zm_ai_dogs
	Checksum: 0xB5DB6735
	Offset: 0x12C8
	Size: 0x333
	Parameters: 2
	Flags: None
*/
function dog_spawn_fx(ai, ent)
{
	ai endon("death");
	ai SetFreeCameraLockOnAllowed(0);
	playFX(level._effect["lightning_dog_spawn"], ent.origin);
	playsoundatposition("zmb_hellhound_prespawn", ent.origin);
	wait(1.5);
	playsoundatposition("zmb_hellhound_bolt", ent.origin);
	Earthquake(0.5, 0.75, ent.origin, 1000);
	playsoundatposition("zmb_hellhound_spawn", ent.origin);
	if(isdefined(ai.favoriteenemy))
	{
		angle = VectorToAngles(ai.favoriteenemy.origin - ent.origin);
		angles = (ai.angles[0], angle[1], ai.angles[2]);
	}
	else
	{
		angles = ent.angles;
	}
	ai ForceTeleport(ent.origin, angles);
	/#
		Assert(isdefined(ai), "Dev Block strings are not supported");
	#/
	/#
		Assert(isalive(ai), "Dev Block strings are not supported");
	#/
	/#
		Assert(ai.isdog, "Dev Block strings are not supported");
	#/
	/#
		Assert(zm_utility::is_magic_bullet_shield_enabled(ai), "Dev Block strings are not supported");
	#/
	ai zombie_setup_attack_properties_dog();
	ai util::stop_magic_bullet_shield();
	wait(0.1);
	ai show();
	ai SetFreeCameraLockOnAllowed(1);
	ai.ignoreme = 0;
	ai notify("visible");
}

/*
	Name: dog_spawn_factory_logic
	Namespace: zm_ai_dogs
	Checksum: 0x2EA8A0D0
	Offset: 0x1608
	Size: 0x121
	Parameters: 1
	Flags: None
*/
function dog_spawn_factory_logic(favorite_enemy)
{
	dog_locs = Array::randomize(level.zm_loc_types["dog_location"]);
	for(i = 0; i < dog_locs.size; i++)
	{
		if(isdefined(level.old_dog_spawn) && level.old_dog_spawn == dog_locs[i])
		{
			continue;
		}
		if(!isdefined(favorite_enemy))
		{
			continue;
		}
		dist_squared = DistanceSquared(dog_locs[i].origin, favorite_enemy.origin);
		if(dist_squared > 160000 && dist_squared < 1000000)
		{
			level.old_dog_spawn = dog_locs[i];
			return dog_locs[i];
		}
	}
	return dog_locs[0];
}

/*
	Name: get_favorite_enemy
	Namespace: zm_ai_dogs
	Checksum: 0x6BBB253C
	Offset: 0x1738
	Size: 0x15D
	Parameters: 0
	Flags: None
*/
function get_favorite_enemy()
{
	dog_targets = GetPlayers();
	least_hunted = dog_targets[0];
	for(i = 0; i < dog_targets.size; i++)
	{
		if(!isdefined(dog_targets[i].hunted_by))
		{
			dog_targets[i].hunted_by = 0;
		}
		if(!zm_utility::is_player_valid(dog_targets[i]))
		{
			continue;
		}
		if(!zm_utility::is_player_valid(least_hunted))
		{
			least_hunted = dog_targets[i];
		}
		if(dog_targets[i].hunted_by < least_hunted.hunted_by)
		{
			least_hunted = dog_targets[i];
		}
	}
	if(!zm_utility::is_player_valid(least_hunted))
	{
		return undefined;
	}
	else
	{
		least_hunted.hunted_by = least_hunted.hunted_by + 1;
		return least_hunted;
	}
}

/*
	Name: dog_health_increase
	Namespace: zm_ai_dogs
	Checksum: 0x9957B674
	Offset: 0x18A0
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function dog_health_increase()
{
	players = GetPlayers();
	if(level.dog_round_count == 1)
	{
		level.DOG_HEALTH = 400;
	}
	else if(level.dog_round_count == 2)
	{
		level.DOG_HEALTH = 900;
	}
	else if(level.dog_round_count == 3)
	{
		level.DOG_HEALTH = 1300;
	}
	else if(level.dog_round_count == 4)
	{
		level.DOG_HEALTH = 1600;
	}
	if(level.DOG_HEALTH > 1600)
	{
		level.DOG_HEALTH = 1600;
	}
}

/*
	Name: dog_round_wait_func
	Namespace: zm_ai_dogs
	Checksum: 0xF1AF3227
	Offset: 0x1960
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function dog_round_wait_func()
{
	if(level flag::get("dog_round"))
	{
		wait(7);
		while(level.dog_intermission)
		{
			wait(0.5);
		}
		zm::increment_dog_round_stat("finished");
	}
	level.sndMusicSpecialRound = 0;
}

/*
	Name: dog_round_tracker
	Namespace: zm_ai_dogs
	Checksum: 0x6F501481
	Offset: 0x19D0
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function dog_round_tracker()
{
	level.dog_round_count = 1;
	level.next_dog_round = level.round_number + randomIntRange(4, 7);
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	while(1)
	{
		level waittill("between_round_over");
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				level.next_dog_round = level.round_number;
			}
		#/
		if(level.round_number == level.next_dog_round)
		{
			level.sndMusicSpecialRound = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			dog_round_start();
			level.round_spawn_func = &dog_round_spawning;
			level.round_wait_func = &dog_round_wait_func;
			level.next_dog_round = level.round_number + randomIntRange(4, 6);
			/#
				GetPlayers()[0] iprintln("Dev Block strings are not supported" + level.next_dog_round);
			#/
		}
		else if(level flag::get("dog_round"))
		{
			dog_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.dog_round_count = level.dog_round_count + 1;
		}
	}
}

/*
	Name: dog_round_start
	Namespace: zm_ai_dogs
	Checksum: 0x8C15BB2E
	Offset: 0x1BD0
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function dog_round_start()
{
	level flag::set("dog_round");
	level flag::set("special_round");
	level flag::set("dog_clips");
	level notify("dog_round_starting");
	level thread zm_audio::sndMusicSystem_PlayState("dog_start");
	util::clientNotify("dog_start");
	if(isdefined(level.dog_melee_range))
	{
		SetDvar("ai_meleeRange", level.dog_melee_range);
	}
	else
	{
		SetDvar("ai_meleeRange", 100);
	}
}

/*
	Name: dog_round_stop
	Namespace: zm_ai_dogs
	Checksum: 0xB099DD97
	Offset: 0x1CD0
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function dog_round_stop()
{
	level flag::clear("dog_round");
	level flag::clear("special_round");
	level flag::clear("dog_clips");
	level notify("dog_round_ending");
	util::clientNotify("dog_stop");
	SetDvar("ai_meleeRange", level.melee_range_sav);
	SetDvar("ai_meleeWidth", level.melee_width_sav);
	SetDvar("ai_meleeHeight", level.melee_height_sav);
}

/*
	Name: play_dog_round
	Namespace: zm_ai_dogs
	Checksum: 0xEAC47A28
	Offset: 0x1DC8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function play_dog_round()
{
	self playlocalsound("zmb_dog_round_start");
	variation_count = 5;
	wait(4.5);
	players = GetPlayers();
	num = randomIntRange(0, players.size);
	players[num] zm_audio::create_and_play_dialog("general", "dog_spawn");
}

/*
	Name: dog_init
	Namespace: zm_ai_dogs
	Checksum: 0x2ACD8E95
	Offset: 0x1E88
	Size: 0x40F
	Parameters: 0
	Flags: None
*/
function dog_init()
{
	self.targetname = "zombie_dog";
	self.script_noteworthy = undefined;
	self.animName = "zombie_dog";
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.allowdeath = 1;
	self.allowPain = 0;
	self.force_gib = 1;
	self.is_zombie = 1;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.default_goalheight = 40;
	self.ignore_inert = 1;
	self.holdFire = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoreSuppression = 1;
	self.suppressionThreshold = 1;
	self.noDodgeMove = 1;
	self.dontShootWhileMoving = 1;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatInitialized = 0;
	self.team = level.zombie_team;
	self.heroweapon_kill_power = 2;
	self AllowPitchAngle(1);
	self SetPitchOrient();
	self SetAvoidanceMask("avoid none");
	self PushActors(1);
	health_multiplier = 1;
	if(GetDvarString("scr_dog_health_walk_multiplier") != "")
	{
		health_multiplier = GetDvarFloat("scr_dog_health_walk_multiplier");
	}
	self.maxhealth = Int(level.DOG_HEALTH * health_multiplier);
	self.health = Int(level.DOG_HEALTH * health_multiplier);
	self.freezegun_damage = 0;
	self.zombie_move_speed = "sprint";
	self.a.nodeath = 1;
	self thread dog_run_think();
	self thread dog_stalk_audio();
	self thread zombie_utility::round_spawn_failsafe();
	self ghost();
	self thread util::magic_bullet_shield();
	self thread dog_death();
	level thread zm_spawner::zombie_death_event(self);
	self thread zm_spawner::enemy_death_detection();
	self thread zm_audio::zmbAIVox_NotifyConvert();
	self.a.disablePain = 1;
	self zm_utility::disable_react();
	self ClearGoalVolume();
	self.flame_damage_time = 0;
	self.meleeDamage = 40;
	self.thundergun_knockdown_func = &dog_thundergun_knockdown;
	self zm_spawner::zombie_history("zombie_dog_spawn_init -> Spawned = " + self.origin);
	if(isdefined(level.achievement_monitor_func))
	{
		self [[level.achievement_monitor_func]]();
	}
}

/*
	Name: dog_death
	Namespace: zm_ai_dogs
	Checksum: 0x3CFAA7AB
	Offset: 0x22A0
	Size: 0x34D
	Parameters: 0
	Flags: None
*/
function dog_death()
{
	self waittill("death");
	if(zombie_utility::get_current_zombie_count() == 0 && level.zombie_total == 0)
	{
		level.last_dog_origin = self.origin;
		level notify("last_ai_down", self);
	}
	if(isPlayer(self.attacker))
	{
		event = "death";
		if(self.damageWeapon.isBallisticKnife)
		{
			event = "ballistic_knife_death";
		}
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			self.attacker zm_score::player_add_points(event, self.damageMod, self.damagelocation, 1);
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](self.attacker, self);
		}
		if(randomIntRange(0, 100) >= 80)
		{
			self.attacker zm_audio::create_and_play_dialog("kill", "hellhound");
		}
		self.attacker zm_stats::increment_client_stat("zdogs_killed");
		self.attacker zm_stats::increment_player_stat("zdogs_killed");
	}
	if(isdefined(self.attacker) && isai(self.attacker))
	{
		self.attacker notify("killed", self);
	}
	self StopLoopSound();
	if(!(isdefined(self.a.nodeath) && self.a.nodeath))
	{
		trace = GroundTrace(self.origin + VectorScale((0, 0, 1), 10), self.origin - VectorScale((0, 0, 1), 30), 0, self);
		if(trace["fraction"] < 1)
		{
			pitch = ACos(VectorDot(trace["normal"], (0, 0, 1)));
			if(pitch > 10)
			{
				self.a.nodeath = 1;
			}
		}
	}
	if(isdefined(self.a.nodeath))
	{
		level thread dog_explode_fx(self.origin);
		self delete();
	}
	else
	{
		self notify("bhtn_action_notify", "death");
	}
}

/*
	Name: dog_explode_fx
	Namespace: zm_ai_dogs
	Checksum: 0xB8E41CFB
	Offset: 0x25F8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function dog_explode_fx(origin)
{
	playFX(level._effect["dog_gib"], origin);
	playsoundatposition("zmb_hellhound_explode", origin);
}

/*
	Name: zombie_setup_attack_properties_dog
	Namespace: zm_ai_dogs
	Checksum: 0x2512CD3C
	Offset: 0x2658
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function zombie_setup_attack_properties_dog()
{
	self zm_spawner::zombie_history("zombie_setup_attack_properties()");
	self thread dog_behind_audio();
	self.ignoreall = 0;
	self.meleeAttackDist = 64;
	self.disableArrivals = 1;
	self.disableExits = 1;
	if(isdefined(level.dog_setup_func))
	{
		self [[level.dog_setup_func]]();
	}
}

/*
	Name: stop_dog_sound_on_death
	Namespace: zm_ai_dogs
	Checksum: 0x87CA10C9
	Offset: 0x26E8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function stop_dog_sound_on_death()
{
	self waittill("death");
	self stopsounds();
}

/*
	Name: dog_behind_audio
	Namespace: zm_ai_dogs
	Checksum: 0xC913C961
	Offset: 0x2718
	Size: 0x1DF
	Parameters: 0
	Flags: None
*/
function dog_behind_audio()
{
	self thread stop_dog_sound_on_death();
	self endon("death");
	self util::waittill_any("dog_running", "dog_combat");
	self notify("bhtn_action_notify", "close");
	wait(3);
	while(1)
	{
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			dogAngle = AngleClamp180(VectorToAngles(self.origin - players[i].origin)[1] - players[i].angles[1]);
			if(isalive(players[i]) && !isdefined(players[i].reviveTrigger))
			{
				if(Abs(dogAngle) > 90 && Distance2D(self.origin, players[i].origin) > 100)
				{
					self notify("bhtn_action_notify", "close");
					wait(3);
				}
			}
		}
		wait(0.75);
	}
}

/*
	Name: dog_clip_monitor
	Namespace: zm_ai_dogs
	Checksum: 0x6B0FABF0
	Offset: 0x2900
	Size: 0x205
	Parameters: 0
	Flags: None
*/
function dog_clip_monitor()
{
	clips_on = 0;
	level.dog_clips = GetEntArray("dog_clips", "targetname");
	while(1)
	{
		for(i = 0; i < level.dog_clips.size; i++)
		{
			level.dog_clips[i] connectpaths();
		}
		level flag::wait_till("dog_clips");
		if(isdefined(level.no_dog_clip) && level.no_dog_clip == 1)
		{
			return;
		}
		for(i = 0; i < level.dog_clips.size; i++)
		{
			level.dog_clips[i] disconnectpaths();
			util::wait_network_frame();
		}
		dog_is_alive = 1;
		while(dog_is_alive || level flag::get("dog_round"))
		{
			dog_is_alive = 0;
			dogs = GetEntArray("zombie_dog", "targetname");
			for(i = 0; i < dogs.size; i++)
			{
				if(isalive(dogs[i]))
				{
					dog_is_alive = 1;
				}
			}
			wait(1);
		}
		level flag::clear("dog_clips");
		wait(1);
	}
}

/*
	Name: special_dog_spawn
	Namespace: zm_ai_dogs
	Checksum: 0xD715D269
	Offset: 0x2B10
	Size: 0x2FB
	Parameters: 3
	Flags: None
*/
function special_dog_spawn(num_to_spawn, spawners, spawn_point)
{
	dogs = GetAISpeciesArray("all", "zombie_dog");
	if(isdefined(dogs) && dogs.size >= 9)
	{
		return 0;
	}
	if(!isdefined(num_to_spawn))
	{
		num_to_spawn = 1;
	}
	spawn_point = undefined;
	count = 0;
	while(count < num_to_spawn)
	{
		players = GetPlayers();
		favorite_enemy = get_favorite_enemy();
		if(isdefined(spawners))
		{
			if(!isdefined(spawn_point))
			{
				spawn_point = spawners[RandomInt(spawners.size)];
			}
			ai = zombie_utility::spawn_zombie(spawn_point);
			if(isdefined(ai))
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx(ai);
				count++;
				level flag::set("dog_clips");
			}
		}
		else if(isdefined(level.dog_spawn_func))
		{
			spawn_loc = [[level.dog_spawn_func]](level.dog_spawners, favorite_enemy);
			ai = zombie_utility::spawn_zombie(level.dog_spawners[0]);
			if(isdefined(ai))
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_loc thread dog_spawn_fx(ai, spawn_loc);
				count++;
				level flag::set("dog_clips");
			}
		}
		else
		{
			spawn_point = dog_spawn_factory_logic(favorite_enemy);
			ai = zombie_utility::spawn_zombie(level.dog_spawners[0]);
			if(isdefined(ai))
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx(ai, spawn_point);
				count++;
				level flag::set("dog_clips");
			}
		}
		waiting_for_next_dog_spawn(count, num_to_spawn);
	}
	return 1;
}

/*
	Name: dog_run_think
	Namespace: zm_ai_dogs
	Checksum: 0xD17D149E
	Offset: 0x2E18
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function dog_run_think()
{
	self endon("death");
	self waittill("visible");
	if(self.health > level.DOG_HEALTH)
	{
		self.maxhealth = level.DOG_HEALTH;
		self.health = level.DOG_HEALTH;
	}
	self clientfield::set("dog_fx", 1);
	self PlayLoopSound("zmb_hellhound_loop_fire");
	while(1)
	{
		if(!zm_utility::is_player_valid(self.favoriteenemy))
		{
			self.favoriteenemy = get_favorite_enemy();
		}
		if(isdefined(level.custom_dog_target_validity_check))
		{
			self [[level.custom_dog_target_validity_check]]();
		}
		wait(0.2);
	}
}

/*
	Name: dog_stalk_audio
	Namespace: zm_ai_dogs
	Checksum: 0x609CC320
	Offset: 0x2F20
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function dog_stalk_audio()
{
	self endon("death");
	self endon("dog_running");
	self endon("dog_combat");
	while(1)
	{
		self notify("bhtn_action_notify", "ambient");
		wait(RandomFloatRange(2, 4));
	}
}

/*
	Name: dog_thundergun_knockdown
	Namespace: zm_ai_dogs
	Checksum: 0x1B76A9F0
	Offset: 0x2F88
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function dog_thundergun_knockdown(player, gib)
{
	self endon("death");
	damage = Int(self.maxhealth * 0.5);
	self DoDamage(damage, player.origin, player);
}

