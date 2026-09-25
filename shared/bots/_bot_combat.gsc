#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace bot_combat;

/*
	Name: combat_think
	Namespace: bot_combat
	Checksum: 0xB9EEA440
	Offset: 0x180
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function combat_think()
{
	if(self has_threat())
	{
		if(self threat_is_alive())
		{
			self update_threat();
		}
		else
		{
			self thread [[level.botThreatDead]]();
		}
	}
	if(!self has_threat() && !self get_new_threat())
	{
		return;
	}
	else if(self has_threat())
	{
		if(!self threat_visible() || self.bot.threat.lastDistanceSq > level.botSettings.threatRadiusMaxSq)
		{
			self get_new_threat(level.botSettings.threatRadiusMin);
		}
	}
	if(self threat_visible())
	{
		self thread [[level.botUpdateThreatGoal]]();
		self thread [[level.botThreatEngage]]();
	}
	else
	{
		self thread [[level.botThreatLost]]();
	}
}

/*
	Name: is_alive
	Namespace: bot_combat
	Checksum: 0xCEC84A4F
	Offset: 0x2F8
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function is_alive(entity)
{
	return isalive(entity);
}

/*
	Name: get_bot_threats
	Namespace: bot_combat
	Checksum: 0xBE4C1B4
	Offset: 0x328
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function get_bot_threats(maxDistance)
{
	if(!isdefined(maxDistance))
	{
		maxDistance = 0;
	}
	return self botGetThreats(maxDistance);
}

/*
	Name: get_ai_threats
	Namespace: bot_combat
	Checksum: 0x49DCB002
	Offset: 0x368
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function get_ai_threats()
{
	return GetAITeamArray("axis");
}

/*
	Name: ignore_none
	Namespace: bot_combat
	Checksum: 0xADDE8142
	Offset: 0x390
	Size: 0xD
	Parameters: 1
	Flags: None
*/
function ignore_none(entity)
{
	return 0;
}

/*
	Name: ignore_non_sentient
	Namespace: bot_combat
	Checksum: 0xDE59D988
	Offset: 0x3A8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function ignore_non_sentient(entity)
{
	return !IsSentient(entity);
}

/*
	Name: has_threat
	Namespace: bot_combat
	Checksum: 0xE2E3CB35
	Offset: 0x3D8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function has_threat()
{
	return isdefined(self.bot.threat.entity);
}

/*
	Name: threat_visible
	Namespace: bot_combat
	Checksum: 0x301A4EB5
	Offset: 0x400
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function threat_visible()
{
	return self has_threat() && self.bot.threat.visible;
}

/*
	Name: threat_is_alive
	Namespace: bot_combat
	Checksum: 0x48B413B8
	Offset: 0x440
	Size: 0x81
	Parameters: 0
	Flags: None
*/
function threat_is_alive()
{
	if(!self has_threat())
	{
		return 0;
	}
	if(isdefined(level.botThreatIsAlive))
	{
		return self [[level.botThreatIsAlive]](self.bot.threat.entity);
	}
	return isalive(self.bot.threat.entity);
}

/*
	Name: set_threat
	Namespace: bot_combat
	Checksum: 0xE7593144
	Offset: 0x4D0
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function set_threat(entity)
{
	self.bot.threat.entity = entity;
	self.bot.threat.aimOffset = self get_aim_offset(entity);
	self update_threat(1);
}

/*
	Name: clear_threat
	Namespace: bot_combat
	Checksum: 0xE2BAABCE
	Offset: 0x550
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function clear_threat()
{
	self.bot.threat.entity = undefined;
	self clear_threat_aim();
	self BotLookForward();
}

/*
	Name: update_threat
	Namespace: bot_combat
	Checksum: 0x2648F662
	Offset: 0x5A0
	Size: 0x3EF
	Parameters: 1
	Flags: None
*/
function update_threat(newThreat)
{
	if(isdefined(newThreat) && newThreat)
	{
		self.bot.threat.wasVisible = 0;
		self clear_threat_aim();
	}
	else
	{
		self.bot.threat.wasVisible = self.bot.threat.visible;
	}
	velocity = self.bot.threat.entity GetVelocity();
	distanceSq = DistanceSquared(self GetEye(), self.bot.threat.entity.origin);
	if(isdefined(level.botSettings.thinkInterval))
	{
	}
	else
	{
	}
	predictionTime = 0.05;
	predictedPosition = self.bot.threat.entity.origin + velocity * predictionTime;
	aimPoint = predictedPosition + self.bot.threat.aimOffset;
	dot = self bot::fwd_dot(aimPoint);
	fov = self BotGetFov();
	if(isdefined(newThreat) && newThreat)
	{
		self.bot.threat.visible = 1;
	}
	else if(dot < fov || !self BotSightTrace(self.bot.threat.entity))
	{
		self.bot.threat.visible = 0;
		return;
	}
	self.bot.threat.visible = 1;
	self.bot.threat.lastVisibleTime = GetTime();
	self.bot.threat.lastDistanceSq = distanceSq;
	self.bot.threat.lastVelocity = velocity;
	self.bot.threat.lastPosition = predictedPosition;
	self.bot.threat.aimPoint = aimPoint;
	self.bot.threat.dot = dot;
	weapon = self GetCurrentWeapon();
	weaponRange = weapon_range(weapon);
	self.bot.threat.inRange = distanceSq < weaponRange * weaponRange;
	weaponRangeClose = weapon_range_close(weapon);
	self.bot.threat.inCloseRange = distanceSq < weaponRangeClose * weaponRangeClose;
}

/*
	Name: get_new_threat
	Namespace: bot_combat
	Checksum: 0x81AEE3B0
	Offset: 0x998
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function get_new_threat(maxDistance)
{
	entity = self get_greatest_threat(maxDistance);
	if(isdefined(entity) && entity !== self.bot.threat.entity)
	{
		self set_threat(entity);
		return 1;
	}
	return 0;
}

/*
	Name: get_greatest_threat
	Namespace: bot_combat
	Checksum: 0xB9522EEE
	Offset: 0xA20
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function get_greatest_threat(maxDistance)
{
	threats = self [[level.botGetThreats]](maxDistance);
	if(!isdefined(threats))
	{
		return undefined;
	}
	foreach(entity in threats)
	{
		if(self [[level.botIgnoreThreat]](entity))
		{
			continue;
		}
		return entity;
	}
	return undefined;
}

/*
	Name: engage_threat
	Namespace: bot_combat
	Checksum: 0xC002A5FD
	Offset: 0xAF8
	Size: 0x4BB
	Parameters: 0
	Flags: None
*/
function engage_threat()
{
	if(!self.bot.threat.wasVisible && self.bot.threat.visible && !self IsThrowingGrenade() && !self fragButtonPressed() && !self SecondaryOffhandButtonPressed() && !self IsSwitchingWeapons())
	{
		visibleRoll = RandomInt(100);
		if(isdefined(level.botSettings.lethalWeight))
		{
		}
		else
		{
		}
		rollWeight = 0;
		if(visibleRoll < rollWeight && self.bot.threat.lastDistanceSq >= level.botSettings.lethalDistanceMinSq && self.bot.threat.lastDistanceSq <= level.botSettings.lethalDistanceMaxSq && self GetWeaponAmmoStock(self.grenadeTypePrimary))
		{
			self clear_threat_aim();
			self throw_grenade(self.grenadeTypePrimary, self.bot.threat.lastPosition);
			return;
		}
		visibleRoll = visibleRoll - rollWeight;
		if(isdefined(level.botSettings.tacticalWeight))
		{
		}
		else
		{
		}
		rollWeight = 0;
		if(visibleRoll >= 0 && visibleRoll < rollWeight && self.bot.threat.lastDistanceSq >= level.botSettings.tacticalDistanceMinSq && self.bot.threat.lastDistanceSq <= level.botSettings.tacticalDistanceMaxSq && self GetWeaponAmmoStock(self.grenadeTypeSecondary))
		{
			self clear_threat_aim();
			self throw_grenade(self.grenadeTypeSecondary, self.bot.threat.lastPosition);
			return;
		}
		self.bot.threat.aimOffset = self get_aim_offset(self.bot.threat.entity);
	}
	if(self fragButtonPressed())
	{
		self throw_grenade(self.grenadeTypePrimary, self.bot.threat.lastPosition);
		return;
	}
	else if(self SecondaryOffhandButtonPressed())
	{
		self throw_grenade(self.grenadeTypeSecondary, self.bot.threat.lastPosition);
		return;
	}
	self update_weapon_aim();
	if(self IsReloading() || self IsSwitchingWeapons() || self IsThrowingGrenade() || self fragButtonPressed() || self SecondaryOffhandButtonPressed() || self IsMeleeing())
	{
		return;
	}
	if(melee_attack())
	{
		return;
	}
	self update_weapon_ads();
	self fire_weapon();
}

/*
	Name: update_threat_goal
	Namespace: bot_combat
	Checksum: 0x95CE1B32
	Offset: 0xFC0
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function update_threat_goal()
{
	if(self BotUnderManualControl())
	{
		return;
	}
	if(self BotGoalSet() && (self.bot.threat.wasVisible || !self.bot.threat.visible))
	{
		return;
	}
	radius = get_threat_goal_radius();
	radiusSq = radius * radius;
	threatDistSq = Distance2DSquared(self.origin, self.bot.threat.lastPosition);
	if(threatDistSq < radiusSq || !self BotSetGoal(self.bot.threat.lastPosition, radius))
	{
		self combat_strafe();
	}
}

/*
	Name: get_threat_goal_radius
	Namespace: bot_combat
	Checksum: 0x9CCB08DE
	Offset: 0x1108
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function get_threat_goal_radius()
{
	weapon = self GetCurrentWeapon();
	if(RandomInt(100) < 10 || weapon.weapClass == "melee" || (!self GetWeaponAmmoClip(weapon) && !self GetWeaponAmmoStock(weapon)))
	{
		return level.botSettings.meleeRange;
	}
	return randomIntRange(level.botSettings.threatRadiusMin, level.botSettings.threatRadiusMax);
}

/*
	Name: fire_weapon
	Namespace: bot_combat
	Checksum: 0x5B1C39CB
	Offset: 0x11F8
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function fire_weapon()
{
	if(!self.bot.threat.inRange)
	{
		return;
	}
	weapon = self GetCurrentWeapon();
	if(weapon == level.weaponNone || !self GetWeaponAmmoClip(weapon) || self.bot.threat.dot < weapon_fire_dot(weapon))
	{
		return;
	}
	if(weapon.fireType == "Single Shot" || weapon.fireType == "Burst" || weapon.fireType == "Charge Shot")
	{
		if(self AttackButtonPressed())
		{
			return;
		}
	}
	self bot::press_attack_button();
	if(weapon.isDualWield)
	{
		self bot::press_throw_button();
	}
}

/*
	Name: melee_attack
	Namespace: bot_combat
	Checksum: 0x9120BE55
	Offset: 0x1350
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function melee_attack()
{
	if(self.bot.threat.dot < level.botSettings.meleeDot)
	{
		return 0;
	}
	if(DistanceSquared(self.origin, self.bot.threat.lastPosition) > level.botSettings.meleeRangeSq)
	{
		return 0;
	}
	self bot::tap_melee_button();
	return 1;
}

/*
	Name: chase_threat
	Namespace: bot_combat
	Checksum: 0x15539658
	Offset: 0x13F0
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function chase_threat()
{
	if(self BotUnderManualControl())
	{
		return;
	}
	if(self.bot.threat.wasVisible && !self.bot.threat.visible)
	{
		self clear_threat_aim();
		self BotSetGoal(self.bot.threat.lastPosition);
		self bot::sprint_to_goal();
		return;
	}
	if(isdefined(level.botSettings.chaseThreatTime))
	{
	}
	else if(self.bot.threat.lastVisibleTime + 0 < GetTime())
	{
		self clear_threat();
		return;
	}
	if(!self BotGoalSet())
	{
		self bot::navmesh_wander(self.bot.threat.lastVelocity, self.botSettings.chaseWanderMin, self.botSettings.chaseWanderMax, self.botSettings.chaseWanderSpacing, self.botSettings.chaseWanderFwdDot);
		self clear_threat();
	}
}

/*
	Name: get_aim_offset
	Namespace: bot_combat
	Checksum: 0xF906A30B
	Offset: 0x15B0
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function get_aim_offset()
{
System.Exception: Unexpected non-stack operation within jump expression
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‪⁮⁮‪‪‭‎‎‍⁪⁪⁭⁮‎⁪​‎‎⁪‏⁭‪⁬⁫‏‍​‎‬‏‏​​⁫‫⁫‭‎‭⁯‮(ScriptOp )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‬‪‎⁭⁭⁮‎⁮⁭⁯‭‍⁯⁯⁪⁬‪‎⁪⁮‎⁭‬‪​‍‭⁪‮‪​‮‪⁯‪⁮⁬‪‮‏‮(Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‫⁯⁪​‍⁭​⁫‫⁯‮​‍‬‮‌‪‪‎‫⁫‎‭‫⁪‫⁪⁬‪‍⁮‏‌⁪​‎‎⁯‮‭‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: update_weapon_aim
	Namespace: bot_combat
	Checksum: 0x894DC0A8
	Offset: 0x1670
	Size: 0x1F3
	Parameters: 0
	Flags: None
*/
function update_weapon_aim()
{
	if(!isdefined(self.bot.threat.aimStartTime))
	{
		self start_threat_aim();
	}
	aimTime = GetTime() - self.bot.threat.aimStartTime;
	if(aimTime < 0)
	{
		return;
	}
	if(aimTime >= self.bot.threat.aimTime || !isdefined(self.bot.threat.aimError))
	{
		self BotLookAtPoint(self.bot.threat.aimPoint);
		return;
	}
	eyePoint = self GetEye();
	threatAngles = VectorToAngles(self.bot.threat.aimPoint - eyePoint);
	initialAngles = threatAngles + self.bot.threat.aimError;
	currAngles = VectorLerp(initialAngles, threatAngles, aimTime / self.bot.threat.aimTime);
	playerAngles = self getPlayerAngles();
	self BotSetLookAngles(AnglesToForward(currAngles));
}

/*
	Name: start_threat_aim
	Namespace: bot_combat
	Checksum: 0xD75065E7
	Offset: 0x1870
	Size: 0x19B
	Parameters: 0
	Flags: None
*/
function start_threat_aim()
{
	if(isdefined(level.botSettings.aimDelay))
	{
	}
	else
	{
	}
	self.bot.threat.aimStartTime = level.botSettings.aimDelay + 0 * 1000;
	if(isdefined(level.botSettings.aimTime))
	{
	}
	else
	{
	}
	self.bot.threat.aimTime = 0 * 1000;
	if(isdefined(level.botSettings.aimErrorMaxPitch))
	{
	}
	else if(isdefined(level.botSettings.aimErrorMinPitch))
	{
	}
	else
	{
	}
	pitchError = angleError(0, level.botSettings.aimErrorMinPitch);
	if(isdefined(level.botSettings.aimErrorMaxYaw))
	{
	}
	else if(isdefined(level.botSettings.aimErrorMinYaw))
	{
	}
	else
	{
	}
	yawError = angleError(0, level.botSettings.aimErrorMinYaw);
	self.bot.threat.aimError = (pitchError, yawError, 0);
}

/*
	Name: angleError
	Namespace: bot_combat
	Checksum: 0xFF5424A3
	Offset: 0x1A18
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function angleError(angleMin, angleMax)
{
	angle = angleMax - angleMin;
	angle = angle * RandomFloatRange(-1, 1);
	if(angle < 0)
	{
		angle = angle - angleMin;
	}
	else
	{
		angle = angle + angleMin;
	}
	return angle;
}

/*
	Name: clear_threat_aim
	Namespace: bot_combat
	Checksum: 0xD30A5D1B
	Offset: 0x1AA8
	Size: 0x69
	Parameters: 0
	Flags: None
*/
function clear_threat_aim()
{
	if(!isdefined(self.bot.threat.aimStartTime))
	{
		return;
	}
	self.bot.threat.aimStartTime = undefined;
	self.bot.threat.aimTime = undefined;
	self.bot.threat.aimError = undefined;
}

/*
	Name: bot_pre_combat
	Namespace: bot_combat
	Checksum: 0x74E72767
	Offset: 0x1B20
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function bot_pre_combat()
{
	if(self has_threat())
	{
		return;
	}
	if(isdefined(self.bot.damage.time) && self.bot.damage.time + 1500 > GetTime())
	{
		if(self has_threat() && self.bot.damage.time > self.bot.threat.lastVisibleTime)
		{
			self clear_threat();
		}
		self bot::navmesh_wander(self.bot.damage.attackDir, level.botSettings.damageWanderMin, level.botSettings.damageWanderMax, level.botSettings.damageWanderSpacing, level.botSettings.damageWanderFwdDot);
		self bot::end_sprint_to_goal();
		self clear_damage();
	}
}

/*
	Name: bot_post_combat
	Namespace: bot_combat
	Checksum: 0x99EC1590
	Offset: 0x1C90
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function bot_post_combat()
{
}

/*
	Name: update_weapon_ads
	Namespace: bot_combat
	Checksum: 0x311BB27F
	Offset: 0x1CA0
	Size: 0x103
	Parameters: 0
	Flags: None
*/
function update_weapon_ads()
{
	if(!self.bot.threat.inRange || self.bot.threat.inCloseRange)
	{
		return;
	}
	weapon = self GetCurrentWeapon();
	if(weapon == level.weaponNone || weapon.isDualWield || weapon.weapClass == "melee" || self GetWeaponAmmoClip(weapon) <= 0)
	{
		return;
	}
	if(self.bot.threat.dot < weapon_ads_dot(weapon))
	{
		return;
	}
	self bot::press_ads_button();
}

/*
	Name: weapon_ads_dot
	Namespace: bot_combat
	Checksum: 0xF6D0E3A5
	Offset: 0x1DB0
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function weapon_ads_dot(weapon)
{
	if(weapon.isSniperWeapon)
	{
		return level.botSettings.sniperAds;
	}
	else if(weapon.isRocketLauncher)
	{
		return level.botSettings.rocketLauncherAds;
	}
	switch(weapon.weapClass)
	{
		case "mg":
		{
			return level.botSettings.mgAds;
		}
		case "smg":
		{
			return level.botSettings.smgAds;
		}
		case "spread":
		{
			return level.botSettings.spreadAds;
		}
		case "pistol":
		{
			return level.botSettings.pistolAds;
		}
		case "rifle":
		{
			return level.botSettings.rifleAds;
		}
	}
	return level.botSettings.defaultAds;
}

/*
	Name: weapon_fire_dot
	Namespace: bot_combat
	Checksum: 0x4D88569
	Offset: 0x1EB8
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function weapon_fire_dot(weapon)
{
	if(weapon.isSniperWeapon)
	{
		return level.botSettings.sniperFire;
	}
	else if(weapon.isRocketLauncher)
	{
		return level.botSettings.rocketLauncherFire;
	}
	switch(weapon.weapClass)
	{
		case "mg":
		{
			return level.botSettings.mgFire;
		}
		case "smg":
		{
			return level.botSettings.smgFire;
		}
		case "spread":
		{
			return level.botSettings.spreadFire;
		}
		case "pistol":
		{
			return level.botSettings.pistolFire;
		}
		case "rifle":
		{
			return level.botSettings.rifleFire;
		}
	}
	return level.botSettings.defaultFire;
}

/*
	Name: weapon_range
	Namespace: bot_combat
	Checksum: 0x45B8FE45
	Offset: 0x1FC0
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function weapon_range(weapon)
{
	if(weapon.isSniperWeapon)
	{
		return level.botSettings.sniperRange;
	}
	else if(weapon.isRocketLauncher)
	{
		return level.botSettings.rocketLauncherRange;
	}
	switch(weapon.weapClass)
	{
		case "mg":
		{
			return level.botSettings.mgRange;
		}
		case "smg":
		{
			return level.botSettings.smgRange;
		}
		case "spread":
		{
			return level.botSettings.spreadRange;
		}
		case "pistol":
		{
			return level.botSettings.pistolRange;
		}
		case "rifle":
		{
			return level.botSettings.rifleRange;
		}
	}
	return level.botSettings.defaultRange;
}

/*
	Name: weapon_range_close
	Namespace: bot_combat
	Checksum: 0xB3567CD3
	Offset: 0x20C8
	Size: 0xFD
	Parameters: 1
	Flags: None
*/
function weapon_range_close(weapon)
{
	if(weapon.isSniperWeapon)
	{
		return level.botSettings.sniperRangeClose;
	}
	else if(weapon.isRocketLauncher)
	{
		return level.botSettings.rocketLauncherRangeClose;
	}
	switch(weapon.weapClass)
	{
		case "mg":
		{
			return level.botSettings.mgRangeClose;
		}
		case "smg":
		{
			return level.botSettings.smgRangeClose;
		}
		case "spread":
		{
			return level.botSettings.spreadRangeClose;
		}
		case "pistol":
		{
			return level.botSettings.pistolRangeClose;
		}
		case "rifle":
		{
			return level.botSettings.rifleRangeClose;
		}
	}
	return level.botSettings.defaultRangeClose;
}

/*
	Name: switch_weapon
	Namespace: bot_combat
	Checksum: 0x6E5F8073
	Offset: 0x21D0
	Size: 0x359
	Parameters: 0
	Flags: None
*/
function switch_weapon()
{
	currentWeapon = self GetCurrentWeapon();
	if(self IsSwitchingWeapons() || currentWeapon.isHeroWeapon || currentWeapon.isItem)
	{
		return 0;
	}
	weapon = bot::get_ready_gadget();
	if(weapon != level.weaponNone)
	{
		if(!isdefined(level.enemyEmpActive) || !self [[level.enemyEmpActive]]())
		{
			self bot::activate_hero_gadget(weapon);
			return 1;
		}
	}
	weapons = self GetWeaponsListPrimaries();
	if(currentWeapon == level.weaponNone || currentWeapon.weapClass == "melee" || currentWeapon.weapClass == "rocketLauncher" || currentWeapon.weapClass == "pistol")
	{
		foreach(weapon in weapons)
		{
			if(weapon == currentWeapon)
			{
				continue;
			}
			if(self GetWeaponAmmoClip(weapon) || self GetWeaponAmmoStock(weapon))
			{
				self BotSwitchToWeapon(weapon);
				return 1;
			}
		}
		return 0;
	}
	currentAmmoStock = self GetWeaponAmmoStock(currentWeapon);
	if(currentAmmoStock)
	{
		return 0;
	}
	switchFrac = 0.3;
	currentClipFrac = self weapon_clip_frac(currentWeapon);
	if(currentClipFrac > switchFrac)
	{
		return 0;
	}
	foreach(weapon in weapons)
	{
		if(self GetWeaponAmmoStock(weapon) || self weapon_clip_frac(weapon) > switchFrac)
		{
			self BotSwitchToWeapon(weapon);
			return 1;
		}
	}
	return 0;
}

/*
	Name: threat_switch_weapon
	Namespace: bot_combat
	Checksum: 0xE97DA6C4
	Offset: 0x2538
	Size: 0x249
	Parameters: 0
	Flags: None
*/
function threat_switch_weapon()
{
	currentWeapon = self GetCurrentWeapon();
	if(self IsSwitchingWeapons() || self GetWeaponAmmoClip(currentWeapon) || currentWeapon.isItem)
	{
		return;
	}
	currentAmmoStock = self GetWeaponAmmoStock(currentWeapon);
	weapons = self GetWeaponsListPrimaries();
	foreach(weapon in weapons)
	{
		if(weapon == currentWeapon || weapon.requireLockOnToFire)
		{
			continue;
		}
		if(weapon.weapClass == "melee")
		{
			if(currentAmmoStock && randomIntRange(0, 100) < 75)
			{
				continue;
			}
		}
		else if(!self GetWeaponAmmoClip(weapon) && currentAmmoStock)
		{
			continue;
		}
		weaponAmmoStock = self GetWeaponAmmoStock(weapon);
		if(!currentAmmoStock && !weaponAmmoStock)
		{
			continue;
		}
		if(weapon.weapClass != "pistol" && randomIntRange(0, 100) < 75)
		{
			continue;
		}
		self BotSwitchToWeapon(weapon);
	}
}

/*
	Name: reload_weapon
	Namespace: bot_combat
	Checksum: 0xFE651764
	Offset: 0x2790
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function reload_weapon()
{
	weapon = self GetCurrentWeapon();
	if(!self GetWeaponAmmoStock(weapon))
	{
		return 0;
	}
	reloadFrac = 0.5;
	if(weapon.weapClass == "mg")
	{
		reloadFrac = 0.25;
	}
	if(self weapon_clip_frac(weapon) < reloadFrac)
	{
		self bot::tap_reload_button();
		return 1;
	}
	return 0;
}

/*
	Name: weapon_clip_frac
	Namespace: bot_combat
	Checksum: 0xF355A527
	Offset: 0x2868
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function weapon_clip_frac(weapon)
{
	if(weapon.clipSize <= 0)
	{
		return 1;
	}
	clipAmmo = self GetWeaponAmmoClip(weapon);
	return clipAmmo / weapon.clipSize;
}

/*
	Name: throw_grenade
	Namespace: bot_combat
	Checksum: 0xF6FBDE65
	Offset: 0x28D8
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function throw_grenade(weapon, target)
{
	if(!isdefined(self.bot.threat.aimStartTime))
	{
		self aim_grenade(weapon, target);
		self press_grenade_button(weapon);
		return;
	}
	if(self.bot.threat.aimStartTime + self.bot.threat.aimTime > GetTime())
	{
		return;
	}
	if(self will_hit_target(weapon, target))
	{
		return;
	}
	self press_grenade_button(weapon);
}

/*
	Name: press_grenade_button
	Namespace: bot_combat
	Checksum: 0xFE18D520
	Offset: 0x29C0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function press_grenade_button(weapon)
{
	if(weapon == self.grenadeTypePrimary)
	{
		self bot::press_frag_button();
	}
	else if(weapon == self.grenadeTypeSecondary)
	{
		self bot::press_offhand_button();
	}
}

/*
	Name: aim_grenade
	Namespace: bot_combat
	Checksum: 0x1CA88626
	Offset: 0x2A28
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function aim_grenade(weapon, target)
{
	aimPeak = target + VectorScale((0, 0, 1), 100);
	self.bot.threat.aimStartTime = GetTime();
	self.bot.threat.aimTime = 1500;
	self BotSetLookAnglesFromPoint(aimPeak);
}

/*
	Name: will_hit_target
	Namespace: bot_combat
	Checksum: 0x88297306
	Offset: 0x2AB8
	Size: 0x157
	Parameters: 2
	Flags: None
*/
function will_hit_target(weapon, target)
{
	velocity = get_throw_velocity(weapon);
	throwOrigin = self GetEye();
	xyDist = Distance2D(throwOrigin, target);
	xySpeed = Distance2D(velocity, (0, 0, 0));
	t = xyDist / xySpeed;
	gravity = GetDvarFloat("bg_gravity") * -1;
	tHeight = throwOrigin[2] + velocity[2] * t + gravity * t * t * 0.5;
	return Abs(tHeight - target[2]) < 20;
}

/*
	Name: get_throw_velocity
	Namespace: bot_combat
	Checksum: 0x1B6210CD
	Offset: 0x2C18
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function get_throw_velocity(weapon)
{
	angles = self getPlayerAngles();
	FORWARD = AnglesToForward(angles);
	return FORWARD * 928;
}

/*
	Name: get_lethal_grenade
	Namespace: bot_combat
	Checksum: 0x78DBAD39
	Offset: 0x2C80
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function get_lethal_grenade()
{
	weaponsList = self GetWeaponsList();
	foreach(weapon in weaponsList)
	{
		if(weapon.type == "grenade" && self GetWeaponAmmoStock(weapon))
		{
			return weapon;
		}
	}
	return level.weaponNone;
}

/*
	Name: wait_damage_loop
	Namespace: bot_combat
	Checksum: 0x227B42DA
	Offset: 0x2D68
	Size: 0x193
	Parameters: 0
	Flags: None
*/
function wait_damage_loop()
{
	self endon("death");
	level endon("game_ended");
	while(1)
	{
		self waittill("damage", damage, attacker, direction, point, mod, unused1, unused2, unused3, weapon, flags, inflictor);
		self.bot.damage.entity = attacker;
		self.bot.damage.amount = damage;
		self.bot.damage.attackDir = VectorNormalize(attacker.origin - self.origin);
		self.bot.damage.weapon = weapon;
		self.bot.damage.mod = mod;
		self.bot.damage.time = GetTime();
		self thread [[level.onBotDamage]]();
	}
}

/*
	Name: clear_damage
	Namespace: bot_combat
	Checksum: 0x3923B7D8
	Offset: 0x2F08
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function clear_damage()
{
	self.bot.damage.entity = undefined;
	self.bot.damage.amount = undefined;
	self.bot.damage.direction = undefined;
	self.bot.damage.weapon = undefined;
	self.bot.damage.mod = undefined;
	self.bot.damage.time = undefined;
}

/*
	Name: combat_strafe
	Namespace: bot_combat
	Checksum: 0x5510F30C
	Offset: 0x2FA8
	Size: 0x393
	Parameters: 5
	Flags: None
*/
function combat_strafe(radiusMin, radiusMax, spacing, sideDotMin, sideDotMax)
{
	if(!isdefined(radiusMin))
	{
		if(isdefined(level.botSettings.strafeMin))
		{
		}
		else
		{
		}
		radiusMin = 0;
	}
	if(!isdefined(radiusMax))
	{
		if(isdefined(level.botSettings.strafeMax))
		{
		}
		else
		{
		}
		radiusMax = 0;
	}
	if(!isdefined(spacing))
	{
		if(isdefined(level.botSettings.strafeSpacing))
		{
		}
		else
		{
		}
		spacing = 0;
	}
	if(!isdefined(sideDotMin))
	{
		if(isdefined(level.botSettings.strafeSideDotMin))
		{
		}
		else
		{
		}
		sideDotMin = 0;
	}
	if(!isdefined(sideDotMax))
	{
		if(isdefined(level.botSettings.strafeSideDotMax))
		{
		}
		else
		{
		}
		sideDotMax = 0;
	}
	fwd = AnglesToForward(self.angles);
	/#
	#/
	queryResult = PositionQuery_Source_Navigation(self.origin, radiusMin, radiusMax, 64, spacing, self);
	best_point = undefined;
	foreach(point in queryResult.data)
	{
		moveDir = VectorNormalize(point.origin - self.origin);
		dot = VectorDot(moveDir, fwd);
		if(dot >= sideDotMin && dot <= sideDotMax)
		{
			point.score = mapfloat(radiusMin, radiusMax, 0, 50, point.distToOrigin2D);
			point.score = point.score + RandomFloatRange(0, 50);
		}
		/#
		#/
		if(!isdefined(best_point) || point.score > best_point.score)
		{
			best_point = point;
		}
	}
	if(isdefined(best_point))
	{
		/#
		#/
		self BotSetGoal(best_point.origin);
		self bot::end_sprint_to_goal();
	}
}

