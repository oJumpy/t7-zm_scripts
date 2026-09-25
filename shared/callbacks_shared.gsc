#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\simple_hostmigration;
#using scripts\shared\system_shared;

#namespace callback;

/*
	Name: callback
	Namespace: callback
	Checksum: 0xBF800C51
	Offset: 0x1E8
	Size: 0x133
	Parameters: 2
	Flags: None
*/
function callback(event, params)
{
	if(isdefined(level._callbacks) && isdefined(level._callbacks[event]))
	{
		for(i = 0; i < level._callbacks[event].size; i++)
		{
			callback = level._callbacks[event][i][0];
			obj = level._callbacks[event][i][1];
			if(!isdefined(callback))
			{
				continue;
			}
			if(isdefined(obj))
			{
				if(isdefined(params))
				{
					obj thread [[callback]](self, params);
				}
				else
				{
					obj thread [[callback]](self);
				}
				continue;
			}
			if(isdefined(params))
			{
				self thread [[callback]](params);
				continue;
			}
			self thread [[callback]]();
		}
	}
}

/*
	Name: add_callback
	Namespace: callback
	Checksum: 0xF8621DC8
	Offset: 0x328
	Size: 0x18B
	Parameters: 3
	Flags: None
*/
function add_callback(event, func, obj)
{
	/#
		Assert(isdefined(event), "Dev Block strings are not supported");
	#/
	if(!isdefined(level._callbacks) || !isdefined(level._callbacks[event]))
	{
		level._callbacks[event] = [];
	}
	foreach(callback in level._callbacks[event])
	{
		if(callback[0] == func)
		{
			if(!isdefined(obj) || callback[1] == obj)
			{
				return;
			}
		}
	}
	Array::add(level._callbacks[event], Array(func, obj), 0);
	if(isdefined(obj))
	{
		obj thread remove_callback_on_death(event, func);
	}
}

/*
	Name: remove_callback_on_death
	Namespace: callback
	Checksum: 0xE9A29850
	Offset: 0x4C0
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function remove_callback_on_death(event, func)
{
	self waittill("death");
	remove_callback(event, func, self);
}

/*
	Name: remove_callback
	Namespace: callback
	Checksum: 0x47454813
	Offset: 0x508
	Size: 0x13D
	Parameters: 3
	Flags: None
*/
function remove_callback(event, func, obj)
{
	/#
		Assert(isdefined(event), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(level._callbacks[event]), "Dev Block strings are not supported");
	#/
	foreach(func_group in level._callbacks[event])
	{
		if(func_group[0] == func)
		{
			if(func_group[1] === obj)
			{
				ArrayRemoveIndex(level._callbacks[event], index, 0);
				break;
			}
		}
	}
}

/*
	Name: on_finalize_initialization
	Namespace: callback
	Checksum: 0x59FB6166
	Offset: 0x650
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_finalize_initialization(func, obj)
{
	add_callback("hash_36fb1b1a", func, obj);
}

/*
	Name: on_connect
	Namespace: callback
	Checksum: 0xA3BB1492
	Offset: 0x690
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_connect(func, obj)
{
	add_callback("hash_eaffea17", func, obj);
}

/*
	Name: remove_on_connect
	Namespace: callback
	Checksum: 0x4A68B221
	Offset: 0x6D0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_connect(func, obj)
{
	remove_callback("hash_eaffea17", func, obj);
}

/*
	Name: on_connecting
	Namespace: callback
	Checksum: 0x21382839
	Offset: 0x710
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_connecting(func, obj)
{
	add_callback("hash_fefe13f5", func, obj);
}

/*
	Name: remove_on_connecting
	Namespace: callback
	Checksum: 0xC650034D
	Offset: 0x750
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_connecting(func, obj)
{
	remove_callback("hash_fefe13f5", func, obj);
}

/*
	Name: on_disconnect
	Namespace: callback
	Checksum: 0x4F79BAC7
	Offset: 0x790
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_disconnect(func, obj)
{
	add_callback("hash_aebdd257", func, obj);
}

/*
	Name: remove_on_disconnect
	Namespace: callback
	Checksum: 0xEEEFC98A
	Offset: 0x7D0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_disconnect(func, obj)
{
	remove_callback("hash_aebdd257", func, obj);
}

/*
	Name: on_spawned
	Namespace: callback
	Checksum: 0xB675CD4E
	Offset: 0x810
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_spawned(func, obj)
{
	add_callback("hash_bc12b61f", func, obj);
}

/*
	Name: remove_on_spawned
	Namespace: callback
	Checksum: 0x1B1F5633
	Offset: 0x850
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_spawned(func, obj)
{
	remove_callback("hash_bc12b61f", func, obj);
}

/*
	Name: on_loadout
	Namespace: callback
	Checksum: 0x12DE6700
	Offset: 0x890
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_loadout(func, obj)
{
	add_callback("hash_33bba039", func, obj);
}

/*
	Name: remove_on_loadout
	Namespace: callback
	Checksum: 0x2B2C56FC
	Offset: 0x8D0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_loadout(func, obj)
{
	remove_callback("hash_33bba039", func, obj);
}

/*
	Name: on_player_damage
	Namespace: callback
	Checksum: 0x4683F8BD
	Offset: 0x910
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_player_damage(func, obj)
{
	add_callback("hash_ab5ecf6c", func, obj);
}

/*
	Name: remove_on_player_damage
	Namespace: callback
	Checksum: 0x96EAA2DE
	Offset: 0x950
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_player_damage(func, obj)
{
	remove_callback("hash_ab5ecf6c", func, obj);
}

/*
	Name: on_start_gametype
	Namespace: callback
	Checksum: 0x29A20C08
	Offset: 0x990
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_start_gametype(func, obj)
{
	add_callback("hash_cc62acca", func, obj);
}

/*
	Name: on_joined_team
	Namespace: callback
	Checksum: 0x8D185449
	Offset: 0x9D0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_joined_team(func, obj)
{
	add_callback("hash_95a6c4c0", func, obj);
}

/*
	Name: on_joined_spectate
	Namespace: callback
	Checksum: 0xA955467D
	Offset: 0xA10
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_joined_spectate(func, obj)
{
	add_callback("hash_4c5ae192", func, obj);
}

/*
	Name: on_player_killed
	Namespace: callback
	Checksum: 0x48CFDE09
	Offset: 0xA50
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_player_killed(func, obj)
{
	add_callback("hash_bc435202", func, obj);
}

/*
	Name: remove_on_player_killed
	Namespace: callback
	Checksum: 0xA9CBF769
	Offset: 0xA90
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_player_killed(func, obj)
{
	remove_callback("hash_bc435202", func, obj);
}

/*
	Name: on_ai_killed
	Namespace: callback
	Checksum: 0x1BA9BEF2
	Offset: 0xAD0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_ai_killed(func, obj)
{
	add_callback("hash_fc2ec5ff", func, obj);
}

/*
	Name: remove_on_ai_killed
	Namespace: callback
	Checksum: 0x4FA015B1
	Offset: 0xB10
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_ai_killed(func, obj)
{
	remove_callback("hash_fc2ec5ff", func, obj);
}

/*
	Name: on_actor_killed
	Namespace: callback
	Checksum: 0x40C25DA0
	Offset: 0xB50
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_actor_killed(func, obj)
{
	add_callback("hash_8c38c12e", func, obj);
}

/*
	Name: remove_on_actor_killed
	Namespace: callback
	Checksum: 0x464D37E4
	Offset: 0xB90
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_actor_killed(func, obj)
{
	remove_callback("hash_8c38c12e", func, obj);
}

/*
	Name: on_vehicle_spawned
	Namespace: callback
	Checksum: 0xB1A13417
	Offset: 0xBD0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_vehicle_spawned(func, obj)
{
	add_callback("hash_bae82b92", func, obj);
}

/*
	Name: remove_on_vehicle_spawned
	Namespace: callback
	Checksum: 0x4E9ADD3B
	Offset: 0xC10
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_vehicle_spawned(func, obj)
{
	remove_callback("hash_bae82b92", func, obj);
}

/*
	Name: on_vehicle_killed
	Namespace: callback
	Checksum: 0xF010E8CA
	Offset: 0xC50
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_vehicle_killed(func, obj)
{
	add_callback("hash_acb66515", func, obj);
}

/*
	Name: remove_on_vehicle_killed
	Namespace: callback
	Checksum: 0x1019C3F2
	Offset: 0xC90
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_vehicle_killed(func, obj)
{
	remove_callback("hash_acb66515", func, obj);
}

/*
	Name: on_ai_damage
	Namespace: callback
	Checksum: 0xA0498752
	Offset: 0xCD0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_ai_damage(func, obj)
{
	add_callback("hash_eb4a4369", func, obj);
}

/*
	Name: remove_on_ai_damage
	Namespace: callback
	Checksum: 0x6A025514
	Offset: 0xD10
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_ai_damage(func, obj)
{
	remove_callback("hash_eb4a4369", func, obj);
}

/*
	Name: on_ai_spawned
	Namespace: callback
	Checksum: 0xB48F6CED
	Offset: 0xD50
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_ai_spawned(func, obj)
{
	add_callback("hash_f96ca9bc", func, obj);
}

/*
	Name: remove_on_ai_spawned
	Namespace: callback
	Checksum: 0x6519D1EE
	Offset: 0xD90
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_ai_spawned(func, obj)
{
	remove_callback("hash_f96ca9bc", func, obj);
}

/*
	Name: on_actor_damage
	Namespace: callback
	Checksum: 0xA14636CB
	Offset: 0xDD0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_actor_damage(func, obj)
{
	add_callback("hash_7b543e98", func, obj);
}

/*
	Name: remove_on_actor_damage
	Namespace: callback
	Checksum: 0xAFE44382
	Offset: 0xE10
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_actor_damage(func, obj)
{
	remove_callback("hash_7b543e98", func, obj);
}

/*
	Name: on_vehicle_damage
	Namespace: callback
	Checksum: 0xB00793E5
	Offset: 0xE50
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_vehicle_damage(func, obj)
{
	add_callback("hash_9bd1e27f", func, obj);
}

/*
	Name: remove_on_vehicle_damage
	Namespace: callback
	Checksum: 0x180D0C44
	Offset: 0xE90
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function remove_on_vehicle_damage(func, obj)
{
	remove_callback("hash_9bd1e27f", func, obj);
}

/*
	Name: on_laststand
	Namespace: callback
	Checksum: 0x49724D9C
	Offset: 0xED0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_laststand(func, obj)
{
	add_callback("hash_6751ab5b", func, obj);
}

/*
	Name: on_challenge_complete
	Namespace: callback
	Checksum: 0xC2655BD9
	Offset: 0xF10
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function on_challenge_complete(func, obj)
{
	add_callback("hash_b286c65c", func, obj);
}

/*
	Name: CodeCallback_PreInitialization
	Namespace: callback
	Checksum: 0xD96BE601
	Offset: 0xF50
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function CodeCallback_PreInitialization()
{
	callback("hash_ecc6aecf");
	system::run_pre_systems();
}

/*
	Name: CodeCallback_FinalizeInitialization
	Namespace: callback
	Checksum: 0xF10ABC5D
	Offset: 0xF88
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function CodeCallback_FinalizeInitialization()
{
	system::run_post_systems();
	callback("hash_36fb1b1a");
}

/*
	Name: add_weapon_damage
	Namespace: callback
	Checksum: 0x8ED56E39
	Offset: 0xFC0
	Size: 0x3D
	Parameters: 2
	Flags: None
*/
function add_weapon_damage(weapontype, callback)
{
	if(!isdefined(level.weapon_damage_callback_array))
	{
		level.weapon_damage_callback_array = [];
	}
	level.weapon_damage_callback_array[weapontype] = callback;
}

/*
	Name: callback_weapon_damage
	Namespace: callback
	Checksum: 0x817BF70F
	Offset: 0x1008
	Size: 0xD9
	Parameters: 5
	Flags: None
*/
function callback_weapon_damage(eAttacker, eInflictor, weapon, meansOfDeath, damage)
{
	if(isdefined(level.weapon_damage_callback_array))
	{
		if(isdefined(level.weapon_damage_callback_array[weapon]))
		{
			self thread [[level.weapon_damage_callback_array[weapon]]](eAttacker, eInflictor, weapon, meansOfDeath, damage);
			return 1;
		}
		else if(isdefined(level.weapon_damage_callback_array[weapon.rootweapon]))
		{
			self thread [[level.weapon_damage_callback_array[weapon.rootweapon]]](eAttacker, eInflictor, weapon, meansOfDeath, damage);
			return 1;
		}
	}
	return 0;
}

/*
	Name: add_weapon_watcher
	Namespace: callback
	Checksum: 0x39EAFCCA
	Offset: 0x10F0
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function add_weapon_watcher(callback)
{
	if(!isdefined(level.weapon_watcher_callback_array))
	{
		level.weapon_watcher_callback_array = [];
	}
	Array::add(level.weapon_watcher_callback_array, callback);
}

/*
	Name: callback_weapon_watcher
	Namespace: callback
	Checksum: 0x40668F64
	Offset: 0x1140
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function callback_weapon_watcher()
{
	if(isdefined(level.weapon_watcher_callback_array))
	{
		for(x = 0; x < level.weapon_watcher_callback_array.size; x++)
		{
			self [[level.weapon_watcher_callback_array[x]]]();
		}
	}
}

/*
	Name: CodeCallback_StartGameType
	Namespace: callback
	Checksum: 0xB20B5DFC
	Offset: 0x11A0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function CodeCallback_StartGameType()
{
	if(!isdefined(level.gametypestarted) || !level.gametypestarted)
	{
		[[level.callbackStartGameType]]();
		level.gametypestarted = 1;
	}
}

/*
	Name: CodeCallback_PlayerConnect
	Namespace: callback
	Checksum: 0x117EE0D9
	Offset: 0x11E8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function CodeCallback_PlayerConnect()
{
	self endon("disconnect");
	[[level.callbackPlayerConnect]]();
}

/*
	Name: CodeCallback_PlayerDisconnect
	Namespace: callback
	Checksum: 0x850DE460
	Offset: 0x1210
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function CodeCallback_PlayerDisconnect()
{
	self notify("death");
	self.player_disconnected = 1;
	self notify("disconnect");
	level notify("disconnect", self);
	[[level.callbackPlayerDisconnect]]();
	callback("hash_aebdd257");
}

/*
	Name: CodeCallback_Migration_SetupGameType
	Namespace: callback
	Checksum: 0x7FF90849
	Offset: 0x1280
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function CodeCallback_Migration_SetupGameType()
{
	/#
		println("Dev Block strings are not supported");
	#/
	simple_hostmigration::Migration_SetupGameType();
}

/*
	Name: CodeCallback_HostMigration
	Namespace: callback
	Checksum: 0xA3E742C0
	Offset: 0x12C0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function CodeCallback_HostMigration()
{
	/#
		println("Dev Block strings are not supported");
	#/
	[[level.callbackHostMigration]]();
}

/*
	Name: CodeCallback_HostMigrationSave
	Namespace: callback
	Checksum: 0x1DA9CAB5
	Offset: 0x1300
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function CodeCallback_HostMigrationSave()
{
	/#
		println("Dev Block strings are not supported");
	#/
	[[level.callbackHostMigrationSave]]();
}

/*
	Name: CodeCallback_PreHostMigrationSave
	Namespace: callback
	Checksum: 0x5BD0D6FD
	Offset: 0x1340
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function CodeCallback_PreHostMigrationSave()
{
	/#
		println("Dev Block strings are not supported");
	#/
	[[level.callbackPreHostMigrationSave]]();
}

/*
	Name: CodeCallback_PlayerMigrated
	Namespace: callback
	Checksum: 0xEEABBFA5
	Offset: 0x1380
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function CodeCallback_PlayerMigrated()
{
	/#
		println("Dev Block strings are not supported");
	#/
	[[level.callbackPlayerMigrated]]();
}

/*
	Name: CodeCallback_PlayerDamage
	Namespace: callback
	Checksum: 0x8F21F542
	Offset: 0x13C0
	Size: 0xB7
	Parameters: 13
	Flags: None
*/
function CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, vSurfaceNormal)
{
	self endon("disconnect");
	[[level.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, vSurfaceNormal);
}

/*
	Name: CodeCallback_PlayerKilled
	Namespace: callback
	Checksum: 0x91ABE38A
	Offset: 0x1480
	Size: 0x87
	Parameters: 9
	Flags: None
*/
function CodeCallback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");
	[[level.callbackPlayerKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
}

/*
	Name: CodeCallback_PlayerLastStand
	Namespace: callback
	Checksum: 0x3CF3C93E
	Offset: 0x1510
	Size: 0x87
	Parameters: 9
	Flags: None
*/
function CodeCallback_PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset, delayOverride)
{
	self endon("disconnect");
	[[level.callbackPlayerLastStand]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset, delayOverride);
}

/*
	Name: CodeCallback_PlayerMelee
	Namespace: callback
	Checksum: 0x21B2FC39
	Offset: 0x15A0
	Size: 0x7B
	Parameters: 8
	Flags: None
*/
function CodeCallback_PlayerMelee(eAttacker, iDamage, weapon, vOrigin, vDir, boneIndex, shieldHit, fromBehind)
{
	self endon("disconnect");
	[[level.callbackPlayerMelee]](eAttacker, iDamage, weapon, vOrigin, vDir, boneIndex, shieldHit, fromBehind);
}

/*
	Name: CodeCallback_ActorSpawned
	Namespace: callback
	Checksum: 0x48935066
	Offset: 0x1628
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function CodeCallback_ActorSpawned(spawner)
{
	[[level.callbackActorSpawned]](spawner);
}

/*
	Name: CodeCallback_ActorDamage
	Namespace: callback
	Checksum: 0x1A0221F0
	Offset: 0x1650
	Size: 0xC7
	Parameters: 15
	Flags: None
*/
function CodeCallback_ActorDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal)
{
	[[level.callbackActorDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal);
}

/*
	Name: CodeCallback_ActorKilled
	Namespace: callback
	Checksum: 0x2ECFC077
	Offset: 0x1720
	Size: 0x73
	Parameters: 8
	Flags: None
*/
function CodeCallback_ActorKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset)
{
	[[level.callbackActorKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, timeOffset);
}

/*
	Name: CodeCallback_ActorCloned
	Namespace: callback
	Checksum: 0x7B9FAD6F
	Offset: 0x17A0
	Size: 0x1F
	Parameters: 1
	Flags: None
*/
function CodeCallback_ActorCloned(original)
{
	[[level.callbackActorCloned]](original);
}

/*
	Name: CodeCallback_VehicleSpawned
	Namespace: callback
	Checksum: 0xD98FF782
	Offset: 0x17C8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function CodeCallback_VehicleSpawned(spawner)
{
	if(isdefined(level.callbackVehicleSpawned))
	{
		[[level.callbackVehicleSpawned]](spawner);
	}
}

/*
	Name: codecallback_vehiclekilled
	Namespace: callback
	Checksum: 0x33EDC3BA
	Offset: 0x1800
	Size: 0x73
	Parameters: 8
	Flags: None
*/
function codecallback_vehiclekilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	[[level.callbackVehicleKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime);
}

/*
	Name: CodeCallback_VehicleDamage
	Namespace: callback
	Checksum: 0xB692CFA
	Offset: 0x1880
	Size: 0xC7
	Parameters: 15
	Flags: None
*/
function CodeCallback_VehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	[[level.callbackVehicleDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, damageFromUnderneath, modelIndex, partName, vSurfaceNormal);
}

/*
	Name: CodeCallback_VehicleRadiusDamage
	Namespace: callback
	Checksum: 0xED79F1CC
	Offset: 0x1950
	Size: 0xAF
	Parameters: 13
	Flags: None
*/
function CodeCallback_VehicleRadiusDamage(eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, timeOffset)
{
	[[level.callbackVehicleRadiusDamage]](eInflictor, eAttacker, iDamage, fInnerDamage, fOuterDamage, iDFlags, sMeansOfDeath, weapon, vPoint, fRadius, fConeAngleCos, vConeDir, timeOffset);
}

/*
	Name: finishCustomTraversalListener
	Namespace: callback
	Checksum: 0xAC8C0A8D
	Offset: 0x1A08
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function finishCustomTraversalListener()
{
	self endon("death");
	self waittillmatch("hash_154a271a");
	self finishtraversal();
	self Unlink();
	self.useGoalAnimWeight = 0;
	self.blockingPain = 0;
	self.customTraverseEndNode = undefined;
	self.customTraverseStartNode = undefined;
	self notify("custom_traversal_cleanup", "end");
}

/*
	Name: killedCustomTraversalListener
	Namespace: callback
	Checksum: 0x404E990C
	Offset: 0x1AA0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function killedCustomTraversalListener()
{
	self endon("custom_traversal_cleanup");
	self waittill("death");
	if(isdefined(self))
	{
		self finishtraversal();
		self StopAnimScripted();
		self Unlink();
	}
}

/*
	Name: CodeCallback_PlayCustomTraversal
	Namespace: callback
	Checksum: 0xE2C15BC
	Offset: 0x1B18
	Size: 0x1BB
	Parameters: 10
	Flags: None
*/
function CodeCallback_PlayCustomTraversal(entity, beginParent, endParent, origin, angles, animHandle, animMode, playbackSpeed, goalTime, lerpTime)
{
	entity.blockingPain = 1;
	entity.useGoalAnimWeight = 1;
	entity.customTraverseEndNode = entity.traverseEndNode;
	entity.customTraverseStartNode = entity.traverseStartNode;
	entity animMode("noclip", 0);
	entity OrientMode("face angle", angles[1]);
	if(isdefined(endParent))
	{
		offset = entity.origin - endParent.origin;
		entity LinkTo(endParent, "", offset);
	}
	entity AnimScripted("custom_traversal_anim_finished", origin, angles, animHandle, animMode, undefined, playbackSpeed, goalTime, lerpTime);
	entity thread finishCustomTraversalListener();
	entity thread killedCustomTraversalListener();
}

/*
	Name: CodeCallback_FaceEventNotify
	Namespace: callback
	Checksum: 0x8EDE0787
	Offset: 0x1CE0
	Size: 0x93
	Parameters: 2
	Flags: None
*/
function CodeCallback_FaceEventNotify(notify_msg, ent)
{
	if(isdefined(ent) && isdefined(ent.do_face_anims) && ent.do_face_anims)
	{
		if(isdefined(level.face_event_handler) && isdefined(level.face_event_handler.events[notify_msg]))
		{
			ent SendFaceEvent(level.face_event_handler.events[notify_msg]);
		}
	}
}

/*
	Name: CodeCallback_MenuResponse
	Namespace: callback
	Checksum: 0x85C5EE2F
	Offset: 0x1D80
	Size: 0xDD
	Parameters: 2
	Flags: None
*/
function CodeCallback_MenuResponse(ACTION, arg)
{
	if(!isdefined(level.MenuResponseQueue))
	{
		level.MenuResponseQueue = [];
		level thread menu_response_queue_pump();
	}
	index = level.MenuResponseQueue.size;
	level.MenuResponseQueue[index] = spawnstruct();
	level.MenuResponseQueue[index].ACTION = ACTION;
	level.MenuResponseQueue[index].arg = arg;
	level.MenuResponseQueue[index].ent = self;
	level notify("menuresponse_queue");
}

/*
	Name: menu_response_queue_pump
	Namespace: callback
	Checksum: 0x1E62D2E1
	Offset: 0x1E68
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function menu_response_queue_pump()
{
	while(1)
	{
		level waittill("menuresponse_queue");
		do
		{
			level.MenuResponseQueue[0].ent notify("menuresponse", level.MenuResponseQueue[0].ACTION, level.MenuResponseQueue[0].arg);
			ArrayRemoveIndex(level.MenuResponseQueue, 0, 0);
			wait(0.05);
		}
		while(!level.MenuResponseQueue.size > 0);
	}
}

/*
	Name: CodeCallback_CallServerScript
	Namespace: callback
	Checksum: 0x542A4E23
	Offset: 0x1F08
	Size: 0x59
	Parameters: 3
	Flags: None
*/
function CodeCallback_CallServerScript(pSelf, label, Param)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		return;
	}
	if(isdefined(level._animnotifyfuncs[label]))
	{
		pSelf [[level._animnotifyfuncs[label]]](Param);
	}
}

/*
	Name: CodeCallback_CallServerScriptOnLevel
	Namespace: callback
	Checksum: 0xB90539AC
	Offset: 0x1F70
	Size: 0x51
	Parameters: 2
	Flags: None
*/
function CodeCallback_CallServerScriptOnLevel(label, Param)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		return;
	}
	if(isdefined(level._animnotifyfuncs[label]))
	{
		level [[level._animnotifyfuncs[label]]](Param);
	}
}

/*
	Name: CodeCallback_LaunchSideMission
	Namespace: callback
	Checksum: 0xC1A0E47E
	Offset: 0x1FD0
	Size: 0x93
	Parameters: 4
	Flags: None
*/
function CodeCallback_LaunchSideMission(str_mapname, str_gametype, int_list_index, int_lighting)
{
	SwitchMap_Preload(str_mapname, str_gametype, int_lighting);
	LUINotifyEvent(&"open_side_mission_countdown", 1, int_list_index);
	wait(10);
	LUINotifyEvent(&"close_side_mission_countdown");
	switchmap_switch();
}

/*
	Name: CodeCallback_FadeBlackscreen
	Namespace: callback
	Checksum: 0x1C1E0FBB
	Offset: 0x2070
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function CodeCallback_FadeBlackscreen(duration, blendTime)
{
	for(i = 0; i < level.players.size; i++)
	{
		if(isdefined(level.players[i]))
		{
			level.players[i] thread hud::fade_to_black_for_x_sec(0, duration, blendTime, blendTime);
		}
	}
}

/*
	Name: CodeCallback_SetActiveCybercomAbility
	Namespace: callback
	Checksum: 0x3F1F9D49
	Offset: 0x2100
	Size: 0x1D
	Parameters: 1
	Flags: None
*/
function CodeCallback_SetActiveCybercomAbility(new_ability)
{
	self notify("setcybercomability", new_ability);
}

/*
	Name: abort_level
	Namespace: callback
	Checksum: 0x2F23F6EF
	Offset: 0x2128
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function abort_level()
{
	/#
		println("Dev Block strings are not supported");
	#/
	level.callbackStartGameType = &callback_void;
	level.callbackPlayerConnect = &callback_void;
	level.callbackPlayerDisconnect = &callback_void;
	level.callbackPlayerDamage = &callback_void;
	level.callbackPlayerKilled = &callback_void;
	level.callbackPlayerLastStand = &callback_void;
	level.callbackPlayerMelee = &callback_void;
	level.callbackActorDamage = &callback_void;
	level.callbackActorKilled = &callback_void;
	level.callbackVehicleDamage = &callback_void;
	level.callbackVehicleKilled = &callback_void;
	level.callbackActorSpawned = &callback_void;
	level.callbackBotEnteredUserEdge = &callback_void;
	if(isdefined(level._gametype_default))
	{
		SetDvar("g_gametype", level._gametype_default);
	}
	exitLevel(0);
}

/*
	Name: CodeCallback_GlassSmash
	Namespace: callback
	Checksum: 0x7E7088B0
	Offset: 0x22D8
	Size: 0x29
	Parameters: 2
	Flags: None
*/
function CodeCallback_GlassSmash(pos, dir)
{
	level notify("glass_smash", pos, dir);
}

/*
	Name: CodeCallback_BotEnteredUserEdge
	Namespace: callback
	Checksum: 0x3EB81165
	Offset: 0x2310
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function CodeCallback_BotEnteredUserEdge(startnode, endNode)
{
	[[level.callbackBotEnteredUserEdge]](startnode, endNode);
}

/*
	Name: CodeCallback_Decoration
	Namespace: callback
	Checksum: 0x23BE3DEA
	Offset: 0x2348
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function CodeCallback_Decoration(name)
{
	a_decorations = self GetDecorations(1);
	if(!isdefined(a_decorations))
	{
		return;
	}
	if(a_decorations.size == 12)
	{
		self notify("give_achievement", "CP_ALL_DECORATIONS");
	}
	a_all_decorations = self GetDecorations();
	if(a_decorations.size == a_all_decorations.size - 1)
	{
		self GiveDecoration("cp_medal_all_decorations");
	}
	level notify("decoration_awarded");
	[[level.callbackDecorationAwarded]]();
}

/*
	Name: callback_void
	Namespace: callback
	Checksum: 0x99EC1590
	Offset: 0x2420
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function callback_void()
{
}

