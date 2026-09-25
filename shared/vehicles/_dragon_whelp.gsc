#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace dragon;

/*
	Name: __init__sytem__
	Namespace: dragon
	Checksum: 0x95A02DCE
	Offset: 0x330
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("dragon", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: dragon
	Checksum: 0x19735DDB
	Offset: 0x370
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("dragon", &dragon_initialize);
}

/*
	Name: dragon_initialize
	Namespace: dragon
	Checksum: 0x6E1FC824
	Offset: 0x3A8
	Size: 0x23B
	Parameters: 0
	Flags: None
*/
function dragon_initialize()
{
	self useanimtree(-1);
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	if(isdefined(self.scriptbundlesettings))
	{
		self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	/#
		Assert(isdefined(self.settings));
	#/
	self SetNearGoalNotifyDist(self.radius * 1.5);
	self SetHoverParams(self.radius, self.settings.defaultMoveSpeed * 2, self.radius);
	self SetSpeed(self.settings.defaultMoveSpeed);
	blackboard::CreateBlackBoardForEntity(self);
	self blackboard::RegisterVehicleBlackBoardAttributes();
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.vehAirCraftCollisionEnabled = 0;
	self.goalRadius = 9999999;
	self.goalHeight = 512;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self.delete_on_death = 1;
	self.overrideVehicleDamage = &dragon_callback_damage;
	self.allowFriendlyFireDamageOverride = &dragon_AllowFriendlyFireDamage;
	self.ignoreme = 1;
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	defaultRole();
}

/*
	Name: defaultRole
	Namespace: dragon
	Checksum: 0xB07A22BD
	Offset: 0x5F0
	Size: 0x177
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	if(SessionModeIsZombiesGame())
	{
		self vehicle_ai::add_state("power_up", undefined, &state_power_up_update, undefined);
		self vehicle_ai::add_utility_connection("combat", "power_up", &should_go_for_power_up);
		self vehicle_ai::add_utility_connection("power_up", "combat");
	}
	/#
		SetDvar("Dev Block strings are not supported", 0);
	#/
	self thread dragon_target_selection();
	vehicle_ai::StartInitialState("combat");
	self.startTime = GetTime();
}

/*
	Name: is_enemy_valid
	Namespace: dragon
	Checksum: 0x301A319A
	Offset: 0x770
	Size: 0x1BD
	Parameters: 1
	Flags: Private
*/
function private is_enemy_valid(target)
{
	if(!isdefined(target))
	{
		return 0;
	}
	if(!isalive(target))
	{
		return 0;
	}
	if(isdefined(self.intermission) && self.intermission)
	{
		return 0;
	}
	if(isdefined(target.ignoreme) && target.ignoreme)
	{
		return 0;
	}
	if(target IsNoTarget())
	{
		return 0;
	}
	if(isdefined(target._dragon_ignoreme) && target._dragon_ignoreme)
	{
		return 0;
	}
	if(DistanceSquared(self.owner.origin, target.origin) > self.settings.guardradius * self.settings.guardradius)
	{
		return 0;
	}
	if(self VehCanSee(target))
	{
		return 1;
	}
	if(IsActor(target) && target cansee(self.owner))
	{
		return 1;
	}
	if(isVehicle(target) && target VehCanSee(self.owner))
	{
		return 1;
	}
	return 0;
}

/*
	Name: get_dragon_enemy
	Namespace: dragon
	Checksum: 0xC3DB2B33
	Offset: 0x938
	Size: 0x29B
	Parameters: 0
	Flags: Private
*/
function private get_dragon_enemy()
{
	dragon_enemies = GetAITeamArray("axis");
	distSqr = 10000 * 10000;
	best_enemy = undefined;
	foreach(enemy in dragon_enemies)
	{
		newDistSqr = Distance2DSquared(enemy.origin, self.owner.origin);
		if(is_enemy_valid(enemy))
		{
			if(enemy.archetype === "raz")
			{
				newDistSqr = max(Distance2D(enemy.origin, self.owner.origin) - 700, 0);
				newDistSqr = newDistSqr * newDistSqr;
			}
			else if(enemy.archetype === "sentinel_drone")
			{
				newDistSqr = max(Distance2D(enemy.origin, self.owner.origin) - 500, 0);
				newDistSqr = newDistSqr * newDistSqr;
			}
			else if(enemy === self.dragonEnemy)
			{
				newDistSqr = max(Distance2D(enemy.origin, self.owner.origin) - 300, 0);
				newDistSqr = newDistSqr * newDistSqr;
			}
			if(newDistSqr < distSqr)
			{
				distSqr = newDistSqr;
				best_enemy = enemy;
			}
		}
	}
	return best_enemy;
}

/*
	Name: dragon_target_selection
	Namespace: dragon
	Checksum: 0x9CE7BF64
	Offset: 0xBE0
	Size: 0xFF
	Parameters: 0
	Flags: Private
*/
function private dragon_target_selection()
{
	self endon("death");
	while(!isdefined(self.owner))
	{
		wait(0.25);
		continue;
		if(isdefined(self.ignoreall) && self.ignoreall)
		{
			wait(0.25);
		}
		else
		{
			if(GetDvarInt("Dev Block strings are not supported", 0))
			{
				if(isdefined(self.dragonEnemy))
				{
					line(self.origin, self.dragonEnemy.origin, (1, 0, 0), 1, 0, 5);
				}
			}
			target = get_dragon_enemy();
			if(!isdefined(target))
			{
				self.dragonEnemy = undefined;
			}
			else
			{
				self.dragonEnemy = target;
			}
			wait(0.25);
		}
		/#
		#/
	}
}

/*
	Name: state_power_up_update
	Namespace: dragon
	Checksum: 0x6AC2C56B
	Offset: 0xCE8
	Size: 0x263
	Parameters: 1
	Flags: None
*/
function state_power_up_update(params)
{
	self endon("change_state");
	self endon("death");
	closest_distSqr = 10000 * 10000;
	closest = undefined;
	foreach(powerup in level.active_powerups)
	{
		powerup.navVolumeOrigin = self GetClosestPointOnNavVolume(powerup.origin, 100);
		if(!isdefined(powerup.navVolumeOrigin))
		{
			continue;
		}
		distSqr = DistanceSquared(powerup.origin, self.origin);
		if(distSqr < closest_distSqr)
		{
			closest_distSqr = distSqr;
			closest = powerup;
		}
	}
	if(isdefined(closest) && distSqr < 2000 * 2000)
	{
		self SetVehGoalPos(closest.navVolumeOrigin, 1, 1);
		if(vehicle_ai::waittill_pathresult())
		{
			self vehicle_ai::waittill_pathing_done();
		}
		if(isdefined(closest))
		{
			trace = bullettrace(self.origin, closest.origin, 0, self);
			if(trace["fraction"] == 1)
			{
				self SetVehGoalPos(closest.origin, 1, 0);
			}
		}
	}
	self vehicle_ai::evaluate_connections();
}

/*
	Name: should_go_for_power_up
	Namespace: dragon
	Checksum: 0x5C589533
	Offset: 0xF58
	Size: 0x59
	Parameters: 3
	Flags: None
*/
function should_go_for_power_up(from_state, to_state, connection)
{
	if(level.whelp_no_power_up_pickup === 1)
	{
		return 0;
	}
	if(isdefined(self.dragonEnemy))
	{
		return 0;
	}
	if(level.active_powerups.size < 1)
	{
		return 0;
	}
	return 1;
}

/*
	Name: state_combat_update
	Namespace: dragon
	Checksum: 0x170A7E76
	Offset: 0xFC0
	Size: 0x84F
	Parameters: 1
	Flags: None
*/
function state_combat_update(params)
{
	self endon("change_state");
	self endon("death");
	idealDistToOwner = 300;
	self ASMRequestSubstate("locomotion@movement");
	while(!isdefined(self.owner))
	{
		wait(0.05);
	}
	self thread attack_thread();
	for(;;)
	{
		self SetSpeed(self.settings.defaultMoveSpeed);
		self ASMRequestSubstate("locomotion@movement");
		if(isdefined(self.owner) && Distance2DSquared(self.origin, self.owner.origin) < idealDistToOwner * idealDistToOwner && IsPointInNavvolume(self.origin, "navvolume_small"))
		{
			if(!isdefined(self.current_pathto_pos))
			{
				self.current_pathto_pos = self GetClosestPointOnNavVolume(self.origin, 100);
			}
			self SetVehGoalPos(self.current_pathto_pos, 1, 0);
			wait(0.1);
			continue;
		}
		if(isdefined(self.owner))
		{
			queryResult = PositionQuery_Source_Navigation(self.origin, 0, 256, 90, self.radius, self);
			sightTarget = undefined;
			if(isdefined(self.dragonEnemy))
			{
				sightTarget = self.dragonEnemy GetEye();
				PositionQuery_Filter_Sight(queryResult, sightTarget, (0, 0, 0), self, 4);
			}
			if(isdefined(queryResult.centerOnNav) && queryResult.centerOnNav)
			{
				ownerOrigin = self.owner.origin;
				ownerForward = AnglesToForward(self.owner.angles);
				best_point = undefined;
				best_score = -999999;
				foreach(point in queryResult.data)
				{
					distSqr = Distance2DSquared(point.origin, ownerOrigin);
					if(distSqr > idealDistToOwner * idealDistToOwner)
					{
						/#
							if(!isdefined(point._scoreDebug))
							{
								point._scoreDebug = [];
							}
							point._scoreDebug["Dev Block strings are not supported"] = sqrt(distSqr) * -1 * 2;
						#/
						point.score = point.score + sqrt(distSqr) * -1 * 2;
					}
					if(isdefined(point.visibility) && point.visibility)
					{
						if(BulletTracePassed(point.origin, sightTarget, 0, self))
						{
							/#
								if(!isdefined(point._scoreDebug))
								{
									point._scoreDebug = [];
								}
								point._scoreDebug["Dev Block strings are not supported"] = 400;
							#/
							point.score = point.score + 400;
						}
					}
					vecToOwner = point.origin - ownerOrigin;
					dirToOwner = VectorNormalize((vecToOwner[0], vecToOwner[1], 0));
					if(VectorDot(ownerForward, dirToOwner) > 0.34)
					{
						if(Abs(vecToOwner[2]) < 100)
						{
							/#
								if(!isdefined(point._scoreDebug))
								{
									point._scoreDebug = [];
								}
								point._scoreDebug["Dev Block strings are not supported"] = 300;
							#/
							point.score = point.score + 300;
						}
						else if(Abs(vecToOwner[2]) < 200)
						{
							/#
								if(!isdefined(point._scoreDebug))
								{
									point._scoreDebug = [];
								}
								point._scoreDebug["Dev Block strings are not supported"] = 100;
							#/
							point.score = point.score + 100;
						}
					}
					if(point.score > best_score)
					{
						best_score = point.score;
						best_point = point;
					}
				}
				self vehicle_ai::PositionQuery_DebugScores(queryResult);
				if(isdefined(best_point))
				{
					/#
						if(isdefined(GetDvarInt("Dev Block strings are not supported")) && GetDvarInt("Dev Block strings are not supported"))
						{
							recordLine(self.origin, best_point.origin, (0.3, 1, 0));
							recordLine(self.origin, self.owner.origin, (1, 0, 0.4));
						}
					#/
					if(DistanceSquared(self.origin, best_point.origin) > 50 * 50)
					{
						self.current_pathto_pos = best_point.origin;
						self SetVehGoalPos(self.current_pathto_pos, 1, 1);
						self vehicle_ai::waittill_pathing_done(5);
					}
					else
					{
						self vehicle_ai::Cooldown("move_cooldown", 4);
					}
				}
			}
			else
			{
				go_back_on_navvolume();
			}
		}
		wait(0.1);
	}
}

/*
	Name: attack_thread
	Namespace: dragon
	Checksum: 0x36FDCF4
	Offset: 0x1818
	Size: 0x24F
	Parameters: 0
	Flags: None
*/
function attack_thread()
{
	self endon("change_state");
	self endon("death");
	for(;;)
	{
		wait(0.1);
		self vehicle_ai::evaluate_connections();
		if(!self vehicle_ai::IsCooldownReady("attack"))
		{
			continue;
		}
		if(!isdefined(self.dragonEnemy))
		{
			continue;
		}
		self SetLookAtEnt(self.dragonEnemy);
		if(!self VehCanSee(self.dragonEnemy))
		{
			continue;
		}
		if(Distance2DSquared(self.dragonEnemy.origin, self.owner.origin) > self.settings.guardradius * self.settings.guardradius)
		{
			continue;
		}
		eyeOffset = self.dragonEnemy GetEye() - self.dragonEnemy.origin * 0.6;
		if(!BulletTracePassed(self.origin, self.dragonEnemy GetEye() - eyeOffset, 0, self, self.dragonEnemy))
		{
			self.dragonEnemy = undefined;
			continue;
		}
		aimOffset = self.dragonEnemy GetVelocity() * 0.3 - eyeOffset;
		self SetTurretTargetEnt(self.dragonEnemy, aimOffset);
		wait(0.2);
		if(isdefined(self.dragonEnemy))
		{
			self FireWeapon(0, self.dragonEnemy, (0, 0, 0), self);
			self vehicle_ai::Cooldown("attack", 1);
		}
	}
}

/*
	Name: go_back_on_navvolume
	Namespace: dragon
	Checksum: 0x43D208C4
	Offset: 0x1A70
	Size: 0x2AB
	Parameters: 0
	Flags: None
*/
function go_back_on_navvolume()
{
	queryResult = PositionQuery_Source_Navigation(self.origin, 0, 100, 90, self.radius, self);
	multiplier = 2;
	while(queryResult.data.size < 1)
	{
		queryResult = PositionQuery_Source_Navigation(self.origin, 0, 100 * multiplier, 90 * multiplier, self.radius * multiplier, self);
		multiplier = multiplier + 2;
	}
	if(queryResult.data.size && !queryResult.centerOnNav)
	{
		best_point = undefined;
		best_score = 999999;
		foreach(point in queryResult.data)
		{
			point.score = Abs(point.origin[2] - queryResult.origin[2]);
			if(point.score < best_score)
			{
				best_score = point.score;
				best_point = point;
			}
		}
		if(isdefined(best_point))
		{
			self SetNearGoalNotifyDist(2);
			point = best_point;
			self.current_pathto_pos = point.origin;
			foundpath = self SetVehGoalPos(self.current_pathto_pos, 1, 0);
			if(foundpath)
			{
				self vehicle_ai::waittill_pathing_done(5);
			}
			self SetNearGoalNotifyDist(self.radius);
		}
	}
}

/*
	Name: dragon_AllowFriendlyFireDamage
	Namespace: dragon
	Checksum: 0xF44B4151
	Offset: 0x1D28
	Size: 0x25
	Parameters: 4
	Flags: None
*/
function dragon_AllowFriendlyFireDamage(eInflictor, eAttacker, sMeansOfDeath, weapon)
{
	return 0;
}

/*
	Name: dragon_callback_damage
	Namespace: dragon
	Checksum: 0x5610BCB2
	Offset: 0x1D58
	Size: 0x93
	Parameters: 15
	Flags: None
*/
function dragon_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(self.dragon_recall_death !== 1)
	{
		return 0;
	}
	return iDamage;
}

/*
	Name: state_death_update
	Namespace: dragon
	Checksum: 0xB059842E
	Offset: 0x1DF8
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function state_death_update(params)
{
	self endon("death");
	attacker = params.inflictor;
	if(!isdefined(attacker))
	{
		attacker = params.attacker;
	}
	if(attacker !== self && (!isdefined(self.owner) || self.owner !== attacker) && (isai(attacker) || isPlayer(attacker)))
	{
		self.damage_on_death = 0;
		wait(0.05);
		attacker = params.inflictor;
		if(!isdefined(attacker))
		{
			attacker = params.attacker;
		}
	}
	self vehicle_ai::defaultstate_death_update();
}

