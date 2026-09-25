#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace grapple;

/*
	Name: __init__sytem__
	Namespace: grapple
	Checksum: 0x5F7CF6D5
	Offset: 0x248
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("grapple", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: grapple
	Checksum: 0xD8107BE
	Offset: 0x290
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_spawned(&watch_for_grapple);
}

/*
	Name: __main__
	Namespace: grapple
	Checksum: 0x2FAFD7A3
	Offset: 0x2C0
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function __main__()
{
	grapple_targets = GetEntArray("grapple_target", "targetname");
	foreach(target in grapple_targets)
	{
		target.grapple_type = 1;
		target SetGrapplableType(target.grapple_type);
	}
}

/*
	Name: translate_notify_1
	Namespace: grapple
	Checksum: 0x9CFDDFE
	Offset: 0x3A0
	Size: 0x89
	Parameters: 2
	Flags: None
*/
function translate_notify_1(from_notify, to_notify)
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned_player");
	while(isdefined(self))
	{
		self waittill(from_notify, param1, param2, param3);
		self notify(to_notify, from_notify, param1, param2, param3);
	}
}

/*
	Name: watch_for_grapple
	Namespace: grapple
	Checksum: 0xB9EDC697
	Offset: 0x438
	Size: 0xF9
	Parameters: 0
	Flags: None
*/
function watch_for_grapple()
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned_player");
	self endon("killReplayGunMonitor");
	self thread translate_notify_1("weapon_switch_started", "grapple_weapon_change");
	self thread translate_notify_1("weapon_change_complete", "grapple_weapon_change");
	while(1)
	{
		self waittill("hash_17cf4048", event, weapon);
		if(isdefined(weapon.grappleWeapon) && weapon.grappleWeapon)
		{
			self thread watch_lockon(weapon);
		}
		else
		{
			self notify("grapple_unwield");
		}
	}
}

/*
	Name: watch_lockon
	Namespace: grapple
	Checksum: 0x6FB44EAD
	Offset: 0x540
	Size: 0x13B
	Parameters: 1
	Flags: None
*/
function watch_lockon(weapon)
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned_player");
	self endon("grapple_unwield");
	self notify("watch_lockon");
	self endon("watch_lockon");
	self thread watch_lockon_angles(weapon);
	self thread clear_lockon_after_grapple(weapon);
	self.use_expensive_targeting = 1;
	while(1)
	{
		wait(0.05);
		if(!self IsGrappling())
		{
			target = self get_a_target(weapon);
			if(!self IsGrappling() && !target === self.lockonentity)
			{
				self WeaponLockNoClearance(!target === self.dummy_target);
				self.lockonentity = target;
				wait(0.1);
			}
		}
	}
}

/*
	Name: clear_lockon_after_grapple
	Namespace: grapple
	Checksum: 0xC1854E2F
	Offset: 0x688
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function clear_lockon_after_grapple(weapon)
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned_player");
	self endon("grapple_unwield");
	self notify("clear_lockon_after_grapple");
	self endon("clear_lockon_after_grapple");
	while(1)
	{
		self util::waittill_any("grapple_pulled", "grapple_landed");
		if(isdefined(self.lockonentity))
		{
			self.lockonentity = undefined;
			self.use_expensive_targeting = 1;
		}
	}
}

/*
	Name: watch_lockon_angles
	Namespace: grapple
	Checksum: 0x614C00DF
	Offset: 0x738
	Size: 0x12F
	Parameters: 1
	Flags: None
*/
function watch_lockon_angles(weapon)
{
	self endon("disconnect");
	self endon("death");
	self endon("spawned_player");
	self endon("grapple_unwield");
	self notify("watch_lockon_angles");
	self endon("watch_lockon_angles");
	while(1)
	{
		wait(0.05);
		if(!self IsGrappling())
		{
			if(isdefined(self.lockonentity))
			{
				if(self.lockonentity === self.dummy_target)
				{
					self weaponlocktargettooclose(0);
				}
				else
				{
					testOrigin = get_target_lock_on_origin(self.lockonentity);
					if(!self inside_screen_angles(testOrigin, weapon, 0))
					{
						self weaponlocktargettooclose(1);
					}
					else
					{
						self weaponlocktargettooclose(0);
					}
				}
			}
		}
	}
}

/*
	Name: place_dummy_target
	Namespace: grapple
	Checksum: 0xC3F53AC0
	Offset: 0x870
	Size: 0x185
	Parameters: 3
	Flags: None
*/
function place_dummy_target(origin, FORWARD, weapon)
{
	if(!isdefined(self.dummy_target))
	{
		self.dummy_target = spawn("script_origin", origin);
	}
	self.dummy_target SetGrapplableType(3);
	start = origin;
	Distance = weapon.lockOnMaxRange * 0.9;
	if(isdefined(level.grapple_notarget_distance))
	{
		Distance = level.grapple_notarget_distance;
	}
	end = origin + FORWARD * Distance;
	if(!self IsGrappling())
	{
		self.dummy_target.origin = self trace(start, end, self.dummy_target);
	}
	minrange_sq = weapon.lockOnMinRange * weapon.lockOnMinRange;
	if(DistanceSquared(self.dummy_target.origin, origin) < minrange_sq)
	{
		return undefined;
	}
	return self.dummy_target;
}

/*
	Name: get_a_target
	Namespace: grapple
	Checksum: 0xB795839B
	Offset: 0xA00
	Size: 0x3CB
	Parameters: 1
	Flags: None
*/
function get_a_target(weapon)
{
	origin = self GetEye();
	FORWARD = self GetWeaponForwardDir();
	targets = GetGrappleTargetArray();
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
	should_wait_limit = 2;
	if(isdefined(self.use_expensive_targeting) && self.use_expensive_targeting)
	{
		should_wait_limit = 4;
		self.use_expensive_targeting = 0;
	}
	for(i = 0; i < targets.size; i++)
	{
		if(should_wait >= should_wait_limit)
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
		if(!self inside_screen_angles(testOrigin, weapon, !testTarget === self.lockonentity))
		{
			continue;
		}
		cansee = self can_see(testTarget, testOrigin, origin, FORWARD, 30);
		should_wait++;
		if(cansee)
		{
			validTargets[validTargets.size] = testTarget;
		}
	}
	best = pick_a_target_from(validTargets, origin, FORWARD, weapon.lockOnMinRange, weapon.lockOnMaxRange);
	if(isdefined(level.grapple_notarget_enabled) && level.grapple_notarget_enabled)
	{
		if(!isdefined(best) || best === self.dummy_target)
		{
			best = place_dummy_target(origin, FORWARD, weapon);
		}
	}
	return best;
}

/*
	Name: get_target_type_score
	Namespace: grapple
	Checksum: 0x8CAA6854
	Offset: 0xDD8
	Size: 0xA9
	Parameters: 1
	Flags: None
*/
function get_target_type_score(target)
{
	if(!isdefined(target))
	{
		return 0;
	}
	if(target === self.dummy_target)
	{
		return 0;
	}
	if(target.grapple_type === 1)
	{
		return 1;
	}
	if(target.grapple_type === 2)
	{
		return 0.985;
	}
	if(!isdefined(target.grapple_type))
	{
		return 0.9;
	}
	if(target.grapple_type === 3)
	{
		return 0.75;
	}
	return 0;
}

/*
	Name: get_target_score
	Namespace: grapple
	Checksum: 0xD1C3B9C
	Offset: 0xE90
	Size: 0x199
	Parameters: 5
	Flags: None
*/
function get_target_score(target, origin, FORWARD, min_range, max_range)
{
	if(!isdefined(target))
	{
		return -1;
	}
	if(target === self.dummy_target)
	{
		return 0;
	}
	if(is_valid_target(target))
	{
		testOrigin = get_target_lock_on_origin(target);
		normal = VectorNormalize(testOrigin - origin);
		dot = VectorDot(FORWARD, normal);
		targetDistance = Distance(self.origin, testOrigin);
		distance_score = 1 - targetDistance - min_range / max_range - min_range;
		type_score = get_target_type_score(target);
		return type_score * pow(dot, 0.85) * pow(distance_score, 0.15);
	}
	return -1;
}

/*
	Name: pick_a_target_from
	Namespace: grapple
	Checksum: 0x86DBDECB
	Offset: 0x1038
	Size: 0x13F
	Parameters: 5
	Flags: None
*/
function pick_a_target_from(targets, origin, FORWARD, min_range, max_range)
{
	if(!isdefined(targets))
	{
		return undefined;
	}
	bestTarget = undefined;
	bestScore = undefined;
	for(i = 0; i < targets.size; i++)
	{
		target = targets[i];
		if(is_valid_target(target))
		{
			score = get_target_score(target, origin, FORWARD, min_range, max_range);
			if(!isdefined(bestTarget) || !isdefined(bestScore))
			{
				bestTarget = target;
				bestScore = score;
				continue;
			}
			if(score > bestScore)
			{
				bestTarget = target;
				bestScore = score;
			}
		}
	}
	return bestTarget;
}

/*
	Name: trace
	Namespace: grapple
	Checksum: 0x1AEBF85A
	Offset: 0x1180
	Size: 0x5B
	Parameters: 3
	Flags: None
*/
function trace(from, to, target)
{
	trace = bullettrace(from, to, 0, self, 1, 0, target);
	return trace["position"];
}

/*
	Name: can_see
	Namespace: grapple
	Checksum: 0x2FE8A7C0
	Offset: 0x11E8
	Size: 0x177
	Parameters: 5
	Flags: None
*/
function can_see(target, target_origin, player_origin, player_forward, Distance)
{
	start = player_origin + player_forward * Distance;
	end = target_origin - player_forward * Distance;
	collided = self trace(start, end, target);
	if(Distance2DSquared(end, collided) > 9)
	{
		/#
			if(GetDvarInt("Dev Block strings are not supported"))
			{
				line(start, collided, (0, 0, 1), 1, 0, 50);
				line(collided, end, (1, 0, 0), 1, 0, 50);
			}
		#/
		return 0;
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported"))
		{
			line(start, end, (0, 1, 0), 1, 0, 30);
		}
	#/
	return 1;
}

/*
	Name: is_valid_target
	Namespace: grapple
	Checksum: 0x63620F01
	Offset: 0x1368
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function is_valid_target(ent)
{
	if(isdefined(ent) && isdefined(level.grapple_valid_target_check))
	{
		if(![[level.grapple_valid_target_check]](ent))
		{
			return 0;
		}
	}
	return isdefined(ent) && (isalive(ent) || !IsSentient(ent));
}

/*
	Name: inside_screen_angles
	Namespace: grapple
	Checksum: 0x15DEAB00
	Offset: 0x13E8
	Size: 0xF7
	Parameters: 3
	Flags: None
*/
function inside_screen_angles(testOrigin, weapon, newTarget)
{
	hang = weapon.lockonlossanglehorizontal;
	if(newTarget)
	{
		hang = weapon.lockonanglehorizontal;
	}
	vang = weapon.lockonlossanglevertical;
	if(newTarget)
	{
		vang = weapon.lockonanglevertical;
	}
	angles = self GetTargetScreenAngles(testOrigin);
	return Abs(angles[0]) < hang && Abs(angles[1]) < vang;
}

/*
	Name: inside_screen_crosshair_radius
	Namespace: grapple
	Checksum: 0xEF02A434
	Offset: 0x14E8
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
	Namespace: grapple
	Checksum: 0x3F7329BE
	Offset: 0x1540
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
	Namespace: grapple
	Checksum: 0x3759731A
	Offset: 0x1598
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
	Namespace: grapple
	Checksum: 0x36EF5584
	Offset: 0x15E0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_target_lock_on_origin(target)
{
	return self GetLockOnOrigin(target);
}

