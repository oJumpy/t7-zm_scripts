#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_spawnlogic;

#namespace Spawning;

/*
	Name: __init__
	Namespace: Spawning
	Checksum: 0x26A7CB93
	Offset: 0x3F0
	Size: 0x1ED
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level init_spawn_system();
	level.recently_deceased = [];
	foreach(team in level.teams)
	{
		level.recently_deceased[team] = util::spawn_array_struct();
	}
	callback::on_connecting(&on_player_connecting);
	level.spawnProtectionTime = GetGametypeSetting("spawnprotectiontime");
	if(isdefined(level.spawnProtectionTime))
	{
	}
	else
	{
	}
	level.spawnProtectionTimeMS = Int(0 * 1000);
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		level.test_spawn_point_index = 0;
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
	#/
	return;
}

/*
	Name: init_spawn_system
	Namespace: Spawning
	Checksum: 0x9B22C85F
	Offset: 0x5E8
	Size: 0x1B1
	Parameters: 0
	Flags: None
*/
function init_spawn_system()
{
	level.spawnsystem = spawnstruct();
	spawnsystem = level.spawnsystem;
	if(!isdefined(spawnsystem.unifiedSideSwitching))
	{
		spawnsystem.unifiedSideSwitching = 1;
	}
	spawnsystem.objective_facing_bonus = 0;
	spawnsystem.iSPAWN_TEAMMASK = [];
	spawnsystem.iSPAWN_TEAMMASK_FREE = 1;
	spawnsystem.iSPAWN_TEAMMASK["free"] = spawnsystem.iSPAWN_TEAMMASK_FREE;
	all = spawnsystem.iSPAWN_TEAMMASK_FREE;
	count = 1;
	foreach(team in level.teams)
	{
		spawnsystem.iSPAWN_TEAMMASK[team] = 1 << count;
		all = all | spawnsystem.iSPAWN_TEAMMASK[team];
		count++;
	}
	spawnsystem.iSPAWN_TEAMMASK["all"] = all;
}

/*
	Name: on_player_connecting
	Namespace: Spawning
	Checksum: 0x5D0EB288
	Offset: 0x7A8
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function on_player_connecting()
{
	level endon("game_ended");
	self setEnterTime(GetTime());
	callback::on_spawned(&on_player_spawned);
	callback::on_joined_team(&on_joined_team);
	self thread onGrenadeThrow();
}

/*
	Name: on_player_spawned
	Namespace: Spawning
	Checksum: 0x7132A790
	Offset: 0x830
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		self waittill("spawned_player");
		self enable_player_influencers(1);
		self thread onDeath();
	}
}

/*
	Name: onDeath
	Namespace: Spawning
	Checksum: 0xA7EB5A19
	Offset: 0x898
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function onDeath()
{
	self endon("disconnect");
	level endon("game_ended");
	self waittill("death");
	self enable_player_influencers(0);
	level create_friendly_influencer("friend_dead", self.origin, self.team);
}

/*
	Name: on_joined_team
	Namespace: Spawning
	Checksum: 0x4CF10D65
	Offset: 0x910
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function on_joined_team()
{
	self endon("disconnect");
	level endon("game_ended");
	self player_influencers_set_team();
}

/*
	Name: onGrenadeThrow
	Namespace: Spawning
	Checksum: 0x4C5AD434
	Offset: 0x948
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function onGrenadeThrow()
{
	self endon("disconnect");
	level endon("game_ended");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapon);
		level thread create_grenade_influencers(self.pers["team"], weapon, grenade);
		wait(0.05);
	}
}

/*
	Name: get_friendly_team_mask
	Namespace: Spawning
	Checksum: 0x3463AC60
	Offset: 0x9D0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function get_friendly_team_mask(team)
{
	if(level.teambased)
	{
		team_mask = util::getTeamMask(team);
	}
	else
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	return team_mask;
}

/*
	Name: get_enemy_team_mask
	Namespace: Spawning
	Checksum: 0xA05B3C3E
	Offset: 0xA30
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function get_enemy_team_mask(team)
{
	if(level.teambased)
	{
		team_mask = util::getOtherTeamsMask(team);
	}
	else
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	return team_mask;
}

/*
	Name: create_influencer
	Namespace: Spawning
	Checksum: 0x865213FF
	Offset: 0xA90
	Size: 0x67
	Parameters: 3
	Flags: None
*/
function create_influencer(name, origin, team_mask)
{
	self.influencers[name] = AddInfluencer(name, origin, team_mask);
	self thread watch_remove_influencer();
	return self.influencers[name];
}

/*
	Name: create_friendly_influencer
	Namespace: Spawning
	Checksum: 0x275FDD8F
	Offset: 0xB00
	Size: 0x77
	Parameters: 3
	Flags: None
*/
function create_friendly_influencer(name, origin, team)
{
	team_mask = self get_friendly_team_mask(team);
	self.influencersFriendly[name] = create_influencer(name, origin, team_mask);
	return self.influencersFriendly[name];
}

/*
	Name: create_enemy_influencer
	Namespace: Spawning
	Checksum: 0x89F20AE3
	Offset: 0xB80
	Size: 0x77
	Parameters: 3
	Flags: None
*/
function create_enemy_influencer(name, origin, team)
{
	team_mask = self get_enemy_team_mask(team);
	self.influencersEnemy[name] = create_influencer(name, origin, team_mask);
	return self.influencersEnemy[name];
}

/*
	Name: create_entity_influencer
	Namespace: Spawning
	Checksum: 0x8C8245F8
	Offset: 0xC00
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function create_entity_influencer(name, team_mask)
{
	self.influencers[name] = AddEntityInfluencer(name, self, team_mask);
	return self.influencers[name];
}

/*
	Name: create_entity_friendly_influencer
	Namespace: Spawning
	Checksum: 0x1436A7CE
	Offset: 0xC58
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function create_entity_friendly_influencer(name)
{
	team_mask = self get_friendly_team_mask();
	return self create_entity_masked_friendly_influencer(name, team_mask);
}

/*
	Name: create_entity_enemy_influencer
	Namespace: Spawning
	Checksum: 0x205ED741
	Offset: 0xCB0
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function create_entity_enemy_influencer(name)
{
	team_mask = self get_enemy_team_mask();
	return self create_entity_masked_enemy_influencer(name, team_mask);
}

/*
	Name: create_entity_masked_friendly_influencer
	Namespace: Spawning
	Checksum: 0x8376247B
	Offset: 0xD08
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function create_entity_masked_friendly_influencer(name, team_mask)
{
	self.influencersFriendly[name] = self create_entity_influencer(name, team_mask);
	return self.influencersFriendly[name];
}

/*
	Name: create_entity_masked_enemy_influencer
	Namespace: Spawning
	Checksum: 0xC0152F10
	Offset: 0xD60
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function create_entity_masked_enemy_influencer(name, team_mask)
{
	self.influencersEnemy[name] = self create_entity_influencer(name, team_mask);
	return self.influencersEnemy[name];
}

/*
	Name: create_player_influencers
	Namespace: Spawning
	Checksum: 0x67EB6933
	Offset: 0xDB8
	Size: 0x22B
	Parameters: 0
	Flags: None
*/
function create_player_influencers()
{
	/#
		Assert(!isdefined(self.influencers));
	#/
	/#
		Assert(!isdefined(self.influencers));
	#/
	if(!level.teambased)
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		other_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		weapon_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	else if(isdefined(self.pers["team"]))
	{
		team = self.pers["team"];
		team_mask = util::getTeamMask(team);
		enemy_teams_mask = util::getOtherTeamsMask(team);
	}
	else
	{
		team_mask = 0;
		enemy_teams_mask = 0;
	}
	angles = self.angles;
	origin = self.origin;
	up = (0, 0, 1);
	FORWARD = (1, 0, 0);
	self.influencers = [];
	self.friendlyInfluencers = [];
	self.enemyInfluencers = [];
	self create_entity_masked_enemy_influencer("enemy", enemy_teams_mask);
	if(level.teambased)
	{
		self create_entity_masked_friendly_influencer("friend", team_mask);
	}
	if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator")
	{
		self enable_influencers(0);
	}
}

/*
	Name: remove_influencers
	Namespace: Spawning
	Checksum: 0xA8693910
	Offset: 0xFF0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function remove_influencers()
{
	foreach(influencer in self.influencers)
	{
		RemoveInfluencer(influencer);
	}
	self.influencers = [];
	if(isdefined(self.influencersFriendly))
	{
		self.influencersFriendly = [];
	}
	if(isdefined(self.influencersEnemy))
	{
		self.influencersEnemy = [];
	}
}

/*
	Name: watch_remove_influencer
	Namespace: Spawning
	Checksum: 0xEF7624D3
	Offset: 0x10C0
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function watch_remove_influencer()
{
	self endon("death");
	self notify("watch_remove_influencer");
	self endon("watch_remove_influencer");
	self waittill("influencer_removed", index);
	ArrayRemoveValue(self.influencers, index);
	ArrayRemoveValue(self.influencersFriendly, index);
	ArrayRemoveValue(self.influencersEnemy, index);
	self thread watch_remove_influencer();
}

/*
	Name: enable_influencers
	Namespace: Spawning
	Checksum: 0x13865551
	Offset: 0x1180
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function enable_influencers(enabled)
{
	foreach(influencer in self.influencers)
	{
		EnableInfluencer(influencer, enabled);
	}
}

/*
	Name: enable_player_influencers
	Namespace: Spawning
	Checksum: 0xBD42F983
	Offset: 0x1228
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function enable_player_influencers(enabled)
{
	if(!isdefined(self.influencers))
	{
		self create_player_influencers();
	}
	self enable_influencers(enabled);
}

/*
	Name: player_influencers_set_team
	Namespace: Spawning
	Checksum: 0xFD2B9C69
	Offset: 0x1278
	Size: 0x1C9
	Parameters: 0
	Flags: None
*/
function player_influencers_set_team()
{
	if(!level.teambased)
	{
		team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		enemy_teams_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	else
	{
		team = self.pers["team"];
		team_mask = util::getTeamMask(team);
		enemy_teams_mask = util::getOtherTeamsMask(team);
	}
	if(isdefined(self.influencersFriendly))
	{
		foreach(influencer in self.influencersFriendly)
		{
			SetInfluencerTeammask(influencer, team_mask);
		}
	}
	else if(isdefined(self.influencersEnemy))
	{
		foreach(influencer in self.influencersEnemy)
		{
			SetInfluencerTeammask(influencer, enemy_teams_mask);
		}
	}
}

/*
	Name: create_grenade_influencers
	Namespace: Spawning
	Checksum: 0x8BE8A0B0
	Offset: 0x1450
	Size: 0x113
	Parameters: 3
	Flags: None
*/
function create_grenade_influencers(parent_team, weapon, grenade)
{
	PixBeginEvent("create_grenade_influencers");
	spawn_influencer = weapon.spawnInfluencer;
	if(isdefined(grenade.origin) && spawn_influencer != "")
	{
		if(!level.teambased)
		{
			weapon_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
		}
		else
		{
			weapon_team_mask = util::getOtherTeamsMask(parent_team);
			if(level.friendlyfire)
			{
				weapon_team_mask = weapon_team_mask | util::getTeamMask(parent_team);
			}
		}
		grenade create_entity_masked_enemy_influencer(spawn_influencer, weapon_team_mask);
	}
	PixEndEvent();
}

/*
	Name: create_map_placed_influencers
	Namespace: Spawning
	Checksum: 0x8DFF2EB
	Offset: 0x1570
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function create_map_placed_influencers()
{
	staticInfluencerEnts = GetEntArray("mp_uspawn_influencer", "classname");
	for(i = 0; i < staticInfluencerEnts.size; i++)
	{
		staticInfluencerEnt = staticInfluencerEnts[i];
		create_map_placed_influencer(staticInfluencerEnt);
	}
}

/*
	Name: create_map_placed_influencer
	Namespace: Spawning
	Checksum: 0x1DF0B7
	Offset: 0x1600
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function create_map_placed_influencer(influencer_entity)
{
	influencer_id = -1;
	if(isdefined(influencer_entity.script_noteworty))
	{
		team_mask = util::getTeamMask(influencer_entity.script_team);
		level create_enemy_influencer(influencer_entity.script_noteworty, influencer_entity.origin, team_mask);
	}
	else
	{
		ASSERTMSG("Dev Block strings are not supported");
	}
	/#
	#/
	return influencer_id;
}

/*
	Name: updateAllSpawnPoints
	Namespace: Spawning
	Checksum: 0xDD5D62C1
	Offset: 0x16B8
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function updateAllSpawnPoints()
{
	foreach(team in level.teams)
	{
		gatherSpawnPoints(team);
	}
	spawnlogic::clearSpawnPoints();
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			spawnlogic::addSpawnPoints(team, level.unified_spawn_points[team].a);
		}
		break;
	}
	foreach(team in level.teams)
	{
		spawnlogic::addSpawnPoints("free", level.unified_spawn_points[team].a);
	}
	remove_unused_spawn_entities();
}

/*
	Name: onSpawnPlayer_Unified
	Namespace: Spawning
	Checksum: 0x53C3D24F
	Offset: 0x18B0
	Size: 0x145
	Parameters: 1
	Flags: None
*/
function onSpawnPlayer_Unified(predictedSpawn)
{
	if(!isdefined(predictedSpawn))
	{
		predictedSpawn = 0;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") != 0)
		{
			spawn_point = get_debug_spawnpoint(self);
			self spawn(spawn_point.origin, spawn_point.angles);
			return;
		}
	#/
	use_new_spawn_system = 0;
	initial_spawn = 1;
	if(isdefined(self.uspawn_already_spawned))
	{
		initial_spawn = !self.uspawn_already_spawned;
	}
	if(level.useStartSpawns)
	{
		use_new_spawn_system = 0;
	}
	if(level.gametype == "sd")
	{
		use_new_spawn_system = 0;
	}
	util::set_dvar_if_unset("scr_spawn_force_unified", "0");
	[[level.onSpawnPlayer]](predictedSpawn);
	if(!predictedSpawn)
	{
		self.uspawn_already_spawned = 1;
	}
	return;
}

/*
	Name: getSpawnPoint
	Namespace: Spawning
	Checksum: 0x82C1BC6E
	Offset: 0x1A00
	Size: 0x147
	Parameters: 2
	Flags: None
*/
function getSpawnPoint(player_entity, predictedSpawn)
{
	if(!isdefined(predictedSpawn))
	{
		predictedSpawn = 0;
	}
	if(level.teambased)
	{
		point_team = player_entity.pers["team"];
		influencer_team = player_entity.pers["team"];
	}
	else
	{
		point_team = "free";
		influencer_team = "free";
	}
	if(level.teambased && isdefined(game["switchedsides"]) && game["switchedsides"] && level.spawnsystem.unifiedSideSwitching)
	{
		point_team = util::getOtherTeam(point_team);
	}
	best_spawn = get_best_spawnpoint(point_team, influencer_team, player_entity, predictedSpawn);
	if(!predictedSpawn)
	{
		player_entity.last_spawn_origin = best_spawn["origin"];
	}
	return best_spawn;
}

/*
	Name: get_debug_spawnpoint
	Namespace: Spawning
	Checksum: 0x4D4178F9
	Offset: 0x1B50
	Size: 0x279
	Parameters: 1
	Flags: None
*/
function get_debug_spawnpoint(player)
{
	if(level.teambased)
	{
		team = player.pers["team"];
	}
	else
	{
		team = "free";
	}
	index = level.test_spawn_point_index;
	level.test_spawn_point_index++;
	if(team == "free")
	{
		spawn_counts = 0;
		foreach(team in level.teams)
		{
			spawn_counts = spawn_counts + level.unified_spawn_points[team].a.size;
		}
		if(level.test_spawn_point_index >= spawn_counts)
		{
			level.test_spawn_point_index = 0;
		}
		count = 0;
		foreach(team in level.teams)
		{
			SIZE = level.unified_spawn_points[team].a.size;
			if(level.test_spawn_point_index < count + SIZE)
			{
				return level.unified_spawn_points[team].a[level.test_spawn_point_index - count];
			}
			count = count + SIZE;
		}
	}
	else if(level.test_spawn_point_index >= level.unified_spawn_points[team].a.size)
	{
		level.test_spawn_point_index = 0;
	}
	return level.unified_spawn_points[team].a[level.test_spawn_point_index];
}

/*
	Name: get_best_spawnpoint
	Namespace: Spawning
	Checksum: 0x57D47B9D
	Offset: 0x1DD8
	Size: 0xE7
	Parameters: 4
	Flags: None
*/
function get_best_spawnpoint(point_team, influencer_team, player, predictedSpawn)
{
	if(level.teambased)
	{
		vis_team_mask = util::getOtherTeamsMask(player.pers["team"]);
	}
	else
	{
		vis_team_mask = level.spawnsystem.iSPAWN_TEAMMASK_FREE;
	}
	spawn_point = GetBestSpawnPoint(point_team, influencer_team, vis_team_mask, player, predictedSpawn);
	if(!predictedSpawn)
	{
		bbPrint("mpspawnpointsused", "reason %s x %d y %d z %d", "point used", spawn_point["origin"]);
	}
	return spawn_point;
}

/*
	Name: gatherSpawnPoints
	Namespace: Spawning
	Checksum: 0xDF2D315
	Offset: 0x1EC8
	Size: 0xC1
	Parameters: 1
	Flags: None
*/
function gatherSpawnPoints(player_team)
{
	if(!isdefined(level.unified_spawn_points))
	{
		level.unified_spawn_points = [];
	}
	else if(isdefined(level.unified_spawn_points[player_team]))
	{
		return level.unified_spawn_points[player_team];
	}
	spawn_entities_s = util::spawn_array_struct();
	spawn_entities_s.a = spawnlogic::getTeamSpawnPoints(player_team);
	if(!isdefined(spawn_entities_s.a))
	{
		spawn_entities_s.a = [];
	}
	level.unified_spawn_points[player_team] = spawn_entities_s;
	return spawn_entities_s;
}

/*
	Name: is_hardcore
	Namespace: Spawning
	Checksum: 0xF710A2C9
	Offset: 0x1F98
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function is_hardcore()
{
	return isdefined(level.hardcoreMode) && level.hardcoreMode;
}

/*
	Name: teams_have_enmity
	Namespace: Spawning
	Checksum: 0x7ED98DDC
	Offset: 0x1FB8
	Size: 0x71
	Parameters: 2
	Flags: None
*/
function teams_have_enmity(team1, team2)
{
	if(!isdefined(team1) || !isdefined(team2) || level.gametype == "dm")
	{
		return 1;
	}
	return team1 != "neutral" && team2 != "neutral" && team1 != team2;
}

/*
	Name: remove_unused_spawn_entities
	Namespace: Spawning
	Checksum: 0x2C185004
	Offset: 0x2038
	Size: 0x22D
	Parameters: 0
	Flags: None
*/
function remove_unused_spawn_entities()
{
	spawn_entity_types = [];
	spawn_entity_types[spawn_entity_types.size] = "mp_dm_spawn";
	spawn_entity_types[spawn_entity_types.size] = "mp_tdm_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_tdm_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_tdm_spawn";
	spawn_entity_types[spawn_entity_types.size] = "mp_ctf_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_ctf_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_ctf_spawn_allies";
	spawn_entity_types[spawn_entity_types.size] = "mp_ctf_spawn_axis";
	spawn_entity_types[spawn_entity_types.size] = "mp_dom_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_dom_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_dom_spawn";
	spawn_entity_types[spawn_entity_types.size] = "mp_sab_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_sab_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_sab_spawn_allies";
	spawn_entity_types[spawn_entity_types.size] = "mp_sab_spawn_axis";
	spawn_entity_types[spawn_entity_types.size] = "mp_sd_spawn_attacker";
	spawn_entity_types[spawn_entity_types.size] = "mp_sd_spawn_defender";
	spawn_entity_types[spawn_entity_types.size] = "mp_twar_spawn_axis_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_twar_spawn_allies_start";
	spawn_entity_types[spawn_entity_types.size] = "mp_twar_spawn";
	for(i = 0; i < spawn_entity_types.size; i++)
	{
		if(spawn_point_class_name_being_used(spawn_entity_types[i]))
		{
			continue;
		}
		Spawnpoints = spawnlogic::getSpawnpointArray(spawn_entity_types[i]);
		delete_all_spawns(Spawnpoints);
	}
}

/*
	Name: delete_all_spawns
	Namespace: Spawning
	Checksum: 0xCDE1D01D
	Offset: 0x2270
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function delete_all_spawns(Spawnpoints)
{
	for(i = 0; i < Spawnpoints.size; i++)
	{
		Spawnpoints[i] delete();
	}
}

/*
	Name: spawn_point_class_name_being_used
	Namespace: Spawning
	Checksum: 0xC47E94B0
	Offset: 0x22D0
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function spawn_point_class_name_being_used(name)
{
	if(!isdefined(level.spawn_point_class_names))
	{
		return 0;
	}
	for(i = 0; i < level.spawn_point_class_names.size; i++)
	{
		if(level.spawn_point_class_names[i] == name)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: CodeCallback_UpdateSpawnPoints
	Namespace: Spawning
	Checksum: 0x6F654D0A
	Offset: 0x2340
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function CodeCallback_UpdateSpawnPoints()
{
	foreach(team in level.teams)
	{
		spawnlogic::rebuildSpawnPoints(team);
	}
	level.unified_spawn_points = undefined;
	updateAllSpawnPoints();
}

/*
	Name: initialSpawnProtection
	Namespace: Spawning
	Checksum: 0xA0A91454
	Offset: 0x23F0
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function initialSpawnProtection(specialtyName, spawnMonitorSpeed)
{
	self endon("death");
	self endon("disconnect");
	if(!isdefined(level.spawnProtectionTime) || level.spawnProtectionTime == 0)
	{
		return;
	}
	if(specialtyName == "specialty_nottargetedbyairsupport")
	{
		self.specialty_nottargetedbyairsupport = 1;
		wait(level.spawnProtectionTime);
		self.specialty_nottargetedbyairsupport = undefined;
	}
	else if(!self hasPerk(specialtyName))
	{
		self setPerk(specialtyName);
		wait(level.spawnProtectionTime);
		self unsetPerk(specialtyName);
	}
}

