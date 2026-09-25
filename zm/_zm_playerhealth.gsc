#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_perks;

#namespace zm_playerhealth;

/*
	Name: __init__sytem__
	Namespace: zm_playerhealth
	Checksum: 0x31E42B91
	Offset: 0x2E8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_playerhealth", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_playerhealth
	Checksum: 0x1E9DB964
	Offset: 0x328
	Size: 0x33B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "sndZombieHealth", 21000, 1, "int");
	level.global_damage_func_ads = &empty_kill_func;
	level.global_damage_func = &empty_kill_func;
	level.difficultyType[0] = "easy";
	level.difficultyType[1] = "normal";
	level.difficultyType[2] = "hardened";
	level.difficultyType[3] = "veteran";
	level.difficultyString["easy"] = &"GAMESKILL_EASY";
	level.difficultyString["normal"] = &"GAMESKILL_NORMAL";
	level.difficultyString["hardened"] = &"GAMESKILL_HARDENED";
	level.difficultyString["veteran"] = &"GAMESKILL_VETERAN";
	/#
		thread playerHealthDebug();
	#/
	level.gameskill = 1;
	switch(level.gameskill)
	{
		case 0:
		{
			SetDvar("currentDifficulty", "easy");
			break;
		}
		case 1:
		{
			SetDvar("currentDifficulty", "normal");
			break;
		}
		case 2:
		{
			SetDvar("currentDifficulty", "hardened");
			break;
		}
		case 3:
		{
			SetDvar("currentDifficulty", "veteran");
			break;
		}
	}
	/#
		print("Dev Block strings are not supported" + level.gameskill);
	#/
	level.player_deathInvulnerableTime = 1700;
	level.longRegenTime = 5000;
	level.healthOverlayCutoff = 0.2;
	level.invulTime_preShield = 0.35;
	level.invulTime_onShield = 0.5;
	level.invulTime_postShield = 0.3;
	level.playerHealth_RegularRegenDelay = 2400;
	level.worthyDamageRatio = 0.1;
	callback::on_spawned(&on_player_spawned);
	if(!isdefined(level.vsmgr_prio_overlay_zm_player_health_blur))
	{
		level.vsmgr_prio_overlay_zm_player_health_blur = 22;
	}
	visionset_mgr::register_info("overlay", "zm_health_blur", 1, level.vsmgr_prio_overlay_zm_player_health_blur, 1, 1, &visionset_mgr::ramp_in_out_thread_per_player, 1);
}

/*
	Name: on_player_spawned
	Namespace: zm_playerhealth
	Checksum: 0xC7762652
	Offset: 0x670
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 0);
	self notify("noHealthOverlay");
	self thread playerHealthRegen();
}

/*
	Name: player_health_visionset
	Namespace: zm_playerhealth
	Checksum: 0xB14FA474
	Offset: 0x6C0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function player_health_visionset()
{
	visionset_mgr::deactivate("overlay", "zm_health_blur", self);
	visionset_mgr::activate("overlay", "zm_health_blur", self, 0, 1, 1);
}

/*
	Name: playerHurtcheck
	Namespace: zm_playerhealth
	Checksum: 0x8AF64608
	Offset: 0x720
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function playerHurtcheck()
{
	self endon("noHealthOverlay");
	self.hurtAgain = 0;
	for(;;)
	{
		self waittill("damage", amount, attacker, dir, point, mod);
		if(isdefined(attacker) && isPlayer(attacker) && attacker.team == self.team)
		{
			continue;
		}
		self.hurtAgain = 1;
		self.damagePoint = point;
		self.damageAttacker = attacker;
	}
}

/*
	Name: playerHealthRegen
	Namespace: zm_playerhealth
	Checksum: 0x8D589359
	Offset: 0x7F8
	Size: 0x72F
	Parameters: 0
	Flags: None
*/
function playerHealthRegen()
{
	self notify("playerHealthRegen");
	self endon("playerHealthRegen");
	self endon("death");
	self endon("disconnect");
	if(!isdefined(self.flag))
	{
		self.flag = [];
		self.flags_lock = [];
	}
	if(!isdefined(self.flag["player_has_red_flashing_overlay"]))
	{
		self flag::init("player_has_red_flashing_overlay");
		self flag::init("player_is_invulnerable");
	}
	self flag::clear("player_has_red_flashing_overlay");
	self flag::clear("player_is_invulnerable");
	self thread healthoverlay();
	oldratio = 1;
	health_add = 0;
	regenRate = 0.1;
	veryHurt = 0;
	playerJustGotRedFlashing = 0;
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	self thread playerHurtcheck();
	if(!isdefined(self.veryHurt))
	{
		self.veryHurt = 0;
	}
	self.boltHit = 0;
	if(GetDvarString("scr_playerInvulTimeScale") == "")
	{
		SetDvar("scr_playerInvulTimeScale", 1);
	}
	playerInvulTimeScale = GetDvarFloat("scr_playerInvulTimeScale");
	for(;;)
	{
		wait(0.05);
		waittillframeend;
		if(self.health == self.maxhealth)
		{
			if(self flag::get("player_has_red_flashing_overlay"))
			{
				self clientfield::set_to_player("sndZombieHealth", 0);
				self flag::clear("player_has_red_flashing_overlay");
			}
			lastinvulratio = 1;
			playerJustGotRedFlashing = 0;
			veryHurt = 0;
			continue;
		}
		if(self.health <= 0)
		{
			/#
				showHitLog();
			#/
			return;
		}
		wasVeryHurt = veryHurt;
		health_ratio = self.health / self.maxhealth;
		if(health_ratio <= level.healthOverlayCutoff)
		{
			veryHurt = 1;
			if(!wasVeryHurt)
			{
				hurtTime = GetTime();
				self startfadingblur(3.6, 2);
				self clientfield::set_to_player("sndZombieHealth", 1);
				self flag::set("player_has_red_flashing_overlay");
				playerJustGotRedFlashing = 1;
			}
		}
		if(self.hurtAgain)
		{
			hurtTime = GetTime();
			self.hurtAgain = 0;
		}
		if(health_ratio >= oldratio)
		{
			if(GetTime() - hurtTime < level.playerHealth_RegularRegenDelay)
			{
				continue;
			}
			if(veryHurt)
			{
				self.veryHurt = 1;
				newHealth = health_ratio;
				if(GetTime() > hurtTime + level.longRegenTime)
				{
					newHealth = newHealth + regenRate;
				}
			}
			else
			{
				newHealth = 1;
				self.veryHurt = 0;
			}
			if(newHealth > 1)
			{
				newHealth = 1;
			}
			if(newHealth <= 0)
			{
				return;
			}
			/#
				if(newHealth > health_ratio)
				{
					logRegen(newHealth);
				}
			#/
			self setnormalhealth(newHealth);
			oldratio = self.health / self.maxhealth;
			continue;
		}
		invulWorthyHealthDrop = lastinvulratio - health_ratio > level.worthyDamageRatio;
		if(self.health <= 1)
		{
			self setnormalhealth(2 / self.maxhealth);
			invulWorthyHealthDrop = 1;
			/#
				if(!isdefined(level.player_deathInvulnerableTimeout))
				{
					level.player_deathInvulnerableTimeout = 0;
				}
				if(level.player_deathInvulnerableTimeout < GetTime())
				{
					level.player_deathInvulnerableTimeout = GetTime() + GetDvarInt("Dev Block strings are not supported");
				}
			#/
		}
		oldratio = self.health / self.maxhealth;
		level notify("hit_again");
		health_add = 0;
		hurtTime = GetTime();
		self startfadingblur(3, 0.8);
		if(!invulWorthyHealthDrop || playerInvulTimeScale <= 0)
		{
			/#
				logHit(self.health, 0);
			#/
			continue;
		}
		if(self flag::get("player_is_invulnerable"))
		{
			continue;
		}
		self flag::set("player_is_invulnerable");
		level notify("player_becoming_invulnerable");
		if(playerJustGotRedFlashing)
		{
			invulTime = level.invulTime_onShield;
			playerJustGotRedFlashing = 0;
		}
		else if(veryHurt)
		{
			invulTime = level.invulTime_postShield;
		}
		else
		{
			invulTime = level.invulTime_preShield;
		}
		invulTime = invulTime * playerInvulTimeScale;
		/#
			logHit(self.health, invulTime);
		#/
		lastinvulratio = self.health / self.maxhealth;
		self thread playerInvul(invulTime);
	}
}

/*
	Name: playerInvul
	Namespace: zm_playerhealth
	Checksum: 0x7C3C6426
	Offset: 0xF30
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function playerInvul(timer)
{
	self endon("death");
	self endon("disconnect");
	if(timer > 0)
	{
		/#
			level.playerInvulTimeEnd = GetTime() + timer * 1000;
		#/
		wait(timer);
	}
	self flag::clear("player_is_invulnerable");
}

/*
	Name: healthoverlay
	Namespace: zm_playerhealth
	Checksum: 0x5BB3085F
	Offset: 0xFA8
	Size: 0x1DF
	Parameters: 0
	Flags: None
*/
function healthoverlay()
{
	self endon("disconnect");
	self endon("noHealthOverlay");
	if(!isdefined(self._health_overlay))
	{
		self._health_overlay = newClientHudElem(self);
		self._health_overlay.x = 0;
		self._health_overlay.y = 0;
		self._health_overlay SetShader("overlay_low_health", 640, 480);
		self._health_overlay.alignX = "left";
		self._health_overlay.alignY = "top";
		self._health_overlay.horzAlign = "fullscreen";
		self._health_overlay.vertAlign = "fullscreen";
		self._health_overlay.alpha = 0;
	}
	overlay = self._health_overlay;
	self thread healthOverlay_remove(overlay);
	self thread watchHideRedFlashingOverlay(overlay);
	pulseTime = 0.8;
	while(overlay.alpha > 0)
	{
		overlay fadeOverTime(0.5);
		overlay.alpha = 0;
		self flag::wait_till("player_has_red_flashing_overlay");
		self redFlashingOverlay(overlay);
	}
}

/*
	Name: fadeFunc
	Namespace: zm_playerhealth
	Checksum: 0x7E454E0B
	Offset: 0x1190
	Size: 0x23F
	Parameters: 4
	Flags: None
*/
function fadeFunc(overlay, severity, mult, hud_scaleOnly)
{
	pulseTime = 0.8;
	scaleMin = 0.5;
	fadeInTime = pulseTime * 0.1;
	stayFullTime = pulseTime * 0.1 + severity * 0.2;
	fadeOutHalfTime = pulseTime * 0.1 + severity * 0.1;
	fadeOutFullTime = pulseTime * 0.3;
	remainingTime = pulseTime - fadeInTime - stayFullTime - fadeOutHalfTime - fadeOutFullTime;
	/#
		Assert(remainingTime >= -0.001);
	#/
	if(remainingTime < 0)
	{
		remainingTime = 0;
	}
	halfAlpha = 0.8 + severity * 0.1;
	leastAlpha = 0.5 + severity * 0.3;
	overlay fadeOverTime(fadeInTime);
	overlay.alpha = mult * 1;
	wait(fadeInTime + stayFullTime);
	overlay fadeOverTime(fadeOutHalfTime);
	overlay.alpha = mult * halfAlpha;
	wait(fadeOutHalfTime);
	overlay fadeOverTime(fadeOutFullTime);
	overlay.alpha = mult * leastAlpha;
	wait(fadeOutFullTime);
	wait(remainingTime);
}

/*
	Name: watchHideRedFlashingOverlay
	Namespace: zm_playerhealth
	Checksum: 0x58CBCEC4
	Offset: 0x13D8
	Size: 0xAD
	Parameters: 1
	Flags: None
*/
function watchHideRedFlashingOverlay(overlay)
{
	self endon("death_or_disconnect");
	while(isdefined(overlay))
	{
		self waittill("clear_red_flashing_overlay");
		self clientfield::set_to_player("sndZombieHealth", 0);
		self flag::clear("player_has_red_flashing_overlay");
		overlay fadeOverTime(0.05);
		overlay.alpha = 0;
		self notify("hit_again");
	}
}

/*
	Name: redFlashingOverlay
	Namespace: zm_playerhealth
	Checksum: 0xAA59A084
	Offset: 0x1490
	Size: 0x249
	Parameters: 1
	Flags: None
*/
function redFlashingOverlay(overlay)
{
	self endon("hit_again");
	self endon("damage");
	self endon("death");
	self endon("disconnect");
	self endon("clear_red_flashing_overlay");
	self.stopFlashingBadlyTime = GetTime() + level.longRegenTime;
	if(!isdefined(self.is_in_process_of_zombify) && self.is_in_process_of_zombify && (!isdefined(self.is_zombie) && self.is_zombie))
	{
		fadeFunc(overlay, 1, 1, 0);
		while(GetTime() < self.stopFlashingBadlyTime && isalive(self) && (!isdefined(self.is_in_process_of_zombify) && self.is_in_process_of_zombify && (!isdefined(self.is_zombie) && self.is_zombie)))
		{
			fadeFunc(overlay, 0.9, 1, 0);
		}
		if(!isdefined(self.is_in_process_of_zombify) && self.is_in_process_of_zombify && (!isdefined(self.is_zombie) && self.is_zombie))
		{
			if(isalive(self))
			{
				fadeFunc(overlay, 0.65, 0.8, 0);
			}
			fadeFunc(overlay, 0, 0.6, 1);
		}
	}
	overlay fadeOverTime(0.5);
	overlay.alpha = 0;
	self flag::clear("player_has_red_flashing_overlay");
	self clientfield::set_to_player("sndZombieHealth", 0);
	wait(0.5);
	self notify("hit_again");
}

/*
	Name: healthOverlay_remove
	Namespace: zm_playerhealth
	Checksum: 0x15591E96
	Offset: 0x16E8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function healthOverlay_remove(overlay)
{
	self endon("disconnect");
	self util::waittill_any("noHealthOverlay", "death");
	overlay fadeOverTime(3.5);
	overlay.alpha = 0;
}

/*
	Name: empty_kill_func
	Namespace: zm_playerhealth
	Checksum: 0xB17F6BCB
	Offset: 0x1760
	Size: 0x2B
	Parameters: 5
	Flags: None
*/
function empty_kill_func(type, loc, point, attacker, amount)
{
}

/*
	Name: logHit
	Namespace: zm_playerhealth
	Checksum: 0x59F3E9D
	Offset: 0x1798
	Size: 0x17
	Parameters: 2
	Flags: None
*/
function logHit(newHealth, invulTime)
{
	/#
	#/
}

/*
	Name: logRegen
	Namespace: zm_playerhealth
	Checksum: 0x1ACF3C81
	Offset: 0x17B8
	Size: 0xF
	Parameters: 1
	Flags: None
*/
function logRegen(newHealth)
{
	/#
	#/
}

/*
	Name: showHitLog
	Namespace: zm_playerhealth
	Checksum: 0x1C49D3A3
	Offset: 0x17D0
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function showHitLog()
{
	/#
	#/
}

/*
	Name: playerHealthDebug
	Namespace: zm_playerhealth
	Checksum: 0x13442FEB
	Offset: 0x17E0
	Size: 0x10F
	Parameters: 0
	Flags: None
*/
function playerHealthDebug()
{
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		waittillframeend;
		while(1)
		{
			while(1)
			{
				if(GetDvarString("Dev Block strings are not supported") != "Dev Block strings are not supported")
				{
					break;
				}
				wait(0.5);
			}
			thread printHealthDebug();
			while(1)
			{
				if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
				{
					break;
				}
				wait(0.5);
			}
			level notify("stop_printing_grenade_timers");
			destroyHealthDebug();
		}
	#/
}

/*
	Name: printHealthDebug
	Namespace: zm_playerhealth
	Checksum: 0x28E276B8
	Offset: 0x18F8
	Size: 0x66D
	Parameters: 0
	Flags: None
*/
function printHealthDebug()
{
	/#
		level notify("stop_printing_health_bars");
		level endon("stop_printing_health_bars");
		x = 40;
		y = 40;
		level.healthBarHudElems = [];
		level.healthBarKeys[0] = "Dev Block strings are not supported";
		level.healthBarKeys[1] = "Dev Block strings are not supported";
		level.healthBarKeys[2] = "Dev Block strings are not supported";
		if(!isdefined(level.playerInvulTimeEnd))
		{
			level.playerInvulTimeEnd = 0;
		}
		if(!isdefined(level.player_deathInvulnerableTimeout))
		{
			level.player_deathInvulnerableTimeout = 0;
		}
		for(i = 0; i < level.healthBarKeys.size; i++)
		{
			key = level.healthBarKeys[i];
			textelem = NewHudElem();
			textelem.x = x;
			textelem.y = y;
			textelem.alignX = "Dev Block strings are not supported";
			textelem.alignY = "Dev Block strings are not supported";
			textelem.horzAlign = "Dev Block strings are not supported";
			textelem.vertAlign = "Dev Block strings are not supported";
			textelem setText(key);
			bgbar = NewHudElem();
			bgbar.x = x + 79;
			bgbar.y = y + 1;
			bgbar.alignX = "Dev Block strings are not supported";
			bgbar.alignY = "Dev Block strings are not supported";
			bgbar.horzAlign = "Dev Block strings are not supported";
			bgbar.vertAlign = "Dev Block strings are not supported";
			bgbar.maxwidth = 3;
			bgbar SetShader("Dev Block strings are not supported", bgbar.maxwidth, 10);
			bgbar.color = VectorScale((1, 1, 1), 0.5);
			bar = NewHudElem();
			bar.x = x + 80;
			bar.y = y + 2;
			bar.alignX = "Dev Block strings are not supported";
			bar.alignY = "Dev Block strings are not supported";
			bar.horzAlign = "Dev Block strings are not supported";
			bar.vertAlign = "Dev Block strings are not supported";
			bar SetShader("Dev Block strings are not supported", 1, 8);
			textelem.bar = bar;
			textelem.bgbar = bgbar;
			textelem.key = key;
			y = y + 10;
			level.healthBarHudElems[key] = textelem;
		}
		level flag::wait_till("Dev Block strings are not supported");
		while(1)
		{
			wait(0.05);
			players = GetPlayers();
			for(i = 0; i < level.healthBarKeys.size && players.size > 0; i++)
			{
				key = level.healthBarKeys[i];
				player = players[0];
				width = 0;
				if(i == 0)
				{
					width = player.health / player.maxhealth * 300;
				}
				else if(i == 1)
				{
					width = level.playerInvulTimeEnd - GetTime() / 1000 * 40;
				}
				else if(i == 2)
				{
					width = level.player_deathInvulnerableTimeout - GetTime() / 1000 * 40;
				}
				width = Int(max(width, 1));
				width = Int(min(width, 300));
				bar = level.healthBarHudElems[key].bar;
				bar SetShader("Dev Block strings are not supported", width, 8);
				bgbar = level.healthBarHudElems[key].bgbar;
				if(width + 2 > bgbar.maxwidth)
				{
					bgbar.maxwidth = width + 2;
					bgbar SetShader("Dev Block strings are not supported", bgbar.maxwidth, 10);
					bgbar.color = VectorScale((1, 1, 1), 0.5);
				}
			}
		}
	#/
}

/*
	Name: destroyHealthDebug
	Namespace: zm_playerhealth
	Checksum: 0x96689F7B
	Offset: 0x1F70
	Size: 0xCD
	Parameters: 0
	Flags: None
*/
function destroyHealthDebug()
{
	/#
		if(!isdefined(level.healthBarHudElems))
		{
			return;
		}
		for(i = 0; i < level.healthBarKeys.size; i++)
		{
			level.healthBarHudElems[level.healthBarKeys[i]].bgbar destroy();
			level.healthBarHudElems[level.healthBarKeys[i]].bar destroy();
			level.healthBarHudElems[level.healthBarKeys[i]] destroy();
		}
	#/
}

