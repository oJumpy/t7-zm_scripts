#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace replay_gun;

/*
	Name: __init__sytem__
	Namespace: replay_gun
	Checksum: 0xE680F5DB
	Offset: 0x1D0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("replay_gun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: replay_gun
	Checksum: 0x8AE866DD
	Offset: 0x210
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_spawned(&watch_for_replay_gun);
}

/*
	Name: watch_for_replay_gun
	Namespace: replay_gun
	Checksum: 0xDD7341A9
	Offset: 0x240
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function watch_for_replay_gun()
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned_player");
	self endon("killReplayGunMonitor");
	while(1)
	{
		self waittill("weapon_change_complete", weapon);
		self WeaponLockFree();
		if(isdefined(weapon.usesPivotTargeting) && weapon.usesPivotTargeting)
		{
			self thread watch_lockon(weapon);
		}
	}
}

/*
	Name: watch_lockon
	Namespace: replay_gun
	Checksum: 0x7B092F85
	Offset: 0x2F8
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function watch_lockon(weapon)
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned_player");
	self endon("weapon_change_complete");
	while(1)
	{
		wait(0.05);
		if(!isdefined(self.lockonentity))
		{
			ADS = self PlayerAds() == 1;
			if(ADS)
			{
				target = self get_a_target(weapon);
				if(is_valid_target(target))
				{
					self WeaponLockFree();
					self.lockonentity = target;
				}
			}
		}
	}
}

/*
	Name: get_a_target
	Namespace: replay_gun
	Checksum: 0x411A8683
	Offset: 0x3F0
	Size: 0x2E9
	Parameters: 1
	Flags: None
*/
function get_a_target(weapon)
{
	origin = self GetWeaponMuzzlePoint();
	FORWARD = self GetWeaponForwardDir();
	targets = self get_potential_targets();
	if(!isdefined(targets))
	{
		return undefined;
	}
	if(!isdefined(weapon.lockOnScreenRadius) || weapon.lockOnScreenRadius < 1)
	{
		return undefined;
	}
	validTargets = [];
	should_wait = 0;
	for(i = 0; i < targets.size; i++)
	{
		if(should_wait)
		{
			wait(0.05);
			origin = self GetWeaponMuzzlePoint();
			FORWARD = self GetWeaponForwardDir();
			should_wait = 0;
		}
		testTarget = targets[i];
		if(!is_valid_target(testTarget))
		{
			continue;
		}
		testOrigin = get_target_lock_on_origin(testTarget);
		test_range = Distance(origin, testOrigin);
		if(test_range > weapon.lockOnMaxRange || test_range < weapon.lockOnMinRange)
		{
			continue;
		}
		normal = VectorNormalize(testOrigin - origin);
		dot = VectorDot(FORWARD, normal);
		if(0 > dot)
		{
			continue;
		}
		if(!self inside_screen_crosshair_radius(testOrigin, weapon))
		{
			continue;
		}
		cansee = self can_see_projected_crosshair(testTarget, testOrigin, origin, FORWARD, test_range);
		should_wait = 1;
		if(cansee)
		{
			validTargets[validTargets.size] = testTarget;
		}
	}
	return pick_a_target_from(validTargets);
}

/*
	Name: get_potential_targets
	Namespace: replay_gun
	Checksum: 0xEF543EE7
	Offset: 0x6E8
	Size: 0xFD
	Parameters: 0
	Flags: None
*/
function get_potential_targets()
{
	str_opposite_team = "axis";
	if(self.team == "axis")
	{
		str_opposite_team = "allies";
	}
	potentialTargets = [];
	aiTargets = GetAITeamArray(str_opposite_team);
	if(aiTargets.size > 0)
	{
		potentialTargets = ArrayCombine(potentialTargets, aiTargets, 1, 0);
	}
	playerTargets = self GetEnemies();
	if(playerTargets.size > 0)
	{
		potentialTargets = ArrayCombine(potentialTargets, playerTargets, 1, 0);
	}
	if(potentialTargets.size == 0)
	{
		return undefined;
	}
	return potentialTargets;
}

/*
	Name: pick_a_target_from
	Namespace: replay_gun
	Checksum: 0x3E45CF2B
	Offset: 0x7F0
	Size: 0x11F
	Parameters: 1
	Flags: None
*/
function pick_a_target_from(targets)
{
	if(!isdefined(targets))
	{
		return undefined;
	}
	bestTarget = undefined;
	bestTargetDistanceSquared = undefined;
	for(i = 0; i < targets.size; i++)
	{
		target = targets[i];
		if(is_valid_target(target))
		{
			targetDistanceSquared = DistanceSquared(self.origin, target.origin);
			if(!isdefined(bestTarget) || !isdefined(bestTargetDistanceSquared))
			{
				bestTarget = target;
				bestTargetDistanceSquared = targetDistanceSquared;
				continue;
			}
			if(targetDistanceSquared < bestTargetDistanceSquared)
			{
				bestTarget = target;
				bestTargetDistanceSquared = targetDistanceSquared;
			}
		}
	}
	return bestTarget;
}

/*
	Name: trace
	Namespace: replay_gun
	Checksum: 0xDE141C1C
	Offset: 0x918
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function trace(from, to)
{
	return bullettrace(from, to, 0, self)["position"];
}

/*
	Name: can_see_projected_crosshair
	Namespace: replay_gun
	Checksum: 0x99EBE69D
	Offset: 0x960
	Size: 0xEB
	Parameters: 5
	Flags: None
*/
function can_see_projected_crosshair(target, target_origin, player_origin, player_forward, Distance)
{
	crosshair = player_origin + player_forward * Distance;
	collided = target trace(target_origin, crosshair);
	if(Distance2DSquared(crosshair, collided) > 9)
	{
		return 0;
	}
	collided = self trace(player_origin, crosshair);
	if(Distance2DSquared(crosshair, collided) > 9)
	{
		return 0;
	}
	return 1;
}

/*
	Name: is_valid_target
	Namespace: replay_gun
	Checksum: 0xE3D519D4
	Offset: 0xA58
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function is_valid_target(ent)
{
	return isdefined(ent) && isalive(ent);
}

/*
	Name: inside_screen_crosshair_radius
	Namespace: replay_gun
	Checksum: 0x2857B355
	Offset: 0xA90
	Size: 0x49
	Parameters: 2
	Flags: None
*/
function inside_screen_crosshair_radius(testOrigin, weapon)
{
	radius = weapon.lockOnScreenRadius;
	return self inside_screen_radius(testOrigin, radius);
}

/*
	Name: inside_screen_lockon_radius
	Namespace: replay_gun
	Checksum: 0xC419F5BE
	Offset: 0xAE8
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function inside_screen_lockon_radius(targetOrigin)
{
	radius = self getLockOnRadius();
	return self inside_screen_radius(targetOrigin, radius);
}

/*
	Name: inside_screen_radius
	Namespace: replay_gun
	Checksum: 0x3321CBA0
	Offset: 0xB40
	Size: 0x39
	Parameters: 2
	Flags: None
*/
function inside_screen_radius(targetOrigin, radius)
{
	return Target_OriginIsInCircle(targetOrigin, self, 65, radius);
}

/*
	Name: get_target_lock_on_origin
	Namespace: replay_gun
	Checksum: 0xDA063C6E
	Offset: 0xB88
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_target_lock_on_origin(target)
{
	return self GetReplayGunLockOnOrigin(target);
}

