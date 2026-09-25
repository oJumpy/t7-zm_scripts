#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace vehicle_ai;

/*
	Name: __init__sytem__
	Namespace: vehicle_ai
	Checksum: 0x22A80DD0
	Offset: 0x488
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicle_ai", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: vehicle_ai
	Checksum: 0x99EC1590
	Offset: 0x4C8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: RegisterSharedInterfaceAttributes
	Namespace: vehicle_ai
	Checksum: 0xC63DF162
	Offset: 0x4D8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function RegisterSharedInterfaceAttributes(archetype)
{
	ai::RegisterMatchedInterface(archetype, "force_high_speed", 0, Array(1, 0));
}

/*
	Name: InitThreatBias
	Namespace: vehicle_ai
	Checksum: 0x2BC4137E
	Offset: 0x520
	Size: 0x121
	Parameters: 0
	Flags: None
*/
function InitThreatBias()
{
	aiArray = GetAIArray();
	foreach(ai in aiArray)
	{
		if(ai === self)
		{
			continue;
		}
		if(self.ignoreFireFly === 1 && ai.var_fb7ac308 === 1)
		{
			self function_cceed911(ai);
		}
		if(self.ignoreDecoy === 1 && ai.var_e42818a3 === 1)
		{
			self function_cceed911(ai);
		}
	}
}

/*
	Name: EntityIsArchetype
	Namespace: vehicle_ai
	Checksum: 0xF05386D0
	Offset: 0x650
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function EntityIsArchetype(entity, archetype)
{
	if(!isdefined(entity))
	{
		return 0;
	}
	if(isPlayer(entity) && entity.usingvehicle && isdefined(entity.viewlockedentity) && entity.viewlockedentity.archetype === archetype)
	{
		return 1;
	}
	if(isVehicle(entity) && entity.archetype === archetype)
	{
		return 1;
	}
	return 0;
}

/*
	Name: GetEnemyTarget
	Namespace: vehicle_ai
	Checksum: 0xBC86BBE7
	Offset: 0x718
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function GetEnemyTarget()
{
	if(isdefined(self.enemy) && self VehCanSee(self.enemy))
	{
		return self.enemy;
	}
	else if(isdefined(self.var_676045bc))
	{
		return self.var_676045bc;
	}
	return undefined;
}

/*
	Name: GetTargetPos
	Namespace: vehicle_ai
	Checksum: 0x84CD94CD
	Offset: 0x778
	Size: 0x113
	Parameters: 2
	Flags: None
*/
function GetTargetPos(target, GetEye)
{
	pos = undefined;
	if(isdefined(target))
	{
		if(IsVec(target))
		{
			pos = target;
		}
		else if(isdefined(GetEye) && GetEye && IsSentient(target))
		{
			pos = target GetEye();
		}
		else if(IsEntity(target))
		{
			pos = target.origin;
		}
		else if(isdefined(target.origin) && IsVec(target.origin))
		{
			pos = target.origin;
		}
	}
	return pos;
}

/*
	Name: GetTargetEyeOffset
	Namespace: vehicle_ai
	Checksum: 0xB111546E
	Offset: 0x898
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function GetTargetEyeOffset(target)
{
	offset = (0, 0, 0);
	if(isdefined(target) && IsSentient(target))
	{
		offset = target GetEye() - target.origin;
	}
	return offset;
}

/*
	Name: fire_for_time
	Namespace: vehicle_ai
	Checksum: 0x2F425E0E
	Offset: 0x910
	Size: 0x173
	Parameters: 4
	Flags: None
*/
function fire_for_time(totalFireTime, turretIdx, target, var_d8dce884)
{
	if(!isdefined(var_d8dce884))
	{
		var_d8dce884 = 1;
	}
	self endon("death");
	self endon("change_state");
	self notify("fire_stop");
	self endon("fire_stop");
	if(!isdefined(turretIdx))
	{
		turretIdx = 0;
	}
	weapon = self SeatGetWeapon(turretIdx);
	/#
		Assert(isdefined(weapon) && weapon.name != "Dev Block strings are not supported" && weapon.fireTime > 0);
	#/
	fireTime = weapon.fireTime * var_d8dce884;
	fireCount = Int(floor(totalFireTime / fireTime)) + 1;
	function_59f83de7(fireCount, fireTime, turretIdx, target);
}

/*
	Name: fire_for_rounds
	Namespace: vehicle_ai
	Checksum: 0xA4FCCB6E
	Offset: 0xA90
	Size: 0xEB
	Parameters: 3
	Flags: None
*/
function fire_for_rounds(fireCount, turretIdx, target)
{
	self endon("death");
	self endon("fire_stop");
	self endon("change_state");
	if(!isdefined(turretIdx))
	{
		turretIdx = 0;
	}
	weapon = self SeatGetWeapon(turretIdx);
	/#
		Assert(isdefined(weapon) && weapon.name != "Dev Block strings are not supported" && weapon.fireTime > 0);
	#/
	function_59f83de7(fireCount, weapon.fireTime, turretIdx, target);
}

/*
	Name: function_59f83de7
	Namespace: vehicle_ai
	Checksum: 0x62DD2D6C
	Offset: 0xB88
	Size: 0x21B
	Parameters: 4
	Flags: None
*/
function function_59f83de7(fireCount, var_82d8b276, turretIdx, target)
{
	self endon("death");
	self endon("fire_stop");
	self endon("change_state");
	if(isdefined(target) && IsSentient(target))
	{
		target endon("death");
	}
	/#
		Assert(isdefined(turretIdx));
	#/
	aiFireChance = 1;
	if(isdefined(target) && !isPlayer(target) && isai(target) || isdefined(self.fire_half_blanks))
	{
		aiFireChance = 2;
	}
	counter = 0;
	while(counter < fireCount)
	{
		if(self.avoid_shooting_owner === 1 && self owner_in_line_of_fire())
		{
			wait(var_82d8b276);
			continue;
		}
		if(isdefined(target) && !IsVec(target) && isdefined(target.attackerAccuracy) && target.attackerAccuracy == 0)
		{
			self fireturret(turretIdx, 1);
		}
		else if(aiFireChance > 1)
		{
			self fireturret(turretIdx, counter % aiFireChance);
		}
		else
		{
			self fireturret(turretIdx);
		}
		counter++;
		wait(var_82d8b276);
	}
}

/*
	Name: owner_in_line_of_fire
	Namespace: vehicle_ai
	Checksum: 0x41604A55
	Offset: 0xDB0
	Size: 0x129
	Parameters: 0
	Flags: None
*/
function owner_in_line_of_fire()
{
	if(!isdefined(self.owner))
	{
		return 0;
	}
	var_ac8491f5 = DistanceSquared(self.owner.origin, self.origin);
	if(var_ac8491f5 < 9216)
	{
	}
	else
	{
	}
	var_1c5b81ec = 0.9848;
	if(isdefined(self.avoid_shooting_owner_ref_tag))
	{
	}
	else
	{
	}
	var_4723fbc4 = self GetTagAngles("tag_flash");
	gun_forward = AnglesToForward(var_4723fbc4);
	dot = VectorDot(gun_forward, VectorNormalize(self.owner.origin - self.origin));
	return dot > var_1c5b81ec;
}

/*
	Name: SetTurretTarget
	Namespace: vehicle_ai
	Checksum: 0xDB976140
	Offset: 0xEE8
	Size: 0x14B
	Parameters: 3
	Flags: None
*/
function SetTurretTarget(target, turretIdx, offset)
{
	if(!isdefined(turretIdx))
	{
		turretIdx = 0;
	}
	if(!isdefined(offset))
	{
		offset = (0, 0, 0);
	}
	if(IsEntity(target))
	{
		if(turretIdx == 0)
		{
			self SetTurretTargetEnt(target, offset);
		}
		else
		{
			self setGunnerTargetEnt(target, offset, turretIdx - 1);
		}
	}
	else if(IsVec(target))
	{
		origin = target + offset;
		if(turretIdx == 0)
		{
			self SetTurretTargetVec(target);
		}
		else
		{
			self SetGunnerTargetVec(target, turretIdx - 1);
		}
	}
	else
	{
		ASSERTMSG("Dev Block strings are not supported");
	}
	/#
	#/
}

/*
	Name: fireturret
	Namespace: vehicle_ai
	Checksum: 0x27DEB27D
	Offset: 0x1040
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function fireturret(turretIdx, var_2b904ac6)
{
	self FireWeapon(turretIdx, undefined, undefined, self);
}

/*
	Name: Javelin_LoseTargetAtRightTime
	Namespace: vehicle_ai
	Checksum: 0x695829D9
	Offset: 0x1080
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function Javelin_LoseTargetAtRightTime(target)
{
	self endon("death");
	self waittill("weapon_fired", proj);
	if(!isdefined(proj))
	{
		return;
	}
	proj endon("death");
	wait(2);
	while(isdefined(target))
	{
		if(proj GetVelocity()[2] < -150 && DistanceSquared(proj.origin, target.origin) < 1200 * 1200)
		{
			proj Missile_SetTarget(undefined);
			break;
		}
		wait(0.1);
	}
}

/*
	Name: waittill_pathing_done
	Namespace: vehicle_ai
	Checksum: 0xD130444C
	Offset: 0x1170
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function waittill_pathing_done(maxTime)
{
	if(!isdefined(maxTime))
	{
		maxTime = 15;
	}
	self endon("change_state");
	self util::waittill_any_ex(maxTime, "near_goal", "force_goal", "reached_end_node", "goal", "pathfind_failed", "change_state");
}

/*
	Name: waittill_pathresult
	Namespace: vehicle_ai
	Checksum: 0x2F53DE23
	Offset: 0x11F0
	Size: 0x85
	Parameters: 1
	Flags: None
*/
function waittill_pathresult(maxTime)
{
	if(!isdefined(maxTime))
	{
		maxTime = 0.5;
	}
	self endon("change_state");
	result = self util::waittill_any_timeout(maxTime, "pathfind_failed", "pathfind_succeeded", "change_state");
	succeeded = result === "pathfind_succeeded";
	return succeeded;
}

/*
	Name: function_4134aafd
	Namespace: vehicle_ai
	Checksum: 0x99E99FB8
	Offset: 0x1280
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function function_4134aafd()
{
	self endon("death");
	self notify("hash_e8f330bf");
	self endon("hash_e8f330bf");
	self waittill("hash_1ae8bd76");
	self notify("hash_6f82574c", "__terminated__");
}

/*
	Name: function_9dfad743
	Namespace: vehicle_ai
	Checksum: 0x8E8CB833
	Offset: 0x12D8
	Size: 0x49
	Parameters: 1
	Flags: None
*/
function function_9dfad743(timeout)
{
	self endon("death");
	self notify("hash_f3b632f7");
	self endon("hash_f3b632f7");
	wait(timeout);
	self notify("hash_6f82574c", "__timeout__");
}

/*
	Name: waittill_asm_complete
	Namespace: vehicle_ai
	Checksum: 0x5301D55D
	Offset: 0x1330
	Size: 0xD5
	Parameters: 2
	Flags: None
*/
function waittill_asm_complete(var_147c7cd8, timeout)
{
	if(!isdefined(timeout))
	{
		timeout = 10;
	}
	self endon("death");
	self thread function_4134aafd();
	self thread function_9dfad743(timeout);
	substate = undefined;
	while(!isdefined(substate) || (substate != var_147c7cd8 && substate != "__terminated__" && substate != "__timeout__"))
	{
		self waittill("hash_6f82574c", substate);
	}
	self notify("hash_e8f330bf");
	self notify("hash_f3b632f7");
}

/*
	Name: throw_off_balance
	Namespace: vehicle_ai
	Checksum: 0xA47B5BCB
	Offset: 0x1410
	Size: 0x1E3
	Parameters: 4
	Flags: None
*/
function throw_off_balance(damageType, hitPoint, hitDirection, hitLocationInfo)
{
	if(damageType == "MOD_EXPLOSIVE" || damageType == "MOD_GRENADE_SPLASH" || damageType == "MOD_PROJECTILE_SPLASH")
	{
		self SetVehVelocity(self.velocity + VectorNormalize(hitDirection) * 300);
		ang_vel = self GetAngularVelocity();
		ang_vel = ang_vel + (RandomFloatRange(-300, 300), RandomFloatRange(-300, 300), RandomFloatRange(-300, 300));
		self SetAngularVelocity(ang_vel);
	}
	else
	{
		ang_vel = self GetAngularVelocity();
		yaw_vel = RandomFloatRange(-320, 320);
		yaw_vel = yaw_vel + math::sign(yaw_vel) * 150;
		ang_vel = ang_vel + (RandomFloatRange(-150, 150), yaw_vel, RandomFloatRange(-150, 150));
		self SetAngularVelocity(ang_vel);
	}
}

/*
	Name: function_53d45756
	Namespace: vehicle_ai
	Checksum: 0xE005A867
	Offset: 0x1600
	Size: 0x79
	Parameters: 0
	Flags: None
*/
function function_53d45756()
{
	self endon("crash_done");
	self endon("death");
	while(1)
	{
		self waittill("veh_predictedcollision", velocity, normal);
		if(normal[2] >= 0.6)
		{
			self notify("veh_collision", velocity, normal);
		}
	}
}

/*
	Name: collision_fx
	Namespace: vehicle_ai
	Checksum: 0xED4A3458
	Offset: 0x1688
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function collision_fx()
{
System.InvalidOperationException: Stack empty.
   at System.ThrowHelper.ThrowInvalidOperationException(ExceptionResource resource)
   at System.Collections.Generic.Stack`1.Pop()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‌‏‪‍⁫‮⁮‫‍‬⁯⁮⁮‏‬‪‎‎‍⁪‮⁪‬‬⁪⁭‮‫‭⁮‮‫‭‫‏‭‫‪⁪‪‮(⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ , Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: nudge_collision
	Namespace: vehicle_ai
	Checksum: 0x65F8C6EB
	Offset: 0x1710
	Size: 0x3CD
	Parameters: 0
	Flags: None
*/
function nudge_collision()
{
	self endon("crash_done");
	self endon("hash_5060be39");
	self endon("death");
	self notify("end_nudge_collision");
	self endon("end_nudge_collision");
	if(self.notsolid === 1)
	{
		return;
	}
	while(1)
	{
		self waittill("veh_collision", velocity, normal);
		ang_vel = self GetAngularVelocity() * 0.5;
		self SetAngularVelocity(ang_vel);
		var_668a05dc = self get_current_state() === "emped" || self get_current_state() === "off";
		if(isalive(self) && (normal[2] < 0.6 || !var_668a05dc))
		{
			self SetVehVelocity(self.velocity + normal * 90);
			self collision_fx(normal);
		}
		else if(var_668a05dc)
		{
			if(isdefined(self.bounced))
			{
				self playsound("veh_wasp_wall_imp");
				self SetVehVelocity((0, 0, 0));
				self SetAngularVelocity((0, 0, 0));
				pitch = self.angles[0];
				pitch = math::sign(pitch) * math::clamp(Abs(pitch), 10, 15);
				self.angles = (pitch, self.angles[1], self.angles[2]);
				self.bounced = undefined;
				self notify("landed");
				return;
			}
			else
			{
				self.bounced = 1;
				self SetVehVelocity(self.velocity + normal * 30);
				self collision_fx(normal);
			}
		}
		else
		{
			impact_vel = Abs(VectorDot(velocity, normal));
			if(normal[2] < 0.6 && impact_vel < 100)
			{
				self SetVehVelocity(self.velocity + normal * 90);
				self collision_fx(normal);
			}
			else
			{
				self playsound("veh_wasp_ground_death");
				self thread vehicle_death::death_fire_loop_audio();
				self notify("crash_done");
			}
		}
	}
}

/*
	Name: function_cfb0d8c8
	Namespace: vehicle_ai
	Checksum: 0xC717CF64
	Offset: 0x1AE8
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function function_cfb0d8c8()
{
	self endon("death");
	self endon("change_state");
	self endon("landed");
	while(1)
	{
		velocity = self.velocity;
		self.angles = (self.angles[0] * 0.85, self.angles[1], self.angles[2] * 0.85);
		ang_vel = self GetAngularVelocity() * 0.85;
		self SetAngularVelocity(ang_vel);
		self SetVehVelocity(velocity + VectorScale((0, 0, -1), 60));
		wait(0.05);
	}
}

/*
	Name: function_587b6deb
	Namespace: vehicle_ai
	Checksum: 0x2714A9F2
	Offset: 0x1BF0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_587b6deb(attacker)
{
	self endon("death");
	self thread burning_thread(attacker, attacker);
}

/*
	Name: burning_thread
	Namespace: vehicle_ai
	Checksum: 0x5D375F20
	Offset: 0x1C30
	Size: 0x2A3
	Parameters: 2
	Flags: None
*/
function burning_thread(attacker, inflictor)
{
	self endon("death");
	self notify("hash_893fbbb3");
	self endon("hash_893fbbb3");
	var_31da22cf = self.settings.var_4bef48f3;
	if(!isdefined(var_31da22cf) || var_31da22cf <= 0)
	{
		return;
	}
	var_a44a0b04 = 1 / float(var_31da22cf);
	if(!isdefined(self.abnormal_status))
	{
		self.abnormal_status = spawnstruct();
	}
	if(self.abnormal_status.burning !== 1)
	{
		self vehicle::toggle_burn_fx(1);
	}
	self.abnormal_status.burning = 1;
	self.abnormal_status.attacker = attacker;
	self.abnormal_status.inflictor = inflictor;
	var_bb7cd140 = self.settings.var_f2363474;
	if(!isdefined(var_bb7cd140))
	{
		var_bb7cd140 = 999999;
	}
	startTime = GetTime();
	interval = max(var_a44a0b04, 0.5);
	damage = 0;
	while(TimeSince(startTime) < var_bb7cd140)
	{
		var_590b95c9 = GetTime();
		wait(interval);
		damage = damage + TimeSince(var_590b95c9) * var_31da22cf;
		var_192b133d = Int(damage);
		self DoDamage(var_192b133d, self.origin, attacker, self, "none", "MOD_BURNED");
		damage = damage - var_192b133d;
	}
	self.abnormal_status.burning = 0;
	self vehicle::toggle_burn_fx(0);
}

/*
	Name: function_e26f0e60
	Namespace: vehicle_ai
	Checksum: 0xA0435258
	Offset: 0x1EE0
	Size: 0x2D
	Parameters: 2
	Flags: None
*/
function function_e26f0e60(time, note)
{
	self endon("death");
	wait(time);
	self notify(note);
}

/*
	Name: iff_override
	Namespace: vehicle_ai
	Checksum: 0x4EF27CD4
	Offset: 0x1F18
	Size: 0x1E3
	Parameters: 2
	Flags: None
*/
function iff_override(owner, time)
{
	if(!isdefined(time))
	{
		time = 60;
	}
	self endon("death");
	self.var_f3402890 = self.team;
	self function_a3ebd0f(owner.team);
	if(isdefined(self.var_7be9baa7))
	{
		self [[self.var_7be9baa7]](1);
	}
	if(isdefined(self.settings) && (!isdefined(self.settings.var_bf04419a) && self.settings.var_bf04419a))
	{
		return;
	}
	if(isdefined(self.settings))
	{
	}
	else
	{
	}
	timeout = time;
	/#
		Assert(timeout > 10);
	#/
	self thread function_e26f0e60(timeout - 10, "iff_override_revert_warn");
	msg = self util::waittill_any_timeout(timeout, "iff_override_reverted", "death");
	if(msg == "timeout")
	{
		self notify("hash_6eb14bb1", self.settings.var_86098f42);
	}
	self playsound("gdt_iff_deactivate");
	self function_a3ebd0f(self.var_f3402890);
	if(isdefined(self.var_7be9baa7))
	{
		self [[self.var_7be9baa7]](0);
	}
}

/*
	Name: function_a3ebd0f
	Namespace: vehicle_ai
	Checksum: 0xA9B1A471
	Offset: 0x2108
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function function_a3ebd0f(team)
{
	self endon("death");
	old_ignoreme = self.ignoreme;
	self.ignoreme = 1;
	self function_81b6f1ac();
	self vehicle::lights_off();
	wait(0.1);
	wait(1);
	self SetTeam(team);
	self blink_lights_for_time(1);
	self function_efe9815e();
	wait(1);
	self.ignoreme = old_ignoreme;
}

/*
	Name: blink_lights_for_time
	Namespace: vehicle_ai
	Checksum: 0x73D09BB3
	Offset: 0x21E0
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function blink_lights_for_time(time)
{
	self endon("death");
	startTime = GetTime();
	self vehicle::lights_off();
	wait(0.1);
	while(GetTime() < startTime + time * 1000)
	{
		self vehicle::lights_off();
		wait(0.2);
		self vehicle::lights_on();
		wait(0.2);
	}
	self vehicle::lights_on();
}

/*
	Name: turnoff
	Namespace: vehicle_ai
	Checksum: 0x97DB72E5
	Offset: 0x22A0
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function turnoff()
{
	self notify("hash_777b79d1");
}

/*
	Name: turnOn
	Namespace: vehicle_ai
	Checksum: 0x65CFFD1C
	Offset: 0x22C0
	Size: 0x11
	Parameters: 0
	Flags: None
*/
function turnOn()
{
	self notify("hash_8d400b59");
}

/*
	Name: TurnOffAllLightsAndLaser
	Namespace: vehicle_ai
	Checksum: 0xB60EE7CE
	Offset: 0x22E0
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function TurnOffAllLightsAndLaser()
{
	self LaserOff();
	self vehicle::lights_off();
	self vehicle::toggle_lights_group(1, 0);
	self vehicle::toggle_lights_group(2, 0);
	self vehicle::toggle_lights_group(3, 0);
	self vehicle::toggle_lights_group(4, 0);
	self vehicle::toggle_burn_fx(0);
	self vehicle::toggle_emp_fx(0);
}

/*
	Name: TurnOffAllAmbientAnims
	Namespace: vehicle_ai
	Checksum: 0x19D9D6C
	Offset: 0x23B0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function TurnOffAllAmbientAnims()
{
	self vehicle::toggle_ambient_anim_group(1, 0);
	self vehicle::toggle_ambient_anim_group(2, 0);
	self vehicle::toggle_ambient_anim_group(3, 0);
}

/*
	Name: ClearAllLookingAndTargeting
	Namespace: vehicle_ai
	Checksum: 0x57B7DEBE
	Offset: 0x2408
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function ClearAllLookingAndTargeting()
{
	self ClearTargetEntity();
	self cleargunnertarget(0);
	self cleargunnertarget(1);
	self cleargunnertarget(2);
	self cleargunnertarget(3);
	self ClearLookAtEnt();
}

/*
	Name: ClearAllMovement
	Namespace: vehicle_ai
	Checksum: 0xD8363931
	Offset: 0x24A8
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function ClearAllMovement(var_3339c1a2)
{
	if(!isdefined(var_3339c1a2))
	{
		var_3339c1a2 = 0;
	}
	if(!IsAirBorne(self))
	{
		self CancelAIMove();
	}
	self ClearVehGoalPos();
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
	if(var_3339c1a2 === 1)
	{
		self notify("landed");
		self SetVehVelocity((0, 0, 0));
		self SetPhysAcceleration((0, 0, 0));
		self SetAngularVelocity((0, 0, 0));
	}
}

/*
	Name: shared_callback_damage
	Namespace: vehicle_ai
	Checksum: 0xF298EA25
	Offset: 0x25A8
	Size: 0x23F
	Parameters: 15
	Flags: None
*/
function shared_callback_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(should_emp(self, weapon, sMeansOfDeath, eInflictor, eAttacker))
	{
		minEmpDownTime = 0.8 * self.settings.empdowntime;
		maxEmpDownTime = 1.2 * self.settings.empdowntime;
		self notify("emped", RandomFloatRange(minEmpDownTime, maxEmpDownTime), eAttacker, eInflictor);
	}
	if(should_burn(self, weapon, sMeansOfDeath, eInflictor, eAttacker))
	{
		self thread burning_thread(eAttacker, eInflictor);
	}
	if(!isdefined(self.damageLevel))
	{
		self.damageLevel = 0;
		self.newDamageLevel = self.damageLevel;
	}
	newDamageLevel = vehicle::should_update_damage_fx_level(self.health, iDamage, self.healthdefault);
	if(newDamageLevel > self.damageLevel)
	{
		self.newDamageLevel = newDamageLevel;
	}
	if(self.newDamageLevel > self.damageLevel)
	{
		self.damageLevel = self.newDamageLevel;
		if(self.pain_when_damagelevel_change === 1)
		{
			self notify("pain");
		}
		vehicle::set_damage_fx_level(self.damageLevel);
	}
	return iDamage;
}

/*
	Name: should_emp
	Namespace: vehicle_ai
	Checksum: 0x8D3F4559
	Offset: 0x27F0
	Size: 0x159
	Parameters: 5
	Flags: None
*/
function should_emp(vehicle, weapon, meansOfDeath, eInflictor, eAttacker)
{
	if(!isdefined(vehicle) || meansOfDeath === "MOD_IMPACT" || vehicle.disableElectroDamage === 1)
	{
		return 0;
	}
	if(!(isdefined(weapon) && weapon.isEmp || meansOfDeath === "MOD_ELECTROCUTED"))
	{
		return 0;
	}
	if(isdefined(eAttacker))
	{
	}
	else
	{
	}
	var_90914764 = eInflictor;
	if(!isdefined(var_90914764))
	{
		return 1;
	}
	if(isai(var_90914764) && isVehicle(var_90914764))
	{
		return 0;
	}
	if(level.teambased)
	{
		return vehicle.team != var_90914764.team;
	}
	else if(isdefined(vehicle.owner))
	{
		return vehicle.owner != var_90914764;
	}
	return vehicle != var_90914764;
}

/*
	Name: should_burn
	Namespace: vehicle_ai
	Checksum: 0x39E2D8AA
	Offset: 0x2958
	Size: 0x159
	Parameters: 5
	Flags: None
*/
function should_burn(vehicle, weapon, meansOfDeath, eInflictor, eAttacker)
{
	if(level.disableVehicleBurnDamage === 1 || vehicle.disableBurnDamage === 1)
	{
		return 0;
	}
	if(!isdefined(vehicle))
	{
		return 0;
	}
	if(meansOfDeath !== "MOD_BURNED")
	{
		return 0;
	}
	if(vehicle === eInflictor)
	{
		return 0;
	}
	if(isdefined(eAttacker))
	{
	}
	else
	{
	}
	var_90914764 = eInflictor;
	if(!isdefined(var_90914764))
	{
		return 1;
	}
	if(isai(var_90914764) && isVehicle(var_90914764))
	{
		return 0;
	}
	if(level.teambased)
	{
		return vehicle.team != var_90914764.team;
	}
	else if(isdefined(vehicle.owner))
	{
		return vehicle.owner != var_90914764;
	}
	return vehicle != var_90914764;
}

/*
	Name: StartInitialState
	Namespace: vehicle_ai
	Checksum: 0xC9CB0B6
	Offset: 0x2AC0
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function StartInitialState(var_d200ec07)
{
	if(!isdefined(var_d200ec07))
	{
		var_d200ec07 = "combat";
	}
	params = spawnstruct();
	params.var_8f949536 = 1;
	if(isdefined(self.script_startstate))
	{
		self set_state(self.script_startstate, params);
	}
	else
	{
		self set_state(var_d200ec07, params);
	}
}

/*
	Name: function_81b6f1ac
	Namespace: vehicle_ai
	Checksum: 0xF60E461D
	Offset: 0x2B70
	Size: 0x6F
	Parameters: 2
	Flags: None
*/
function function_81b6f1ac(var_93f11df2, var_28dcae96)
{
	params = spawnstruct();
	params.var_28dcae96 = var_28dcae96;
	self set_state("scripted", params);
	self.var_de81e9c8 = var_93f11df2;
}

/*
	Name: function_efe9815e
	Namespace: vehicle_ai
	Checksum: 0x804A0AA4
	Offset: 0x2BE8
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function function_efe9815e(stateName)
{
	if(isalive(self) && is_instate("scripted"))
	{
		if(isdefined(stateName))
		{
			self set_state(stateName);
		}
		else
		{
			self set_state("combat");
		}
	}
}

/*
	Name: set_role
	Namespace: vehicle_ai
	Checksum: 0x482669B3
	Offset: 0x2C78
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function set_role(var_f43142a0)
{
	self.var_e7f3ac93 = var_f43142a0;
}

/*
	Name: set_state
	Namespace: vehicle_ai
	Checksum: 0x103EF3B8
	Offset: 0x2C98
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function set_state(name, params)
{
	self.state_machines[self.var_e7f3ac93] thread statemachine::set_state(name, params);
}

/*
	Name: evaluate_connections
	Namespace: vehicle_ai
	Checksum: 0xA4DF6ED6
	Offset: 0x2CE8
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function evaluate_connections(eval_func, params)
{
	self.state_machines[self.var_e7f3ac93] statemachine::evaluate_connections(eval_func, params);
}

/*
	Name: get_state_callbacks
	Namespace: vehicle_ai
	Checksum: 0x94835341
	Offset: 0x2D38
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function get_state_callbacks(stateName)
{
	var_f43142a0 = "default";
	if(isdefined(self.var_e7f3ac93))
	{
		var_f43142a0 = self.var_e7f3ac93;
	}
	if(isdefined(self.state_machines[var_f43142a0]))
	{
		return self.state_machines[var_f43142a0].states[stateName];
	}
	return undefined;
}

/*
	Name: function_7972425b
	Namespace: vehicle_ai
	Checksum: 0xABBD9BAD
	Offset: 0x2DB0
	Size: 0x5F
	Parameters: 2
	Flags: None
*/
function function_7972425b(var_f43142a0, stateName)
{
	if(!isdefined(var_f43142a0))
	{
		var_f43142a0 = "default";
	}
	if(isdefined(self.state_machines[var_f43142a0]))
	{
		return self.state_machines[var_f43142a0].states[stateName];
	}
	return undefined;
}

/*
	Name: get_current_state
	Namespace: vehicle_ai
	Checksum: 0xC002AEE0
	Offset: 0x2E18
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function get_current_state()
{
	if(isdefined(self.var_e7f3ac93) && isdefined(self.state_machines[self.var_e7f3ac93].current_state))
	{
		return self.state_machines[self.var_e7f3ac93].current_state.name;
	}
	return undefined;
}

/*
	Name: get_previous_state
	Namespace: vehicle_ai
	Checksum: 0x8FDB09E1
	Offset: 0x2E78
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function get_previous_state()
{
	if(isdefined(self.var_e7f3ac93) && isdefined(self.state_machines[self.var_e7f3ac93].previous_state))
	{
		return self.state_machines[self.var_e7f3ac93].previous_state.name;
	}
	return undefined;
}

/*
	Name: get_next_state
	Namespace: vehicle_ai
	Checksum: 0xE9CFF409
	Offset: 0x2ED8
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function get_next_state()
{
	if(isdefined(self.var_e7f3ac93) && isdefined(self.state_machines[self.var_e7f3ac93].next_state))
	{
		return self.state_machines[self.var_e7f3ac93].next_state.name;
	}
	return undefined;
}

/*
	Name: is_instate
	Namespace: vehicle_ai
	Checksum: 0x3A1AA4BF
	Offset: 0x2F38
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function is_instate(stateName)
{
	if(isdefined(self.var_e7f3ac93) && isdefined(self.state_machines[self.var_e7f3ac93].current_state))
	{
		return self.state_machines[self.var_e7f3ac93].current_state.name === stateName;
	}
	return 0;
}

/*
	Name: add_state
	Namespace: vehicle_ai
	Checksum: 0xD793377D
	Offset: 0x2FA8
	Size: 0x8F
	Parameters: 4
	Flags: None
*/
function add_state(name, enter_func, update_func, exit_func)
{
	if(isdefined(self.var_e7f3ac93))
	{
		statemachine = self.state_machines[self.var_e7f3ac93];
		if(isdefined(statemachine))
		{
			State = statemachine statemachine::add_state(name, enter_func, update_func, exit_func);
			return State;
		}
	}
	return undefined;
}

/*
	Name: add_interrupt_connection
	Namespace: vehicle_ai
	Checksum: 0x15382124
	Offset: 0x3040
	Size: 0x5B
	Parameters: 4
	Flags: None
*/
function add_interrupt_connection(from_state_name, to_state_name, on_notify, checkfunc)
{
	self.state_machines[self.var_e7f3ac93] statemachine::add_interrupt_connection(from_state_name, to_state_name, on_notify, checkfunc);
}

/*
	Name: add_utility_connection
	Namespace: vehicle_ai
	Checksum: 0x9ACD29F8
	Offset: 0x30A8
	Size: 0x5B
	Parameters: 4
	Flags: None
*/
function add_utility_connection(from_state_name, to_state_name, checkfunc, defaultScore)
{
	self.state_machines[self.var_e7f3ac93] statemachine::add_utility_connection(from_state_name, to_state_name, checkfunc, defaultScore);
}

/*
	Name: init_state_machine_for_role
	Namespace: vehicle_ai
	Checksum: 0xAC220F89
	Offset: 0x3110
	Size: 0x707
	Parameters: 1
	Flags: None
*/
function init_state_machine_for_role(var_f43142a0)
{
	if(!isdefined(var_f43142a0))
	{
		var_f43142a0 = "default";
	}
	statemachine = statemachine::create(var_f43142a0, self);
	statemachine.var_44b80155 = 1;
	if(!isdefined(self.var_e7f3ac93))
	{
		set_role(var_f43142a0);
	}
	statemachine statemachine::add_state("suspend", undefined, undefined, undefined);
	statemachine statemachine::add_state("death", &defaultstate_death_enter, &defaultstate_death_update, undefined);
	statemachine statemachine::add_state("scripted", &function_eabd902b, undefined, &function_1f45a6b);
	statemachine statemachine::add_state("combat", &function_d29906a1, undefined, &function_fe49fdbd);
	statemachine statemachine::add_state("emped", &defaultstate_emped_enter, &defaultstate_emped_update, &defaultstate_emped_exit, &function_bcfeb905);
	statemachine statemachine::add_state("surge", &function_27cb64b3, &defaultstate_surge_update, &function_3e758cb3);
	statemachine statemachine::add_state("off", &defaultstate_off_enter, undefined, &defaultstate_off_exit);
	statemachine statemachine::add_state("driving", &defaultstate_driving_enter, undefined, &function_637abdaa);
	statemachine statemachine::add_state("pain", &function_1ad2f451, undefined, &function_25cfa18d);
	statemachine statemachine::add_interrupt_connection("off", "combat", "start_up");
	statemachine statemachine::add_interrupt_connection("driving", "combat", "exit_vehicle");
	statemachine statemachine::add_utility_connection("emped", "combat");
	statemachine statemachine::add_utility_connection("pain", "combat");
	statemachine statemachine::add_interrupt_connection("combat", "emped", "emped");
	statemachine statemachine::add_interrupt_connection("pain", "emped", "emped");
	statemachine statemachine::add_interrupt_connection("emped", "emped", "emped");
	statemachine statemachine::add_interrupt_connection("combat", "surge", "surge");
	statemachine statemachine::add_interrupt_connection("off", "surge", "surge");
	statemachine statemachine::add_interrupt_connection("pain", "surge", "surge");
	statemachine statemachine::add_interrupt_connection("emped", "surge", "surge");
	statemachine statemachine::add_interrupt_connection("combat", "off", "shut_off");
	statemachine statemachine::add_interrupt_connection("emped", "off", "shut_off");
	statemachine statemachine::add_interrupt_connection("pain", "off", "shut_off");
	statemachine statemachine::add_interrupt_connection("combat", "driving", "enter_vehicle");
	statemachine statemachine::add_interrupt_connection("emped", "driving", "enter_vehicle");
	statemachine statemachine::add_interrupt_connection("off", "driving", "enter_vehicle");
	statemachine statemachine::add_interrupt_connection("pain", "driving", "enter_vehicle");
	statemachine statemachine::add_interrupt_connection("combat", "pain", "pain");
	statemachine statemachine::add_interrupt_connection("emped", "pain", "pain");
	statemachine statemachine::add_interrupt_connection("off", "pain", "pain");
	statemachine statemachine::add_interrupt_connection("driving", "pain", "pain");
	self.overrideVehicleKilled = &Callback_VehicleKilled;
	self.overrideVehicleDeathPostGame = &Callback_VehicleKilled;
	statemachine thread statemachine::set_state("suspend");
	self thread function_cdad1698();
	return statemachine;
}

/*
	Name: register_custom_add_state_callback
	Namespace: vehicle_ai
	Checksum: 0x8257BE41
	Offset: 0x3820
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function register_custom_add_state_callback(func)
{
	if(!isdefined(level.var_5fa88aeb))
	{
		level.var_5fa88aeb = [];
	}
	level.var_5fa88aeb[level.var_5fa88aeb.size] = func;
}

/*
	Name: call_custom_add_state_callbacks
	Namespace: vehicle_ai
	Checksum: 0x43A38276
	Offset: 0x3868
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function call_custom_add_state_callbacks()
{
	if(isdefined(level.var_5fa88aeb))
	{
		for(i = 0; i < level.var_5fa88aeb.size; i++)
		{
			self [[level.var_5fa88aeb[i]]]();
		}
	}
}

/*
	Name: Callback_VehicleKilled
	Namespace: vehicle_ai
	Checksum: 0x8BB9CDE8
	Offset: 0x38C8
	Size: 0x13B
	Parameters: 8
	Flags: None
*/
function Callback_VehicleKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	if(isdefined(self.var_de81e9c8) && self.var_de81e9c8)
	{
		return;
	}
	death_info = spawnstruct();
	death_info.inflictor = eInflictor;
	death_info.attacker = eAttacker;
	death_info.damage = iDamage;
	death_info.meansOfDeath = sMeansOfDeath;
	death_info.weapon = weapon;
	death_info.dir = vDir;
	death_info.hitLoc = sHitLoc;
	death_info.timeOffset = psOffsetTime;
	self set_state("death", death_info);
}

/*
	Name: function_cdad1698
	Namespace: vehicle_ai
	Checksum: 0xCACA5A10
	Offset: 0x3A10
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function function_cdad1698()
{
	state_machines = self.state_machines;
	self waittill("free_vehicle");
	foreach(statemachine in state_machines)
	{
		statemachine statemachine::clear();
	}
}

/*
	Name: defaultstate_death_enter
	Namespace: vehicle_ai
	Checksum: 0xE02EC71C
	Offset: 0x3AC8
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function defaultstate_death_enter(params)
{
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
	self DisableAimAssist();
	TurnOffAllLightsAndLaser();
	TurnOffAllAmbientAnims();
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	self CancelAIMove();
	self.takedamage = 0;
	self vehicle_death::death_cleanup_level_variables();
}

/*
	Name: function_1f48ef7e
	Namespace: vehicle_ai
	Checksum: 0x44040A95
	Offset: 0x3BB8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_1f48ef7e()
{
	if(isdefined(self.settings.var_ada27b12) && isdefined(self.settings.var_ebdbaf9c))
	{
		PlayFXOnTag(self.settings.var_ada27b12, self, self.settings.var_ebdbaf9c);
	}
	if(isdefined(self.settings.var_b4be6ee9))
	{
		self playsound(self.settings.var_b4be6ee9);
	}
}

/*
	Name: function_7b0235ff
	Namespace: vehicle_ai
	Checksum: 0x9C7D97ED
	Offset: 0x3C58
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_7b0235ff()
{
	if(isdefined(self.settings.emp_death_fx_1) && isdefined(self.settings.emp_death_tag_1))
	{
		PlayFXOnTag(self.settings.emp_death_fx_1, self, self.settings.emp_death_tag_1);
	}
	if(isdefined(self.settings.emp_death_sound_1))
	{
		self playsound(self.settings.emp_death_sound_1);
	}
}

/*
	Name: function_c3eceaae
	Namespace: vehicle_ai
	Checksum: 0xC721E0B8
	Offset: 0x3CF8
	Size: 0xFB
	Parameters: 2
	Flags: None
*/
function function_c3eceaae(var_2bb85a7b, meansOfDamage)
{
	self endon("death");
	if(!isdefined(self) || self.abandoned === 1 || self.damage_on_death === 0 || self.radiusdamageradius <= 0)
	{
		return;
	}
	position = self.origin + VectorScale((0, 0, 1), 15);
	radius = self.radiusdamageradius * var_2bb85a7b;
	damageMax = self.radiusdamagemax;
	damageMin = self.radiusdamagemin;
	wait(0.05);
	if(isdefined(self))
	{
		self RadiusDamage(position, radius, damageMax, damageMin, undefined, meansOfDamage);
	}
}

/*
	Name: burning_death
	Namespace: vehicle_ai
	Checksum: 0xAC931E75
	Offset: 0x3E00
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function burning_death(params)
{
	self endon("death");
	self function_1f48ef7e();
	self.var_ffe1e6db = 1;
	self thread function_c3eceaae(2, "MOD_BURNED");
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::do_death_dynents(3);
	self vehicle_death::DeleteWhenSafe(10);
}

/*
	Name: function_ad32d1d9
	Namespace: vehicle_ai
	Checksum: 0x29D146A6
	Offset: 0x3EC0
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_ad32d1d9(params)
{
	self endon("death");
	self function_7b0235ff();
	self.var_ffe1e6db = 1;
	self thread function_c3eceaae(2, "MOD_ELECTROCUTED");
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::do_death_dynents(2);
	self vehicle_death::DeleteWhenSafe();
}

/*
	Name: function_6e26f2f1
	Namespace: vehicle_ai
	Checksum: 0xC997F7B6
	Offset: 0x3F80
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_6e26f2f1(params)
{
	self endon("death");
	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::do_death_dynents();
	self vehicle_death::DeleteWhenSafe();
}

/*
	Name: function_4a695697
	Namespace: vehicle_ai
	Checksum: 0x198E5E5E
	Offset: 0x4028
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function function_4a695697(params)
{
	self endon("death");
	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	if(isdefined(level.disable_thermal))
	{
		[[level.disable_thermal]]();
	}
	if(isdefined(self.waittime_before_delete))
	{
	}
	else
	{
	}
	waitTime = 0;
	owner = self GetVehicleOwner();
	if(isdefined(owner) && self function_d04b5e96())
	{
		waitTime = max(waitTime, 4);
	}
	util::waitForTime(waitTime);
	vehicle_death::FreeWhenSafe();
}

/*
	Name: get_death_type
	Namespace: vehicle_ai
	Checksum: 0x714F3E04
	Offset: 0x4168
	Size: 0x107
	Parameters: 1
	Flags: None
*/
function get_death_type(params)
{
	if(self.delete_on_death === 1)
	{
		death_type = "default";
	}
	else
	{
		death_type = self.death_type;
	}
	if(!isdefined(death_type))
	{
		death_type = params.death_type;
	}
	if(!isdefined(death_type) && isdefined(self.abnormal_status) && self.abnormal_status.burning === 1)
	{
		death_type = "burning";
	}
	if(!isdefined(death_type) && (isdefined(self.abnormal_status) && self.abnormal_status.emped === 1) || (isdefined(params.weapon) && params.weapon.isEmp))
	{
		death_type = "emped";
	}
	return death_type;
}

/*
	Name: defaultstate_death_update
	Namespace: vehicle_ai
	Checksum: 0x8F11CEEA
	Offset: 0x4278
	Size: 0x14D
	Parameters: 1
	Flags: None
*/
function defaultstate_death_update(params)
{
	self endon("death");
	if(isdefined(level.var_baa25f4f))
	{
		[[level.var_baa25f4f]](self);
	}
	if(self.delete_on_death === 1)
	{
		function_4a695697(params);
		vehicle_death::DeleteWhenSafe(0.25);
		break;
	}
	if(isdefined(get_death_type(params)))
	{
	}
	else
	{
	}
	death_type = "default";
	switch(death_type)
	{
		case "burning":
		{
			burning_death(params);
			break;
		}
		case "emped":
		{
			function_ad32d1d9(params);
			break;
		}
		case "gibbed":
		{
			function_6e26f2f1(params);
			break;
		}
		case default:
		{
			function_4a695697(params);
			break;
		}
	}
}

/*
	Name: function_eabd902b
	Namespace: vehicle_ai
	Checksum: 0x803457C
	Offset: 0x43D0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function function_eabd902b(params)
{
	if(params.var_28dcae96 !== 1)
	{
		ClearAllLookingAndTargeting();
		ClearAllMovement();
		if(function_ec812c78(self))
		{
			self ASMRequestSubstate("locomotion@movement");
		}
		self ResumeSpeed();
	}
}

/*
	Name: function_1f45a6b
	Namespace: vehicle_ai
	Checksum: 0xB063C4A5
	Offset: 0x4470
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_1f45a6b(params)
{
	if(params.var_28dcae96 !== 1)
	{
		ClearAllLookingAndTargeting();
		ClearAllMovement();
	}
}

/*
	Name: function_d29906a1
	Namespace: vehicle_ai
	Checksum: 0x23C8A6E3
	Offset: 0x44C0
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function function_d29906a1(params)
{
}

/*
	Name: function_fe49fdbd
	Namespace: vehicle_ai
	Checksum: 0x5145A6B6
	Offset: 0x44D8
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function function_fe49fdbd(params)
{
}

/*
	Name: defaultstate_emped_enter
	Namespace: vehicle_ai
	Checksum: 0x860AD2B
	Offset: 0x44F0
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function defaultstate_emped_enter(params)
{
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
	params.LaserOn = IsLaserOn(self);
	self LaserOff();
	self vehicle::lights_off();
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	if(IsAirBorne(self))
	{
		self SetRotorSpeed(0);
	}
	if(!isdefined(self.abnormal_status))
	{
		self.abnormal_status = spawnstruct();
	}
	self.abnormal_status.emped = 1;
	self.abnormal_status.attacker = params.notify_param[1];
	self.abnormal_status.inflictor = params.notify_param[2];
	self vehicle::toggle_emp_fx(1);
}

/*
	Name: emp_startup_fx
	Namespace: vehicle_ai
	Checksum: 0x4AB811EB
	Offset: 0x4690
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function emp_startup_fx()
{
	if(isdefined(self.settings.var_e4bcedb4) && isdefined(self.settings.var_adc6af1a))
	{
		PlayFXOnTag(self.settings.var_e4bcedb4, self, self.settings.var_adc6af1a);
	}
}

/*
	Name: defaultstate_emped_update
	Namespace: vehicle_ai
	Checksum: 0x96A1A4D2
	Offset: 0x46F8
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function defaultstate_emped_update(params)
{
	self endon("death");
	self endon("change_state");
	time = params.notify_param[0];
	/#
		Assert(isdefined(time));
	#/
	Cooldown("emped_timer", time);
	while(!IsCooldownReady("emped_timer"))
	{
		timeLeft = max(GetCooldownLeft("emped_timer"), 0.5);
		wait(timeLeft);
	}
	self.abnormal_status.emped = 0;
	self vehicle::toggle_emp_fx(0);
	self emp_startup_fx();
	wait(1);
	self evaluate_connections();
}

/*
	Name: defaultstate_emped_exit
	Namespace: vehicle_ai
	Checksum: 0xBD2FCDC0
	Offset: 0x4838
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function defaultstate_emped_exit(params)
{
	self vehicle::toggle_tread_fx(1);
	self vehicle::toggle_exhaust_fx(1);
	self vehicle::toggle_sounds(1);
	if(params.LaserOn === 1)
	{
		self LaserOn();
	}
	self vehicle::lights_on();
	if(IsAirBorne(self))
	{
		self SetPhysAcceleration((0, 0, 0));
		self thread nudge_collision();
		self SetRotorSpeed(1);
	}
}

/*
	Name: function_bcfeb905
	Namespace: vehicle_ai
	Checksum: 0x2FF93DC7
	Offset: 0x4940
	Size: 0xF
	Parameters: 1
	Flags: None
*/
function function_bcfeb905(params)
{
	return 1;
}

/*
	Name: function_27cb64b3
	Namespace: vehicle_ai
	Checksum: 0x52E18E5C
	Offset: 0x4958
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function function_27cb64b3(params)
{
}

/*
	Name: function_3e758cb3
	Namespace: vehicle_ai
	Checksum: 0x53C40913
	Offset: 0x4970
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function function_3e758cb3(params)
{
}

/*
	Name: defaultstate_surge_update
	Namespace: vehicle_ai
	Checksum: 0x91FB6384
	Offset: 0x4988
	Size: 0x403
	Parameters: 1
	Flags: None
*/
function defaultstate_surge_update(params)
{
	self endon("change_state");
	self endon("death");
	if(!isdefined(self.abnormal_status))
	{
		self.abnormal_status = spawnstruct();
	}
	self.abnormal_status.emped = 1;
	pathfailcount = 0;
	self thread function_bd32466();
	targets = GetAITeamArray("axis", "team3");
	ArrayRemoveValue(targets, self);
	closest = ArrayGetClosest(self.origin, targets);
	self SetSpeed(self.settings.surgespeedmultiplier * self.settings.defaultMoveSpeed);
	startTime = GetTime();
	self thread function_cae5a3fd(params.notify_param[0]);
	while(GetTime() - startTime < self.settings.var_f6a8f077 * 1000)
	{
		if(!isdefined(closest))
		{
			self detonate(params.notify_param[0]);
		}
		else
		{
			foundpath = 0;
			targetPos = closest.origin + VectorScale((0, 0, 1), 32);
			if(isdefined(targetPos))
			{
				queryResult = PositionQuery_Source_Navigation(targetPos, 0, 64, 35, 5, self);
				foreach(point in queryResult.data)
				{
					self.current_pathto_pos = point.origin;
					foundpath = self SetVehGoalPos(self.current_pathto_pos, 0, 1);
					if(foundpath)
					{
						self thread path_update_interrupt(closest, params.notify_param[0]);
						pathfailcount = 0;
						self waittill_pathing_done(self.settings.var_f6a8f077);
						try_detonate(closest, params.notify_param[0]);
						break;
					}
					waittillframeend;
				}
			}
			else if(!foundpath)
			{
				pathfailcount++;
				if(pathfailcount > 10)
				{
					self detonate(params.notify_param[0]);
				}
			}
			wait(0.2);
		}
	}
	if(isalive(self))
	{
		self detonate(params.notify_param[0]);
	}
}

/*
	Name: path_update_interrupt
	Namespace: vehicle_ai
	Checksum: 0x6BF2AF6A
	Offset: 0x4D98
	Size: 0xD7
	Parameters: 2
	Flags: None
*/
function path_update_interrupt(closest, attacker)
{
	self endon("death");
	self endon("change_state");
	self endon("near_goal");
	self endon("reached_end_node");
	wait(0.1);
	while(!self try_detonate(closest, attacker))
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(Distance2DSquared(self.current_pathto_pos, self.goalpos) > self.goalRadius * self.goalRadius)
			{
				wait(0.5);
				self notify("near_goal");
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_cae5a3fd
	Namespace: vehicle_ai
	Checksum: 0x8A4A4BE3
	Offset: 0x4E78
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_cae5a3fd(attacker)
{
	self endon("death");
	self endon("change_state");
	wait(0.25 * self.settings.var_f6a8f077);
	self SetTeam(attacker.team);
}

/*
	Name: try_detonate
	Namespace: vehicle_ai
	Checksum: 0x567EFD0C
	Offset: 0x4EE8
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function try_detonate(closest, attacker)
{
	if(isdefined(closest) && isalive(closest))
	{
		if(DistanceSquared(closest.origin, self.origin) < 80 * 80)
		{
			self detonate(attacker);
			return 1;
		}
	}
	return 0;
}

/*
	Name: detonate
	Namespace: vehicle_ai
	Checksum: 0xDB4ACF74
	Offset: 0x4F80
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function detonate(attacker)
{
	self SetTeam(attacker.team);
	self RadiusDamage(self.origin + VectorScale((0, 0, 1), 5), self.settings.var_1b64a6a8, 1500, 1000, attacker, "MOD_EXPLOSIVE");
	if(isalive(self))
	{
		self kill();
	}
}

/*
	Name: function_bd32466
	Namespace: vehicle_ai
	Checksum: 0xB397E217
	Offset: 0x5038
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function function_bd32466()
{
	self endon("death");
	self endon("change_state");
	while(1)
	{
		self vehicle::lights_off();
		wait(0.1);
		self vehicle::lights_on("allies");
		wait(0.1);
		self vehicle::lights_off();
		wait(0.1);
		self vehicle::lights_on("axis");
		wait(0.1);
	}
}

/*
	Name: defaultstate_off_enter
	Namespace: vehicle_ai
	Checksum: 0x2D8116F4
	Offset: 0x50F0
	Size: 0x183
	Parameters: 1
	Flags: None
*/
function defaultstate_off_enter(params)
{
	self vehicle::toggle_tread_fx(0);
	self vehicle::toggle_exhaust_fx(0);
	self vehicle::toggle_sounds(0);
	self DisableAimAssist();
	params.LaserOn = IsLaserOn(self);
	TurnOffAllLightsAndLaser();
	TurnOffAllAmbientAnims();
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	if(isdefined(level.disable_thermal))
	{
		[[level.disable_thermal]]();
	}
	if(IsAirBorne(self))
	{
		if(params.var_8f949536 !== 1 && params.var_fbf3948c !== 1)
		{
			self SetPhysAcceleration(VectorScale((0, 0, -1), 300));
			self thread function_cfb0d8c8();
		}
		self SetRotorSpeed(0);
	}
}

/*
	Name: defaultstate_off_exit
	Namespace: vehicle_ai
	Checksum: 0xA3D80445
	Offset: 0x5280
	Size: 0x14B
	Parameters: 1
	Flags: None
*/
function defaultstate_off_exit(params)
{
	self vehicle::toggle_tread_fx(1);
	self vehicle::toggle_exhaust_fx(1);
	self vehicle::toggle_sounds(1);
	self EnableAimAssist();
	if(IsAirBorne(self))
	{
		self SetPhysAcceleration((0, 0, 0));
		self thread nudge_collision();
		self SetRotorSpeed(1);
	}
	if(params.LaserOn === 1)
	{
		self LaserOn();
	}
	if(isdefined(level.var_b3ce91e0))
	{
		if(self get_next_state() !== "death")
		{
			[[level.var_b3ce91e0]]();
		}
	}
	self vehicle::lights_on();
}

/*
	Name: defaultstate_driving_enter
	Namespace: vehicle_ai
	Checksum: 0x20D8648F
	Offset: 0x53D8
	Size: 0x1AB
	Parameters: 1
	Flags: None
*/
function defaultstate_driving_enter(params)
{
	params.driver = self GetSeatOccupant(0);
	/#
		Assert(isdefined(params.driver));
	#/
	self DisableAimAssist();
	if(level.playersDrivingVehiclesBecomeInvulnerable)
	{
		params.driver EnableInvulnerability();
		params.driver.ignoreme = 1;
	}
	self.turretRotScale = 1;
	self.team = params.driver.team;
	if(function_ec812c78(self))
	{
		self ASMRequestSubstate("locomotion@movement");
	}
	self function_e4783446(1);
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	self CancelAIMove();
	if(isdefined(params.driver) && !isdefined(self.customDamageMonitor))
	{
		self thread vehicle::monitor_damage_as_occupant(params.driver);
	}
}

/*
	Name: function_637abdaa
	Namespace: vehicle_ai
	Checksum: 0x3AC5D332
	Offset: 0x5590
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function function_637abdaa(params)
{
	self EnableAimAssist();
	if(isdefined(params.driver))
	{
		params.driver DisableInvulnerability();
		params.driver.ignoreme = 0;
	}
	self.turretRotScale = 1;
	self function_e4783446(0);
	ClearAllLookingAndTargeting();
	ClearAllMovement();
	if(isdefined(params.driver))
	{
		params.driver vehicle::stop_monitor_damage_as_occupant();
	}
}

/*
	Name: function_1ad2f451
	Namespace: vehicle_ai
	Checksum: 0x32BDD794
	Offset: 0x5678
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_1ad2f451(params)
{
	ClearAllLookingAndTargeting();
	ClearAllMovement();
}

/*
	Name: function_25cfa18d
	Namespace: vehicle_ai
	Checksum: 0xDC743933
	Offset: 0x56B0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_25cfa18d(params)
{
	ClearAllLookingAndTargeting();
	ClearAllMovement();
}

/*
	Name: CanSeeEnemyFromPosition
	Namespace: vehicle_ai
	Checksum: 0xFDF6C837
	Offset: 0x56E8
	Size: 0x71
	Parameters: 3
	Flags: None
*/
function CanSeeEnemyFromPosition(position, enemy, var_5529f205)
{
	sightCheckOrigin = position + (0, 0, var_5529f205);
	return SightTracePassed(sightCheckOrigin, enemy.origin + VectorScale((0, 0, 1), 30), 0, self);
}

/*
	Name: FindNewPosition
	Namespace: vehicle_ai
	Checksum: 0x43AE0A34
	Offset: 0x5768
	Size: 0x7FD
	Parameters: 1
	Flags: None
*/
function FindNewPosition(var_5529f205)
{
	if(self.goalforced)
	{
		goalpos = GetClosestPointOnNavMesh(self.goalpos, self.radius * 2, self.radius);
		return goalpos;
	}
	var_cae297db = 90;
	PixBeginEvent("vehicle_ai_shared::FindNewPosition");
	queryResult = PositionQuery_Source_Navigation(self.origin, 0, 2000, 300, var_cae297db, self, var_cae297db * 2);
	PixEndEvent();
	PositionQuery_Filter_Random(queryResult, 0, 50);
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	PositionQuery_Filter_OutOfGoalAnchor(queryResult, 50);
	origin = self.goalpos;
	best_point = undefined;
	best_score = -999999;
	if(isdefined(self.enemy))
	{
		PositionQuery_Filter_Sight(queryResult, self.enemy.origin, self GetEye() - self.origin, self, 0, self.enemy);
		self PositionQuery_Filter_EngagementDist(queryResult, self.enemy, self.settings.engagementDistMin, self.settings.engagementDistMax);
		if(turret::has_turret(1))
		{
			var_7d8fdc18 = turret::get_target(1);
			if(isdefined(var_7d8fdc18) && var_7d8fdc18 != self.enemy)
			{
				PositionQuery_Filter_Sight(queryResult, var_7d8fdc18.origin, (0, 0, var_5529f205), self, 20, self, "sight2");
			}
		}
		if(turret::has_turret(2))
		{
			var_7d8fdc18 = turret::get_target(2);
			if(isdefined(var_7d8fdc18) && var_7d8fdc18 != self.enemy)
			{
				PositionQuery_Filter_Sight(queryResult, var_7d8fdc18.origin, (0, 0, var_5529f205), self, 20, self, "sight3");
			}
		}
		foreach(point in queryResult.data)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = point.distAwayFromEngagementArea * -1;
			#/
			point.score = point.score + point.distAwayFromEngagementArea * -1;
			if(Distance2DSquared(self.origin, point.origin) < 28900)
			{
				/#
					if(!isdefined(point._scoreDebug))
					{
						point._scoreDebug = [];
					}
					point._scoreDebug["Dev Block strings are not supported"] = -170;
				#/
				point.score = point.score + -170;
			}
			if(isdefined(point.sight) && point.sight)
			{
				/#
					if(!isdefined(point._scoreDebug))
					{
						point._scoreDebug = [];
					}
					point._scoreDebug["Dev Block strings are not supported"] = 250;
				#/
				point.score = point.score + 250;
			}
			if(isdefined(point.var_ffab01e6) && point.var_ffab01e6)
			{
				/#
					if(!isdefined(point._scoreDebug))
					{
						point._scoreDebug = [];
					}
					point._scoreDebug["Dev Block strings are not supported"] = 150;
				#/
				point.score = point.score + 150;
			}
			if(isdefined(point.var_25ad7c4f) && point.var_25ad7c4f)
			{
				/#
					if(!isdefined(point._scoreDebug))
					{
						point._scoreDebug = [];
					}
					point._scoreDebug["Dev Block strings are not supported"] = 150;
				#/
				point.score = point.score + 150;
			}
			if(point.score > best_score)
			{
				best_score = point.score;
				best_point = point;
			}
		}
		break;
	}
	foreach(point in queryResult.data)
	{
		if(Distance2DSquared(self.origin, point.origin) < 28900)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = -100;
			#/
			point.score = point.score + -100;
		}
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self PositionQuery_DebugScores(queryResult);
	if(isdefined(best_point))
	{
		/#
		#/
		origin = best_point.origin;
	}
	return origin + VectorScale((0, 0, 1), 10);
}

/*
	Name: TimeSince
	Namespace: vehicle_ai
	Checksum: 0xC25F5CA9
	Offset: 0x5F70
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function TimeSince(var_a3ad3d0f)
{
	return GetTime() - var_a3ad3d0f * 0.001;
}

/*
	Name: function_ba468810
	Namespace: vehicle_ai
	Checksum: 0x5318DF93
	Offset: 0x5F98
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_ba468810()
{
	if(!isdefined(self.var_95b9a013))
	{
		self.var_95b9a013 = [];
	}
}

/*
	Name: Cooldown
	Namespace: vehicle_ai
	Checksum: 0x3D3EFF66
	Offset: 0x5FC0
	Size: 0x41
	Parameters: 2
	Flags: None
*/
function Cooldown(name, var_c22073e8)
{
	function_ba468810();
	self.var_95b9a013[name] = GetTime() + var_c22073e8 * 1000;
}

/*
	Name: function_1d641563
	Namespace: vehicle_ai
	Checksum: 0xB7C6190C
	Offset: 0x6010
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_1d641563(name)
{
	function_ba468810();
	if(!isdefined(self.var_95b9a013[name]))
	{
		self.var_95b9a013[name] = GetTime() - 1;
	}
	return self.var_95b9a013[name];
}

/*
	Name: GetCooldownLeft
	Namespace: vehicle_ai
	Checksum: 0x31A30C44
	Offset: 0x6070
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function GetCooldownLeft(name)
{
	function_ba468810();
	return function_1d641563(name) - GetTime() * 0.001;
}

/*
	Name: IsCooldownReady
	Namespace: vehicle_ai
	Checksum: 0x275E9D6A
	Offset: 0x60B8
	Size: 0x71
	Parameters: 2
	Flags: None
*/
function IsCooldownReady(name, var_84bf858b)
{
	function_ba468810();
	if(!isdefined(var_84bf858b))
	{
		var_84bf858b = 0;
	}
	var_79e38ba8 = self.var_95b9a013[name];
	return !isdefined(var_79e38ba8) || GetTime() + var_84bf858b * 1000 > var_79e38ba8;
}

/*
	Name: ClearCooldown
	Namespace: vehicle_ai
	Checksum: 0x2A236979
	Offset: 0x6138
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function ClearCooldown(name)
{
	function_ba468810();
	self.var_95b9a013[name] = GetTime() - 1;
}

/*
	Name: AddCooldownTime
	Namespace: vehicle_ai
	Checksum: 0x99DDD88A
	Offset: 0x6178
	Size: 0x55
	Parameters: 2
	Flags: None
*/
function AddCooldownTime(name, var_c22073e8)
{
	function_ba468810();
	self.var_95b9a013[name] = function_1d641563(name) + var_c22073e8 * 1000;
}

/*
	Name: ClearAllCooldowns
	Namespace: vehicle_ai
	Checksum: 0xBAAB30F4
	Offset: 0x61D8
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function ClearAllCooldowns()
{
	if(isdefined(self.var_95b9a013))
	{
		foreach(Cooldown in self.var_95b9a013)
		{
			self.var_95b9a013[str_name] = GetTime() - 1;
		}
	}
}

/*
	Name: PositionQuery_DebugScores
	Namespace: vehicle_ai
	Checksum: 0x299FCEFF
	Offset: 0x6278
	Size: 0xD9
	Parameters: 1
	Flags: None
*/
function PositionQuery_DebugScores(queryResult)
{
	if(!(isdefined(GetDvarInt("hkai_debugPositionQuery")) && GetDvarInt("hkai_debugPositionQuery")))
	{
		return;
	}
	foreach(point in queryResult.data)
	{
		point function_cdd2a274(self);
	}
}

/*
	Name: function_cdd2a274
	Namespace: vehicle_ai
	Checksum: 0x7F59C836
	Offset: 0x6360
	Size: 0x1C1
	Parameters: 1
	Flags: None
*/
function function_cdd2a274(entity)
{
	/#
		if(!isdefined(self._scoreDebug))
		{
			return;
		}
		if(!(isdefined(GetDvarInt("Dev Block strings are not supported")) && GetDvarInt("Dev Block strings are not supported")))
		{
			return;
		}
		step = 10;
		count = 1;
		color = (1, 0, 0);
		if(self.score >= 0)
		{
			color = (0, 1, 0);
		}
		RecordStar(self.origin, color);
		Record3DText("Dev Block strings are not supported" + self.score + "Dev Block strings are not supported", self.origin - (0, 0, step * count), color);
		foreach(score in self._scoreDebug)
		{
			count++;
			Record3DText(name + "Dev Block strings are not supported" + score, self.origin - (0, 0, step * count), color);
		}
	#/
}

/*
	Name: function_45e2b2c3
	Namespace: vehicle_ai
	Checksum: 0xB4AEAE62
	Offset: 0x6530
	Size: 0x3F
	Parameters: 2
	Flags: None
*/
function function_45e2b2c3(left, right)
{
	if(!isdefined(left))
	{
		return 0;
	}
	else if(!isdefined(right))
	{
		return 1;
	}
	return left < right;
}

/*
	Name: function_df397320
	Namespace: vehicle_ai
	Checksum: 0x3A65BD8A
	Offset: 0x6578
	Size: 0x5B
	Parameters: 3
	Flags: None
*/
function function_df397320(left, right, descending)
{
	if(descending)
	{
		return function_45e2b2c3(right, left);
	}
	else
	{
		return function_45e2b2c3(left, right);
	}
}

/*
	Name: function_3bee5ccf
	Namespace: vehicle_ai
	Checksum: 0xC47ABC03
	Offset: 0x65E0
	Size: 0x49
	Parameters: 3
	Flags: None
*/
function function_3bee5ccf(left, right, descending)
{
	return function_df397320(left.score, right.score, descending);
}

/*
	Name: PositionQuery_Filter_Random
	Namespace: vehicle_ai
	Checksum: 0x8EDEC30E
	Offset: 0x6638
	Size: 0x121
	Parameters: 3
	Flags: None
*/
function PositionQuery_Filter_Random(queryResult, min, max)
{
	foreach(point in queryResult.data)
	{
		score = RandomFloatRange(min, max);
		/#
			if(!isdefined(point._scoreDebug))
			{
				point._scoreDebug = [];
			}
			point._scoreDebug["Dev Block strings are not supported"] = score;
		#/
		point.score = point.score + score;
	}
}

/*
	Name: PositionQuery_PostProcess_SortScore
	Namespace: vehicle_ai
	Checksum: 0xB241D1A0
	Offset: 0x6768
	Size: 0x73
	Parameters: 2
	Flags: None
*/
function PositionQuery_PostProcess_SortScore(queryResult, descending)
{
	if(!isdefined(descending))
	{
		descending = 1;
	}
	sorted = Array::merge_sort(queryResult.data, &function_3bee5ccf, descending);
	queryResult.data = sorted;
}

/*
	Name: PositionQuery_Filter_OutOfGoalAnchor
	Namespace: vehicle_ai
	Checksum: 0x74E4CBA1
	Offset: 0x67E8
	Size: 0x141
	Parameters: 2
	Flags: None
*/
function PositionQuery_Filter_OutOfGoalAnchor(queryResult, tolerance)
{
	if(!isdefined(tolerance))
	{
		tolerance = 1;
	}
	foreach(point in queryResult.data)
	{
		if(point.distToGoal > tolerance)
		{
			score = -10000 - point.distToGoal * 10;
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = score;
			#/
			point.score = point.score + score;
		}
	}
}

/*
	Name: PositionQuery_Filter_EngagementDist
	Namespace: vehicle_ai
	Checksum: 0x4AA76431
	Offset: 0x6938
	Size: 0x33D
	Parameters: 4
	Flags: None
*/
function PositionQuery_Filter_EngagementDist(queryResult, enemy, var_96db8187, var_39bb39f9)
{
	if(!isdefined(enemy))
	{
		return;
	}
	var_c0c36df1 = var_96db8187 + var_39bb39f9 * 0.5;
	var_e97a4c3d = Abs(var_39bb39f9 - var_c0c36df1);
	enemy_origin = (enemy.origin[0], enemy.origin[1], 0);
	vec_enemy_to_self = VectorNormalize((self.origin[0], self.origin[1], 0) - enemy_origin);
	foreach(point in queryResult.data)
	{
		point.distAwayFromEngagementArea = 0;
		vec_enemy_to_point = (point.origin[0], point.origin[1], 0) - enemy_origin;
		dist_in_front_of_enemy = VectorDot(vec_enemy_to_point, vec_enemy_to_self);
		if(Abs(dist_in_front_of_enemy) < var_96db8187)
		{
			dist_in_front_of_enemy = var_96db8187 * -1;
		}
		dist_away_from_sweet_line = Abs(dist_in_front_of_enemy - var_c0c36df1);
		if(dist_away_from_sweet_line > var_e97a4c3d)
		{
			point.distAwayFromEngagementArea = dist_away_from_sweet_line - var_e97a4c3d;
		}
		too_far_dist = var_39bb39f9 * 1.1;
		var_d64ee09 = too_far_dist * too_far_dist;
		var_54a2f524 = Distance2DSquared(point.origin, enemy_origin);
		if(var_54a2f524 > var_d64ee09)
		{
			var_4a456cfa = var_54a2f524 / var_d64ee09;
			dist = var_4a456cfa * too_far_dist;
			var_c967150d = dist - too_far_dist;
			if(var_c967150d > point.distAwayFromEngagementArea)
			{
				point.distAwayFromEngagementArea = var_c967150d;
			}
		}
	}
}

/*
	Name: PositionQuery_Filter_DistAwayFromTarget
	Namespace: vehicle_ai
	Checksum: 0x53B3A1B3
	Offset: 0x6C80
	Size: 0x29D
	Parameters: 4
	Flags: None
*/
function PositionQuery_Filter_DistAwayFromTarget(queryResult, targetArray, Distance, var_9561cba2)
{
	if(!isdefined(targetArray) || !IsArray(targetArray))
	{
		return;
	}
	foreach(point in queryResult.data)
	{
		tooClose = 0;
		foreach(target in targetArray)
		{
			origin = undefined;
			if(IsVec(target))
			{
				origin = target;
			}
			else if(IsSentient(target) && isalive(target))
			{
				origin = target.origin;
			}
			else if(IsEntity(target))
			{
				origin = target.origin;
			}
			if(isdefined(origin) && Distance2DSquared(point.origin, origin) < Distance * Distance)
			{
				tooClose = 1;
				break;
			}
		}
		if(tooClose)
		{
			/#
				if(!isdefined(point._scoreDebug))
				{
					point._scoreDebug = [];
				}
				point._scoreDebug["Dev Block strings are not supported"] = var_9561cba2;
			#/
			point.score = point.score + var_9561cba2;
		}
	}
}

/*
	Name: function_764546dd
	Namespace: vehicle_ai
	Checksum: 0x1815BE84
	Offset: 0x6F28
	Size: 0x121
	Parameters: 4
	Flags: None
*/
function function_764546dd(origin, enemy, engagementHeightMin, engagementHeightMax)
{
	if(!isdefined(enemy))
	{
		return undefined;
	}
	result = 0;
	var_766f5391 = 0.5 * self.settings.engagementHeightMin + self.settings.engagementHeightMax;
	half_height = Abs(engagementHeightMax - var_766f5391);
	targetHeight = enemy.origin[2] + var_766f5391;
	var_2aad727d = Abs(origin[2] - targetHeight);
	if(var_2aad727d > half_height)
	{
		result = var_2aad727d - half_height;
	}
	return result;
}

/*
	Name: PositionQuery_Filter_EngagementHeight
	Namespace: vehicle_ai
	Checksum: 0xBEA00DE8
	Offset: 0x7058
	Size: 0x185
	Parameters: 4
	Flags: None
*/
function PositionQuery_Filter_EngagementHeight(queryResult, enemy, engagementHeightMin, engagementHeightMax)
{
	if(!isdefined(enemy))
	{
		return;
	}
	var_766f5391 = 0.5 * engagementHeightMin + engagementHeightMax;
	half_height = Abs(engagementHeightMax - var_766f5391);
	foreach(point in queryResult.data)
	{
		point.distEngagementHeight = 0;
		targetHeight = enemy.origin[2] + var_766f5391;
		var_2aad727d = Abs(point.origin[2] - targetHeight);
		if(var_2aad727d > half_height)
		{
			point.distEngagementHeight = var_2aad727d - half_height;
		}
	}
}

/*
	Name: function_8088e85d
	Namespace: vehicle_ai
	Checksum: 0x681EF66D
	Offset: 0x71E8
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function function_8088e85d(queryResult, tolerance)
{
	if(!isdefined(tolerance))
	{
		tolerance = 1;
	}
	for(i = 0; i < queryResult.data.size; i++)
	{
		point = queryResult.data[i];
		if(point.distToGoal > tolerance)
		{
			ArrayRemoveIndex(queryResult.data, i);
			i--;
		}
	}
}

/*
	Name: UpdatePersonalThreatBias_AttackerLockedOnToMe
	Namespace: vehicle_ai
	Checksum: 0xE4BA196B
	Offset: 0x72B0
	Size: 0x4B
	Parameters: 4
	Flags: None
*/
function UpdatePersonalThreatBias_AttackerLockedOnToMe(var_9f84050f, var_1e08b2fd, var_9c5ca2c, var_cee3c9e9)
{
	function_c8b0c8c2(self.locked_on, var_9f84050f, var_1e08b2fd, var_9c5ca2c, var_cee3c9e9);
}

/*
	Name: UpdatePersonalThreatBias_AttackerLockingOnToMe
	Namespace: vehicle_ai
	Checksum: 0xFB1493EA
	Offset: 0x7308
	Size: 0x4B
	Parameters: 4
	Flags: None
*/
function UpdatePersonalThreatBias_AttackerLockingOnToMe(var_9f84050f, var_1e08b2fd, var_9c5ca2c, var_cee3c9e9)
{
	function_c8b0c8c2(self.locking_on, var_9f84050f, var_1e08b2fd, var_9c5ca2c, var_cee3c9e9);
}

/*
	Name: function_c8b0c8c2
	Namespace: vehicle_ai
	Checksum: 0xBFCE0F29
	Offset: 0x7360
	Size: 0x187
	Parameters: 5
	Flags: None
*/
function function_c8b0c8c2(client_flags, var_9f84050f, var_1e08b2fd, var_9c5ca2c, var_cee3c9e9)
{
	if(!isdefined(var_9c5ca2c))
	{
		var_9c5ca2c = 1;
	}
	if(!isdefined(var_cee3c9e9))
	{
		var_cee3c9e9 = 1;
	}
	/#
		Assert(isdefined(client_flags));
	#/
	remaining_flags_to_process = client_flags;
	for(i = 0; remaining_flags_to_process && i < level.players.size; i++)
	{
		attacker = level.players[i];
		if(isdefined(attacker))
		{
			client_flag = 1 << attacker GetEntityNumber();
			if(client_flag & remaining_flags_to_process)
			{
				self SetPersonalThreatBias(attacker, Int(var_9f84050f), var_1e08b2fd);
				if(var_9c5ca2c)
				{
					self GetPerfectInfo(attacker, var_cee3c9e9);
				}
				~client_flag;
				remaining_flags_to_process = remaining_flags_to_process & client_flag;
			}
		}
	}
}

/*
	Name: UpdatePersonalThreatBias_Bots
	Namespace: vehicle_ai
	Checksum: 0x7E52AE37
	Offset: 0x74F0
	Size: 0xD9
	Parameters: 2
	Flags: None
*/
function UpdatePersonalThreatBias_Bots(var_9f84050f, var_1e08b2fd)
{
	/#
		foreach(player in level.players)
		{
			if(player util::is_bot())
			{
				self SetPersonalThreatBias(player, Int(var_9f84050f), var_1e08b2fd);
			}
		}
	#/
}

/*
	Name: target_hijackers
	Namespace: vehicle_ai
	Checksum: 0x53C5153D
	Offset: 0x75D8
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function target_hijackers()
{
	self endon("death");
	while(1)
	{
		self waittill("hash_4a129f22", var_66abe754);
		self GetPerfectInfo(var_66abe754, 1);
		if(isPlayer(var_66abe754))
		{
			self SetPersonalThreatBias(var_66abe754, 1500, 4);
		}
	}
}

