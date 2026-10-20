#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_thundergun;

#namespace zm_ai_sonic;

/*
	Name: __init__sytem__
	Namespace: zm_ai_sonic
	Checksum: 0x78099771
	Offset: 0x6A8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_sonic", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_sonic
	Checksum: 0x3CFB12FC
	Offset: 0x6F0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_clientfields();
	_sonic_initfx();
	_sonic_initsounds();
	RegisterBehaviorScriptFunctions();
}

/*
	Name: __main__
	Namespace: zm_ai_sonic
	Checksum: 0x9D17E027
	Offset: 0x740
	Size: 0x233
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level.sonicZombiesEnabled = 1;
	level.soniczombieminroundwait = 1;
	level.soniczombiemaxroundwait = 3;
	level.soniczombieroundrequirement = 4;
	level.nextSonicSpawnRound = level.soniczombieroundrequirement + randomIntRange(0, level.soniczombiemaxroundwait + 1);
	level.sonicplayerdamage = 10;
	level.sonicscreamdamageradius = 300;
	level.sonicscreamattackradius = 240;
	level.sonicscreamattackdebouncemin = 3;
	level.sonicscreamattackdebouncemax = 9;
	level.sonicscreamattacknext = 0;
	level.sonichealthmultiplier = 2.5;
	level.sonic_zombie_spawners = GetEntArray("sonic_zombie_spawner", "script_noteworthy");
	zombie_utility::set_zombie_var("thundergun_knockdown_damage", 15);
	level.thundergun_gib_refs = [];
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "guts";
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "right_arm";
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "left_arm";
	Array::thread_all(level.sonic_zombie_spawners, &spawner::add_spawn_function, &sonic_zombie_spawn);
	Array::thread_all(level.sonic_zombie_spawners, &spawner::add_spawn_function, &zombie_utility::round_spawn_failsafe);
	zm_spawner::register_zombie_damage_callback(&_sonic_damage_callback);
	level thread sonic_zombie_spawnthink();
	/#
		println("Dev Block strings are not supported" + level.nextSonicSpawnRound);
	#/
}

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: zm_ai_sonic
	Checksum: 0x2F8A1DE7
	Offset: 0x980
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function RegisterBehaviorScriptFunctions()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("sonicAttackInitialize", &sonicattackinitialize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("sonicAttackTerminate", &sonicattackterminate);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("sonicCanAttack", &soniccanattack);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("sonic_fire", &function_cd107cf);
}

/*
	Name: init_clientfields
	Namespace: zm_ai_sonic
	Checksum: 0xACABAA2F
	Offset: 0xA30
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	clientfield::register("actor", "issonic", 21000, 1, "int");
}

/*
	Name: _sonic_initfx
	Namespace: zm_ai_sonic
	Checksum: 0xDB257CE4
	Offset: 0xA70
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function _sonic_initfx()
{
	level._effect["sonic_explosion"] = "dlc5/temple/fx_ztem_sonic_zombie";
	level._effect["sonic_spawn"] = "dlc5/temple/fx_ztem_sonic_zombie_spawn";
	level._effect["sonic_attack"] = "dlc5/temple/fx_ztem_sonic_zombie_attack";
}

/*
	Name: get_sonic_spawners
	Namespace: zm_ai_sonic
	Checksum: 0x2452BB0D
	Offset: 0xAD0
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_sonic_spawners()
{
	return level.sonic_zombie_spawners;
}

/*
	Name: get_sonic_locations
	Namespace: zm_ai_sonic
	Checksum: 0xB4A667C9
	Offset: 0xAE8
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function get_sonic_locations()
{
	return level.zm_loc_types["napalm_location"];
}

/*
	Name: sonic_zombie_spawnthink
	Namespace: zm_ai_sonic
	Checksum: 0xA336A26
	Offset: 0xB08
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function sonic_zombie_spawnthink()
{
	level waittill("start_of_round");
	while(1)
	{
		if(sonic_spawn_check())
		{
			spawner_list = get_sonic_spawners();
			location_list = get_sonic_locations();
			spawner = Array::random(spawner_list);
			location = Array::random(location_list);
			ai = zombie_utility::spawn_zombie(spawner, spawner.targetname, location);
			if(isdefined(ai))
			{
				ai.spawn_point_override = location;
			}
		}
		wait(3);
	}
}

/*
	Name: do_sonic_spawn
	Namespace: zm_ai_sonic
	Checksum: 0x417ECAE8
	Offset: 0xC18
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function do_sonic_spawn()
{
	self endon("death");
	spot = self.spawn_point_override;
	self.spawn_point = spot;
	if(isdefined(spot.target))
	{
		self.target = spot.target;
	}
	if(isdefined(spot.zone_name))
	{
		self.zone_name = spot.zone_name;
	}
	if(isdefined(spot.script_parameters))
	{
		self.script_parameters = spot.script_parameters;
	}
	self thread zm_spawner::do_zombie_rise(spot);
	playsoundatposition("evt_sonic_spawn", self.origin);
	thread function_332b9adf();
}

/*
	Name: function_332b9adf
	Namespace: zm_ai_sonic
	Checksum: 0xBD9E0475
	Offset: 0xD20
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_332b9adf()
{
	wait(3);
	players = GetPlayers();
	players[randomIntRange(0, players.size)] thread zm_audio::create_and_play_dialog("general", "sonic_spawn");
}

/*
	Name: _sonic_initsounds
	Namespace: zm_ai_sonic
	Checksum: 0x18CD50EA
	Offset: 0xD98
	Size: 0x15F
	Parameters: 0
	Flags: None
*/
function _sonic_initsounds()
{
	level.zmb_vox["sonic_zombie"] = [];
	level.zmb_vox["sonic_zombie"]["ambient"] = "sonic_ambient";
	level.zmb_vox["sonic_zombie"]["sprint"] = "sonic_ambient";
	level.zmb_vox["sonic_zombie"]["attack"] = "sonic_attack";
	level.zmb_vox["sonic_zombie"]["teardown"] = "sonic_attack";
	level.zmb_vox["sonic_zombie"]["taunt"] = "sonic_ambient";
	level.zmb_vox["sonic_zombie"]["behind"] = "sonic_ambient";
	level.zmb_vox["sonic_zombie"]["death"] = "sonic_explode";
	level.zmb_vox["sonic_zombie"]["crawler"] = "sonic_ambient";
	level.zmb_vox["sonic_zombie"]["scream"] = "sonic_scream";
}

/*
	Name: _entity_in_zone
	Namespace: zm_ai_sonic
	Checksum: 0xEC98BF7A
	Offset: 0xF00
	Size: 0x6F
	Parameters: 1
	Flags: None
*/
function _entity_in_zone(zone)
{
	for(i = 0; i < zone.Volumes.size; i++)
	{
		if(self istouching(zone.Volumes[i]))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: sonic_spawn_check
	Namespace: zm_ai_sonic
	Checksum: 0xC0909CF6
	Offset: 0xF78
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function sonic_spawn_check()
{
	if(!isdefined(level.sonicZombiesEnabled) || level.sonicZombiesEnabled == 0 || level.sonic_zombie_spawners.size == 0)
	{
		return 0;
	}
	if(isdefined(level.sonicZombieCount) && level.sonicZombieCount > 0)
	{
		return 0;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") != 0)
		{
			return 1;
		}
	#/
	if(level.nextSonicSpawnRound > level.round_number)
	{
		return 0;
	}
	if(level.last_special_zombie_round >= level.round_number)
	{
		return 0;
	}
	if(level.zombie_total == 0)
	{
		return 0;
	}
	return level.zombie_total < level.zombiesLeftBeforeSonicSpawn;
}

/*
	Name: sonic_zombie_spawn
	Namespace: zm_ai_sonic
	Checksum: 0xF6F06FE5
	Offset: 0x1058
	Size: 0x25B
	Parameters: 1
	Flags: None
*/
function sonic_zombie_spawn(animname_set)
{
	self.custom_location = &do_sonic_spawn;
	zm_spawner::zombie_spawn_init(animname_set);
	level.last_special_zombie_round = level.round_number;
	/#
		println("Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", 0);
	#/
	self.animName = "sonic_zombie";
	self clientfield::set("issonic", 1);
	self.maxhealth = Int(self.maxhealth * level.sonichealthmultiplier);
	self.health = self.maxhealth;
	self.ignore_enemy_count = 1;
	self.sonicscreamattackdebouncemin = 6;
	self.sonicscreamattackdebouncemax = 10;
	self.death_knockdown_range = 480;
	self.death_gib_range = 360;
	self.death_fling_range = 240;
	self.death_scream_range = 480;
	self _updatenextscreamtime();
	self.deathFunction = &sonic_zombie_death;
	self._zombie_shrink_callback = &_sonic_shrink;
	self._zombie_unshrink_callback = &_sonic_unshrink;
	self.monkey_bolt_taunts = &sonic_monkey_bolt_taunts;
	self thread _zombie_runeffects();
	self thread _zombie_initsidestep();
	self thread _zombie_death_watch();
	self thread sonic_zombie_count_watch();
	self.zombie_move_speed = "walk";
	self.zombie_arms_position = "up";
	self.variant_type = RandomInt(3);
}

/*
	Name: _zombie_initsidestep
	Namespace: zm_ai_sonic
	Checksum: 0x290400B6
	Offset: 0x12C0
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function _zombie_initsidestep()
{
	self.zombie_can_sidestep = 1;
}

/*
	Name: _zombie_death_watch
	Namespace: zm_ai_sonic
	Checksum: 0x77D859DC
	Offset: 0x12D8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function _zombie_death_watch()
{
	self waittill("death");
	self clientfield::set("issonic", 0);
}

/*
	Name: _zombie_ambient_sounds
	Namespace: zm_ai_sonic
	Checksum: 0xB2C73337
	Offset: 0x1310
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function _zombie_ambient_sounds()
{
	self endon("death");
	while(1)
	{
	}
}

/*
	Name: _updatenextscreamtime
	Namespace: zm_ai_sonic
	Checksum: 0x1B1319CD
	Offset: 0x1338
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function _updatenextscreamtime()
{
	self.sonicscreamattacknext = GetTime();
	self.sonicscreamattacknext = self.sonicscreamattacknext + randomIntRange(self.sonicscreamattackdebouncemin * 1000, self.sonicscreamattackdebouncemax * 1000);
}

/*
	Name: _canscreamnow
	Namespace: zm_ai_sonic
	Checksum: 0x9468199B
	Offset: 0x1390
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function _canscreamnow()
{
	if(GetTime() > self.sonicscreamattacknext)
	{
		return 1;
	}
	return 0;
}

/*
	Name: soniccanattack
	Namespace: zm_ai_sonic
	Checksum: 0xDAE38123
	Offset: 0x13B8
	Size: 0x18F
	Parameters: 1
	Flags: Private
*/
function private soniccanattack(entity)
{
	if(entity.animName !== "sonic_zombie")
	{
		return 0;
	}
	if(!isdefined(entity.favoriteenemy) || !isPlayer(entity.favoriteenemy))
	{
		return 0;
	}
	hasHead = !isdefined(entity.head_gibbed) && entity.head_gibbed;
	notmini = !isdefined(entity.shrinked) && entity.shrinked;
	screamtime = level _canscreamnow() && entity _canscreamnow();
	if(screamtime && !entity.ignoreall && (!isdefined(entity.is_traversing) && entity.is_traversing) && hasHead && notmini)
	{
		blurplayers = entity _zombie_any_players_in_blur_area();
		if(blurplayers)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: sonicattackinitialize
	Namespace: zm_ai_sonic
	Checksum: 0x4864A892
	Offset: 0x1550
	Size: 0x43
	Parameters: 2
	Flags: Private
*/
function private sonicattackinitialize(entity, asmStateName)
{
	level _updatenextscreamtime();
	entity _updatenextscreamtime();
}

/*
	Name: function_cd107cf
	Namespace: zm_ai_sonic
	Checksum: 0x2A15CF98
	Offset: 0x15A0
	Size: 0x43
	Parameters: 1
	Flags: Private
*/
function private function_cd107cf(entity)
{
	if(entity.animName !== "sonic_zombie")
	{
		return;
	}
	entity _zombie_screamattack();
}

/*
	Name: sonicattackterminate
	Namespace: zm_ai_sonic
	Checksum: 0x5DBCC21
	Offset: 0x15F0
	Size: 0x2B
	Parameters: 2
	Flags: Private
*/
function private sonicattackterminate(entity, asmStateName)
{
	entity _zombie_scream_attack_done();
}

/*
	Name: _zombie_screamattack
	Namespace: zm_ai_sonic
	Checksum: 0x8E38EE17
	Offset: 0x1628
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function _zombie_screamattack()
{
	self playsound("zmb_vocals_sonic_scream");
	self thread _zombie_playscreamfx();
	players = GetPlayers();
	Array::thread_all(players, &_player_screamattackwatch, self);
}

/*
	Name: _zombie_scream_attack_done
	Namespace: zm_ai_sonic
	Checksum: 0xB62E5555
	Offset: 0x16B0
	Size: 0x6D
	Parameters: 0
	Flags: None
*/
function _zombie_scream_attack_done()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] notify("scream_watch_done");
	}
	self notify("scream_attack_done");
}

/*
	Name: _zombie_playscreamfx
	Namespace: zm_ai_sonic
	Checksum: 0xA2F84C6E
	Offset: 0x1728
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function _zombie_playscreamfx()
{
	if(isdefined(self.screamfx))
	{
		self.screamfx delete();
	}
	tag = "tag_eye";
	origin = self GetTagOrigin(tag);
	self.screamfx = spawn("script_model", origin);
	self.screamfx SetModel("tag_origin");
	self.screamfx.angles = self GetTagAngles(tag);
	self.screamfx LinkTo(self, tag);
	PlayFXOnTag(level._effect["sonic_attack"], self.screamfx, "tag_origin");
	self util::waittill_any("death", "scream_attack_done", "shrink");
	self.screamfx delete();
}

/*
	Name: _player_screamattackwatch
	Namespace: zm_ai_sonic
	Checksum: 0x5C0281EF
	Offset: 0x18A8
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function _player_screamattackwatch(sonic_zombie)
{
	self endon("death");
	self endon("scream_watch_done");
	sonic_zombie endon("death");
	self.screamattackblur = 0;
	while(1)
	{
		if(self _player_in_blur_area(sonic_zombie))
		{
			break;
		}
		wait(0.1);
	}
	self thread _player_sonicblurvision(sonic_zombie);
	self thread zm_audio::create_and_play_dialog("general", "sonic_hit");
}

/*
	Name: _player_in_blur_area
	Namespace: zm_ai_sonic
	Checksum: 0x1FF92C28
	Offset: 0x1968
	Size: 0x147
	Parameters: 1
	Flags: None
*/
function _player_in_blur_area(sonic_zombie)
{
	if(Abs(self.origin[2] - sonic_zombie.origin[2]) > 70)
	{
		return 0;
	}
	radiusSqr = level.sonicscreamdamageradius * level.sonicscreamdamageradius;
	if(Distance2DSquared(self.origin, sonic_zombie.origin) > radiusSqr)
	{
		return 0;
	}
	dirtoplayer = self.origin - sonic_zombie.origin;
	dirtoplayer = VectorNormalize(dirtoplayer);
	sonicdir = AnglesToForward(sonic_zombie.angles);
	dot = VectorDot(dirtoplayer, sonicdir);
	if(dot < 0.4)
	{
		return 0;
	}
	return 1;
}

/*
	Name: _zombie_any_players_in_blur_area
	Namespace: zm_ai_sonic
	Checksum: 0xECE3B7F9
	Offset: 0x1AB8
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function _zombie_any_players_in_blur_area()
{
	if(isdefined(level.intermission) && level.intermission)
	{
		return 0;
	}
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(zombie_utility::is_player_valid(player) && player _player_in_blur_area(self))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: _player_sonicblurvision
	Namespace: zm_ai_sonic
	Checksum: 0xA371E3D3
	Offset: 0x1B70
	Size: 0xF7
	Parameters: 1
	Flags: None
*/
function _player_sonicblurvision(zombie)
{
	self endon("disconnect");
	level endon("intermission");
	if(!self.screamattackblur)
	{
		mini = isdefined(zombie) && (isdefined(zombie.shrinked) && zombie.shrinked);
		self.screamattackblur = 1;
		if(mini)
		{
			self _player_screamattackdamage(1, 2, 0.2, "damage_light", zombie);
		}
		else
		{
			self _player_screamattackdamage(4, 5, 0.2, "damage_heavy", zombie);
		}
		self.screamattackblur = 0;
	}
}

/*
	Name: _player_screamattackdamage
	Namespace: zm_ai_sonic
	Checksum: 0x9E49146F
	Offset: 0x1C70
	Size: 0x10B
	Parameters: 5
	Flags: None
*/
function _player_screamattackdamage(time, blurscale, earthquakescale, rumble, attacker)
{
	self thread _player_blurfailsafe();
	Earthquake(earthquakescale, 3, attacker.origin, level.sonicscreamdamageradius, self);
	visionset_mgr::activate("overlay", "zm_ai_screecher_blur", self);
	self PlayRumbleOnEntity(rumble);
	self _player_screamattack_wait(time);
	visionset_mgr::deactivate("overlay", "zm_ai_screecher_blur", self);
	self notify("blur_cleared");
	self StopRumble(rumble);
}

/*
	Name: _player_blurfailsafe
	Namespace: zm_ai_sonic
	Checksum: 0x844824AF
	Offset: 0x1D88
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function _player_blurfailsafe()
{
	self endon("disconnect");
	self endon("blur_cleared");
	level waittill("intermission");
	visionset_mgr::deactivate("overlay", "zm_ai_screecher_blur", self);
}

/*
	Name: _player_screamattack_wait
	Namespace: zm_ai_sonic
	Checksum: 0xCC1DA95E
	Offset: 0x1DE0
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function _player_screamattack_wait(time)
{
	self endon("disconnect");
	level endon("intermission");
	wait(time);
}

/*
	Name: _player_soniczombiedeath_doublevision
	Namespace: zm_ai_sonic
	Checksum: 0x99EC1590
	Offset: 0x1E10
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function _player_soniczombiedeath_doublevision()
{
}

/*
	Name: _zombie_runeffects
	Namespace: zm_ai_sonic
	Checksum: 0x99EC1590
	Offset: 0x1E20
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function _zombie_runeffects()
{
}

/*
	Name: _zombie_setupfxonjoint
	Namespace: zm_ai_sonic
	Checksum: 0x96DDDA01
	Offset: 0x1E30
	Size: 0xEF
	Parameters: 2
	Flags: None
*/
function _zombie_setupfxonjoint(jointname, fxName)
{
	origin = self GetTagOrigin(jointname);
	effectEnt = spawn("script_model", origin);
	effectEnt SetModel("tag_origin");
	effectEnt.angles = self GetTagAngles(jointname);
	effectEnt LinkTo(self, jointname);
	PlayFXOnTag(level._effect[fxName], effectEnt, "tag_origin");
	return effectEnt;
}

/*
	Name: _zombie_getnearbyplayers
	Namespace: zm_ai_sonic
	Checksum: 0xCA1EA914
	Offset: 0x1F28
	Size: 0x12D
	Parameters: 0
	Flags: None
*/
function _zombie_getnearbyplayers()
{
	nearbyPlayers = [];
	radiusSqr = level.sonicscreamattackradius * level.sonicscreamattackradius;
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(!zombie_utility::is_player_valid(players[i]))
		{
			continue;
		}
		playerOrigin = players[i].origin;
		if(Abs(playerOrigin[2] - self.origin[2]) > 70)
		{
			continue;
		}
		if(Distance2DSquared(playerOrigin, self.origin) > radiusSqr)
		{
			continue;
		}
		nearbyPlayers[nearbyPlayers.size] = players[i];
	}
	return nearbyPlayers;
}

/*
	Name: sonic_zombie_death
	Namespace: zm_ai_sonic
	Checksum: 0x60198AC8
	Offset: 0x2060
	Size: 0x141
	Parameters: 8
	Flags: None
*/
function sonic_zombie_death(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	self playsound("evt_sonic_explode");
	if(isdefined(level._effect["sonic_explosion"]))
	{
		PlayFXOnTag(level._effect["sonic_explosion"], self, "J_SpineLower");
	}
	if(isdefined(self.attacker) && isPlayer(self.attacker))
	{
		self.attacker thread zm_audio::create_and_play_dialog("kill", "sonic");
	}
	self thread _sonic_zombie_death_scream(self.attacker);
	_sonic_zombie_death_explode(self.attacker);
	return self zm_spawner::zombie_death_animscript();
}

/*
	Name: zombie_sonic_scream_death
	Namespace: zm_ai_sonic
	Checksum: 0x7B976CBD
	Offset: 0x21B0
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function zombie_sonic_scream_death(attacker)
{
	self endon("death");
	randomWait = RandomFloatRange(0, 1);
	wait(randomWait);
	self.no_powerups = 1;
	self zombie_utility::zombie_eye_glow_stop();
	self playsound("evt_zombies_head_explode");
	self zombie_utility::zombie_head_gib();
	self DoDamage(self.health + 666, self.origin, attacker);
}

/*
	Name: _sonic_zombie_death_scream
	Namespace: zm_ai_sonic
	Checksum: 0xAD3569AF
	Offset: 0x2290
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function _sonic_zombie_death_scream(attacker)
{
	zombies = _sonic_zombie_get_enemies_in_scream_range();
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(zombies[i]))
		{
			continue;
		}
		if(self.animName == "monkey_zombie")
		{
			continue;
		}
		zombies[i] thread zombie_sonic_scream_death(attacker);
	}
}

/*
	Name: _sonic_zombie_death_explode
	Namespace: zm_ai_sonic
	Checksum: 0xCDACCF05
	Offset: 0x2360
	Size: 0x173
	Parameters: 1
	Flags: None
*/
function _sonic_zombie_death_explode(attacker)
{
	PhysicsExplosionCylinder(self.origin, 600, 240, 1);
	if(!isdefined(level.soniczombie_knockdown_enemies))
	{
		level.soniczombie_knockdown_enemies = [];
		level.soniczombie_knockdown_gib = [];
		level.soniczombie_fling_enemies = [];
		level.soniczombie_fling_vecs = [];
	}
	self _sonic_zombie_get_enemies_in_range();
	level.sonic_zombie_network_choke_count = 0;
	for(i = 0; i < level.soniczombie_fling_enemies.size; i++)
	{
		level.soniczombie_fling_enemies[i] thread _soniczombie_fling_zombie(attacker, level.soniczombie_fling_vecs[i], i);
	}
	for(i = 0; i < level.soniczombie_knockdown_enemies.size; i++)
	{
		level.soniczombie_knockdown_enemies[i] thread _soniczombie_knockdown_zombie(attacker, level.soniczombie_knockdown_gib[i]);
	}
	level.soniczombie_knockdown_enemies = [];
	level.soniczombie_knockdown_gib = [];
	level.soniczombie_fling_enemies = [];
	level.soniczombie_fling_vecs = [];
}

/*
	Name: _sonic_zombie_network_choke
	Namespace: zm_ai_sonic
	Checksum: 0x287C7B38
	Offset: 0x24E0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function _sonic_zombie_network_choke()
{
	level.sonic_zombie_network_choke_count++;
	if(!level.sonic_zombie_network_choke_count % 10)
	{
		util::wait_network_frame();
		util::wait_network_frame();
		util::wait_network_frame();
	}
}

/*
	Name: _sonic_zombie_get_enemies_in_scream_range
	Namespace: zm_ai_sonic
	Checksum: 0xE17BF652
	Offset: 0x2538
	Size: 0x157
	Parameters: 0
	Flags: None
*/
function _sonic_zombie_get_enemies_in_scream_range()
{
	return_zombies = [];
	center = self GetCentroid();
	zombies = Array::get_all_closest(center, GetAISpeciesArray("axis", "all"), undefined, undefined, self.death_scream_range);
	if(isdefined(zombies))
	{
		for(i = 0; i < zombies.size; i++)
		{
			if(!isdefined(zombies[i]) || !isalive(zombies[i]))
			{
				continue;
			}
			test_origin = zombies[i] GetCentroid();
			if(!BulletTracePassed(center, test_origin, 0, undefined))
			{
				continue;
			}
			return_zombies[return_zombies.size] = zombies[i];
		}
	}
	return return_zombies;
}

/*
	Name: _sonic_zombie_get_enemies_in_range
	Namespace: zm_ai_sonic
	Checksum: 0x4B05B43E
	Offset: 0x2698
	Size: 0x31B
	Parameters: 0
	Flags: None
*/
function _sonic_zombie_get_enemies_in_range()
{
	center = self GetCentroid();
	zombies = Array::get_all_closest(center, GetAISpeciesArray("axis", "all"), undefined, undefined, self.death_knockdown_range);
	if(!isdefined(zombies))
	{
		return;
	}
	knockdown_range_squared = self.death_knockdown_range * self.death_knockdown_range;
	gib_range_squared = self.death_gib_range * self.death_gib_range;
	fling_range_squared = self.death_fling_range * self.death_fling_range;
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || !isalive(zombies[i]))
		{
			continue;
		}
		test_origin = zombies[i] GetCentroid();
		test_range_squared = DistanceSquared(center, test_origin);
		if(test_range_squared > knockdown_range_squared)
		{
			return;
		}
		if(!BulletTracePassed(center, test_origin, 0, undefined))
		{
			continue;
		}
		if(test_range_squared < fling_range_squared)
		{
			level.soniczombie_fling_enemies[level.soniczombie_fling_enemies.size] = zombies[i];
			dist_mult = fling_range_squared - test_range_squared / fling_range_squared;
			fling_vec = VectorNormalize(test_origin - center);
			fling_vec = (fling_vec[0], fling_vec[1], Abs(fling_vec[2]));
			fling_vec = VectorScale(fling_vec, 100 + 100 * dist_mult);
			level.soniczombie_fling_vecs[level.soniczombie_fling_vecs.size] = fling_vec;
			continue;
		}
		if(test_range_squared < gib_range_squared)
		{
			level.soniczombie_knockdown_enemies[level.soniczombie_knockdown_enemies.size] = zombies[i];
			level.soniczombie_knockdown_gib[level.soniczombie_knockdown_gib.size] = 1;
			continue;
		}
		level.soniczombie_knockdown_enemies[level.soniczombie_knockdown_enemies.size] = zombies[i];
		level.soniczombie_knockdown_gib[level.soniczombie_knockdown_gib.size] = 0;
	}
}

/*
	Name: _soniczombie_fling_zombie
	Namespace: zm_ai_sonic
	Checksum: 0xBFD33633
	Offset: 0x29C0
	Size: 0x11B
	Parameters: 3
	Flags: None
*/
function _soniczombie_fling_zombie(player, fling_vec, index)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	self DoDamage(self.health + 666, player.origin, player);
	if(self.health <= 0)
	{
		points = 10;
		if(!index)
		{
			points = zm_score::get_zombie_death_player_points();
		}
		else if(1 == index)
		{
			points = 30;
		}
		player zm_score::player_add_points("thundergun_fling", points);
		self StartRagdoll();
		self LaunchRagdoll(fling_vec);
	}
}

/*
	Name: _soniczombie_knockdown_zombie
	Namespace: zm_ai_sonic
	Checksum: 0x2BE2F860
	Offset: 0x2AE8
	Size: 0x103
	Parameters: 2
	Flags: None
*/
function _soniczombie_knockdown_zombie(player, gib)
{
	self endon("death");
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(self.thundergun_knockdown_func))
	{
		self.lander_knockdown = 1;
		self [[self.thundergun_knockdown_func]](player, gib);
	}
	else if(gib)
	{
		self.a.gib_ref = Array::random(level.thundergun_gib_refs);
		self thread zombie_death::do_gib();
	}
	self.thundergun_handle_pain_notetracks = &zm_weap_thundergun::handle_thundergun_pain_notetracks;
	self DoDamage(20, player.origin, player);
}

/*
	Name: _sonic_shrink
	Namespace: zm_ai_sonic
	Checksum: 0x99EC1590
	Offset: 0x2BF8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function _sonic_shrink()
{
}

/*
	Name: _sonic_unshrink
	Namespace: zm_ai_sonic
	Checksum: 0x99EC1590
	Offset: 0x2C08
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function _sonic_unshrink()
{
}

/*
	Name: sonic_zombie_count_watch
	Namespace: zm_ai_sonic
	Checksum: 0x9FE60B79
	Offset: 0x2C18
	Size: 0x12F
	Parameters: 0
	Flags: None
*/
function sonic_zombie_count_watch()
{
	if(!isdefined(level.sonicZombieCount))
	{
		level.sonicZombieCount = 0;
	}
	level.sonicZombieCount++;
	self waittill("death");
	level.sonicZombieCount--;
	if(isdefined(self.shrinked) && self.shrinked)
	{
		level.nextSonicSpawnRound = level.round_number + 1;
	}
	else
	{
		level.nextSonicSpawnRound = level.round_number + randomIntRange(level.soniczombieminroundwait, level.soniczombiemaxroundwait + 1);
	}
	/#
		println("Dev Block strings are not supported" + level.nextSonicSpawnRound);
	#/
	attacker = self.attacker;
	if(isdefined(attacker) && isPlayer(attacker) && (isdefined(attacker.screamattackblur) && attacker.screamattackblur))
	{
		attacker notify("blinded_by_the_fright_achieved");
	}
}

/*
	Name: _sonic_damage_callback
	Namespace: zm_ai_sonic
	Checksum: 0x75688DFB
	Offset: 0x2D50
	Size: 0x14B
	Parameters: 13
	Flags: None
*/
function _sonic_damage_callback(str_mod, str_hit_location, v_hit_origin, e_player, n_amount, w_weapon, direction_vec, tagName, modelName, partName, dFlags, inflictor, chargeLevel)
{
	if(isdefined(self.lander_knockdown) && self.lander_knockdown)
	{
		return 0;
	}
	if(self.classname == "actor_spawner_zm_temple_sonic")
	{
		if(!isdefined(self.damagecount))
		{
			self.damagecount = 0;
		}
		if(self.damagecount % Int(GetPlayers().size * level.sonichealthmultiplier) == 0)
		{
			e_player zm_score::player_add_points("thundergun_fling", 10, str_hit_location, self.isdog);
		}
		self.damagecount++;
		self thread zm_powerups::check_for_instakill(e_player, str_mod, str_hit_location);
		return 1;
	}
	return 0;
}

/*
	Name: sonic_monkey_bolt_taunts
	Namespace: zm_ai_sonic
	Checksum: 0xC7B4810A
	Offset: 0x2EA8
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function sonic_monkey_bolt_taunts(monkey_bolt)
{
	return isdefined(self.in_the_ground) && self.in_the_ground;
}

