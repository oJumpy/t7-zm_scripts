#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\serverfaceanim_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;

#namespace spawner;

/*
	Name: __init__sytem__
	Namespace: spawner
	Checksum: 0x3503196B
	Offset: 0x418
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spawner", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: spawner
	Checksum: 0x650B8DE
	Offset: 0x460
	Size: 0x2B3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(GetDvarString("noai") == "")
	{
		SetDvar("noai", "off");
	}
	level._nextcoverprint = 0;
	level._ai_group = [];
	level.killedaxis = 0;
	level.ffpoints = 0;
	level.missionfailed = 0;
	level.gather_delay = [];
	level.smoke_thrown = [];
	level.deathflags = [];
	level.spawner_number = 0;
	level.go_to_node_arrays = [];
	level.next_health_drop_time = 0;
	level.guys_to_die_before_next_health_drop = randomIntRange(1, 4);
	level.portable_mg_gun_tag = "J_Shoulder_RI";
	level.mg42_hide_distance = 1024;
	level.global_spawn_timer = 0;
	level.global_spawn_count = 0;
	if(!isdefined(level.maxFriendlies))
	{
		level.maxFriendlies = 11;
	}
	level.ai_classname_in_level = [];
	spawners = GetSpawnerArray();
	for(i = 0; i < spawners.size; i++)
	{
		spawners[i] thread spawn_prethink();
	}
	thread process_deathflags();
	precache_player_weapon_drops(Array("rpg"));
	goal_volume_init();
	level thread spawner_targets_init();
	level.ai = [];
	add_global_spawn_function("axis", &global_ai_array);
	add_global_spawn_function("allies", &global_ai_array);
	add_global_spawn_function("team3", &global_ai_array);
	level thread update_nav_triggers();
}

/*
	Name: __main__
	Namespace: spawner
	Checksum: 0xE7567A93
	Offset: 0x720
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function __main__()
{
	waittillframeend;
	ai = GetAISpeciesArray("all");
	Array::thread_all(ai, &living_ai_prethink);
	foreach(ai_guy in ai)
	{
		if(isalive(ai_guy))
		{
			ai_guy.overrideActorKilled = &callback_Track_Dead_NPCs_By_Type;
			ai_guy thread spawn_think();
		}
	}
	level thread spawn_throttle_reset();
}

/*
	Name: update_nav_triggers
	Namespace: spawner
	Checksum: 0x4CE4EEA3
	Offset: 0x840
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function update_nav_triggers()
{
	level.valid_navmesh_positions = [];
	a_nav_triggers = GetEntArray("trigger_navmesh", "classname");
	if(!a_nav_triggers.size)
	{
		return;
	}
	level.navmesh_zones = [];
	foreach(trig in a_nav_triggers)
	{
		level.navmesh_zones[trig.targetname] = 0;
	}
	while(1)
	{
		UpdateNavTriggers();
		level util::waittill_notify_or_timeout("update_nav_triggers", 1);
	}
}

/*
	Name: global_ai_array
	Namespace: spawner
	Checksum: 0xA90EA074
	Offset: 0x968
	Size: 0x2B3
	Parameters: 0
	Flags: None
*/
function global_ai_array()
{
	if(!isdefined(level.ai[self.team]))
	{
		level.ai[self.team] = [];
	}
	else if(!IsArray(level.ai[self.team]))
	{
		level.ai[self.team] = Array(level.ai[self.team]);
	}
	level.ai[self.team][level.ai[self.team].size] = self;
	self waittill("death");
	if(isdefined(self))
	{
		if(isdefined(level.ai) && isdefined(level.ai[self.team]) && IsInArray(level.ai[self.team], self))
		{
			ArrayRemoveValue(level.ai[self.team], self);
			break;
		}
		foreach(aiArray in level.ai)
		{
			if(IsInArray(aiArray, self))
			{
				ArrayRemoveValue(aiArray, self);
				break;
			}
		}
		break;
	}
	foreach(Array in level.ai)
	{
		for(i = Array.size - 1; i >= 0; i--)
		{
			if(!isdefined(Array[i]))
			{
				ArrayRemoveIndex(Array, i);
			}
		}
	}
}

/*
	Name: spawn_throttle_reset
	Namespace: spawner
	Checksum: 0xAB53B5A5
	Offset: 0xC28
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function spawn_throttle_reset()
{
	while(1)
	{
		util::wait_network_frame();
		util::wait_network_frame();
		level.global_spawn_count = 0;
	}
}

/*
	Name: global_spawn_throttle
	Namespace: spawner
	Checksum: 0xEE27373E
	Offset: 0xC70
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function global_spawn_throttle(n_count_per_network_frame)
{
	if(!(isdefined(level.first_frame) && level.first_frame))
	{
		while(level.global_spawn_count >= n_count_per_network_frame)
		{
			wait(0.05);
		}
		level.global_spawn_count++;
	}
}

/*
	Name: callback_Track_Dead_NPCs_By_Type
	Namespace: spawner
	Checksum: 0x1787F7B3
	Offset: 0xCC0
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function callback_Track_Dead_NPCs_By_Type()
{
	return;
}

/*
	Name: goal_volume_init
	Namespace: spawner
	Checksum: 0xC4F58EA2
	Offset: 0xCD0
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function goal_volume_init()
{
	Volumes = GetEntArray("info_volume", "classname");
	level.deathchain_goalVolume = [];
	level.goalVolumes = [];
	for(i = 0; i < Volumes.size; i++)
	{
		volume = Volumes[i];
		if(isdefined(volume.script_deathChain))
		{
			level.deathchain_goalVolume[volume.script_deathChain] = volume;
		}
		if(isdefined(volume.script_goalvolume))
		{
			level.goalVolumes[volume.script_goalvolume] = volume;
		}
	}
}

/*
	Name: precache_player_weapon_drops
	Namespace: spawner
	Checksum: 0x3467519C
	Offset: 0xDC8
	Size: 0x10D
	Parameters: 1
	Flags: None
*/
function precache_player_weapon_drops(weapon_names)
{
	level.ai_classname_in_level_keys = getArrayKeys(level.ai_classname_in_level);
	for(i = 0; i < level.ai_classname_in_level_keys.size; i++)
	{
		if(weapon_names.size <= 0)
		{
			break;
		}
		for(j = 0; j < weapon_names.size; j++)
		{
			weaponName = weapon_names[j];
			if(!IsSubStr(ToLower(level.ai_classname_in_level_keys[i]), weaponName))
			{
				continue;
			}
			ArrayRemoveValue(weapon_names, weaponName);
			break;
		}
	}
	level.ai_classname_in_level_keys = undefined;
}

/*
	Name: process_deathflags
	Namespace: spawner
	Checksum: 0x3287C083
	Offset: 0xEE0
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function process_deathflags()
{
	keys = getArrayKeys(level.deathflags);
	level.deathflags = [];
	for(i = 0; i < keys.size; i++)
	{
		deathflag = keys[i];
		level.deathflags[deathflag] = [];
		level.deathflags[deathflag]["ai"] = [];
		if(!isdefined(level.flag[deathflag]))
		{
			level flag::init(deathflag);
		}
	}
}

/*
	Name: spawn_guys_until_death_or_no_count
	Namespace: spawner
	Checksum: 0xEA2265F5
	Offset: 0xFB8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function spawn_guys_until_death_or_no_count()
{
	self endon("death");
	self waittill("count_gone");
}

/*
	Name: flood_spawner_scripted
	Namespace: spawner
	Checksum: 0xD26305C6
	Offset: 0xFE0
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function flood_spawner_scripted(spawners)
{
	/#
		Assert(isdefined(spawners) && spawners.size, "Dev Block strings are not supported");
	#/
	Array::thread_all(spawners, &flood_spawner_init);
	Array::thread_all(spawners, &flood_spawner_think);
}

/*
	Name: reincrement_count_if_deleted
	Namespace: spawner
	Checksum: 0x58C09DA9
	Offset: 0x1068
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function reincrement_count_if_deleted(spawner)
{
	spawner endon("death");
	self waittill("death");
	if(!isdefined(self))
	{
		spawner.count++;
	}
}

/*
	Name: kill_trigger
	Namespace: spawner
	Checksum: 0xF80AB128
	Offset: 0x10B0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function kill_trigger(trigger)
{
	if(!isdefined(trigger))
	{
		return;
	}
	if(isdefined(trigger.targetname) && trigger.targetname != "flood_spawner")
	{
		return;
	}
	trigger delete();
}

/*
	Name: waittillDeathOrPainDeath
	Namespace: spawner
	Checksum: 0x1231D3F3
	Offset: 0x1120
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function waittillDeathOrPainDeath()
{
	self endon("death");
	self waittill("pain_death");
}

/*
	Name: drop_gear
	Namespace: spawner
	Checksum: 0x8D189B6E
	Offset: 0x1148
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function drop_gear()
{
	team = self.team;
	waittillDeathOrPainDeath();
	if(!isdefined(self))
	{
		return;
	}
	if(self.grenadeAmmo <= 0)
	{
		return;
	}
	if(isdefined(self.dropweapon) && !self.dropweapon)
	{
		return;
	}
	if(!isdefined(level.nextGrenadeDrop))
	{
		level.nextGrenadeDrop = RandomInt(3);
	}
	level.nextGrenadeDrop--;
	if(level.nextGrenadeDrop > 0)
	{
		return;
	}
	level.nextGrenadeDrop = 2 + RandomInt(2);
	spawn_grenade_bag(self.origin + (RandomInt(25) - 12, RandomInt(25) - 12, 2) + VectorScale((0, 0, 1), 42), (0, RandomInt(360), 0), self.team);
}

/*
	Name: spawn_grenade_bag
	Namespace: spawner
	Checksum: 0x6F787029
	Offset: 0x12B0
	Size: 0x173
	Parameters: 3
	Flags: None
*/
function spawn_grenade_bag(origin, angles, team)
{
	if(!isdefined(level.grenade_cache) || !isdefined(level.grenade_cache[team]))
	{
		level.grenade_cache_index[team] = 0;
		level.grenade_cache[team] = [];
	}
	index = level.grenade_cache_index[team];
	grenade = level.grenade_cache[team][index];
	if(isdefined(grenade))
	{
		grenade delete();
	}
	count = self.grenadeAmmo;
	grenade = sys::spawn("weapon_" + self.grenadeWeapon.name + level.game_mode_suffix, origin);
	level.grenade_cache[team][index] = grenade;
	level.grenade_cache_index[team] = index + 1 % 16;
	grenade.angles = angles;
	grenade.count = count;
}

/*
	Name: spawn_prethink
	Namespace: spawner
	Checksum: 0xB9EE2ECC
	Offset: 0x1430
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function spawn_prethink()
{
	/#
		Assert(self != level);
	#/
	level.ai_classname_in_level[self.classname] = 1;
	/#
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
		{
			self.count = 0;
			return;
		}
	#/
	if(isdefined(self.script_aigroup))
	{
		aigroup_init(self.script_aigroup, self);
	}
	if(isdefined(self.script_delete))
	{
		array_size = 0;
		if(isdefined(level._ai_delete))
		{
			if(isdefined(level._ai_delete[self.script_delete]))
			{
				array_size = level._ai_delete[self.script_delete].size;
			}
		}
		level._ai_delete[self.script_delete][array_size] = self;
	}
	if(isdefined(self.target))
	{
		crawl_through_targets_to_init_flags();
	}
}

/*
	Name: update_nav_triggers_for_actor
	Namespace: spawner
	Checksum: 0xD3E9150D
	Offset: 0x1560
	Size: 0x5D
	Parameters: 0
	Flags: None
*/
function update_nav_triggers_for_actor()
{
	level notify("update_nav_triggers");
	while(isalive(self))
	{
		self util::waittill_either("death", "goal_changed");
		level notify("update_nav_triggers");
	}
}

/*
	Name: spawn_think
	Namespace: spawner
	Checksum: 0x85444F87
	Offset: 0x15C8
	Size: 0x265
	Parameters: 1
	Flags: None
*/
function spawn_think(spawner)
{
	self endon("death");
	if(isdefined(self.spawn_think_thread_active))
	{
		return;
	}
	self.spawn_think_thread_active = 1;
	self.spawner = spawner;
	/#
		Assert(IsActor(self) || isVehicle(self), "spawner::spawn_think" + "Dev Block strings are not supported");
	#/
	if(!isVehicle(self))
	{
		if(!isalive(self))
		{
			return;
		}
		self.maxhealth = self.health;
		self thread update_nav_triggers_for_actor();
	}
	self.script_animname = undefined;
	if(isdefined(self.script_aigroup))
	{
		level flag::set(self.script_aigroup + "_spawning");
		self thread aigroup_think(level._ai_group[self.script_aigroup]);
	}
	if(isdefined(spawner) && isdefined(spawner.script_dropAmmo))
	{
		self.disableAmmoDrop = !spawner.script_dropAmmo;
	}
	if(isdefined(spawner) && isdefined(spawner.spawn_funcs))
	{
		self.spawn_funcs = spawner.spawn_funcs;
	}
	if(isai(self))
	{
		spawn_think_action(spawner);
		/#
			Assert(isalive(self));
		#/
		/#
			Assert(isdefined(self.team));
		#/
	}
	self thread run_spawn_functions();
	self.finished_spawning = 1;
	self notify("finished spawning");
}

/*
	Name: run_spawn_functions
	Namespace: spawner
	Checksum: 0x752232F9
	Offset: 0x1838
	Size: 0x28D
	Parameters: 0
	Flags: None
*/
function run_spawn_functions()
{
	self endon("death");
	if(!isdefined(level.spawn_funcs))
	{
		return;
	}
	if(isdefined(self.archetype) && isdefined(level.spawn_funcs[self.archetype]))
	{
		for(i = 0; i < level.spawn_funcs[self.archetype].size; i++)
		{
			func = level.spawn_funcs[self.archetype][i];
			util::single_thread(self, func["function"], func["param1"], func["param2"], func["param3"], func["param4"], func["param5"]);
		}
	}
	waittillframeend;
	callback::callback("hash_f96ca9bc");
	if(isdefined(level.spawn_funcs[self.team]))
	{
		for(i = 0; i < level.spawn_funcs[self.team].size; i++)
		{
			func = level.spawn_funcs[self.team][i];
			util::single_thread(self, func["function"], func["param1"], func["param2"], func["param3"], func["param4"], func["param5"]);
		}
	}
	else if(isdefined(self.spawn_funcs))
	{
		for(i = 0; i < self.spawn_funcs.size; i++)
		{
			func = self.spawn_funcs[i];
			util::single_thread(self, func["function"], func["param1"], func["param2"], func["param3"], func["param4"], func["param5"]);
		}
		/#
			return;
		#/
		self.spawn_funcs = undefined;
	}
}

/*
	Name: living_ai_prethink
	Namespace: spawner
	Checksum: 0xFE06D25F
	Offset: 0x1AD0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function living_ai_prethink()
{
	if(isdefined(self.script_deathflag))
	{
		level.deathflags[self.script_deathflag] = 1;
	}
	if(isdefined(self.target))
	{
		crawl_through_targets_to_init_flags();
	}
}

/*
	Name: crawl_through_targets_to_init_flags
	Namespace: spawner
	Checksum: 0xB967ABEC
	Offset: 0x1B20
	Size: 0xAD
	Parameters: 0
	Flags: None
*/
function crawl_through_targets_to_init_flags()
{
	Array = get_node_funcs_based_on_target();
	if(isdefined(Array))
	{
		targets = Array["node"];
		get_func = Array["get_target_func"];
		for(i = 0; i < targets.size; i++)
		{
			crawl_target_and_init_flags(targets[i], get_func);
		}
	}
}

/*
	Name: remove_spawner_values
	Namespace: spawner
	Checksum: 0xB7FB3A9B
	Offset: 0x1BD8
	Size: 0xD
	Parameters: 0
	Flags: None
*/
function remove_spawner_values()
{
	self.spawner_number = undefined;
}

/*
	Name: spawn_think_action
	Namespace: spawner
	Checksum: 0x6CAF08F8
	Offset: 0x1BF0
	Size: 0x67F
	Parameters: 1
	Flags: None
*/
function spawn_think_action(spawner)
{
	remove_spawner_values();
	if(isdefined(level._use_faceanim) && level._use_faceanim)
	{
		self thread serverfaceanim::init_serverfaceanim();
	}
	if(isdefined(spawner))
	{
		if(isdefined(spawner.targetname) && !isdefined(self.targetname))
		{
			self.targetname = spawner.targetname + "_ai";
		}
	}
	if(isdefined(spawner) && isdefined(spawner.script_animname))
	{
		self.animName = spawner.script_animname;
	}
	else if(isdefined(self.script_animname))
	{
		self.animName = self.script_animname;
	}
	/#
		thread show_bad_path();
	#/
	if(isdefined(self.script_forceColor))
	{
		colors::set_force_color(self.script_forceColor);
		if(!isdefined(self.script_no_respawn) || self.script_no_respawn < 1 && !isdefined(level.no_color_respawners_sm))
		{
			self thread replace_on_death();
		}
	}
	if(isdefined(self.script_moveoverride) && self.script_moveoverride == 1)
	{
		override = 1;
	}
	else
	{
		override = 0;
	}
	self.heavy_machine_gunner = IsSubStr(self.classname, "mgportable");
	gameskill::grenadeawareness();
	if(isdefined(self.script_ignoreme))
	{
		/#
			Assert(self.script_ignoreme == 1, "Dev Block strings are not supported");
		#/
		self.ignoreme = 1;
	}
	if(isdefined(self.script_hero))
	{
		/#
			Assert(self.script_hero == 1, "Dev Block strings are not supported");
		#/
	}
	if(isdefined(self.script_ignoreall))
	{
		/#
			Assert(self.script_ignoreall == 1, "Dev Block strings are not supported");
		#/
		self.ignoreall = 1;
	}
	if(isdefined(self.script_sightrange))
	{
		self.maxsightdistsqrd = self.script_sightrange;
	}
	else if(self.weaponClass === "gas")
	{
		self.maxsightdistsqrd = 1048576;
	}
	if(self.team != "axis")
	{
		if(isdefined(self.script_followmin))
		{
			self.followmin = self.script_followmin;
		}
		if(isdefined(self.script_followmax))
		{
			self.followmax = self.script_followmax;
		}
	}
	if(self.team == "axis")
	{
	}
	if(isdefined(self.script_fightdist))
	{
		self.pathEnemyFightDist = self.script_fightdist;
	}
	if(isdefined(self.script_maxdist))
	{
		self.pathenemylookahead = self.script_maxdist;
	}
	if(isdefined(self.script_longdeath))
	{
		/#
			Assert(!self.script_longdeath, "Dev Block strings are not supported" + self.export);
		#/
		self.a.disableLongDeath = 1;
		/#
			Assert(self.team != "Dev Block strings are not supported", "Dev Block strings are not supported" + self.export);
		#/
	}
	if(isdefined(self.script_grenades))
	{
		self.grenadeAmmo = self.script_grenades;
	}
	if(isdefined(self.script_pacifist))
	{
		self.pacifist = 1;
	}
	if(isdefined(self.script_startinghealth))
	{
		self.health = self.script_startinghealth;
	}
	if(isdefined(self.script_allowdeath))
	{
		self.allowdeath = self.script_allowdeath;
	}
	if(isdefined(self.script_forcegib))
	{
		self.force_gib = 1;
	}
	if(isdefined(self.script_lights_on))
	{
		self.has_ir = 1;
	}
	if(isdefined(self.script_patroller))
	{
		return;
	}
	if(isdefined(self.script_rusher) && self.script_rusher)
	{
		return;
	}
	if(isdefined(self.used_an_mg42))
	{
		return;
	}
	if(override)
	{
		self thread set_goalradius_based_on_settings();
		self SetGoal(self.origin);
		return;
	}
	if(isdefined(level.using_awareness) && level.using_awareness)
	{
		return;
	}
	if(isdefined(self.vehicleClass) && self.vehicleClass == "artillery")
	{
		return;
	}
	if(isdefined(self.target))
	{
		e_goal = GetEnt(self.target, "targetname");
		if(isdefined(e_goal))
		{
			self SetGoal(e_goal);
		}
		else
		{
			self thread go_to_node();
		}
	}
	else
	{
		self thread set_goalradius_based_on_settings();
		if(isdefined(self.script_spawner_targets))
		{
			self thread go_to_spawner_target(StrTok(self.script_spawner_targets, " "));
		}
	}
	if(isdefined(self.script_goalvolume))
	{
		self thread set_goal_volume();
	}
	if(isdefined(self.script_turnrate))
	{
		self.turnrate = self.script_turnrate;
	}
}

/*
	Name: set_goal_volume
	Namespace: spawner
	Checksum: 0x5045471C
	Offset: 0x2278
	Size: 0x28B
	Parameters: 0
	Flags: None
*/
function set_goal_volume()
{
	self endon("death");
	waittillframeend;
	volume = level.goalVolumes[self.script_goalvolume];
	if(!isdefined(volume))
	{
		return;
	}
	if(isdefined(volume.target))
	{
		node = GetNode(volume.target, "targetname");
		ent = GetEnt(volume.target, "targetname");
		struct = struct::get(volume.target, "targetname");
		pos = undefined;
		if(isdefined(node))
		{
			pos = node;
			self SetGoal(pos);
		}
		else if(isdefined(ent))
		{
			pos = ent;
			self SetGoal(pos.origin);
		}
		else if(isdefined(struct))
		{
			pos = struct;
			self SetGoal(pos.origin);
		}
		if(isdefined(pos.radius) && pos.radius != 0)
		{
			self.goalRadius = pos.radius;
		}
		if(isdefined(pos.goalHeight) && pos.goalHeight != 0)
		{
			self.goalHeight = pos.goalHeight;
		}
	}
	if(isdefined(self.target))
	{
		self SetGoal(volume);
	}
	else if(isdefined(self.script_spawner_targets))
	{
		self waittill("spawner_target_set");
		self SetGoal(volume);
	}
	else
	{
		self SetGoal(volume);
	}
}

/*
	Name: get_target_ents
	Namespace: spawner
	Checksum: 0x5FC57D3F
	Offset: 0x2510
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_target_ents(target)
{
	return GetEntArray(target, "targetname");
}

/*
	Name: get_target_nodes
	Namespace: spawner
	Checksum: 0x3F161449
	Offset: 0x2548
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_target_nodes(target)
{
	return GetNodeArray(target, "targetname");
}

/*
	Name: get_target_structs
	Namespace: spawner
	Checksum: 0x91273FA2
	Offset: 0x2580
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function get_target_structs(target)
{
	return struct::get_array(target, "targetname");
}

/*
	Name: node_has_radius
	Namespace: spawner
	Checksum: 0xB485D7C8
	Offset: 0x25B8
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function node_has_radius(node)
{
	return isdefined(node.radius) && node.radius != 0;
}

/*
	Name: go_to_origin
	Namespace: spawner
	Checksum: 0xD39D6C93
	Offset: 0x25F8
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function go_to_origin(node, optional_arrived_at_node_func)
{
	self go_to_node(node, "origin", optional_arrived_at_node_func);
}

/*
	Name: go_to_struct
	Namespace: spawner
	Checksum: 0x551DB46D
	Offset: 0x2640
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function go_to_struct(node, optional_arrived_at_node_func)
{
	self go_to_node(node, "struct", optional_arrived_at_node_func);
}

/*
	Name: go_to_node
	Namespace: spawner
	Checksum: 0xABF37034
	Offset: 0x2688
	Size: 0xD3
	Parameters: 3
	Flags: None
*/
function go_to_node(node, goal_type, optional_arrived_at_node_func)
{
	self endon("death");
	if(isdefined(self.used_an_mg42))
	{
		return;
	}
	Array = get_node_funcs_based_on_target(node, goal_type);
	if(!isdefined(Array))
	{
		self notify("reached_path_end");
		return;
	}
	if(!isdefined(optional_arrived_at_node_func))
	{
		optional_arrived_at_node_func = &util::empty;
	}
	go_to_node_using_funcs(Array["node"], Array["get_target_func"], Array["set_goal_func_quits"], optional_arrived_at_node_func);
}

/*
	Name: spawner_targets_init
	Namespace: spawner
	Checksum: 0x41860E1D
	Offset: 0x2768
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function spawner_targets_init()
{
	allnodes = GetAllNodes();
	level.script_spawner_targets_nodes = [];
	for(i = 0; i < allnodes.size; i++)
	{
		if(isdefined(allnodes[i].script_spawner_targets))
		{
			level.script_spawner_targets_nodes[level.script_spawner_targets_nodes.size] = allnodes[i];
		}
	}
}

/*
	Name: go_to_spawner_target
	Namespace: spawner
	Checksum: 0xA7E1FE5B
	Offset: 0x2800
	Size: 0x533
	Parameters: 1
	Flags: None
*/
function go_to_spawner_target(target_names)
{
	self endon("death");
	self notify("go_to_spawner_target");
	self endon("go_to_spawner_target");
	nodes = [];
	a_nodes_unavailable = [];
	nodesPresent = 0;
	for(i = 0; i < target_names.size; i++)
	{
		target_nodes = get_spawner_target_nodes(target_names[i]);
		if(target_nodes.size > 0)
		{
			nodesPresent = 1;
		}
		foreach(node in target_nodes)
		{
			if(IsNodeOccupied(node) || (isdefined(node.node_claimed) && node.node_claimed))
			{
				if(!isdefined(a_nodes_unavailable))
				{
					a_nodes_unavailable = [];
				}
				else if(!IsArray(a_nodes_unavailable))
				{
					a_nodes_unavailable = Array(a_nodes_unavailable);
				}
				a_nodes_unavailable[a_nodes_unavailable.size] = node;
				continue;
			}
			if(isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 512 == 512)
			{
				if(!isdefined(a_nodes_unavailable))
				{
					a_nodes_unavailable = [];
				}
				else if(!IsArray(a_nodes_unavailable))
				{
					a_nodes_unavailable = Array(a_nodes_unavailable);
				}
				a_nodes_unavailable[a_nodes_unavailable.size] = node;
				continue;
			}
			if(!isdefined(nodes))
			{
				nodes = [];
			}
			else if(!IsArray(nodes))
			{
				nodes = Array(nodes);
			}
			nodes[nodes.size] = node;
		}
	}
	if(nodes.size == 0)
	{
		while(nodes.size == 0)
		{
			foreach(node in a_nodes_unavailable)
			{
				if(!IsNodeOccupied(node) && (!isdefined(node.node_claimed) && node.node_claimed) && (!isdefined(node.SPAWNFLAGS) && node.SPAWNFLAGS & 512 == 512))
				{
					if(!isdefined(nodes))
					{
						nodes = [];
					}
					else if(!IsArray(nodes))
					{
						nodes = Array(nodes);
					}
					nodes[nodes.size] = node;
					break;
				}
			}
			wait(0.2);
		}
	}
	/#
		Assert(nodesPresent, "Dev Block strings are not supported");
	#/
	goal = undefined;
	if(nodes.size > 0)
	{
		goal = Array::random(nodes);
	}
	if(isdefined(goal))
	{
		if(isdefined(self.script_radius))
		{
			self.goalRadius = self.script_radius;
		}
		else
		{
			self.goalRadius = 400;
		}
		goal.node_claimed = 1;
		self SetGoal(goal);
		self notify("spawner_target_set");
		self thread release_spawner_target_node(goal);
		self waittill("goal");
	}
	self set_goalradius_based_on_settings(goal);
}

/*
	Name: release_spawner_target_node
	Namespace: spawner
	Checksum: 0xE4A910B5
	Offset: 0x2D40
	Size: 0x41
	Parameters: 1
	Flags: None
*/
function release_spawner_target_node(node)
{
	self util::waittill_any("death", "goal_changed");
	node.node_claimed = undefined;
}

/*
	Name: get_spawner_target_nodes
	Namespace: spawner
	Checksum: 0x9551D670
	Offset: 0x2D90
	Size: 0xF5
	Parameters: 1
	Flags: None
*/
function get_spawner_target_nodes(group)
{
	if(group == "")
	{
		return [];
	}
	nodes = [];
	for(i = 0; i < level.script_spawner_targets_nodes.size; i++)
	{
		groups = StrTok(level.script_spawner_targets_nodes[i].script_spawner_targets, " ");
		for(j = 0; j < groups.size; j++)
		{
			if(groups[j] == group)
			{
				nodes[nodes.size] = level.script_spawner_targets_nodes[i];
			}
		}
	}
	return nodes;
}

/*
	Name: get_least_used_from_array
	Namespace: spawner
	Checksum: 0x7D2CBEB8
	Offset: 0x2E90
	Size: 0x149
	Parameters: 1
	Flags: None
*/
function get_least_used_from_array(Array)
{
	/#
		Assert(Array.size > 0, "Dev Block strings are not supported");
	#/
	if(Array.size == 1)
	{
		return Array[0];
	}
	targetname = Array[0].targetname;
	if(!isdefined(level.go_to_node_arrays[targetname]))
	{
		level.go_to_node_arrays[targetname] = Array;
	}
	Array = level.go_to_node_arrays[targetname];
	first = Array[0];
	newArray = [];
	for(i = 0; i < Array.size - 1; i++)
	{
		newArray[i] = Array[i + 1];
	}
	newArray[Array.size - 1] = Array[0];
	level.go_to_node_arrays[targetname] = newArray;
	return first;
}

/*
	Name: go_to_node_using_funcs
	Namespace: spawner
	Checksum: 0x3C54A625
	Offset: 0x2FE8
	Size: 0x49B
	Parameters: 5
	Flags: None
*/
function go_to_node_using_funcs(node, get_target_func, set_goal_func_quits, optional_arrived_at_node_func, require_player_dist)
{
	self endon("stop_going_to_node");
	self endon("death");
	for(;;)
	{
		node = get_least_used_from_array(node);
		player_wait_dist = require_player_dist;
		if(isdefined(node.script_requires_player))
		{
			if(node.script_requires_player > 1)
			{
				player_wait_dist = node.script_requires_player;
			}
			else
			{
				player_wait_dist = 256;
			}
			node.script_requires_player = 0;
		}
		self set_goalradius_based_on_settings(node);
		if(isdefined(node.height))
		{
			self.goalHeight = node.height;
		}
		[[set_goal_func_quits]](node);
		self waittill("goal");
		[[optional_arrived_at_node_func]](node);
		if(isdefined(node.script_flag_set))
		{
			level flag::set(node.script_flag_set);
		}
		if(isdefined(node.script_flag_clear))
		{
			level flag::set(node.script_flag_clear);
		}
		if(isdefined(node.script_ent_flag_set))
		{
			if(!self flag::exists(node.script_ent_flag_set))
			{
				/#
					ASSERTMSG("Dev Block strings are not supported" + node.script_ent_flag_set + "Dev Block strings are not supported");
				#/
			}
			self flag::set(node.script_ent_flag_set);
		}
		if(isdefined(node.script_ent_flag_clear))
		{
			if(!self flag::exists(node.script_ent_flag_clear))
			{
				/#
					ASSERTMSG("Dev Block strings are not supported" + node.script_ent_flag_clear + "Dev Block strings are not supported");
				#/
			}
			self flag::clear(node.script_ent_flag_clear);
		}
		if(isdefined(node.script_flag_wait))
		{
			level flag::wait_till(node.script_flag_wait);
		}
		while(isdefined(node.script_requires_player))
		{
			node.script_requires_player = 0;
			if(self go_to_node_wait_for_player(node, get_target_func, player_wait_dist))
			{
				node.script_requires_player = 1;
				node notify("script_requires_player");
				break;
			}
			wait(0.1);
		}
		if(isdefined(node.script_aigroup))
		{
			waittill_ai_group_cleared(node.script_aigroup);
		}
		node util::script_delay();
		if(!isdefined(node.target))
		{
		}
		nextNode_array = update_target_array(node.target);
		node = nextNode_array;
	}
	else
	{
		if(!nextNode_array.size)
		{
		}
		else
		{
		}
	}
	if(isdefined(self.arrived_at_end_node_func))
	{
		[[self.arrived_at_end_node_func]](node);
	}
	self notify("reached_path_end");
	if(isdefined(self.delete_on_path_end))
	{
		self delete();
	}
	self set_goalradius_based_on_settings(node);
}

/*
	Name: go_to_node_wait_for_player
	Namespace: spawner
	Checksum: 0xD2399195
	Offset: 0x3490
	Size: 0x345
	Parameters: 3
	Flags: None
*/
function go_to_node_wait_for_player(node, get_target_func, dist)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(DistanceSquared(player.origin, node.origin) < DistanceSquared(self.origin, node.origin))
		{
			return 1;
		}
	}
	vec = AnglesToForward(self.angles);
	if(isdefined(node.target))
	{
		temp = [[get_target_func]](node.target);
		if(temp.size == 1)
		{
			vec = VectorNormalize(temp[0].origin - node.origin);
		}
		else if(isdefined(node.angles))
		{
			vec = AnglesToForward(node.angles);
		}
	}
	else if(isdefined(node.angles))
	{
		vec = AnglesToForward(node.angles);
	}
	vec2 = [];
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		vec2[vec2.size] = VectorNormalize(player.origin - self.origin);
	}
	for(i = 0; i < vec2.size; i++)
	{
		value = vec2[i];
		if(VectorDot(vec, value) > 0)
		{
			return 1;
		}
	}
	dist2rd = dist * dist;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(DistanceSquared(player.origin, self.origin) < dist2rd)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: go_to_node_set_goal_pos
	Namespace: spawner
	Checksum: 0xA1FD4D90
	Offset: 0x37E0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function go_to_node_set_goal_pos(ent)
{
	self SetGoal(ent.origin);
}

/*
	Name: go_to_node_set_goal_node
	Namespace: spawner
	Checksum: 0xAC1E735
	Offset: 0x3818
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function go_to_node_set_goal_node(node)
{
	self SetGoal(node);
}

/*
	Name: remove_crawled
	Namespace: spawner
	Checksum: 0x4752A429
	Offset: 0x3848
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function remove_crawled(ent)
{
	waittillframeend;
	if(isdefined(ent))
	{
		ent.crawled = undefined;
	}
}

/*
	Name: crawl_target_and_init_flags
	Namespace: spawner
	Checksum: 0xCE92A5ED
	Offset: 0x3878
	Size: 0x1A1
	Parameters: 2
	Flags: None
*/
function crawl_target_and_init_flags(ent, get_func)
{
	targets = [];
	index = 0;
	while(!isdefined(ent.crawled))
	{
		ent.crawled = 1;
		level thread remove_crawled(ent);
		if(isdefined(ent.script_flag_set))
		{
			if(!isdefined(level.flag[ent.script_flag_set]))
			{
				level flag::init(ent.script_flag_set);
			}
		}
		if(isdefined(ent.script_flag_wait))
		{
			if(!isdefined(level.flag[ent.script_flag_wait]))
			{
				level flag::init(ent.script_flag_wait);
			}
		}
		if(isdefined(ent.target))
		{
			new_targets = [[get_func]](ent.target);
			Array::add(targets, new_targets);
		}
		index++;
		if(index >= targets.size)
		{
			break;
		}
		ent = targets[index];
	}
}

/*
	Name: get_node_funcs_based_on_target
	Namespace: spawner
	Checksum: 0xC25B008F
	Offset: 0x3A28
	Size: 0x22D
	Parameters: 2
	Flags: None
*/
function get_node_funcs_based_on_target(node, goal_type)
{
	get_target_func["origin"] = &get_target_ents;
	get_target_func["node"] = &get_target_nodes;
	get_target_func["struct"] = &get_target_structs;
	set_goal_func_quits["origin"] = &go_to_node_set_goal_pos;
	set_goal_func_quits["struct"] = &go_to_node_set_goal_pos;
	set_goal_func_quits["node"] = &go_to_node_set_goal_node;
	if(!isdefined(goal_type))
	{
		goal_type = "node";
	}
	Array = [];
	if(isdefined(node))
	{
		Array["node"][0] = node;
	}
	else
	{
		node = GetEntArray(self.target, "targetname");
		if(node.size > 0)
		{
			goal_type = "origin";
		}
		if(goal_type == "node")
		{
			node = GetNodeArray(self.target, "targetname");
			if(!node.size)
			{
				node = struct::get_array(self.target, "targetname");
				if(!node.size)
				{
					return;
				}
				goal_type = "struct";
			}
		}
		Array["node"] = node;
	}
	Array["get_target_func"] = get_target_func[goal_type];
	Array["set_goal_func_quits"] = set_goal_func_quits[goal_type];
	return Array;
}

/*
	Name: update_target_array
	Namespace: spawner
	Checksum: 0x2001031D
	Offset: 0x3C60
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function update_target_array(str_target)
{
	a_nd_target = GetNodeArray(str_target, "targetname");
	if(a_nd_target.size)
	{
		return a_nd_target;
	}
	a_s_target = struct::get_array(str_target, "targetname");
	if(a_s_target.size)
	{
		return a_s_target;
	}
	a_e_target = GetEntArray(str_target, "targetname");
	if(a_e_target.size)
	{
		return a_e_target;
	}
}

/*
	Name: set_goalradius_based_on_settings
	Namespace: spawner
	Checksum: 0x816C1D74
	Offset: 0x3D20
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function set_goalradius_based_on_settings(node)
{
	self endon("death");
	waittillframeend;
	if(isdefined(self.script_radius))
	{
		self.goalRadius = self.script_radius;
	}
	else if(isdefined(node) && node_has_radius(node))
	{
		self.goalRadius = node.radius;
	}
	if(isdefined(self.script_forcegoal) && self.script_forcegoal)
	{
		if(self.script_forcegoal > 1)
		{
		}
		else
		{
		}
		n_radius = undefined;
		self thread ai::force_goal(get_goal(self.target), n_radius);
	}
}

/*
	Name: get_goal
	Namespace: spawner
	Checksum: 0xA1AE2745
	Offset: 0x3E10
	Size: 0x89
	Parameters: 2
	Flags: None
*/
function get_goal(str_goal, str_key)
{
	if(!isdefined(str_key))
	{
		str_key = "targetname";
	}
	a_goals = GetNodeArray(str_goal, str_key);
	if(!a_goals.size)
	{
		a_goals = GetEntArray(str_goal, str_key);
	}
	return Array::random(a_goals);
}

/*
	Name: fallback_spawner_think
	Namespace: spawner
	Checksum: 0x1EFA1498
	Offset: 0x3EA8
	Size: 0x15F
	Parameters: 3
	Flags: None
*/
function fallback_spawner_think(num, node_array, ignoreWhileFallingBack)
{
	self endon("death");
	level.max_fallbackers[num] = level.max_fallbackers[num] + self.count;
	firstSpawn = 1;
	while(self.count > 0)
	{
		self waittill("spawned", spawn);
		if(firstSpawn)
		{
			/#
				if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
				{
					println("Dev Block strings are not supported", num);
				}
			#/
			level notify("fallback_firstspawn" + num);
			firstSpawn = 0;
		}
		wait(0.05);
		if(spawn_failed(spawn))
		{
			level notify("fallbacker_died" + num);
			level.max_fallbackers[num]--;
			continue;
		}
		spawn thread fallback_ai_think(num, node_array, "is spawner", ignoreWhileFallingBack);
	}
}

/*
	Name: fallback_ai_think_death
	Namespace: spawner
	Checksum: 0x45AD9A59
	Offset: 0x4010
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function fallback_ai_think_death(ai, num)
{
	ai waittill("death");
	level.current_fallbackers[num]--;
	level notify("fallbacker_died" + num);
}

/*
	Name: fallback_ai_think
	Namespace: spawner
	Checksum: 0x93C98DB1
	Offset: 0x4060
	Size: 0xDB
	Parameters: 4
	Flags: None
*/
function fallback_ai_think(num, node_array, spawner, ignoreWhileFallingBack)
{
	if(!isdefined(self.fallback) || !isdefined(self.fallback[num]))
	{
		self.fallback[num] = 1;
	}
	else
	{
		return;
	}
	self.script_fallback = num;
	if(!isdefined(spawner))
	{
		level.current_fallbackers[num]++;
	}
	if(isdefined(node_array) && level.fallback_initiated[num])
	{
		self thread fallback_ai(num, node_array, ignoreWhileFallingBack);
	}
	level thread fallback_ai_think_death(self, num);
}

/*
	Name: fallback_death
	Namespace: spawner
	Checksum: 0x946DE9D0
	Offset: 0x4148
	Size: 0x5F
	Parameters: 2
	Flags: None
*/
function fallback_death(ai, num)
{
	ai waittill("death");
	if(isdefined(ai.fallback_node))
	{
		ai.fallback_node.fallback_occupied = 0;
	}
	level notify("fallback_reached_goal" + num);
}

/*
	Name: fallback_goal
	Namespace: spawner
	Checksum: 0x517E74B7
	Offset: 0x41B0
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function fallback_goal(ignoreWhileFallingBack)
{
	self waittill("goal");
	self.ignoreSuppression = 0;
	if(isdefined(ignoreWhileFallingBack) && ignoreWhileFallingBack)
	{
		self.ignoreall = 0;
	}
	self notify("fallback_notify");
	self notify("stop_coverprint");
}

/*
	Name: fallback_interrupt
	Namespace: spawner
	Checksum: 0x6AACB57D
	Offset: 0x4218
	Size: 0x95
	Parameters: 0
	Flags: None
*/
function fallback_interrupt()
{
	self notify("stop_fallback_interrupt");
	self endon("stop_fallback_interrupt");
	self endon("stop_going_to_node");
	self endon("goto next fallback");
	self endon("fallback_notify");
	self endon("death");
	while(1)
	{
		origin = self.origin;
		wait(2);
		if(self.origin == origin)
		{
			self.ignoreall = 0;
			return;
		}
	}
}

/*
	Name: fallback_ai
	Namespace: spawner
	Checksum: 0x8B83EEFF
	Offset: 0x42B8
	Size: 0x25B
	Parameters: 3
	Flags: None
*/
function fallback_ai(num, node_array, ignoreWhileFallingBack)
{
	self notify("stop_going_to_node");
	self endon("stop_going_to_node");
	self endon("goto next fallback");
	self endon("death");
	node = undefined;
	while(1)
	{
		/#
			Assert(node_array.size >= level.current_fallbackers[num], "Dev Block strings are not supported" + num + "Dev Block strings are not supported");
		#/
		node = node_array[RandomInt(node_array.size)];
		if(!isdefined(node.fallback_occupied) || !node.fallback_occupied)
		{
			node.fallback_occupied = 1;
			self.fallback_node = node;
			break;
		}
		wait(0.1);
	}
	self.ignoreSuppression = 1;
	if(self.ignoreall == 0 && isdefined(ignoreWhileFallingBack) && ignoreWhileFallingBack)
	{
		self.ignoreall = 1;
		self thread fallback_interrupt();
	}
	self SetGoal(node);
	if(node.radius != 0)
	{
		self.goalRadius = node.radius;
	}
	self endon("death");
	level thread fallback_death(self, num);
	self thread fallback_goal(ignoreWhileFallingBack);
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			self thread coverprint(node.origin);
		}
	#/
	self waittill("fallback_notify");
	level notify("fallback_reached_goal" + num);
}

/*
	Name: coverprint
	Namespace: spawner
	Checksum: 0x52D8461C
	Offset: 0x4520
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function coverprint(org)
{
	/#
		self endon("fallback_notify");
		self endon("stop_coverprint");
		self endon("death");
		while(1)
		{
			line(self.origin + VectorScale((0, 0, 1), 35), org, (0.2, 0.5, 0.8), 0.5);
			print3d(self.origin + VectorScale((0, 0, 1), 70), "Dev Block strings are not supported", (0.98, 0.4, 0.26), 0.85);
			wait(0.05);
		}
	#/
}

/*
	Name: fallback_overmind
	Namespace: spawner
	Checksum: 0x715670CF
	Offset: 0x4608
	Size: 0x103
	Parameters: 4
	Flags: None
*/
function fallback_overmind(num, group, ignoreWhileFallingBack, percent)
{
	fallback_nodes = undefined;
	nodes = GetAllNodes();
	for(i = 0; i < nodes.size; i++)
	{
		if(isdefined(nodes[i].script_fallback) && nodes[i].script_fallback == num)
		{
			Array::add(fallback_nodes, nodes[i]);
		}
	}
	if(isdefined(fallback_nodes))
	{
		level thread fallback_overmind_internal(num, group, fallback_nodes, ignoreWhileFallingBack, percent);
	}
}

/*
	Name: fallback_overmind_internal
	Namespace: spawner
	Checksum: 0x872445B8
	Offset: 0x4718
	Size: 0x625
	Parameters: 5
	Flags: None
*/
function fallback_overmind_internal(num, group, fallback_nodes, ignoreWhileFallingBack, percent)
{
	level.current_fallbackers[num] = 0;
	level.max_fallbackers[num] = 0;
	level.spawner_fallbackers[num] = 0;
	level.fallback_initiated[num] = 0;
	spawners = GetSpawnerArray();
	for(i = 0; i < spawners.size; i++)
	{
		if(isdefined(spawners[i].script_fallback) && spawners[i].script_fallback == num)
		{
			if(spawners[i].count > 0)
			{
				spawners[i] thread fallback_spawner_think(num, fallback_nodes, ignoreWhileFallingBack);
				level.spawner_fallbackers[num]++;
			}
		}
	}
	/#
		Assert(level.spawner_fallbackers[num] <= fallback_nodes.size, "Dev Block strings are not supported" + num);
	#/
	ai = GetAIArray();
	for(i = 0; i < ai.size; i++)
	{
		if(isdefined(ai[i].script_fallback) && ai[i].script_fallback == num)
		{
			ai[i] thread fallback_ai_think(num, undefined, undefined, ignoreWhileFallingBack);
		}
	}
	if(!level.current_fallbackers[num] && !level.spawner_fallbackers[num])
	{
		return;
	}
	spawners = undefined;
	ai = undefined;
	thread fallback_wait(num, group, ignoreWhileFallingBack, percent);
	level waittill("fallbacker_trigger" + num);
	fallback_add_previous_group(num, fallback_nodes);
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			println("Dev Block strings are not supported", num);
		}
	#/
	level.fallback_initiated[num] = 1;
	fallback_ai = undefined;
	ai = GetAIArray();
	for(i = 0; i < ai.size; i++)
	{
		if(isdefined(ai[i].script_fallback) && ai[i].script_fallback == num || (isdefined(ai[i].script_fallback_group) && isdefined(group) && ai[i].script_fallback_group == group))
		{
			Array::add(fallback_ai, ai[i]);
		}
	}
	ai = undefined;
	if(!isdefined(fallback_ai))
	{
		return;
	}
	if(!isdefined(percent))
	{
		percent = 0.4;
	}
	first_half = fallback_ai.size * percent;
	first_half = Int(first_half);
	level notify("fallback initiated " + num);
	fallback_text(fallback_ai, 0, first_half);
	first_half_ai = [];
	for(i = 0; i < first_half; i++)
	{
		fallback_ai[i] thread fallback_ai(num, fallback_nodes, ignoreWhileFallingBack);
		first_half_ai[i] = fallback_ai[i];
	}
	for(i = 0; i < first_half; i++)
	{
		level waittill("fallback_reached_goal" + num);
	}
	fallback_text(fallback_ai, first_half, fallback_ai.size);
	for(i = 0; i < fallback_ai.size; i++)
	{
		if(isalive(fallback_ai[i]))
		{
			set_fallback = 1;
			for(p = 0; p < first_half_ai.size; p++)
			{
				if(isalive(first_half_ai[p]))
				{
					if(fallback_ai[i] == first_half_ai[p])
					{
						set_fallback = 0;
					}
				}
			}
			if(set_fallback)
			{
				fallback_ai[i] thread fallback_ai(num, fallback_nodes, ignoreWhileFallingBack);
			}
		}
	}
}

/*
	Name: fallback_text
	Namespace: spawner
	Checksum: 0x12F745D2
	Offset: 0x4D48
	Size: 0xA7
	Parameters: 3
	Flags: None
*/
function fallback_text(fallbackers, start, end)
{
	if(GetTime() <= level._nextcoverprint)
	{
		return;
	}
	for(i = start; i < end; i++)
	{
		if(!isalive(fallbackers[i]))
		{
			continue;
		}
		level._nextcoverprint = GetTime() + 2500 + RandomInt(2000);
		return;
	}
}

/*
	Name: fallback_wait
	Namespace: spawner
	Checksum: 0x24578858
	Offset: 0x4DF8
	Size: 0x337
	Parameters: 4
	Flags: None
*/
function fallback_wait(num, group, ignoreWhileFallingBack, percent)
{
	level endon("fallbacker_trigger" + num);
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			println("Dev Block strings are not supported", num);
		}
	#/
	for(i = 0; i < level.spawner_fallbackers[num]; i++)
	{
		/#
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				println("Dev Block strings are not supported", num, "Dev Block strings are not supported", i);
			}
		#/
		level waittill("fallback_firstspawn" + num);
	}
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			println("Dev Block strings are not supported", num, "Dev Block strings are not supported", level.current_fallbackers[num]);
		}
	#/
	ai = GetAIArray();
	for(i = 0; i < ai.size; i++)
	{
		if(isdefined(ai[i].script_fallback) && ai[i].script_fallback == num || (isdefined(ai[i].script_fallback_group) && isdefined(group) && ai[i].script_fallback_group == group))
		{
			ai[i] thread fallback_ai_think(num, undefined, undefined, ignoreWhileFallingBack);
		}
	}
	ai = undefined;
	for(deadfallbackers = 0; deadfallbackers < level.max_fallbackers[num] * percent; deadfallbackers++)
	{
		/#
			if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
			{
				println("Dev Block strings are not supported" + deadfallbackers + "Dev Block strings are not supported" + level.max_fallbackers[num] * 0.5);
			}
		#/
		level waittill("fallbacker_died" + num);
	}
	/#
		println(deadfallbackers, "Dev Block strings are not supported");
	#/
	level notify("fallbacker_trigger" + num);
}

/*
	Name: fallback_think
	Namespace: spawner
	Checksum: 0xBF2C4BBA
	Offset: 0x5138
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function fallback_think(trigger)
{
	ignoreWhileFallingBack = 0;
	if(isdefined(trigger.script_ignoreall) && trigger.script_ignoreall)
	{
		ignoreWhileFallingBack = 1;
	}
	if(!isdefined(level.fallback) || !isdefined(level.fallback[trigger.script_fallback]))
	{
		percent = 0.5;
		if(isdefined(trigger.script_percent))
		{
			percent = trigger.script_percent / 100;
		}
		level thread fallback_overmind(trigger.script_fallback, trigger.script_fallback_group, ignoreWhileFallingBack, percent);
	}
	trigger waittill("trigger");
	level notify("fallbacker_trigger" + trigger.script_fallback);
	kill_trigger(trigger);
}

/*
	Name: fallback_add_previous_group
	Namespace: spawner
	Checksum: 0xCAF92468
	Offset: 0x5278
	Size: 0x193
	Parameters: 2
	Flags: None
*/
function fallback_add_previous_group(num, node_array)
{
	if(!isdefined(level.current_fallbackers[num - 1]))
	{
		return;
	}
	for(i = 0; i < level.current_fallbackers[num - 1]; i++)
	{
		level.max_fallbackers[num]++;
	}
	for(i = 0; i < level.current_fallbackers[num - 1]; i++)
	{
		level.current_fallbackers[num]++;
	}
	ai = GetAIArray();
	for(i = 0; i < ai.size; i++)
	{
		if(isdefined(ai[i].script_fallback) && ai[i].script_fallback == num - 1)
		{
			ai[i].script_fallback++;
			if(isdefined(ai[i].fallback_node))
			{
				ai[i].fallback_node.fallback_occupied = 0;
				ai[i].fallback_node = undefined;
			}
		}
	}
}

/*
	Name: aigroup_init
	Namespace: spawner
	Checksum: 0x6BC4BE44
	Offset: 0x5418
	Size: 0x28B
	Parameters: 2
	Flags: None
*/
function aigroup_init(aigroup, spawner)
{
	if(!isdefined(level._ai_group[aigroup]))
	{
		level._ai_group[aigroup] = spawnstruct();
		level._ai_group[aigroup].aigroup = aigroup;
		level._ai_group[aigroup].aicount = 0;
		level._ai_group[aigroup].killed_count = 0;
		level._ai_group[aigroup].ai = [];
		level._ai_group[aigroup].spawners = [];
		level._ai_group[aigroup].cleared_count = 0;
		if(!isdefined(level.flag[aigroup + "_cleared"]))
		{
			level flag::init(aigroup + "_cleared");
		}
		if(!isdefined(level.flag[aigroup + "_spawning"]))
		{
			level flag::init(aigroup + "_spawning");
		}
		level thread set_ai_group_cleared_flag(level._ai_group[aigroup]);
	}
	if(isdefined(spawner))
	{
		if(!isdefined(level._ai_group[aigroup].spawners))
		{
			level._ai_group[aigroup].spawners = [];
		}
		else if(!IsArray(level._ai_group[aigroup].spawners))
		{
			level._ai_group[aigroup].spawners = Array(level._ai_group[aigroup].spawners);
		}
		level._ai_group[aigroup].spawners[level._ai_group[aigroup].spawners.size] = spawner;
		spawner thread aigroup_spawner_death(level._ai_group[aigroup]);
	}
}

/*
	Name: aigroup_spawner_death
	Namespace: spawner
	Checksum: 0xBDF63F13
	Offset: 0x56B0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function aigroup_spawner_death(tracker)
{
	self util::waittill_any("death", "aigroup_spawner_death");
	tracker notify("update_aigroup");
}

/*
	Name: aigroup_think
	Namespace: spawner
	Checksum: 0xDFF95000
	Offset: 0x5700
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function aigroup_think(tracker)
{
	tracker.aicount++;
	tracker.ai[tracker.ai.size] = self;
	tracker notify("update_aigroup");
	if(isdefined(self.script_deathflag_longdeath))
	{
		self waittillDeathOrPainDeath();
	}
	else
	{
		self waittill("death");
	}
	tracker.aicount--;
	tracker.killed_count++;
	tracker notify("update_aigroup");
	wait(0.05);
	tracker.ai = Array::remove_undefined(tracker.ai);
}

/*
	Name: set_ai_group_cleared_flag
	Namespace: spawner
	Checksum: 0x9817C55C
	Offset: 0x57E8
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function set_ai_group_cleared_flag(tracker)
{
	waittillframeend;
	while(tracker.aicount + get_ai_group_spawner_count(tracker.aigroup) > tracker.cleared_count)
	{
		tracker waittill("update_aigroup");
	}
	level flag::set(tracker.aigroup + "_cleared");
}

/*
	Name: flood_trigger_think
	Namespace: spawner
	Checksum: 0xC15E6D62
	Offset: 0x5880
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function flood_trigger_think(trigger)
{
	/#
		Assert(isdefined(trigger.target), "Dev Block strings are not supported" + trigger.origin + "Dev Block strings are not supported");
	#/
	floodSpawners = GetEntArray(trigger.target, "targetname");
	/#
		Assert(floodSpawners.size, "Dev Block strings are not supported" + trigger.target + "Dev Block strings are not supported");
	#/
	for(i = 0; i < floodSpawners.size; i++)
	{
		floodSpawners[i].script_trigger = trigger;
	}
	Array::thread_all(floodSpawners, &flood_spawner_init);
	trigger waittill("trigger");
	floodSpawners = GetEntArray(trigger.target, "targetname");
	Array::thread_all(floodSpawners, &flood_spawner_think, trigger);
}

/*
	Name: flood_spawner_init
	Namespace: spawner
	Checksum: 0x19F6B350
	Offset: 0x5A08
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function flood_spawner_init(spawner)
{
	/#
		Assert(isdefined(self.SPAWNFLAGS) && self.SPAWNFLAGS & 1 == 1, "Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported" + self GetOrigin() + "Dev Block strings are not supported");
	#/
}

/*
	Name: trigger_requires_player
	Namespace: spawner
	Checksum: 0x1E3065FD
	Offset: 0x5A90
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function trigger_requires_player(trigger)
{
	if(!isdefined(trigger))
	{
		return 0;
	}
	return isdefined(trigger.script_requires_player);
}

/*
	Name: flood_spawner_think
	Namespace: spawner
	Checksum: 0x5F93FF34
	Offset: 0x5AC0
	Size: 0x257
	Parameters: 1
	Flags: None
*/
function flood_spawner_think(trigger)
{
	self endon("death");
	self notify("stop current floodspawner");
	self endon("stop current floodspawner");
	requires_player = trigger_requires_player(trigger);
	util::script_delay();
	while(self.count > 0)
	{
		if(requires_player)
		{
			while(!util::any_player_is_touching(trigger))
			{
				wait(0.5);
			}
		}
		Soldier = self spawn();
		if(spawn_failed(Soldier))
		{
			wait(2);
			continue;
		}
		Soldier thread reincrement_count_if_deleted(self);
		Soldier waittill("death", attacker);
		if(!player_saw_kill(Soldier, attacker))
		{
			self.count++;
		}
		if(!isdefined(Soldier))
		{
			continue;
		}
		if(!util::script_wait(1))
		{
			players = GetPlayers();
			if(players.size == 1)
			{
				wait(RandomFloatRange(5, 9));
			}
			else if(players.size == 2)
			{
				wait(RandomFloatRange(3, 6));
			}
			else if(players.size == 3)
			{
				wait(RandomFloatRange(1, 4));
			}
			else if(players.size == 4)
			{
				wait(RandomFloatRange(0.5, 1.5));
			}
		}
	}
}

/*
	Name: player_saw_kill
	Namespace: spawner
	Checksum: 0xF382496E
	Offset: 0x5D20
	Size: 0x251
	Parameters: 2
	Flags: None
*/
function player_saw_kill(guy, attacker)
{
	if(isdefined(self.script_force_count))
	{
		if(self.script_force_count)
		{
			return 1;
		}
	}
	if(!isdefined(guy))
	{
		return 0;
	}
	if(isalive(attacker))
	{
		if(isPlayer(attacker))
		{
			return 1;
		}
		players = GetPlayers();
		for(q = 0; q < players.size; q++)
		{
			if(DistanceSquared(attacker.origin, players[q].origin) < 40000)
			{
				return 1;
			}
		}
	}
	else if(isdefined(attacker))
	{
		if(attacker.classname == "worldspawn")
		{
			return 0;
		}
		player = util::get_closest_player(attacker.origin);
		if(isdefined(player) && DistanceSquared(attacker.origin, player.origin) < 40000)
		{
			return 1;
		}
	}
	closest_player = util::get_closest_player(guy.origin);
	if(isdefined(closest_player) && DistanceSquared(guy.origin, closest_player.origin) < 40000)
	{
		return 1;
	}
	return BulletTracePassed(closest_player GetEye(), guy GetEye(), 0, undefined);
}

/*
	Name: show_bad_path
	Namespace: spawner
	Checksum: 0x360CFB9
	Offset: 0x5F80
	Size: 0x111
	Parameters: 0
	Flags: None
*/
function show_bad_path()
{
	/#
		self endon("death");
		last_bad_path_time = -5000;
		bad_path_count = 0;
		for(;;)
		{
			self waittill("bad_path", badPathPos);
			if(!isdefined(level.debug_badpath) || !level.debug_badpath)
			{
				break;
			}
			if(GetTime() - last_bad_path_time > 5000)
			{
				bad_path_count = 0;
			}
			else
			{
				bad_path_count++;
			}
			last_bad_path_time = GetTime();
			if(bad_path_count < 10)
			{
				break;
			}
			for(p = 0; p < 200; p++)
			{
				line(self.origin, badPathPos, (1, 0.4, 0.1), 0, 200);
				wait(0.05);
			}
		}
	#/
}

/*
	Name: watches_for_friendly_fire
	Namespace: spawner
	Checksum: 0x85934C07
	Offset: 0x60A0
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function watches_for_friendly_fire()
{
	return 1;
}

/*
	Name: spawn
	Namespace: spawner
	Checksum: 0x4042A05F
	Offset: 0x60B0
	Size: 0x885
	Parameters: 5
	Flags: None
*/
function spawn(b_force, str_targetname, v_origin, v_angles, bIgnoreSpawningLimit)
{
	if(!isdefined(b_force))
	{
		b_force = 0;
	}
	if(isdefined(level.overrideGlobalSpawnFunc) && self.team == "axis")
	{
		return [[level.overrideGlobalSpawnFunc]](b_force, str_targetname, v_origin, v_angles);
	}
	e_spawned = undefined;
	force_spawn = 0;
	makeroom = 0;
	infinitespawn = 0;
	deleteonzerocount = 0;
	/#
		if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
		{
			return;
		}
	#/
	if(!check_player_requirements())
	{
		return;
	}
	while(1)
	{
		if(!isdefined(bIgnoreSpawningLimit) && bIgnoreSpawningLimit && (!isdefined(self.ignorespawninglimit) && self.ignorespawninglimit))
		{
			global_spawn_throttle(1);
		}
		if(SessionModeIsCampaignZombiesGame() && !isdefined(self))
		{
			return;
		}
		if(isdefined(self.lastspawntime) && self.lastspawntime >= GetTime())
		{
			wait(0.05);
			continue;
		}
		break;
	}
	if(IsActorSpawner(self))
	{
		if(isdefined(self.SPAWNFLAGS) && self.SPAWNFLAGS & 2 == 2)
		{
			makeroom = 1;
		}
	}
	else if(IsVehicleSpawner(self))
	{
		if(isdefined(self.SPAWNFLAGS) && self.SPAWNFLAGS & 8 == 8)
		{
			makeroom = 1;
		}
	}
	if(b_force || (isdefined(self.SPAWNFLAGS) && self.SPAWNFLAGS & 16 == 16) || isdefined(self.script_forcespawn))
	{
		force_spawn = 1;
	}
	if(isdefined(self.SPAWNFLAGS) && self.SPAWNFLAGS & 64 == 64)
	{
		infinitespawn = 1;
	}
	/#
		if(isdefined(level.var_2daf1c0e) && IsArray(level.var_2daf1c0e))
		{
			var_fa016757 = undefined;
			if(self.team == "Dev Block strings are not supported")
			{
				archetype = GetDvarString("Dev Block strings are not supported");
				if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
				{
					archetype = GetDvarString("Dev Block strings are not supported");
				}
				var_fa016757 = level.var_2daf1c0e[archetype];
			}
			else if(self.team == "Dev Block strings are not supported")
			{
				archetype = GetDvarString("Dev Block strings are not supported");
				if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
				{
					archetype = GetDvarString("Dev Block strings are not supported");
				}
				var_fa016757 = level.var_2daf1c0e[archetype];
			}
			if(IsSpawner(var_fa016757))
			{
				while(isdefined(var_fa016757.lastspawntime) && var_fa016757.lastspawntime >= GetTime())
				{
					wait(0.05);
				}
				originalOrigin = var_fa016757.origin;
				originalAngles = var_fa016757.angles;
				originalTarget = var_fa016757.target;
				var_2bd6b94a = var_fa016757.targetname;
				var_fa016757.target = self.target;
				var_fa016757.targetname = self.targetname;
				var_fa016757.script_noteworthy = self.script_noteworthy;
				var_fa016757.script_string = self.script_string;
				var_fa016757.origin = self.origin;
				var_fa016757.angles = self.angles;
				e_spawned = var_fa016757 SpawnFromSpawner(str_targetname, force_spawn, makeroom, infinitespawn);
				var_fa016757.target = originalTarget;
				var_fa016757.targetname = var_2bd6b94a;
				var_fa016757.origin = originalOrigin;
				var_fa016757.angles = originalAngles;
				if(isdefined(var_fa016757.SPAWNFLAGS) && var_fa016757.SPAWNFLAGS & 64 == 64)
				{
					var_fa016757.count++;
				}
				var_fa016757.lastspawntime = GetTime();
			}
		}
	#/
	if(!isdefined(e_spawned))
	{
		female_override = undefined;
		use_female = RandomInt(100) < level.female_percent;
		if(level.dont_use_female_replacements === 1)
		{
			use_female = 0;
		}
		if(use_female && isdefined(self.aitypevariant))
		{
			e_spawned = self SpawnFromSpawner(str_targetname, force_spawn, makeroom, infinitespawn, "actor_" + self.aitypevariant);
		}
		else
		{
			override_aitype = undefined;
			if(isdefined(level.override_spawned_aitype_func))
			{
				override_aitype = [[level.override_spawned_aitype_func]](self);
			}
			if(isdefined(override_aitype))
			{
				e_spawned = self SpawnFromSpawner(str_targetname, force_spawn, makeroom, infinitespawn, override_aitype);
			}
			else
			{
				e_spawned = self SpawnFromSpawner(str_targetname, force_spawn, makeroom, infinitespawn);
			}
		}
	}
	if(isdefined(e_spawned))
	{
		if(isdefined(level.run_custom_function_on_ai))
		{
			if(isdefined(var_fa016757))
			{
				e_spawned thread [[level.run_custom_function_on_ai]](var_fa016757, str_targetname, force_spawn);
			}
			else
			{
				e_spawned thread [[level.run_custom_function_on_ai]](self, str_targetname, force_spawn);
			}
		}
		if(isdefined(v_origin) || isdefined(v_angles))
		{
			e_spawned teleport_spawned(v_origin, v_angles);
		}
		self.lastspawntime = GetTime();
	}
	if(deleteonzerocount || (isdefined(self.script_delete_on_zero) && self.script_delete_on_zero) && isdefined(self.count) && self.count <= 0)
	{
		self delete();
	}
	if(IsSentient(e_spawned))
	{
		if(!spawn_failed(e_spawned))
		{
			return e_spawned;
		}
	}
	else
	{
		return e_spawned;
	}
}

/*
	Name: teleport_spawned
	Namespace: spawner
	Checksum: 0xD31C8FB2
	Offset: 0x6940
	Size: 0xB7
	Parameters: 3
	Flags: None
*/
function teleport_spawned(v_origin, v_angles, b_reset_entity)
{
	if(!isdefined(b_reset_entity))
	{
		b_reset_entity = 1;
	}
	if(!isdefined(v_origin))
	{
		v_origin = self.origin;
	}
	if(!isdefined(v_angles))
	{
		v_angles = self.angles;
	}
	if(IsActor(self))
	{
		self ForceTeleport(v_origin, v_angles, 1, b_reset_entity);
	}
	else
	{
		self.origin = v_origin;
		self.angles = v_angles;
	}
}

/*
	Name: check_player_requirements
	Namespace: spawner
	Checksum: 0xD9FCF32E
	Offset: 0x6A00
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function check_player_requirements()
{
	if(isdefined(level.players) && level.players.size > 0)
	{
		n_player_count = level.players.size;
	}
	else
	{
		n_player_count = getnumexpectedplayers();
	}
	if(isdefined(self.script_minplayers))
	{
		if(n_player_count < self.script_minplayers)
		{
			self delete();
			return 0;
		}
	}
	if(isdefined(self.script_numplayers))
	{
		if(n_player_count < self.script_numplayers)
		{
			self delete();
			return 0;
		}
	}
	if(isdefined(self.script_maxplayers))
	{
		if(n_player_count > self.script_maxplayers)
		{
			self delete();
			return 0;
		}
	}
	return 1;
}

/*
	Name: spawn_failed
	Namespace: spawner
	Checksum: 0x90D54C0D
	Offset: 0x6B08
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function spawn_failed(spawn)
{
	if(isalive(spawn))
	{
		if(!isdefined(spawn.finished_spawning))
		{
			spawn waittill("finished spawning");
		}
		waittillframeend;
		if(isalive(spawn))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: kill_spawnernum
	Namespace: spawner
	Checksum: 0x93E61A03
	Offset: 0x6B78
	Size: 0xB1
	Parameters: 1
	Flags: None
*/
function kill_spawnernum(Number)
{
	foreach(SP in GetSpawnerArray("" + Number, "script_killspawner"))
	{
		SP delete();
	}
}

/*
	Name: disable_replace_on_death
	Namespace: spawner
	Checksum: 0xC7EAD2BB
	Offset: 0x6C38
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function disable_replace_on_death()
{
	self.replace_on_death = undefined;
	self notify("_disable_reinforcement");
}

/*
	Name: replace_on_death
	Namespace: spawner
	Checksum: 0x822C5BAD
	Offset: 0x6C60
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function replace_on_death()
{
	colors::colorNode_replace_on_death();
}

/*
	Name: set_ai_group_cleared_count
	Namespace: spawner
	Checksum: 0x8E35876B
	Offset: 0x6C80
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function set_ai_group_cleared_count(aigroup, count)
{
	aigroup_init(aigroup);
	level._ai_group[aigroup].cleared_count = count;
}

/*
	Name: waittill_ai_group_cleared
	Namespace: spawner
	Checksum: 0x6972EF5F
	Offset: 0x6CD0
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function waittill_ai_group_cleared(aigroup)
{
	/#
		Assert(isdefined(level._ai_group[aigroup]), "Dev Block strings are not supported" + aigroup + "Dev Block strings are not supported");
	#/
	level flag::wait_till(aigroup + "_cleared");
}

/*
	Name: waittill_ai_group_count
	Namespace: spawner
	Checksum: 0x10748141
	Offset: 0x6D40
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function waittill_ai_group_count(aigroup, count)
{
	while(get_ai_group_spawner_count(aigroup) + level._ai_group[aigroup].aicount > count)
	{
		level._ai_group[aigroup] waittill("update_aigroup");
	}
}

/*
	Name: waittill_ai_group_ai_count
	Namespace: spawner
	Checksum: 0xEAB9FE90
	Offset: 0x6DB8
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function waittill_ai_group_ai_count(aigroup, count)
{
	while(level._ai_group[aigroup].aicount > count)
	{
		level._ai_group[aigroup] waittill("update_aigroup");
	}
}

/*
	Name: waittill_ai_group_spawner_count
	Namespace: spawner
	Checksum: 0x63761DB9
	Offset: 0x6E10
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function waittill_ai_group_spawner_count(aigroup, count)
{
	while(get_ai_group_spawner_count(aigroup) > count)
	{
		level._ai_group[aigroup] waittill("update_aigroup");
	}
}

/*
	Name: waittill_ai_group_amount_killed
	Namespace: spawner
	Checksum: 0xF497B943
	Offset: 0x6E68
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function waittill_ai_group_amount_killed(aigroup, amount_killed)
{
	while(level._ai_group[aigroup].killed_count < amount_killed)
	{
		level._ai_group[aigroup] waittill("update_aigroup");
	}
}

/*
	Name: get_ai_group_count
	Namespace: spawner
	Checksum: 0x773F74A4
	Offset: 0x6EC0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function get_ai_group_count(aigroup)
{
	return get_ai_group_spawner_count(aigroup) + level._ai_group[aigroup].aicount;
}

/*
	Name: get_ai_group_sentient_count
	Namespace: spawner
	Checksum: 0xEF932398
	Offset: 0x6F08
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_ai_group_sentient_count(aigroup)
{
	return level._ai_group[aigroup].aicount;
}

/*
	Name: get_ai_group_spawner_count
	Namespace: spawner
	Checksum: 0x75D3C609
	Offset: 0x6F38
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function get_ai_group_spawner_count(aigroup)
{
	n_count = 0;
	foreach(SP in level._ai_group[aigroup].spawners)
	{
		if(isdefined(SP))
		{
			n_count = n_count + SP.count;
		}
	}
	return n_count;
}

/*
	Name: get_ai_group_ai
	Namespace: spawner
	Checksum: 0xFC936176
	Offset: 0x7008
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function get_ai_group_ai(aigroup)
{
	aiSet = [];
	for(index = 0; index < level._ai_group[aigroup].ai.size; index++)
	{
		if(!isalive(level._ai_group[aigroup].ai[index]))
		{
			continue;
		}
		aiSet[aiSet.size] = level._ai_group[aigroup].ai[index];
	}
	return aiSet;
}

/*
	Name: add_global_spawn_function
	Namespace: spawner
	Checksum: 0xD8342A99
	Offset: 0x70D0
	Size: 0x197
	Parameters: 7
	Flags: None
*/
function add_global_spawn_function(team, spawn_func, param1, param2, param3, param4, param5)
{
	if(!isdefined(level.spawn_funcs))
	{
		level.spawn_funcs = [];
	}
	if(!isdefined(level.spawn_funcs[team]))
	{
		level.spawn_funcs[team] = [];
	}
	func = [];
	func["function"] = spawn_func;
	func["param1"] = param1;
	func["param2"] = param2;
	func["param3"] = param3;
	func["param4"] = param4;
	func["param5"] = param5;
	if(!isdefined(level.spawn_funcs[team]))
	{
		level.spawn_funcs[team] = [];
	}
	else if(!IsArray(level.spawn_funcs[team]))
	{
		level.spawn_funcs[team] = Array(level.spawn_funcs[team]);
	}
	level.spawn_funcs[team][level.spawn_funcs[team].size] = func;
}

/*
	Name: add_archetype_spawn_function
	Namespace: spawner
	Checksum: 0x9D501E2E
	Offset: 0x7270
	Size: 0x197
	Parameters: 7
	Flags: None
*/
function add_archetype_spawn_function(archetype, spawn_func, param1, param2, param3, param4, param5)
{
	if(!isdefined(level.spawn_funcs))
	{
		level.spawn_funcs = [];
	}
	if(!isdefined(level.spawn_funcs[archetype]))
	{
		level.spawn_funcs[archetype] = [];
	}
	func = [];
	func["function"] = spawn_func;
	func["param1"] = param1;
	func["param2"] = param2;
	func["param3"] = param3;
	func["param4"] = param4;
	func["param5"] = param5;
	if(!isdefined(level.spawn_funcs[archetype]))
	{
		level.spawn_funcs[archetype] = [];
	}
	else if(!IsArray(level.spawn_funcs[archetype]))
	{
		level.spawn_funcs[archetype] = Array(level.spawn_funcs[archetype]);
	}
	level.spawn_funcs[archetype][level.spawn_funcs[archetype].size] = func;
}

/*
	Name: remove_global_spawn_function
	Namespace: spawner
	Checksum: 0x72555217
	Offset: 0x7410
	Size: 0xD1
	Parameters: 2
	Flags: None
*/
function remove_global_spawn_function(team, func)
{
	if(isdefined(level.spawn_funcs) && isdefined(level.spawn_funcs[team]))
	{
		Array = [];
		for(i = 0; i < level.spawn_funcs[team].size; i++)
		{
			if(level.spawn_funcs[team][i]["function"] != func)
			{
				Array[Array.size] = level.spawn_funcs[team][i];
			}
		}
		level.spawn_funcs[team] = Array;
	}
}

/*
	Name: add_spawn_function
	Namespace: spawner
	Checksum: 0xC9F651F
	Offset: 0x74F0
	Size: 0x129
	Parameters: 6
	Flags: None
*/
function add_spawn_function(spawn_func, param1, param2, param3, param4, param5)
{
	/#
		Assert(!isdefined(level._loadStarted) || !isalive(self), "Dev Block strings are not supported");
	#/
	func = [];
	func["function"] = spawn_func;
	func["param1"] = param1;
	func["param2"] = param2;
	func["param3"] = param3;
	func["param4"] = param4;
	func["param5"] = param5;
	if(!isdefined(self.spawn_funcs))
	{
		self.spawn_funcs = [];
	}
	self.spawn_funcs[self.spawn_funcs.size] = func;
}

/*
	Name: remove_spawn_function
	Namespace: spawner
	Checksum: 0x1268AF1F
	Offset: 0x7628
	Size: 0x10F
	Parameters: 1
	Flags: None
*/
function remove_spawn_function(func)
{
	/#
		Assert(!isdefined(level._loadStarted) || !isalive(self), "Dev Block strings are not supported");
	#/
	if(isdefined(self.spawn_funcs))
	{
		Array = [];
		for(i = 0; i < self.spawn_funcs.size; i++)
		{
			if(self.spawn_funcs[i]["function"] != func)
			{
				Array[Array.size] = self.spawn_funcs[i];
			}
		}
		/#
			Assert(self.spawn_funcs.size != Array.size, "Dev Block strings are not supported");
		#/
		self.spawn_funcs = Array;
	}
}

/*
	Name: add_spawn_function_group
	Namespace: spawner
	Checksum: 0x56D7C2DA
	Offset: 0x7740
	Size: 0x10B
	Parameters: 8
	Flags: None
*/
function add_spawn_function_group(str_value, str_key, func_spawn, param_1, param_2, param_3, param_4, param_5)
{
	if(!isdefined(str_key))
	{
		str_key = "targetname";
	}
	/#
		Assert(isdefined(str_value), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func_spawn), "Dev Block strings are not supported");
	#/
	a_spawners = GetSpawnerArray(str_value, str_key);
	Array::run_all(a_spawners, &add_spawn_function, func_spawn, param_1, param_2, param_3, param_4, param_5);
}

/*
	Name: add_spawn_function_ai_group
	Namespace: spawner
	Checksum: 0x4DEFD897
	Offset: 0x7858
	Size: 0xF3
	Parameters: 7
	Flags: None
*/
function add_spawn_function_ai_group(str_aigroup, func_spawn, param_1, param_2, param_3, param_4, param_5)
{
	/#
		Assert(isdefined(str_aigroup), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func_spawn), "Dev Block strings are not supported");
	#/
	a_spawners = GetSpawnerArray(str_aigroup, "script_aigroup");
	Array::run_all(a_spawners, &add_spawn_function, func_spawn, param_1, param_2, param_3, param_4, param_5);
}

/*
	Name: remove_spawn_function_ai_group
	Namespace: spawner
	Checksum: 0x1CAF5BE3
	Offset: 0x7958
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function remove_spawn_function_ai_group(str_aigroup, func_spawn, param_1, param_2, param_3, param_4, param_5)
{
	/#
		Assert(isdefined(str_aigroup), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(func_spawn), "Dev Block strings are not supported");
	#/
	a_spawners = GetSpawnerArray(str_aigroup, "script_aigroup");
	Array::run_all(a_spawners, &remove_spawn_function, func_spawn);
}

/*
	Name: simple_flood_spawn
	Namespace: spawner
	Checksum: 0xF16B73EE
	Offset: 0x7A40
	Size: 0x19D
	Parameters: 3
	Flags: None
*/
function simple_flood_spawn(name, spawn_func, spawn_func_2)
{
	spawners = GetEntArray(name, "targetname");
	/#
		Assert(spawners.size, "Dev Block strings are not supported" + name + "Dev Block strings are not supported");
	#/
	if(isdefined(spawn_func))
	{
		for(i = 0; i < spawners.size; i++)
		{
			spawners[i] add_spawn_function(spawn_func);
		}
	}
	else if(isdefined(spawn_func_2))
	{
		for(i = 0; i < spawners.size; i++)
		{
			spawners[i] add_spawn_function(spawn_func_2);
		}
	}
	for(i = 0; i < spawners.size; i++)
	{
		if(i % 2)
		{
			util::wait_network_frame();
		}
		spawners[i] thread flood_spawner_init();
		spawners[i] thread flood_spawner_think();
	}
}

/*
	Name: simple_spawn
	Namespace: spawner
	Checksum: 0x8797B29A
	Offset: 0x7BE8
	Size: 0x263
	Parameters: 8
	Flags: None
*/
function simple_spawn(name_or_spawners, spawn_func, param1, param2, param3, param4, param5, bForce)
{
	spawners = [];
	if(IsString(name_or_spawners))
	{
		spawners = GetEntArray(name_or_spawners, "targetname");
		/#
			Assert(spawners.size, "Dev Block strings are not supported" + name_or_spawners + "Dev Block strings are not supported");
		#/
	}
	else if(!isdefined(name_or_spawners))
	{
		name_or_spawners = [];
	}
	else if(!IsArray(name_or_spawners))
	{
		name_or_spawners = Array(name_or_spawners);
	}
	spawners = name_or_spawners;
	a_spawned = [];
	foreach(SP in spawners)
	{
		e_spawned = SP spawn(bForce);
		if(isdefined(e_spawned))
		{
			if(isdefined(spawn_func))
			{
				util::single_thread(e_spawned, spawn_func, param1, param2, param3, param4, param5);
			}
			if(!isdefined(a_spawned))
			{
				a_spawned = [];
			}
			else if(!IsArray(a_spawned))
			{
				a_spawned = Array(a_spawned);
			}
			a_spawned[a_spawned.size] = e_spawned;
		}
	}
	return a_spawned;
}

/*
	Name: simple_spawn_single
	Namespace: spawner
	Checksum: 0xFEC77C50
	Offset: 0x7E58
	Size: 0xBF
	Parameters: 8
	Flags: None
*/
function simple_spawn_single(name_or_spawner, spawn_func, param1, param2, param3, param4, param5, bForce)
{
	ai = simple_spawn(name_or_spawner, spawn_func, param1, param2, param3, param4, param5, bForce);
	/#
		Assert(ai.size <= 1, "Dev Block strings are not supported");
	#/
	if(ai.size)
	{
		return ai[0];
	}
}

/*
	Name: set_targets
	Namespace: spawner
	Checksum: 0x8823E476
	Offset: 0x7F20
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function set_targets(spawner_targets)
{
	self thread go_to_spawner_target(StrTok(spawner_targets, " "));
}

/*
	Name: getScoreInfoXP
	Namespace: spawner
	Checksum: 0xAAFFA16E
	Offset: 0x7F68
	Size: 0x89
	Parameters: 1
	Flags: None
*/
function getScoreInfoXP(type)
{
	/#
		if(isdefined(level.scoreInfo) && isdefined(level.scoreInfo[type]))
		{
			n_xp = level.scoreInfo[type]["Dev Block strings are not supported"];
			if(isdefined(level.xpModifierCallback) && isdefined(n_xp))
			{
				n_xp = [[level.xpModifierCallback]](type, n_xp);
			}
			return n_xp;
		}
	#/
}

/*
	Name: function_63a40f84
	Namespace: spawner
	Checksum: 0x54B03394
	Offset: 0x8000
	Size: 0x13B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_63a40f84()
{
	/#
		level.var_d4b93527 = [];
		level.var_50c49a7f = "Dev Block strings are not supported";
		callback::add_callback("hash_8c38c12e", &function_1fe733b8);
		callback::add_callback("hash_acb66515", &function_fbf3ae73);
		callback::add_callback("hash_7b543e98", &function_fa4961d4);
		callback::add_callback("hash_9bd1e27f", &function_2984c1c9);
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		SetDvar("Dev Block strings are not supported", 0);
		level thread function_6ec0d40f();
	#/
}

/*
	Name: function_fbf3ae73
	Namespace: spawner
	Checksum: 0x1771125F
	Offset: 0x8148
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function function_fbf3ae73(params)
{
	/#
		var_6ac43d03 = 0;
		if(isdefined(params) && isPlayer(params.eAttacker))
		{
			var_6ac43d03 = 1;
			if(GetDvarInt("Dev Block strings are not supported"))
			{
				var_f695f102 = getScoreInfoXP("Dev Block strings are not supported" + self.scoreType);
				var_4df005d0 = self.origin;
				var_31fea095 = 50;
				if(isdefined(self.height))
				{
					var_31fea095 = self.height;
				}
				var_4df005d0 = var_4df005d0 + (0, 0, var_31fea095);
				function_8ba6ca57(var_f695f102, var_4df005d0);
			}
		}
		function_2795d1ea(var_6ac43d03);
	#/
}

/*
	Name: function_1fe733b8
	Namespace: spawner
	Checksum: 0x2E4C830B
	Offset: 0x8288
	Size: 0x123
	Parameters: 1
	Flags: None
*/
function function_1fe733b8(params)
{
	/#
		var_6ac43d03 = 0;
		if(isPlayer(params.eAttacker))
		{
			var_6ac43d03 = 1;
			if(GetDvarInt("Dev Block strings are not supported"))
			{
				var_f695f102 = getScoreInfoXP("Dev Block strings are not supported" + self.scoreType);
				var_4df005d0 = self.origin;
				var_31fea095 = 72;
				if(isdefined(self.goalHeight))
				{
					var_31fea095 = self.goalHeight - 12;
				}
				var_4df005d0 = var_4df005d0 + (0, 0, var_31fea095);
				function_8ba6ca57(var_f695f102, var_4df005d0);
			}
		}
		function_2795d1ea(var_6ac43d03);
	#/
}

/*
	Name: function_fa4961d4
	Namespace: spawner
	Checksum: 0x8F68F498
	Offset: 0x83B8
	Size: 0x13B
	Parameters: 1
	Flags: None
*/
function function_fa4961d4(params)
{
	/#
		var_6255a1d2 = (0, 0, 0);
		var_1f95466d = params.iDamage;
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			if(isdefined(self GetTagOrigin("Dev Block strings are not supported")))
			{
				v_position = self GetTagOrigin("Dev Block strings are not supported") + VectorScale((0, 0, 1), 18);
			}
			else
			{
				v_position = self GetOrigin() + VectorScale((0, 0, 1), 78);
			}
			level thread function_440d13a9(var_1f95466d, v_position, "Dev Block strings are not supported", "Dev Block strings are not supported", (0.96, 0.12, 0.12), 1, 0.6);
		}
	#/
}

/*
	Name: function_2984c1c9
	Namespace: spawner
	Checksum: 0xDDC7639F
	Offset: 0x8500
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function function_2984c1c9(params)
{
	/#
		var_6255a1d2 = (0, 0, 0);
		var_1f95466d = params.iDamage;
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			var_6255a1d2 = self.origin;
			var_31fea095 = 50;
			if(isdefined(self.height))
			{
				var_31fea095 = self.height;
			}
			var_6255a1d2 = var_6255a1d2 + (0, 0, var_31fea095);
			level thread function_440d13a9(var_1f95466d, var_6255a1d2, "Dev Block strings are not supported", "Dev Block strings are not supported", (0.96, 0.12, 0.12), 1, 0.6);
		}
	#/
}

/*
	Name: function_8ba6ca57
	Namespace: spawner
	Checksum: 0xBA0335D1
	Offset: 0x8608
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function function_8ba6ca57(var_f695f102, v_position)
{
	/#
		level thread function_440d13a9(var_f695f102, v_position, "Dev Block strings are not supported", "Dev Block strings are not supported", (0.83, 0.18, 0.76), 1, 0.7);
	#/
}

/*
	Name: function_440d13a9
	Namespace: spawner
	Checksum: 0x57F4FE92
	Offset: 0x8680
	Size: 0x109
	Parameters: 7
	Flags: None
*/
function function_440d13a9(n_value, v_pos, var_4b5575e9, var_1e91eabe, color, n_alpha, n_size)
{
	/#
		var_6182c14d = 0;
		var_7578a666 = n_alpha;
		var_2ea9cc6d = v_pos;
		while(var_6182c14d < 40)
		{
			var_2ea9cc6d = var_2ea9cc6d + (0, 0, 1.125);
			print3d(var_2ea9cc6d, var_4b5575e9 + n_value + var_1e91eabe, color, var_7578a666, n_size, 1);
			if(var_6182c14d >= 20)
			{
				var_7578a666 = var_7578a666 - 1 / 20;
			}
			wait(0.05);
			var_6182c14d++;
		}
	#/
}

/*
	Name: function_5671da7d
	Namespace: spawner
	Checksum: 0x64225C33
	Offset: 0x8798
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_5671da7d(e_enemy)
{
	/#
		var_f695f102 = getScoreInfoXP("Dev Block strings are not supported" + e_enemy.scoreType);
		if(isdefined(var_f695f102))
		{
			return var_f695f102;
		}
		else
		{
			return 0;
		}
	#/
}

/*
	Name: function_2795d1ea
	Namespace: spawner
	Checksum: 0x331D1F5F
	Offset: 0x8800
	Size: 0x259
	Parameters: 1
	Flags: None
*/
function function_2795d1ea(var_6ac43d03)
{
	/#
		if(!isdefined(self))
		{
			return;
		}
		if(self.team == "Dev Block strings are not supported" || self.team == "Dev Block strings are not supported")
		{
			var_b28093b = 0;
			for(i = 0; i < level.var_d4b93527.size; i++)
			{
				if(level.var_d4b93527[i].var_af46d184 == self.scoreType)
				{
					level.var_d4b93527[i].var_c964043b = level.var_d4b93527[i].var_c964043b + 1;
					if(var_6ac43d03)
					{
						level.var_d4b93527[i].var_50b2a78e = level.var_d4b93527[i].var_50b2a78e + 1;
						if(isdefined(level.var_d4b93527[i].var_1f8e7452))
						{
							level.var_d4b93527[i].var_1f8e7452 = level.var_d4b93527[i].var_1f8e7452 + function_5671da7d(self);
						}
					}
					var_b28093b = 1;
				}
			}
			if(!var_b28093b)
			{
				var_698fd26a = spawnstruct();
				var_698fd26a.var_af46d184 = self.scoreType;
				var_698fd26a.var_c964043b = 1;
				var_698fd26a.var_50b2a78e = 0;
				var_698fd26a.var_1f8e7452 = 0;
				if(var_6ac43d03)
				{
					var_698fd26a.var_50b2a78e = 1;
					var_698fd26a.var_1f8e7452 = function_5671da7d(self);
				}
				var_7181db51 = level.var_d4b93527.size;
				level.var_d4b93527[var_7181db51] = var_698fd26a;
			}
		}
	#/
}

/*
	Name: function_6ec0d40f
	Namespace: spawner
	Checksum: 0xA62C4046
	Offset: 0x8A68
	Size: 0x2E7
	Parameters: 0
	Flags: None
*/
function function_6ec0d40f()
{
	/#
		while(1)
		{
			function_d8312e();
			if(GetDvarInt("Dev Block strings are not supported") == 1)
			{
				if(!isdefined(level.var_4436cad5))
				{
					level.var_4436cad5 = NewHudElem();
					level.var_4436cad5.alignX = "Dev Block strings are not supported";
					level.var_4436cad5.x = 50;
					level.var_4436cad5.y = 60;
					level.var_4436cad5.fontscale = 1.5;
					level.var_4436cad5.color = (1, 1, 1);
					IPrintLnBold("Dev Block strings are not supported");
				}
				else
				{
					level.var_87874699 = "Dev Block strings are not supported" + GetAITeamArray("Dev Block strings are not supported").size + "Dev Block strings are not supported" + GetAITeamArray("Dev Block strings are not supported").size + "Dev Block strings are not supported";
					level.var_87874699 = level.var_87874699 + "Dev Block strings are not supported";
					if(level.var_d4b93527.size == 0)
					{
						level.var_87874699 = level.var_87874699 + "Dev Block strings are not supported";
						break;
					}
					foreach(var_2b2af279 in level.var_d4b93527)
					{
						level.var_87874699 = level.var_87874699 + var_2b2af279.var_af46d184 + "Dev Block strings are not supported" + var_2b2af279.var_c964043b + "Dev Block strings are not supported" + var_2b2af279.var_50b2a78e + "Dev Block strings are not supported";
					}
					if(GetDvarInt("Dev Block strings are not supported") == 1)
					{
						level.var_4436cad5 setText(level.var_87874699);
					}
				}
			}
			else if(isdefined(level.var_4436cad5))
			{
				level.var_4436cad5 destroy();
				IPrintLnBold("Dev Block strings are not supported");
			}
			wait(0.25);
		}
	#/
}

/*
	Name: function_d8312e
	Namespace: spawner
	Checksum: 0x6E212213
	Offset: 0x8D58
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_d8312e()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 1)
		{
			level.var_d4b93527 = [];
			iprintln("Dev Block strings are not supported");
			SetDvar("Dev Block strings are not supported", 0);
		}
	#/
}

/*
	Name: init_female_spawn
	Namespace: spawner
	Checksum: 0x432F6D00
	Offset: 0x8DD0
	Size: 0x23
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init_female_spawn()
{
	level.female_percent = 0;
	set_female_percent(30);
}

/*
	Name: set_female_percent
	Namespace: spawner
	Checksum: 0x8727635B
	Offset: 0x8E00
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function set_female_percent(percent)
{
	level.female_percent = percent;
}

