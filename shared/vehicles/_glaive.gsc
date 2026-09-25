#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\margwa;
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

#namespace glaive;

/*
	Name: __init__sytem__
	Namespace: glaive
	Checksum: 0xA11527FC
	Offset: 0x490
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("glaive", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: glaive
	Checksum: 0xB691AEEA
	Offset: 0x4D0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("glaive", &glaive_initialize);
	clientfield::register("vehicle", "glaive_blood_fx", 1, 1, "int");
}

/*
	Name: glaive_initialize
	Namespace: glaive
	Checksum: 0xD0DB9DAC
	Offset: 0x538
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function glaive_initialize()
{
	self useanimtree(-1);
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self SetNearGoalNotifyDist(50);
	self SetHoverParams(0, 0, 40);
	self PlayLoopSound("wpn_sword2_looper");
	if(isdefined(self.scriptbundlesettings))
	{
		self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	blackboard::CreateBlackBoardForEntity(self);
	self blackboard::RegisterVehicleBlackBoardAttributes();
	self.fovcosine = 0;
	self.fovcosinebusy = 0.574;
	self.vehAirCraftCollisionEnabled = 0;
	self.goalRadius = 9999999;
	self.goalHeight = 512;
	self SetGoal(self.origin, 0, self.goalRadius, self.goalHeight);
	self.overrideVehicleDamage = &glaive_callback_damage;
	self.allowFriendlyFireDamageOverride = &glaive_AllowFriendlyFireDamage;
	self.ignoreme = 1;
	self._glaive_settings_lifetime = self.settings.lifetime;
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	defaultRole();
}

/*
	Name: defaultRole
	Namespace: glaive
	Checksum: 0x858D585F
	Offset: 0x740
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("combat").enter_func = &state_combat_enter;
	self vehicle_ai::add_state("slash", undefined, &state_slash_update, undefined);
	/#
		SetDvar("Dev Block strings are not supported", 1);
	#/
	self thread glaive_target_selection();
	vehicle_ai::StartInitialState("combat");
	self.startTime = GetTime();
}

/*
	Name: is_enemy_valid
	Namespace: glaive
	Checksum: 0xA618D061
	Offset: 0x850
	Size: 0x205
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
	if(isdefined(target._glaive_ignoreme) && target._glaive_ignoreme)
	{
		return 0;
	}
	if(isdefined(target.archetype) && target.archetype == "margwa")
	{
		if(!target MargwaServerUtils::margwaCanDamageAnyHead())
		{
			return 0;
		}
	}
	if(isdefined(target.archetype) && target.archetype == "zombie" && (!isdefined(target.completed_emerging_into_playable_area) && target.completed_emerging_into_playable_area))
	{
		return 0;
	}
	if(DistanceSquared(self.owner.origin, target.origin) > self.settings.guardradius * self.settings.guardradius)
	{
		return 0;
	}
	if(!SightTracePassed(self.origin, target.origin + VectorScale((0, 0, 1), 16), 0, target))
	{
		return 0;
	}
	return 1;
}

/*
	Name: get_glaive_enemy
	Namespace: glaive
	Checksum: 0xF317B23F
	Offset: 0xA60
	Size: 0xD9
	Parameters: 0
	Flags: Private
*/
function private get_glaive_enemy()
{
	glaive_enemies = GetAITeamArray("axis");
	ArraySortClosest(glaive_enemies, self.owner.origin);
	foreach(glaive_enemy in glaive_enemies)
	{
		if(is_enemy_valid(glaive_enemy))
		{
			return glaive_enemy;
		}
	}
}

/*
	Name: glaive_target_selection
	Namespace: glaive
	Checksum: 0xE2AE9D0D
	Offset: 0xB48
	Size: 0x157
	Parameters: 0
	Flags: Private
*/
function private glaive_target_selection()
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
				if(isdefined(self.glaiveEnemy))
				{
					line(self.origin, self.glaiveEnemy.origin, (1, 0, 0), 1, 0, 5);
				}
			}
			if(self is_enemy_valid(self.glaiveEnemy))
			{
				wait(0.25);
			}
			else if(isdefined(self._glaive_must_return_to_owner) && self._glaive_must_return_to_owner)
			{
				wait(0.25);
			}
			else
			{
				target = get_glaive_enemy();
				if(!isdefined(target))
				{
					self.glaiveEnemy = undefined;
				}
				else
				{
					self.glaiveEnemy = target;
				}
				wait(0.25);
			}
		}
		/#
		#/
	}
}

/*
	Name: should_go_to_owner
	Namespace: glaive
	Checksum: 0xF33A2D4
	Offset: 0xCA8
	Size: 0x67
	Parameters: 0
	Flags: None
*/
function should_go_to_owner()
{
	b_is_lifetime_over = GetTime() - self.startTime > self._glaive_settings_lifetime * 1000;
	if(isdefined(b_is_lifetime_over) && b_is_lifetime_over)
	{
		return 1;
	}
	if(self.owner.sword_power <= 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: should_go_to_near_owner
	Namespace: glaive
	Checksum: 0x7F033140
	Offset: 0xD18
	Size: 0x135
	Parameters: 0
	Flags: None
*/
function should_go_to_near_owner()
{
	if(isdefined(self.owner) && DistanceSquared(self.origin, self.owner.origin) > self.settings.guardradius * self.settings.guardradius)
	{
		return 1;
	}
	if(isdefined(self.owner) && !self is_enemy_valid(self.glaiveEnemy))
	{
		if(Distance2DSquared(self.origin, self.owner.origin) > 160 * 160)
		{
			return 1;
		}
		if(!util::within_fov(self.owner.origin, self.owner.angles, self.origin, cos(60)))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: state_combat_enter
	Namespace: glaive
	Checksum: 0xF8620B6E
	Offset: 0xE58
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function state_combat_enter(params)
{
	self ASMRequestSubstate("idle@movement");
}

/*
	Name: state_combat_update
	Namespace: glaive
	Checksum: 0x4D8510A7
	Offset: 0xE90
	Size: 0x663
	Parameters: 1
	Flags: None
*/
function state_combat_update(params)
{
	self endon("change_state");
	self endon("death");
	pathfailcount = 0;
	while(!isdefined(self.owner))
	{
		wait(0.1);
		if(!isdefined(self.owner))
		{
			self.owner = GetPlayers(self.team)[0];
		}
	}
	while(self should_go_to_owner() || (isdefined(self._glaive_must_return_to_owner) && self._glaive_must_return_to_owner))
	{
		self._glaive_must_return_to_owner = 1;
		if(!isalive(self.glaiveEnemy))
		{
			self go_to_owner();
		}
		if(self should_go_to_near_owner())
		{
			self go_to_near_owner();
		}
		else if(isdefined(self.glaiveEnemy))
		{
			foundpath = 0;
			targetPos = vehicle_ai::GetTargetPos(self.glaiveEnemy, 1);
			if(isdefined(self.glaiveEnemy.archetype) && self.glaiveEnemy.archetype == "margwa")
			{
				targetPos = self.glaiveEnemy GetTagOrigin("j_chunk_head_bone");
			}
			targetPos = targetPos + self.glaiveEnemy GetVelocity() * 0.4;
			if(isdefined(targetPos))
			{
				if(Distance2DSquared(self.origin, self.glaiveEnemy.origin) < 80 * 80)
				{
					self vehicle_ai::set_state("slash");
					break;
				}
				if(isdefined(self.owner) && self is_enemy_valid(self.glaiveEnemy) && self check_glaive_playable_area_conditions())
				{
					go_back_on_navvolume();
					queryResult = PositionQuery_Source_Navigation(targetPos, 0, 64, 64, 8, self);
					if(isdefined(self.glaiveEnemy))
					{
						PositionQuery_Filter_Sight(queryResult, targetPos, self GetEye() - self.origin, self, 0, self.glaiveEnemy);
					}
					if(isdefined(queryResult.centerOnNav) && queryResult.centerOnNav)
					{
						foreach(point in queryResult.data)
						{
							if(isdefined(point.visibility) && point.visibility)
							{
								self.current_pathto_pos = point.origin;
								foundpath = self SetVehGoalPos(self.current_pathto_pos, 1, 1);
								if(foundpath)
								{
									self ASMRequestSubstate("forward@movement");
									self util::waittill_any("near_goal", "goal");
									self ASMRequestSubstate("idle@movement");
									break;
								}
							}
						}
						break;
					}
					foreach(point in queryResult.data)
					{
						if(isdefined(point.visibility) && point.visibility)
						{
							self.current_pathto_pos = point.origin;
							foundpath = self SetVehGoalPos(self.current_pathto_pos, 1, 0);
							if(foundpath)
							{
								self ASMRequestSubstate("forward@movement");
								self util::waittill_any("near_goal", "goal");
								self ASMRequestSubstate("idle@movement");
								break;
							}
						}
					}
				}
			}
			else if(!foundpath && self is_enemy_valid(self.glaiveEnemy))
			{
				go_back_on_navvolume();
				pathfailcount++;
				if(pathfailcount > 3)
				{
					if(isdefined(self.owner))
					{
						self go_to_near_owner();
					}
				}
				wait(0.1);
			}
			else
			{
				pathfailcount = 0;
			}
		}
		wait(0.2);
	}
}

/*
	Name: check_glaive_playable_area_conditions
	Namespace: glaive
	Checksum: 0x928FA15F
	Offset: 0x1500
	Size: 0x9D
	Parameters: 0
	Flags: None
*/
function check_glaive_playable_area_conditions()
{
	if(isdefined(self.glaiveEnemy.archetype) && self.glaiveEnemy.archetype != "zombie")
	{
		return 1;
	}
	else if(isdefined(self.glaiveEnemy.archetype) && self.glaiveEnemy.archetype == "zombie" && (isdefined(self.glaiveEnemy.completed_emerging_into_playable_area) && self.glaiveEnemy.completed_emerging_into_playable_area))
	{
		return 1;
	}
	return 0;
}

/*
	Name: go_back_on_navvolume
	Namespace: glaive
	Checksum: 0xA42902E4
	Offset: 0x15A8
	Size: 0x2A3
	Parameters: 0
	Flags: None
*/
function go_back_on_navvolume()
{
	queryResult = PositionQuery_Source_Navigation(self.origin, 0, 100, 64, 8, self);
	multiplier = 2;
	while(queryResult.data.size < 1)
	{
		queryResult = PositionQuery_Source_Navigation(self.origin, 0, 100 * multiplier, 64 * multiplier, 20 * multiplier, self);
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
				self util::waittill_any("goal", "near_goal");
			}
			self SetNearGoalNotifyDist(50);
		}
	}
}

/*
	Name: chooseSwordAnim
	Namespace: glaive
	Checksum: 0xEF9A546C
	Offset: 0x1858
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function chooseSwordAnim(enemy)
{
	self endon("change_state");
	self endon("death");
	sword_anim = "o_zombie_zod_sword_projectile_melee_synced_a";
	self._glaive_linkToTag = "tag_origin";
	if(isdefined(enemy.archetype))
	{
		switch(enemy.archetype)
		{
			case "parasite":
			{
				sword_anim = "o_zombie_zod_sword_projectile_melee_parasite_synced_a";
				break;
			}
			case "raps":
			{
				sword_anim = "o_zombie_zod_sword_projectile_melee_elemental_synced_a";
				break;
			}
			case "margwa":
			{
				sword_anim = "o_zombie_zod_sword_projectile_melee_margwa_m_synced_a";
				self._glaive_linkToTag = "tag_sync";
				break;
			}
		}
	}
	return sword_anim;
}

/*
	Name: state_slash_update
	Namespace: glaive
	Checksum: 0x2BFD094C
	Offset: 0x1938
	Size: 0x46B
	Parameters: 1
	Flags: None
*/
function state_slash_update(params)
{
	self endon("change_state");
	self endon("death");
	enemy = self.glaiveEnemy;
	should_reevaluate_target = 0;
	sword_anim = self chooseSwordAnim(enemy);
	self AnimScripted("anim_notify", enemy GetTagOrigin(self._glaive_linkToTag), enemy GetTagAngles(self._glaive_linkToTag), sword_anim, "normal", undefined, undefined, 0.3, 0.3);
	self clientfield::set("glaive_blood_fx", 1);
	self waittill("ANIM_NOTIFY");
	if(isalive(enemy) && isdefined(enemy.archetype) && enemy.archetype == "margwa")
	{
		if(isdefined(enemy.chop_actor_cb))
		{
			should_reevaluate_target = 1;
			enemy._glaive_ignoreme = 1;
			enemy thread glaive_ignore_cooldown(5);
			self.owner [[enemy.chop_actor_cb]](enemy, self, self.weapon);
		}
		break;
	}
	target_enemies = GetAITeamArray("axis");
	foreach(target in target_enemies)
	{
		if(Distance2DSquared(self.origin, target.origin) < 128 * 128)
		{
			if(isdefined(target.archetype) && target.archetype == "margwa")
			{
				continue;
			}
			target DoDamage(target.health + 100, self.origin, self.owner, self, "none", "MOD_UNKNOWN", 0, self.weapon);
			self playsound("wpn_sword2_imp");
			if(IsActor(target))
			{
				target zombie_utility::gib_random_parts();
				target StartRagdoll();
				target LaunchRagdoll(100 * VectorNormalize(target.origin - self.origin));
			}
		}
	}
	self waittill("ANIM_NOTIFY", Notetrack);
	while(!isdefined(Notetrack) || Notetrack != "end")
	{
		self waittill("ANIM_NOTIFY", Notetrack);
	}
	self clientfield::set("glaive_blood_fx", 0);
	if(should_reevaluate_target)
	{
		target = get_glaive_enemy();
		self.glaiveEnemy = target;
	}
	self vehicle_ai::set_state("combat");
}

/*
	Name: glaive_ignore_cooldown
	Namespace: glaive
	Checksum: 0x3A1F0CB2
	Offset: 0x1DB0
	Size: 0x25
	Parameters: 1
	Flags: None
*/
function glaive_ignore_cooldown(duration)
{
	self endon("death");
	wait(duration);
	self._glaive_ignoreme = undefined;
}

/*
	Name: go_to_near_owner
	Namespace: glaive
	Checksum: 0x8F9968F4
	Offset: 0x1DE0
	Size: 0x3FB
	Parameters: 0
	Flags: None
*/
function go_to_near_owner()
{
	self endon("near_owner");
	self thread back_to_near_owner_check();
	startTime = GetTime();
	self ASMRequestSubstate("forward@movement");
	while(GetTime() - startTime < self._glaive_settings_lifetime * 1000 * 0.1)
	{
		go_back_on_navvolume();
		ownerTargetPos = vehicle_ai::GetTargetPos(self.owner, 1) - VectorScale((0, 0, 1), 4);
		ownerForwardVec = AnglesToForward(self.owner.angles);
		targetPos = ownerTargetPos + 80 * ownerForwardVec;
		searchCenter = self GetClosestPointOnNavVolume(ownerTargetPos);
		if(isdefined(searchCenter))
		{
			queryResult = PositionQuery_Source_Navigation(searchCenter, 0, 144, 32, 12, self);
			foundpath = 0;
			foreach(point in queryResult.data)
			{
				/#
					if(!isdefined(point._scoreDebug))
					{
						point._scoreDebug = [];
					}
					point._scoreDebug["Dev Block strings are not supported"] = DistanceSquared(point.origin, targetPos) * -1;
				#/
				point.score = point.score + DistanceSquared(point.origin, targetPos) * -1;
			}
			vehicle_ai::PositionQuery_PostProcess_SortScore(queryResult);
			self vehicle_ai::PositionQuery_DebugScores(queryResult);
			foreach(point in queryResult.data)
			{
				self.current_pathto_pos = point.origin;
				foundpath = self SetVehGoalPos(self.current_pathto_pos, 1, 1);
				if(foundpath)
				{
					break;
				}
			}
			if(!foundpath)
			{
				self.current_pathto_pos = searchCenter;
				self SetVehGoalPos(self.current_pathto_pos, 1, 1);
			}
		}
		wait(1);
	}
	self ASMRequestSubstate("idle@movement");
}

/*
	Name: go_to_owner
	Namespace: glaive
	Checksum: 0x6B31F08F
	Offset: 0x21E8
	Size: 0x363
	Parameters: 0
	Flags: None
*/
function go_to_owner()
{
	self thread back_to_owner_check();
	startTime = GetTime();
	self ASMRequestSubstate("forward@movement");
	while(GetTime() - startTime < self._glaive_settings_lifetime * 1000 * 0.3)
	{
		go_back_on_navvolume();
		targetPos = vehicle_ai::GetTargetPos(self.owner, 1);
		queryResult = PositionQuery_Source_Navigation(targetPos, 0, 64, 64, 8, self);
		foundpath = 0;
		trace_count = 0;
		foreach(point in queryResult.data)
		{
			if(SightTracePassed(self.origin, point.origin, 0, undefined))
			{
				trace_count++;
				if(trace_count > 3)
				{
					wait(0.05);
					trace_count = 0;
				}
				if(!BulletTracePassed(self.origin, point.origin, 0, self))
				{
					continue;
				}
			}
			else
			{
				continue;
			}
			self.current_pathto_pos = point.origin;
			foundpath = self SetVehGoalPos(self.current_pathto_pos, 1, 1);
			if(foundpath)
			{
				break;
			}
		}
		if(!foundpath)
		{
			foreach(point in queryResult.data)
			{
				self.current_pathto_pos = point.origin;
				foundpath = self SetVehGoalPos(self.current_pathto_pos, 1, 0);
				if(foundpath)
				{
					break;
				}
			}
		}
		wait(1);
	}
	if(isdefined(self.owner))
	{
		self.origin = self.owner.origin + VectorScale((0, 0, 1), 40);
	}
	self notify("returned_to_owner");
	wait(2);
}

/*
	Name: back_to_owner_check
	Namespace: glaive
	Checksum: 0x373944F1
	Offset: 0x2558
	Size: 0xB5
	Parameters: 0
	Flags: None
*/
function back_to_owner_check()
{
	self endon("death");
	while(isdefined(self.owner) && (Abs(self.origin[2] - self.owner.origin[2]) > 80 * 80 || Distance2DSquared(self.origin, self.owner.origin) > 80 * 80))
	{
		wait(0.1);
	}
	self notify("returned_to_owner");
}

/*
	Name: back_to_near_owner_check
	Namespace: glaive
	Checksum: 0xE937D992
	Offset: 0x2618
	Size: 0x129
	Parameters: 0
	Flags: None
*/
function back_to_near_owner_check()
{
	self endon("death");
	while(isdefined(self.owner) && (Abs(self.origin[2] - self.owner.origin[2]) > 160 * 160 || Distance2DSquared(self.origin, self.owner.origin) > 160 * 160 || !util::within_fov(self.owner.origin, self.owner.angles, self.origin, cos(60))))
	{
		wait(0.1);
	}
	self ASMRequestSubstate("idle@movement");
	self notify("near_owner");
}

/*
	Name: glaive_AllowFriendlyFireDamage
	Namespace: glaive
	Checksum: 0x72C20D9D
	Offset: 0x2750
	Size: 0x25
	Parameters: 4
	Flags: None
*/
function glaive_AllowFriendlyFireDamage(eInflictor, eAttacker, sMeansOfDeath, weapon)
{
	return 0;
}

/*
	Name: glaive_callback_damage
	Namespace: glaive
	Checksum: 0x28D9CD22
	Offset: 0x2780
	Size: 0x7F
	Parameters: 15
	Flags: None
*/
function glaive_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	return 1;
}

