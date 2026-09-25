#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equip_gasmask;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_gravity;

#namespace zm_moon_gravity;

/*
	Name: init
	Namespace: zm_moon_gravity
	Checksum: 0xD58CF54C
	Offset: 0x4B0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function init()
{
	level.zombie_init_done = &zombie_moon_init_done;
	level thread init_low_gravity_fx();
	zm_spawner::register_zombie_death_animscript_callback(&gravity_zombie_death_response);
	callback::on_spawned(&low_gravity_watch);
	level thread update_zombie_locomotion();
	level thread update_low_gravity_fx();
	level thread update_zombie_gravity_transition();
	callback::on_spawned(&player_throw_grenade);
}

/*
	Name: init_low_gravity_fx
	Namespace: zm_moon_gravity
	Checksum: 0xDE6C0869
	Offset: 0x598
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function init_low_gravity_fx()
{
	keys = getArrayKeys(level.zones);
	for(i = 0; i < level.zones.size; i++)
	{
		if(keys[i] == "nml_zone")
		{
			continue;
		}
		ZeroGravityVolumeOn(keys[i]);
	}
	wait(0.5);
	level._effect["low_gravity_blood"] = "dlc5/moon/fx_bul_impact_blood_lowgrav";
}

/*
	Name: gravity_trigger
	Namespace: zm_moon_gravity
	Checksum: 0x8814F522
	Offset: 0x658
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function gravity_trigger()
{
	while(1)
	{
		self waittill("trigger", who);
		if(!isPlayer(who))
		{
			self thread trigger::function_thread(who, &gravity_zombie_in, &gravity_zombie_out);
		}
		else
		{
			self thread trigger::function_thread(who, &gravity_player_in, &gravity_player_out);
		}
	}
}

/*
	Name: gravity_zombie_in
	Namespace: zm_moon_gravity
	Checksum: 0x613A507B
	Offset: 0x718
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function gravity_zombie_in(ent, endon_condition)
{
	if(!isdefined(ent.in_low_gravity))
	{
		ent.in_low_gravity = 0;
	}
	ent.in_low_gravity++;
	ent clientfield::set("low_gravity", 1);
}

/*
	Name: gravity_zombie_out
	Namespace: zm_moon_gravity
	Checksum: 0x1F123193
	Offset: 0x790
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function gravity_zombie_out(ent)
{
	if(ent.in_low_gravity > 0)
	{
		ent.in_low_gravity--;
		if(ent.in_low_gravity == 0)
		{
			ent clientfield::set("low_gravity", 0);
		}
	}
}

/*
	Name: gravity_player_in
	Namespace: zm_moon_gravity
	Checksum: 0x55170B94
	Offset: 0x800
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function gravity_player_in(ent, endon_condition)
{
	ent setplayergravity(136);
}

/*
	Name: gravity_player_out
	Namespace: zm_moon_gravity
	Checksum: 0xCBFD8C6E
	Offset: 0x838
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function gravity_player_out(ent)
{
	ent clearplayergravity();
}

/*
	Name: gravity_zombie_update
	Namespace: zm_moon_gravity
	Checksum: 0xC14CFCB6
	Offset: 0x868
	Size: 0x153
	Parameters: 2
	Flags: None
*/
function gravity_zombie_update(LOW_GRAVITY, force_update)
{
	if(!isdefined(self.animName))
	{
		return;
	}
	if(isdefined(self.ignore_gravity) && self.ignore_gravity)
	{
		return;
	}
	if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area))
	{
		return;
	}
	if(isdefined(self.in_low_gravity) && self.in_low_gravity == LOW_GRAVITY && (!isdefined(force_update) && force_update))
	{
		return;
	}
	self.in_low_gravity = LOW_GRAVITY;
	if(LOW_GRAVITY)
	{
		self clientfield::set("low_gravity", 1);
		self.script_noteworthy = "moon_gravity";
		self.zombie_damage_fx_func = &function_7a7cde90;
	}
	else
	{
		self.zombie_damage_fx_func = undefined;
		self.nogravity = undefined;
		self.script_noteworthy = undefined;
		util::wait_network_frame();
		if(isdefined(self))
		{
			self clientfield::set("low_gravity", 0);
			self thread reset_zombie_anim();
		}
	}
}

/*
	Name: function_7a7cde90
	Namespace: zm_moon_gravity
	Checksum: 0x11AD4B86
	Offset: 0x9C8
	Size: 0xE7
	Parameters: 5
	Flags: None
*/
function function_7a7cde90(mod, HIT_LOCATION, hit_origin, player, direction_vec)
{
	if(mod === "MOD_PISTOL_BULLET" || mod === "MOD_RIFLE_BULLET")
	{
		FORWARD = AnglesToForward(direction_vec);
		up = anglesToUp(direction_vec);
		right = AnglesToRight(direction_vec);
		playFX(level._effect["low_gravity_blood"], hit_origin, FORWARD, up);
		/#
		#/
	}
}

/*
	Name: gravity_zombie_death_response
	Namespace: zm_moon_gravity
	Checksum: 0x835D80AE
	Offset: 0xAB8
	Size: 0x215
	Parameters: 0
	Flags: None
*/
function gravity_zombie_death_response()
{
	if(!isdefined(self.in_low_gravity) || self.in_low_gravity == 0 || (isdefined(self._black_hole_bomb_collapse_death) && self._black_hole_bomb_collapse_death))
	{
		return 0;
	}
	self StartRagdoll();
	rag_x = randomIntRange(-50, 50);
	rag_y = randomIntRange(-50, 50);
	rag_z = randomIntRange(25, 45);
	force_min = 75;
	force_max = 100;
	if(self.damageMod == "MOD_MELEE")
	{
		force_min = 40;
		force_max = 50;
		rag_z = 15;
	}
	else if(self.damageWeapon == level.start_weapon)
	{
		force_min = 60;
		force_max = 75;
		rag_z = 20;
	}
	else if(self.damageWeapon.weapClass == "spread")
	{
		force_min = 100;
		force_max = 150;
	}
	scale = randomIntRange(force_min, force_max);
	rag_x = self.damagedir[0] * scale;
	rag_y = self.damagedir[1] * scale;
	dir = (rag_x, rag_y, rag_z);
	self LaunchRagdoll(dir);
	return 0;
}

/*
	Name: zombie_moon_is_low_gravity_zone
	Namespace: zm_moon_gravity
	Checksum: 0xFCBA135D
	Offset: 0xCD8
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function zombie_moon_is_low_gravity_zone(zone_name)
{
	zone = GetEntArray(zone_name, "targetname");
	if(isdefined(zone[0].script_string) && zone[0].script_string == "lowgravity")
	{
		return 1;
	}
	return 0;
}

/*
	Name: zombie_moon_check_zone
	Namespace: zm_moon_gravity
	Checksum: 0x49096B13
	Offset: 0xD58
	Size: 0x12B
	Parameters: 0
	Flags: None
*/
function zombie_moon_check_zone()
{
	self endon("death");
	util::wait_network_frame();
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.ignore_gravity) && self.ignore_gravity)
	{
		return;
	}
	if(self.zone_name == "nml_zone_spawners" || self.zone_name == "nml_area1_spawners" || self.zone_name == "nml_area2_spawners")
	{
		return;
	}
	if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area))
	{
		self waittill("completed_emerging_into_playable_area");
	}
	if(isdefined(level.on_the_moon) && level.on_the_moon && (!level flag::get("power_on") || zombie_moon_is_low_gravity_zone(self.zone_name)))
	{
		self gravity_zombie_update(1);
	}
	else
	{
		self gravity_zombie_update(0);
	}
}

/*
	Name: zombie_moon_init_done
	Namespace: zm_moon_gravity
	Checksum: 0x6276442B
	Offset: 0xE90
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function zombie_moon_init_done()
{
	self.crawl_anim_override = &zombie_moon_crawl_anim_override;
	self thread zombie_moon_check_zone();
	self thread zombie_watch_nogravity();
	self thread zombie_watch_run_notetracks();
}

/*
	Name: zombie_low_gravity_locomotion
	Namespace: zm_moon_gravity
	Checksum: 0xCE0C1610
	Offset: 0xF00
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function zombie_low_gravity_locomotion()
{
	self endon("death");
	gravity_str = undefined;
	if(self.zombie_move_speed == "walk" || self.zombie_move_speed == "run" || self.zombie_move_speed == "sprint")
	{
		gravity_str = "low_gravity_" + self.zombie_move_speed;
	}
	if(isdefined(gravity_str))
	{
		animStateDef = self zombie_utility::append_missing_legs_suffix(gravity_str);
		animStateDef = "walk";
		self zombie_utility::set_zombie_run_cycle(animStateDef);
	}
}

/*
	Name: zombie_watch_nogravity
	Namespace: zm_moon_gravity
	Checksum: 0x6160E821
	Offset: 0xFD0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function zombie_watch_nogravity()
{
	self endon("death");
	_OFF_GROUND_MAX = 32;
	while(1)
	{
		if(isdefined(self.nogravity) && self.nogravity)
		{
			GROUND = self zm_utility::GROUNDPOS(self.origin);
			dist = self.origin[2] - GROUND[2];
			if(dist > _OFF_GROUND_MAX)
			{
				util::wait_network_frame();
				self.nogravity = undefined;
			}
		}
		wait(0.2);
	}
}

/*
	Name: zombie_watch_run_notetracks
	Namespace: zm_moon_gravity
	Checksum: 0x78B762F3
	Offset: 0x10A0
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function zombie_watch_run_notetracks()
{
	self endon("death");
	while(1)
	{
		self waittill("runAnim", note);
		if(!isdefined(self.script_noteworthy) || self.script_noteworthy != "moon_gravity")
		{
			continue;
		}
		if(note == "gravity off")
		{
			self animMode("nogravity");
			self.nogravity = 1;
		}
		else if(note == "gravity code")
		{
			self.nogravity = undefined;
		}
	}
}

/*
	Name: reset_zombie_anim
	Namespace: zm_moon_gravity
	Checksum: 0x2D855160
	Offset: 0x1160
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function reset_zombie_anim()
{
	zombie_utility::set_zombie_run_cycle();
}

/*
	Name: zombie_moon_update_player_gravity
	Namespace: zm_moon_gravity
	Checksum: 0x9979FD54
	Offset: 0x1180
	Size: 0x3AF
	Parameters: 0
	Flags: None
*/
function zombie_moon_update_player_gravity()
{
	level flag::wait_till("start_zombie_round_logic");
	LOW_G = 136;
	player_zones = GetEntArray("player_volume", "script_noteworthy");
	while(1)
	{
		players = GetPlayers();
		for(i = 0; i < player_zones.size; i++)
		{
			volume = player_zones[i];
			zone = undefined;
			if(isdefined(volume.targetname))
			{
				zone = level.zones[volume.targetname];
			}
			if(isdefined(zone) && (isdefined(zone.is_enabled) && zone.is_enabled))
			{
				for(j = 0; j < players.size; j++)
				{
					player = players[j];
					if(zombie_utility::is_player_valid(player) && player istouching(volume))
					{
						if(isdefined(level.on_the_moon) && level.on_the_moon && !level flag::get("power_on"))
						{
							player setPerk("specialty_lowgravity");
							if(!(isdefined(player.in_low_gravity) && player.in_low_gravity))
							{
								player clientfield::set_to_player("snd_lowgravity", 1);
							}
							player.in_low_gravity = 1;
							continue;
						}
						if(isdefined(volume.script_string) && volume.script_string == "lowgravity")
						{
							player setPerk("specialty_lowgravity");
							if(!(isdefined(player.in_low_gravity) && player.in_low_gravity))
							{
								player clientfield::set_to_player("snd_lowgravity", 1);
							}
							player.in_low_gravity = 1;
							continue;
						}
						player unsetPerk("specialty_lowgravity");
						if(isdefined(player.in_low_gravity) && player.in_low_gravity)
						{
							player clientfield::set_to_player("snd_lowgravity", 0);
						}
						player.in_low_gravity = 0;
					}
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: zombie_moon_update_player_float
	Namespace: zm_moon_gravity
	Checksum: 0xF370E94B
	Offset: 0x1538
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function zombie_moon_update_player_float()
{
	level flag::wait_till("start_zombie_round_logic");
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread zombie_moon_player_float();
	}
}

/*
	Name: zombie_moon_player_float
	Namespace: zm_moon_gravity
	Checksum: 0xBE1524A6
	Offset: 0x15C8
	Size: 0x247
	Parameters: 0
	Flags: None
*/
function zombie_moon_player_float()
{
	self endon("death");
	self endon("disconnect");
	boost_chance = 40;
	while(1)
	{
		if(zombie_utility::is_player_valid(self) && (isdefined(self.in_low_gravity) && self.in_low_gravity) && self IsOnGround() && self issprinting())
		{
			boost = RandomInt(100);
			if(boost < boost_chance)
			{
				time = RandomFloatRange(0.75, 1.25);
				wait(time);
				if(isdefined(self.in_low_gravity) && self.in_low_gravity && self IsOnGround() && self issprinting())
				{
					self SetOrigin(self.origin + (0, 0, 1));
					player_velocity = self GetVelocity();
					boost_velocity = player_velocity + VectorScale((0, 0, 1), 100);
					self SetVelocity(boost_velocity);
					if(!(isdefined(level.var_833e8251) && level.var_833e8251))
					{
						self thread zm_audio::create_and_play_dialog("general", "moonjump");
						level.var_833e8251 = 1;
					}
					boost_chance = 40;
					wait(2);
				}
				else
				{
					boost_chance = boost_chance + 10;
				}
			}
			else
			{
				wait(2);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: check_player_gravity
	Namespace: zm_moon_gravity
	Checksum: 0x2E414EF5
	Offset: 0x1818
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function check_player_gravity()
{
	level flag::wait_till("start_zombie_round_logic");
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread low_gravity_watch();
	}
}

/*
	Name: low_gravity_watch
	Namespace: zm_moon_gravity
	Checksum: 0x60DBA2FC
	Offset: 0x18A8
	Size: 0x5CF
	Parameters: 0
	Flags: None
*/
function low_gravity_watch()
{
	self endon("death");
	self endon("disconnect");
	self notify("low_gravity_watch_start");
	self endon("low_gravity_watch_start");
	level flag::wait_till("start_zombie_round_logic");
	self.airless_vox_in_progess = 0;
	time_in_low_gravity = 0;
	time_to_death = 0;
	time_to_death_default = 15000;
	time_to_death_jug = 17000;
	time_til_damage = 0;
	blur_level = 0;
	blur_level_max = 7;
	blur_occur = [];
	blur_occur[0] = 1000;
	blur_occur[1] = 1250;
	blur_occur[2] = 1250;
	blur_occur[3] = 1500;
	blur_occur[4] = 1500;
	blur_occur[5] = 1750;
	blur_occur[6] = 2250;
	blur_occur[7] = 2500;
	blur_intensity = [];
	blur_intensity[0] = 1;
	blur_intensity[1] = 2;
	blur_intensity[2] = 3;
	blur_intensity[3] = 5;
	blur_intensity[4] = 7;
	blur_intensity[5] = 8;
	blur_intensity[6] = 9;
	blur_intensity[7] = 10;
	blur_duration = [];
	blur_duration[0] = 0.2;
	blur_duration[1] = 0.25;
	blur_duration[2] = 0.25;
	blur_duration[3] = 0.5;
	blur_duration[4] = 0.5;
	blur_duration[5] = 0.75;
	blur_duration[6] = 0.75;
	blur_duration[7] = 1;
	if(isdefined(level.debug_low_gravity) && level.debug_low_gravity)
	{
		time_to_death = 3000;
	}
	startTime = GetTime();
	nextTime = GetTime();
	while(1)
	{
		diff = nextTime - startTime;
		if(IsGodMode(self))
		{
			time_in_low_gravity = 0;
			blur_level = 0;
			wait(1);
			continue;
		}
		if(!zombie_utility::is_player_valid(self) || (!isdefined(level.on_the_moon) && level.on_the_moon))
		{
			time_in_low_gravity = 0;
			blur_level = 0;
			util::wait_network_frame();
			continue;
		}
		if(!level flag::get("power_on") || (isdefined(self.in_low_gravity) && self.in_low_gravity) && !self namespace_11fcf241::gasmask_active())
		{
			self thread airless_vox_without_repeat();
			time_til_damage = time_til_damage + diff;
			time_in_low_gravity = time_in_low_gravity + diff;
			if(self hasPerk("specialty_armorvest"))
			{
				time_to_death = time_to_death_jug;
			}
			else
			{
				time_to_death = time_to_death_default;
			}
			if(time_in_low_gravity > time_to_death)
			{
				self playsoundtoplayer("evt_suffocate_whump", self);
				self DoDamage(self.health * 10, self.origin);
				self setblur(0, 0.1);
			}
			else if(blur_level < blur_occur.size && time_til_damage > blur_occur[blur_level])
			{
				self clientfield::set_to_player("gasp_rumble", 1);
				self playsoundtoplayer("evt_suffocate_whump", self);
				self setblur(blur_intensity[blur_level], 0.1);
				self thread remove_blur(blur_duration[blur_level]);
				blur_level++;
				if(blur_level > blur_level_max)
				{
					blur_level = blur_level_max;
				}
				time_til_damage = 0;
			}
		}
		else if(time_in_low_gravity > 0)
		{
			time_in_low_gravity = 0;
			time_til_damage = 0;
			blur_level = 0;
		}
		startTime = GetTime();
		wait(0.1);
		nextTime = GetTime();
	}
}

/*
	Name: remove_blur
	Namespace: zm_moon_gravity
	Checksum: 0x61586D6C
	Offset: 0x1E80
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function remove_blur(time)
{
	self endon("disconnect");
	wait(time);
	self setblur(0, 0.1);
	self clientfield::set_to_player("gasp_rumble", 0);
}

/*
	Name: airless_vox_without_repeat
	Namespace: zm_moon_gravity
	Checksum: 0x90AFBC2C
	Offset: 0x1EE8
	Size: 0x127
	Parameters: 0
	Flags: None
*/
function airless_vox_without_repeat()
{
	self endon("death");
	self endon("disconnect");
	entity_num = self.characterindex;
	if(isdefined(self.zm_random_char))
	{
		entity_num = self.zm_random_char;
	}
	if(entity_num == 2 && (isdefined(level.player_4_vox_override) && level.player_4_vox_override))
	{
		entity_num = 4;
	}
	if(!self.airless_vox_in_progess)
	{
		self.airless_vox_in_progess = 1;
		wait(2);
		if(isdefined(self) && (isdefined(self.in_low_gravity) && self.in_low_gravity))
		{
			level.player_is_speaking = 1;
			self playsoundtoplayer("vox_plr_" + entity_num + "_location_airless_" + randomIntRange(0, 5), self);
			wait(10);
			level.player_is_speaking = 0;
		}
		wait(0.1);
		self.airless_vox_in_progess = 0;
	}
}

/*
	Name: update_zombie_locomotion
	Namespace: zm_moon_gravity
	Checksum: 0xAA28113
	Offset: 0x2018
	Size: 0x1CF
	Parameters: 0
	Flags: None
*/
function update_zombie_locomotion()
{
	level flag::wait_till("power_on");
	player_zones = GetEntArray("player_volume", "script_noteworthy");
	zombies = GetAIArray();
	for(i = 0; i < player_zones.size; i++)
	{
		volume = player_zones[i];
		zone = undefined;
		if(isdefined(volume.targetname))
		{
			zone = level.zones[volume.targetname];
		}
		if(isdefined(zone) && (isdefined(zone.is_enabled) && zone.is_enabled))
		{
			if(isdefined(volume.script_string) && volume.script_string == "gravity")
			{
				for(j = 0; j < zombies.size; j++)
				{
					zombie = zombies[j];
					if(isdefined(zombie) && zombie istouching(volume))
					{
						zombie gravity_zombie_update(0);
					}
				}
			}
		}
	}
}

/*
	Name: update_low_gravity_fx
	Namespace: zm_moon_gravity
	Checksum: 0x3414CFC9
	Offset: 0x21F0
	Size: 0x105
	Parameters: 0
	Flags: None
*/
function update_low_gravity_fx()
{
	level flag::wait_till("power_on");
	keys = getArrayKeys(level.zones);
	for(i = 0; i < level.zones.size; i++)
	{
		if(keys[i] == "nml_zone")
		{
			continue;
		}
		volume = level.zones[keys[i]].Volumes[0];
		if(isdefined(volume.script_string) && volume.script_string == "gravity")
		{
			ZeroGravityVolumeOff(keys[i]);
		}
	}
}

/*
	Name: watch_player_grenades
	Namespace: zm_moon_gravity
	Checksum: 0x24780E5D
	Offset: 0x2300
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function watch_player_grenades()
{
	level flag::wait_till("start_zombie_round_logic");
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread player_throw_grenade();
	}
}

/*
	Name: player_throw_grenade
	Namespace: zm_moon_gravity
	Checksum: 0x85B2D7B1
	Offset: 0x2390
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function player_throw_grenade()
{
	self notify("player_throw_grenade");
	self endon("player_throw_grenade");
	self endon("disconnect");
	level flag::wait_till("start_zombie_round_logic");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapname);
		grenade thread watch_grenade_gravity();
	}
}

/*
	Name: watch_grenade_gravity
	Namespace: zm_moon_gravity
	Checksum: 0x3A035171
	Offset: 0x2420
	Size: 0x28B
	Parameters: 0
	Flags: None
*/
function watch_grenade_gravity()
{
	self endon("death");
	self endon("explode");
	player_zones = GetEntArray("player_volume", "script_noteworthy");
	while(1)
	{
		if(isdefined(level.on_the_moon) && level.on_the_moon && !level flag::get("power_on"))
		{
			if(isdefined(self) && isalive(self))
			{
				self.script_noteworthy = "moon_gravity";
				self SetEntGravityTrajectory(1);
			}
			wait(0.25);
			continue;
		}
		for(i = 0; i < player_zones.size; i++)
		{
			volume = player_zones[i];
			zone = undefined;
			if(isdefined(volume.targetname))
			{
				zone = level.zones[volume.targetname];
			}
			if(isdefined(zone) && (isdefined(zone.is_enabled) && zone.is_enabled))
			{
				if(isdefined(volume.script_string) && volume.script_string == "lowgravity")
				{
					if(isdefined(self) && isalive(self) && self istouching(volume))
					{
						if(volume.script_string == "lowgravity")
						{
							self.script_noteworthy = "moon_gravity";
							self SetEntGravityTrajectory(1);
							continue;
						}
						if(volume.script_string == "gravity")
						{
							self.script_noteworthy = undefined;
							self SetEntGravityTrajectory(0);
						}
					}
				}
			}
		}
		wait(0.25);
	}
}

/*
	Name: update_zombie_gravity_transition
	Namespace: zm_moon_gravity
	Checksum: 0x8C767D47
	Offset: 0x26B8
	Size: 0x75
	Parameters: 0
	Flags: None
*/
function update_zombie_gravity_transition()
{
	airlock_doors = GetEntArray("zombie_door_airlock", "script_noteworthy");
	for(i = 0; i < airlock_doors.size; i++)
	{
		airlock_doors[i] thread zombie_airlock_think();
	}
}

/*
	Name: zombie_airlock_think
	Namespace: zm_moon_gravity
	Checksum: 0x1BA9DFB4
	Offset: 0x2738
	Size: 0x247
	Parameters: 0
	Flags: None
*/
function zombie_airlock_think()
{
	while(1)
	{
		self waittill("trigger", who);
		if(isPlayer(who))
		{
			continue;
		}
		if(!level flag::get("power_on"))
		{
			continue;
		}
		if(isdefined(self.script_parameters))
		{
			zone = GetEntArray(self.script_parameters, "targetname");
			in_airlock = 0;
			for(i = 0; i < zone.size; i++)
			{
				if(who istouching(zone[i]))
				{
					who gravity_zombie_update(0);
					in_airlock = 1;
					break;
				}
			}
			if(in_airlock)
			{
				continue;
			}
		}
		if(self.script_string == "inside")
		{
			if(isdefined(self.doors[0].script_noteworthy))
			{
				_zones = GetEntArray(self.doors[0].script_noteworthy, "targetname");
				if(_zones[0].script_string == "lowgravity")
				{
					who gravity_zombie_update(1);
					self.script_string = "outside";
				}
				else
				{
					who gravity_zombie_update(0);
				}
			}
			else
			{
				who gravity_zombie_update(0);
			}
		}
		else
		{
			who gravity_zombie_update(1);
		}
	}
}

/*
	Name: zone_breached
	Namespace: zm_moon_gravity
	Checksum: 0x613879BE
	Offset: 0x2988
	Size: 0x1AB
	Parameters: 1
	Flags: None
*/
function zone_breached(zone_name)
{
	zones = GetEntArray(zone_name, "targetname");
	zombies = GetAIArray();
	Throttle = 0;
	for(i = 0; i < zombies.size; i++)
	{
		zombie = zombies[i];
		if(isdefined(zombie))
		{
			for(j = 0; j < zones.size; j++)
			{
				if(zombie istouching(zones[j]))
				{
					zombie gravity_zombie_update(1);
					Throttle++;
				}
			}
		}
		else if(Throttle && !Throttle % 10)
		{
			util::wait_network_frame();
			util::wait_network_frame();
			util::wait_network_frame();
		}
	}
	if(isdefined(level.var_2f9ab492) && isdefined(level.var_2f9ab492[zone_name]))
	{
		exploder::delete_exploder_on_clients(level.var_2f9ab492[zone_name]);
	}
}

/*
	Name: zombie_moon_crawl_anim_override
	Namespace: zm_moon_gravity
	Checksum: 0x15CA9642
	Offset: 0x2B40
	Size: 0x1A5
	Parameters: 0
	Flags: None
*/
function zombie_moon_crawl_anim_override()
{
	player_volumes = GetEntArray("player_volume", "script_noteworthy");
	if(!(isdefined(level.on_the_moon) && level.on_the_moon))
	{
		return;
	}
	if(!level flag::get("power_on"))
	{
		self gravity_zombie_update(1, 1);
		break;
	}
	for(i = 0; i < player_volumes.size; i++)
	{
		volume = player_volumes[i];
		zone = undefined;
		if(isdefined(volume.targetname))
		{
			zone = level.zones[volume.targetname];
		}
		if(isdefined(zone) && (isdefined(zone.is_enabled) && zone.is_enabled))
		{
			if(self istouching(volume))
			{
				if(isdefined(volume.script_string) && volume.script_string == "lowgravity")
				{
					self gravity_zombie_update(1, 1);
				}
			}
		}
	}
}

