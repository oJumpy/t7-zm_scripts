#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace oob;

/*
	Name: __init__sytem__
	Namespace: oob
	Checksum: 0xAE8C057D
	Offset: 0x200
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("out_of_bounds", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: oob
	Checksum: 0x7D58F041
	Offset: 0x240
	Size: 0x2D3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.oob_triggers = [];
	if(SessionModeIsMultiplayerGame())
	{
		level.oob_timekeep_ms = GetDvarInt("oob_timekeep_ms", 3000);
		level.oob_timelimit_ms = GetDvarInt("oob_timelimit_ms", 3000);
		level.oob_damage_interval_ms = GetDvarInt("oob_damage_interval_ms", 3000);
		level.oob_damage_per_interval = GetDvarInt("oob_damage_per_interval", 999);
		level.oob_max_distance_before_black = GetDvarInt("oob_max_distance_before_black", 100000);
		level.oob_time_remaining_before_black = GetDvarInt("oob_time_remaining_before_black", -1);
	}
	else
	{
		level.oob_timelimit_ms = GetDvarInt("oob_timelimit_ms", 6000);
		level.oob_damage_interval_ms = GetDvarInt("oob_damage_interval_ms", 1000);
		level.oob_damage_per_interval = GetDvarInt("oob_damage_per_interval", 5);
		level.oob_max_distance_before_black = GetDvarInt("oob_max_distance_before_black", 400);
		level.oob_time_remaining_before_black = GetDvarInt("oob_time_remaining_before_black", 1000);
	}
	level.oob_damage_interval_sec = level.oob_damage_interval_ms / 1000;
	hurt_triggers = GetEntArray("trigger_out_of_bounds", "classname");
	foreach(trigger in hurt_triggers)
	{
		trigger thread run_oob_trigger();
	}
	clientfield::register("toplayer", "out_of_bounds", 1, 5, "int");
}

/*
	Name: run_oob_trigger
	Namespace: oob
	Checksum: 0x783E749C
	Offset: 0x520
	Size: 0xA3
	Parameters: 0
	Flags: None
*/
function run_oob_trigger()
{
	self.oob_players = [];
	if(!isdefined(level.oob_triggers))
	{
		level.oob_triggers = [];
	}
	else if(!IsArray(level.oob_triggers))
	{
		level.oob_triggers = Array(level.oob_triggers);
	}
	level.oob_triggers[level.oob_triggers.size] = self;
	self thread waitForPlayerTouch();
	self thread waitForCloneTouch();
}

/*
	Name: IsOutOfBounds
	Namespace: oob
	Checksum: 0x7F9C0879
	Offset: 0x5D0
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function IsOutOfBounds()
{
	if(!isdefined(self.oob_start_time))
	{
		return 0;
	}
	return self.oob_start_time != -1;
}

/*
	Name: IsTouchingAnyOOBTrigger
	Namespace: oob
	Checksum: 0x93E8A62E
	Offset: 0x5F8
	Size: 0x1D5
	Parameters: 0
	Flags: None
*/
function IsTouchingAnyOOBTrigger()
{
	triggers_to_remove = [];
	result = 0;
	foreach(trigger in level.oob_triggers)
	{
		if(!isdefined(trigger))
		{
			if(!isdefined(triggers_to_remove))
			{
				triggers_to_remove = [];
			}
			else if(!IsArray(triggers_to_remove))
			{
				triggers_to_remove = Array(triggers_to_remove);
			}
			triggers_to_remove[triggers_to_remove.size] = trigger;
			continue;
		}
		if(!trigger IsTriggerEnabled())
		{
			continue;
		}
		if(self istouching(trigger))
		{
			result = 1;
			break;
		}
	}
	foreach(trigger in triggers_to_remove)
	{
		ArrayRemoveValue(level.oob_triggers, trigger);
	}
	triggers_to_remove = [];
	triggers_to_remove = undefined;
	return result;
}

/*
	Name: ResetOOBTimer
	Namespace: oob
	Checksum: 0x59FE2514
	Offset: 0x7D8
	Size: 0xC5
	Parameters: 2
	Flags: None
*/
function ResetOOBTimer(is_host_migrating, b_disable_timekeep)
{
	self.oob_lastValidPlayerLoc = undefined;
	self.oob_LastValidPlayerDir = undefined;
	self clientfield::set_to_player("out_of_bounds", 0);
	self util::show_hud(1);
	self.oob_start_time = -1;
	if(isdefined(level.oob_timekeep_ms))
	{
		if(isdefined(b_disable_timekeep) && b_disable_timekeep)
		{
			self.last_oob_timekeep_ms = undefined;
		}
		else
		{
			self.last_oob_timekeep_ms = GetTime();
		}
	}
	if(!(isdefined(is_host_migrating) && is_host_migrating))
	{
		self notify("oob_host_migration_exit");
	}
	self notify("oob_exit");
}

/*
	Name: waitForCloneTouch
	Namespace: oob
	Checksum: 0x2F380CD2
	Offset: 0x8A8
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function waitForCloneTouch()
{
	self endon("death");
	while(1)
	{
		self waittill("trigger", clone);
		if(IsActor(clone) && isdefined(clone.isaiclone) && clone.isaiclone && !clone IsPlayingAnimScripted())
		{
			clone notify("clone_shutdown");
		}
	}
}

/*
	Name: GetAdjusedPlayer
	Namespace: oob
	Checksum: 0xAFC02708
	Offset: 0x950
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function GetAdjusedPlayer(player)
{
	if(isdefined(player.hijacked_vehicle_entity) && isalive(player.hijacked_vehicle_entity))
	{
		return player.hijacked_vehicle_entity;
	}
	return player;
}

/*
	Name: waitForPlayerTouch
	Namespace: oob
	Checksum: 0xA3D43195
	Offset: 0x9A8
	Size: 0x30F
	Parameters: 0
	Flags: None
*/
function waitForPlayerTouch()
{
	self endon("death");
	while(1)
	{
		if(SessionModeIsMultiplayerGame())
		{
			hostmigration::waitTillHostMigrationDone();
		}
		self waittill("trigger", entity);
		if(!isPlayer(entity) && (!isVehicle(entity) && (isdefined(entity.hijacked) && entity.hijacked) && isdefined(entity.owner) && isalive(entity)))
		{
			continue;
		}
		if(isPlayer(entity))
		{
			player = entity;
		}
		else
		{
			vehicle = entity;
			player = vehicle.owner;
		}
		if(!player IsOutOfBounds() && !player IsPlayingAnimScripted() && (!isdefined(player.OOBDisabled) && player.OOBDisabled))
		{
			player notify("oob_enter");
			if(isdefined(level.oob_timekeep_ms) && isdefined(player.last_oob_timekeep_ms) && isdefined(player.last_oob_duration_ms) && GetTime() - player.last_oob_timekeep_ms < level.oob_timekeep_ms)
			{
				player.oob_start_time = GetTime() - level.oob_timelimit_ms - player.last_oob_duration_ms;
			}
			else
			{
				player.oob_start_time = GetTime();
			}
			player.oob_lastValidPlayerLoc = entity.origin;
			player.oob_LastValidPlayerDir = VectorNormalize(entity GetVelocity());
			player util::show_hud(0);
			player thread watchForLeave(self, entity);
			player thread watchForDeath(self, entity);
			if(SessionModeIsMultiplayerGame())
			{
				player thread watchForHostMigration(self, entity);
			}
		}
	}
}

/*
	Name: GetDistanceFromLastValidPlayerLoc
	Namespace: oob
	Checksum: 0x524E78F8
	Offset: 0xCC0
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function GetDistanceFromLastValidPlayerLoc(trigger, entity)
{
	if(isdefined(self.oob_LastValidPlayerDir) && self.oob_LastValidPlayerDir != (0, 0, 0))
	{
		vecToPlayerLocFromOrigin = entity.origin - self.oob_lastValidPlayerLoc;
		Distance = VectorDot(vecToPlayerLocFromOrigin, self.oob_LastValidPlayerDir);
	}
	else
	{
		Distance = Distance(entity.origin, self.oob_lastValidPlayerLoc);
	}
	if(Distance < 0)
	{
		Distance = 0;
	}
	if(Distance > level.oob_max_distance_before_black)
	{
		Distance = level.oob_max_distance_before_black;
	}
	return Distance / level.oob_max_distance_before_black;
}

/*
	Name: UpdateVisualEffects
	Namespace: oob
	Checksum: 0xEDC2676F
	Offset: 0xDB8
	Size: 0x1B3
	Parameters: 2
	Flags: None
*/
function UpdateVisualEffects(trigger, entity)
{
	timeRemaining = level.oob_timelimit_ms - GetTime() - self.oob_start_time;
	if(isdefined(level.oob_timekeep_ms))
	{
		self.last_oob_duration_ms = timeRemaining;
	}
	oob_effectValue = 0;
	if(timeRemaining <= level.oob_time_remaining_before_black)
	{
		if(!isdefined(self.oob_lastEffectValue))
		{
			self.oob_lastEffectValue = GetDistanceFromLastValidPlayerLoc(trigger, entity);
		}
		time_val = 1 - timeRemaining / level.oob_time_remaining_before_black;
		if(time_val > 1)
		{
			time_val = 1;
		}
		oob_effectValue = self.oob_lastEffectValue + 1 - self.oob_lastEffectValue * time_val;
	}
	else
	{
		oob_effectValue = GetDistanceFromLastValidPlayerLoc(trigger, entity);
		if(oob_effectValue > 0.9)
		{
			oob_effectValue = 0.9;
		}
		else if(oob_effectValue < 0.05)
		{
			oob_effectValue = 0.05;
		}
		self.oob_lastEffectValue = oob_effectValue;
	}
	oob_effectValue = ceil(oob_effectValue * 31);
	self clientfield::set_to_player("out_of_bounds", Int(oob_effectValue));
}

/*
	Name: killEntity
	Namespace: oob
	Checksum: 0xEF12AF99
	Offset: 0xF78
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function killEntity(entity)
{
	entity_to_kill = entity;
	if(isPlayer(entity) && entity IsInVehicle())
	{
		vehicle = entity GetVehicleOccupied();
		if(isdefined(vehicle) && vehicle.is_oob_kill_target === 1)
		{
			entity_to_kill = vehicle;
		}
	}
	self ResetOOBTimer();
	entity_to_kill DoDamage(entity_to_kill.health + 10000, entity_to_kill.origin, undefined, undefined, "none", "MOD_TRIGGER_HURT");
}

/*
	Name: watchForLeave
	Namespace: oob
	Checksum: 0xAAB08131
	Offset: 0x1078
	Size: 0x13F
	Parameters: 2
	Flags: None
*/
function watchForLeave(trigger, entity)
{
	self endon("oob_exit");
	entity endon("death");
	while(1)
	{
		if(entity IsTouchingAnyOOBTrigger())
		{
			UpdateVisualEffects(trigger, entity);
			if(level.oob_timelimit_ms - GetTime() - self.oob_start_time <= 0)
			{
				if(isPlayer(entity))
				{
					entity DisableInvulnerability();
					entity.ignoreme = 0;
					entity.laststand = undefined;
					if(isdefined(entity.reviveTrigger))
					{
						entity.reviveTrigger delete();
					}
				}
				self thread killEntity(entity);
			}
		}
		else
		{
			self ResetOOBTimer();
		}
		wait(0.1);
	}
}

/*
	Name: watchForDeath
	Namespace: oob
	Checksum: 0x8E5E8487
	Offset: 0x11C0
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function watchForDeath(trigger, entity)
{
	self endon("disconnect");
	self endon("oob_exit");
	util::waittill_any_ents_two(self, "death", entity, "death");
	self ResetOOBTimer();
}

/*
	Name: watchForHostMigration
	Namespace: oob
	Checksum: 0xDA556949
	Offset: 0x1238
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function watchForHostMigration(trigger, entity)
{
	self endon("oob_host_migration_exit");
	level waittill("host_migration_begin");
	self ResetOOBTimer(1, 1);
}

/*
	Name: disablePlayerOOB
	Namespace: oob
	Checksum: 0x6CF93AE2
	Offset: 0x1290
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function disablePlayerOOB(disabled)
{
	if(disabled)
	{
		self ResetOOBTimer();
		self.OOBDisabled = 1;
	}
	else
	{
		self.OOBDisabled = 0;
	}
}

