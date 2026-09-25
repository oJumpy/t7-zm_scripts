#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\weaponlist;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace gameskill;

/*
	Name: init
	Namespace: gameskill
	Checksum: 0x865CE485
	Offset: 0x430
	Size: 0xF
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	level.gameskill = 0;
}

/*
	Name: setSkill
	Namespace: gameskill
	Checksum: 0xD77F5AC2
	Offset: 0x448
	Size: 0x213
	Parameters: 2
	Flags: None
*/
function setSkill(reset, skill_override)
{
	if(!isdefined(level.script))
	{
		level.script = ToLower(GetDvarString("mapname"));
	}
	if(!(isdefined(reset) && reset))
	{
		if(isdefined(level.b_gameSkillSet) && level.b_gameSkillSet)
		{
			return;
		}
		level.global_damage_func_ads = &empty_kill_func;
		level.global_damage_func = &empty_kill_func;
		level.global_kill_func = &empty_kill_func;
		util::set_console_status();
		thread playerHealthDebug();
		if(util::coopGame())
		{
			thread coop_player_threat_bias_adjuster();
			thread coop_enemy_accuracy_scalar_watcher();
			thread coop_friendly_accuracy_scalar_watcher();
		}
		level.b_gameSkillSet = 1;
	}
	replay_single_mission = GetDvarInt("ui_singlemission");
	if(replay_single_mission == 1)
	{
		single_mission_difficulty = GetDvarInt("ui_singlemission_difficulty");
		if(single_mission_difficulty >= 0)
		{
			skill_override = single_mission_difficulty;
		}
	}
	level thread update_skill_level(skill_override);
	if(!isdefined(level.player_attacker_accuracy_multiplier))
	{
		level.player_attacker_accuracy_multiplier = 1;
	}
	anim.run_accuracy = 0.5;
	level.auto_adjust_threatbias = 1;
	anim.pain_test = &pain_protection;
	set_difficulty_from_locked_settings();
}

/*
	Name: apply_difficulty_var_with_func
	Namespace: gameskill
	Checksum: 0xA86C37D4
	Offset: 0x668
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function apply_difficulty_var_with_func(difficulty_func)
{
	level.playerHealth_RegularRegenDelay = get_player_health_regular_regen_delay();
	level.worthyDamageRatio = get_worthy_damage_ratio();
	if(level.auto_adjust_threatbias)
	{
		thread apply_threat_bias_to_all_players(difficulty_func);
	}
	level.longRegenTime = get_long_regen_time();
	anim.player_attacker_accuracy = get_base_enemy_accuracy() * level.player_attacker_accuracy_multiplier;
	anim.dog_hits_before_kill = get_dog_hits_before_kill();
	anim.DOG_HEALTH = get_dog_health();
	anim.dog_presstime = get_dog_press_time();
	SetSavedDvar("ai_accuracyDistScale", 1);
	thread coop_damage_and_accuracy_scaling(difficulty_func);
}

/*
	Name: apply_threat_bias_to_all_players
	Namespace: gameskill
	Checksum: 0xC4707A33
	Offset: 0x790
	Size: 0xA1
	Parameters: 1
	Flags: None
*/
function apply_threat_bias_to_all_players(difficulty_func)
{
	level flag::wait_till("all_players_connected");
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		players[i].threatbias = Int(get_player_threat_bias());
	}
}

/*
	Name: coop_damage_and_accuracy_scaling
	Namespace: gameskill
	Checksum: 0xD485DD39
	Offset: 0x840
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function coop_damage_and_accuracy_scaling(difficulty_func)
{
}

/*
	Name: set_difficulty_from_locked_settings
	Namespace: gameskill
	Checksum: 0x6D7218F9
	Offset: 0x858
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function set_difficulty_from_locked_settings()
{
	apply_difficulty_var_with_func(&get_locked_difficulty_val);
}

/*
	Name: get_locked_difficulty_val
	Namespace: gameskill
	Checksum: 0xDEC404AE
	Offset: 0x888
	Size: 0x29
	Parameters: 2
	Flags: None
*/
function get_locked_difficulty_val(msg, ignored)
{
	return level.difficultySettings[msg][level.currentDifficulty];
}

/*
	Name: always_pain
	Namespace: gameskill
	Checksum: 0xB1F6EE86
	Offset: 0x8C0
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function always_pain()
{
	return 0;
}

/*
	Name: pain_protection
	Namespace: gameskill
	Checksum: 0xEEB78D9C
	Offset: 0x8D0
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function pain_protection()
{
	if(!pain_protection_check())
	{
		return 0;
	}
	return RandomInt(100) > get_enemy_pain_chance() * 100;
}

/*
	Name: pain_protection_check
	Namespace: gameskill
	Checksum: 0xF8999036
	Offset: 0x928
	Size: 0xD1
	Parameters: 0
	Flags: None
*/
function pain_protection_check()
{
	if(!isalive(self.enemy))
	{
		return 0;
	}
	if(!isPlayer(self.enemy))
	{
		return 0;
	}
	if(!isalive(level.painAI) || level.painAI.a.script != "pain")
	{
		level.painAI = self;
	}
	if(self == level.painAI)
	{
		return 0;
	}
	if(self.damageWeapon != level.weaponNone && self.damageWeapon.isBoltAction)
	{
		return 0;
	}
	return 1;
}

/*
	Name: playerHealthDebug
	Namespace: gameskill
	Checksum: 0x353E2C8C
	Offset: 0xA08
	Size: 0xE7
	Parameters: 0
	Flags: None
*/
function playerHealthDebug()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
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
	Namespace: gameskill
	Checksum: 0x817797FD
	Offset: 0xAF8
	Size: 0x6BD
	Parameters: 0
	Flags: None
*/
function printHealthDebug()
{
	level notify("stop_printing_health_bars");
	level endon("stop_printing_health_bars");
	y = 40;
	level.healthBarHudElems = [];
	level.healthBarKeys[0] = "Health";
	level.healthBarKeys[1] = "No Hit Time";
	level.healthBarKeys[2] = "No Die Time";
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
		textelem.x = 150;
		textelem.y = y;
		textelem.alignX = "left";
		textelem.alignY = "top";
		textelem.horzAlign = "fullscreen";
		textelem.vertAlign = "fullscreen";
		textelem setText(key);
		bgbar = NewHudElem();
		bgbar.x = 150 + 79;
		bgbar.y = y + 1;
		bgbar.z = 1;
		bgbar.alignX = "left";
		bgbar.alignY = "top";
		bgbar.horzAlign = "fullscreen";
		bgbar.vertAlign = "fullscreen";
		bgbar.maxwidth = 3;
		bgbar SetShader("white", bgbar.maxwidth, 10);
		bgbar.color = VectorScale((1, 1, 1), 0.5);
		bar = NewHudElem();
		bar.x = 150 + 80;
		bar.y = y + 2;
		bar.alignX = "left";
		bar.alignY = "top";
		bar.horzAlign = "fullscreen";
		bar.vertAlign = "fullscreen";
		bar SetShader("black", 1, 8);
		bar.sort = 1;
		textelem.bar = bar;
		textelem.bgbar = bgbar;
		textelem.key = key;
		y = y + 10;
		level.healthBarHudElems[key] = textelem;
	}
	level flag::wait_till("all_players_spawned");
	while(1)
	{
		wait(0.05);
		players = level.players;
		for(i = 0; i < level.healthBarKeys.size && players.size > 0; i++)
		{
			key = level.healthBarKeys[i];
			player = players[0];
			width = 0;
			if(i == 0)
			{
				width = player.health / player.maxhealth * 300;
				level.healthBarHudElems[key] setText(level.healthBarKeys[0] + " " + player.health);
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
			bar SetShader("black", width, 8);
			bgbar = level.healthBarHudElems[key].bgbar;
			if(width + 2 > bgbar.maxwidth)
			{
				bgbar.maxwidth = width + 2;
				bgbar SetShader("white", bgbar.maxwidth, 10);
				bgbar.color = VectorScale((1, 1, 1), 0.5);
			}
		}
	}
}

/*
	Name: destroyHealthDebug
	Namespace: gameskill
	Checksum: 0xD59A8DBD
	Offset: 0x11C0
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function destroyHealthDebug()
{
	level notify("stop_printing_health_bars");
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
}

/*
	Name: axisAccuracyControl
	Namespace: gameskill
	Checksum: 0xB32EEC7B
	Offset: 0x12A0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function axisAccuracyControl()
{
	self endon("long_death");
	self endon("death");
	if(isdefined(level.script) && level.script != "core_frontend")
	{
		self coop_axis_accuracy_scaler();
	}
}

/*
	Name: alliesAccuracyControl
	Namespace: gameskill
	Checksum: 0x77BA2A24
	Offset: 0x1300
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function alliesAccuracyControl()
{
	self endon("long_death");
	self endon("death");
	self coop_allies_accuracy_scaler();
}

/*
	Name: playerHurtcheck
	Namespace: gameskill
	Checksum: 0xAC383C7A
	Offset: 0x1338
	Size: 0x347
	Parameters: 0
	Flags: None
*/
function playerHurtcheck()
{
	self endon("death");
	self endon("killHurtCheck");
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
		if(isdefined(mod) && mod == "MOD_BURNED")
		{
			self setburn(0.5);
			self playsound("chr_burn");
		}
		invulWorthyHealthDrop = amount / self.maxhealth >= level.worthyDamageRatio;
		death_invuln_time = 0;
		if(self.health <= 1 && self player_eligible_for_death_invulnerability())
		{
			invulWorthyHealthDrop = 1;
			player_death_invulnerability_time = get_player_death_invulnerable_time();
			coop_death_invulnerability_time_modifier = get_coop_player_death_invulnerable_time_modifier();
			death_invuln_time = player_death_invulnerability_time * coop_death_invulnerability_time_modifier;
			self.eligible_for_death_invulnerability = 0;
			self thread monitor_player_death_invulnerability_eligibility();
			level.player_deathInvulnerableTimeout = GetTime() + death_invuln_time;
		}
		oldratio = self.health / self.maxhealth;
		level notify("hit_again");
		health_add = 0;
		hurtTime = GetTime();
		if(!isdefined(level.disable_damage_blur))
		{
			self startfadingblur(3, 0.8);
		}
		if(!invulWorthyHealthDrop)
		{
			continue;
		}
		if(self flag::get("player_is_invulnerable"))
		{
			continue;
		}
		self flag::set("player_is_invulnerable");
		level notify("player_becoming_invulnerable");
		if(death_invuln_time < get_player_hit_invuln_time())
		{
			invulTime = get_player_hit_invuln_time();
		}
		else
		{
			invulTime = death_invuln_time;
		}
		self thread playerInvul(invulTime);
	}
}

/*
	Name: playerHealthRegen
	Namespace: gameskill
	Checksum: 0x4AAA7543
	Offset: 0x1688
	Size: 0x441
	Parameters: 0
	Flags: None
*/
function playerHealthRegen()
{
	self endon("death");
	self endon("disconnect");
	self endon("removehealthregen");
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
	self thread increment_take_cover_warnings_on_death();
	self setTakeCoverWarnings();
	self thread healthoverlay();
	oldratio = 1;
	health_add = 0;
	veryHurt = 0;
	playerJustGotRedFlashing = 0;
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	self.attackerAccuracy = 1;
	self.oldattackeraccuracy = 1;
	self.ignoreBulletDamage = 0;
	self thread playerHurtcheck();
	if(!isdefined(self.veryHurt))
	{
		self.veryHurt = 0;
	}
	self.boltHit = 0;
	for(;;)
	{
		wait(0.05);
		waittillframeend;
		if(self.health == self.maxhealth)
		{
			if(self flag::get("player_has_red_flashing_overlay"))
			{
				flag::clear("player_has_red_flashing_overlay");
			}
			playerJustGotRedFlashing = 0;
			veryHurt = 0;
			continue;
		}
		if(self.health <= 0)
		{
			return;
		}
		wasVeryHurt = veryHurt;
		health_ratio = self.health / self.maxhealth;
		if(health_ratio <= get_health_overlay_cutoff())
		{
			veryHurt = 1;
			self thread cover_warning_check();
			if(!wasVeryHurt)
			{
				hurtTime = GetTime();
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
					newHealth = newHealth + 0.1;
				}
				if(newHealth >= 1)
				{
					reduceTakeCoverWarnings();
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
			self setnormalhealth(newHealth);
			oldratio = self.health / self.maxhealth;
			continue;
		}
	}
}

/*
	Name: reduceTakeCoverWarnings
	Namespace: gameskill
	Checksum: 0xA2E7396B
	Offset: 0x1AD8
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function reduceTakeCoverWarnings()
{
	players = level.players;
	if(isdefined(players[0]) && isalive(players[0]))
	{
		takeCoverWarnings = GetLocalProfileInt("takeCoverWarnings");
		if(takeCoverWarnings > 0)
		{
			takeCoverWarnings--;
			SetLocalProfileVar("takeCoverWarnings", takeCoverWarnings);
			/#
				DebugTakeCoverWarnings();
			#/
		}
	}
}

/*
	Name: DebugTakeCoverWarnings
	Namespace: gameskill
	Checksum: 0x34ADC747
	Offset: 0x1B90
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function DebugTakeCoverWarnings()
{
	/#
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		}
		if(GetDvarString("Dev Block strings are not supported") == "Dev Block strings are not supported")
		{
			iprintln("Dev Block strings are not supported", GetLocalProfileInt("Dev Block strings are not supported") - 3);
		}
	#/
}

/*
	Name: playerInvul
	Namespace: gameskill
	Checksum: 0xBEFCFCFE
	Offset: 0x1C48
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function playerInvul(timer)
{
	self endon("death");
	self endon("disconnect");
	self.oldattackeraccuracy = self.attackerAccuracy;
	if(timer > 0)
	{
		self.attackerAccuracy = 0;
		self.ignoreBulletDamage = 1;
		level.playerInvulTimeEnd = GetTime() + timer * 1000;
		wait(timer);
	}
	self.attackerAccuracy = self.oldattackeraccuracy;
	self.ignoreBulletDamage = 0;
	self flag::clear("player_is_invulnerable");
}

/*
	Name: grenadeawareness
	Namespace: gameskill
	Checksum: 0x70F1AA8F
	Offset: 0x1D08
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function grenadeawareness()
{
	if(self.team == "allies")
	{
		self.grenadeawareness = 0.9;
		return;
	}
	if(self.team == "axis")
	{
		if(isdefined(level.gameskill) && level.gameskill >= 2)
		{
			if(RandomInt(100) < 33)
			{
				self.grenadeawareness = 0.2;
			}
			else
			{
				self.grenadeawareness = 0.5;
			}
		}
		else if(RandomInt(100) < 33)
		{
			self.grenadeawareness = 0;
		}
		else
		{
			self.grenadeawareness = 0.2;
		}
	}
}

/*
	Name: playerheartbeatloop
	Namespace: gameskill
	Checksum: 0x88C92FAB
	Offset: 0x1DF8
	Size: 0xFF
	Parameters: 1
	Flags: None
*/
function playerheartbeatloop(healthcap)
{
	self endon("disconnect");
	self endon("killed_player");
	wait(2);
	player = self;
	ent = undefined;
	for(;;)
	{
		wait(0.2);
		if(player.health >= healthcap)
		{
			if(isdefined(ent))
			{
				ent StopLoopSound(1.5);
				level thread delayed_delete(ent, 1.5);
			}
			continue;
		}
		ent = spawn("script_origin", self.origin);
		ent PlayLoopSound("", 0.5);
	}
}

/*
	Name: delayed_delete
	Namespace: gameskill
	Checksum: 0x292FB450
	Offset: 0x1F00
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function delayed_delete(ent, time)
{
	wait(time);
	ent delete();
	ent = undefined;
}

/*
	Name: healthfadeOffWatcher
	Namespace: gameskill
	Checksum: 0xF95C12C9
	Offset: 0x1F48
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function healthfadeOffWatcher(overlay, timeToFadeOut)
{
	self notify("new_style_health_overlay_done");
	self endon("new_style_health_overlay_done");
	while(!isdefined(level.disable_damage_overlay) && level.disable_damage_overlay && timeToFadeOut > 0)
	{
		wait(0.05);
		timeToFadeOut = timeToFadeOut - 0.05;
	}
	if(isdefined(level.disable_damage_overlay) && level.disable_damage_overlay)
	{
		overlay.alpha = 0;
		overlay fadeOverTime(0.05);
	}
}

/*
	Name: new_style_health_overlay
	Namespace: gameskill
	Checksum: 0x99EC1590
	Offset: 0x2010
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function new_style_health_overlay()
{
}

/*
	Name: healthoverlay
	Namespace: gameskill
	Checksum: 0x806CFF98
	Offset: 0x2020
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function healthoverlay()
{
	self endon("disconnect");
	self endon("noHealthOverlay");
	new_style_health_overlay();
}

/*
	Name: add_hudelm_position_internal
	Namespace: gameskill
	Checksum: 0xCC3DEEB0
	Offset: 0x2058
	Size: 0x19B
	Parameters: 1
	Flags: None
*/
function add_hudelm_position_internal(alignY)
{
	if(level.console)
	{
		self.fontscale = 2;
	}
	else
	{
		self.fontscale = 1.6;
	}
	self.x = 0;
	self.y = -36;
	self.alignX = "center";
	self.alignY = "bottom";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	if(!isdefined(self.background))
	{
		return;
	}
	self.background.x = 0;
	self.background.y = -40;
	self.background.alignX = "center";
	self.background.alignY = "middle";
	self.background.horzAlign = "center";
	self.background.vertAlign = "middle";
	if(level.console)
	{
		self.background SetShader("popmenu_bg", 650, 52);
	}
	else
	{
		self.background SetShader("popmenu_bg", 650, 42);
	}
	self.background.alpha = 0.5;
}

/*
	Name: create_warning_elem
	Namespace: gameskill
	Checksum: 0xD24ED4AB
	Offset: 0x2200
	Size: 0xCF
	Parameters: 1
	Flags: None
*/
function create_warning_elem(player)
{
	level notify("hud_elem_interupt");
	hudelem = NewHudElem();
	hudelem add_hudelm_position_internal();
	hudelem thread destroy_warning_elem_when_mission_failed(player);
	hudelem setText(&"GAME_GET_TO_COVER");
	hudelem.fontscale = 1.85;
	hudelem.alpha = 1;
	hudelem.color = (1, 0.6, 0);
	return hudelem;
}

/*
	Name: play_hurt_vox
	Namespace: gameskill
	Checksum: 0x6B18A257
	Offset: 0x22D8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function play_hurt_vox()
{
	if(isdefined(self.veryHurt))
	{
		if(self.veryHurt == 0)
		{
			if(randomIntRange(0, 1) == 1)
			{
				playsoundatposition("chr_breathing_hurt_start", self.origin);
			}
		}
	}
}

/*
	Name: waitTillPlayerIsHitAgain
	Namespace: gameskill
	Checksum: 0xD77119B9
	Offset: 0x2340
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function waitTillPlayerIsHitAgain()
{
	level endon("hit_again");
	self waittill("damage");
}

/*
	Name: destroy_warning_elem_when_mission_failed
	Namespace: gameskill
	Checksum: 0xC266CB57
	Offset: 0x2368
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function destroy_warning_elem_when_mission_failed(player)
{
	self endon("being_destroyed");
	self endon("death");
	level flag::wait_till("missionfailed");
	self thread destroy_warning_elem(1);
}

/*
	Name: destroy_warning_elem
	Namespace: gameskill
	Checksum: 0xD9F3BAB2
	Offset: 0x23C8
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function destroy_warning_elem(fadeout)
{
	self notify("being_destroyed");
	self.beingDestroyed = 1;
	if(fadeout)
	{
		self fadeOverTime(0.5);
		self.alpha = 0;
		wait(0.5);
	}
	self util::death_notify_wrapper();
	self destroy();
}

/*
	Name: mayChangeCoverWarningAlpha
	Namespace: gameskill
	Checksum: 0x896451B7
	Offset: 0x2460
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function mayChangeCoverWarningAlpha(coverWarning)
{
	if(!isdefined(coverWarning))
	{
		return 0;
	}
	if(isdefined(coverWarning.beingDestroyed))
	{
		return 0;
	}
	return 1;
}

/*
	Name: fontScaler
	Namespace: gameskill
	Checksum: 0x5E9C4F6D
	Offset: 0x24A0
	Size: 0x77
	Parameters: 2
	Flags: None
*/
function fontScaler(scale, timer)
{
	self endon("death");
	scale = scale * 2;
	dif = scale - self.fontscale;
	self changeFontScaleOverTime(timer);
	self.fontscale = self.fontscale + dif;
}

/*
	Name: cover_warning_check
	Namespace: gameskill
	Checksum: 0x66E0D768
	Offset: 0x2520
	Size: 0x1DB
	Parameters: 0
	Flags: None
*/
function cover_warning_check()
{
	level endon("missionfailed");
	if(self shouldShowCoverWarning())
	{
		coverWarning = create_warning_elem(self);
		level.cover_warning_hud = coverWarning;
		coverWarning endon("death");
		stopFlashingBadlyTime = GetTime() + level.longRegenTime;
		yellow_fac = 0.7;
		while(GetTime() < stopFlashingBadlyTime && isalive(self))
		{
			for(i = 0; i < 7; i++)
			{
				yellow_fac = yellow_fac + 0.03;
				coverWarning.color = (1, yellow_fac, 0);
				wait(0.05);
			}
			for(i = 0; i < 7; i++)
			{
				yellow_fac = yellow_fac - 0.03;
				coverWarning.color = (1, yellow_fac, 0);
				wait(0.05);
			}
		}
		if(mayChangeCoverWarningAlpha(coverWarning))
		{
			coverWarning fadeOverTime(0.5);
			coverWarning.alpha = 0;
		}
		wait(0.5);
		wait(5);
		coverWarning destroy();
	}
}

/*
	Name: shouldShowCoverWarning
	Namespace: gameskill
	Checksum: 0x7CD21157
	Offset: 0x2708
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function shouldShowCoverWarning()
{
	return 0;
	if(isdefined(level.enable_cover_warning))
	{
		return level.enable_cover_warning;
	}
	if(!isalive(self))
	{
		return 0;
	}
	if(level.gameskill > 1)
	{
		return 0;
	}
	if(level.missionfailed)
	{
		return 0;
	}
	if(IsSplitscreen() || util::coopGame())
	{
		return 0;
	}
	takeCoverWarnings = GetLocalProfileInt("takeCoverWarnings");
	if(takeCoverWarnings <= 3)
	{
		return 0;
	}
	if(isdefined(level.cover_warning_hud))
	{
		return 0;
	}
	return 1;
}

/*
	Name: fadeFunc
	Namespace: gameskill
	Checksum: 0x4904BAA3
	Offset: 0x27F0
	Size: 0x397
	Parameters: 5
	Flags: None
*/
function fadeFunc(overlay, coverWarning, severity, mult, hud_scaleOnly)
{
	fadeInTime = 0.8 * 0.1;
	stayFullTime = 0.8 * 0.1 + severity * 0.2;
	fadeOutHalfTime = 0.8 * 0.1 + severity * 0.1;
	fadeOutFullTime = 0.8 * 0.3;
	remainingTime = 0.8 - fadeInTime - stayFullTime - fadeOutHalfTime - fadeOutFullTime;
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
	if(mayChangeCoverWarningAlpha(coverWarning))
	{
		if(!hud_scaleOnly)
		{
			coverWarning fadeOverTime(fadeInTime);
			coverWarning.alpha = mult * 1;
		}
	}
	if(isdefined(coverWarning))
	{
		coverWarning thread fontScaler(1, fadeInTime);
	}
	wait(fadeInTime + stayFullTime);
	overlay fadeOverTime(fadeOutHalfTime);
	overlay.alpha = mult * halfAlpha;
	if(mayChangeCoverWarningAlpha(coverWarning))
	{
		if(!hud_scaleOnly)
		{
			coverWarning fadeOverTime(fadeOutHalfTime);
			coverWarning.alpha = mult * halfAlpha;
		}
	}
	wait(fadeOutHalfTime);
	overlay fadeOverTime(fadeOutFullTime);
	overlay.alpha = mult * leastAlpha;
	if(mayChangeCoverWarningAlpha(coverWarning))
	{
		if(!hud_scaleOnly)
		{
			coverWarning fadeOverTime(fadeOutFullTime);
			coverWarning.alpha = mult * leastAlpha;
		}
	}
	if(isdefined(coverWarning))
	{
		coverWarning thread fontScaler(0.9, fadeOutFullTime);
	}
	wait(fadeOutFullTime);
	wait(remainingTime);
}

/*
	Name: healthOverlay_remove
	Namespace: gameskill
	Checksum: 0x95027DB7
	Offset: 0x2B90
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
	Name: setTakeCoverWarnings
	Namespace: gameskill
	Checksum: 0x38489455
	Offset: 0x2C08
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function setTakeCoverWarnings()
{
	isPreGameplayLevel = level.script == "training" || level.script == "cargoship" || level.script == "coup";
	if(GetLocalProfileInt("takeCoverWarnings") == -1 || isPreGameplayLevel)
	{
		SetLocalProfileVar("takeCoverWarnings", 9);
	}
	/#
		DebugTakeCoverWarnings();
	#/
}

/*
	Name: increment_take_cover_warnings_on_death
	Namespace: gameskill
	Checksum: 0x3564F7D0
	Offset: 0x2CC0
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function increment_take_cover_warnings_on_death()
{
	if(!isPlayer(self))
	{
		return;
	}
	level notify("new_cover_on_death_thread");
	level endon("new_cover_on_death_thread");
	self waittill("death");
	if(!self flag::get("player_has_red_flashing_overlay"))
	{
		return;
	}
	if(level.gameskill > 1)
	{
		return;
	}
	warnings = GetLocalProfileInt("takeCoverWarnings");
	if(warnings < 10)
	{
		SetLocalProfileVar("takeCoverWarnings", warnings + 1);
	}
	/#
		DebugTakeCoverWarnings();
	#/
}

/*
	Name: empty_kill_func
	Namespace: gameskill
	Checksum: 0x3AEE0351
	Offset: 0x2DB8
	Size: 0x2B
	Parameters: 5
	Flags: None
*/
function empty_kill_func(type, loc, point, attacker, amount)
{
}

/*
	Name: update_skill_level
	Namespace: gameskill
	Checksum: 0xBD9D0C7C
	Offset: 0x2DF0
	Size: 0x373
	Parameters: 1
	Flags: None
*/
function update_skill_level(skill_override)
{
	level notify("update_skill_from_profile");
	level endon("update_skill_from_profile");
	level.gameSkillLowest = 9999;
	level.gameSkillHighest = 0;
	n_last_gameskill = -1;
	while(!isdefined(skill_override))
	{
		level.gameskill = GetLocalProfileInt("g_gameskill");
		if(level.gameskill != n_last_gameskill)
		{
			if(!isdefined(level.gameskill))
			{
				level.gameskill = 0;
			}
			SetDvar("saved_gameskill", level.gameskill);
			switch(level.gameskill)
			{
				case 0:
				{
					SetDvar("currentDifficulty", "easy");
					level.currentDifficulty = "easy";
					break;
				}
				case 1:
				{
					SetDvar("currentDifficulty", "normal");
					level.currentDifficulty = "normal";
					break;
				}
				case 2:
				{
					SetDvar("currentDifficulty", "hardened");
					level.currentDifficulty = "hardened";
					break;
				}
				case 3:
				{
					SetDvar("currentDifficulty", "veteran");
					level.currentDifficulty = "veteran";
					break;
				}
				case 4:
				{
					SetDvar("currentDifficulty", "realistic");
					level.currentDifficulty = "realistic";
					break;
				}
			}
			/#
				println("Dev Block strings are not supported" + level.gameskill);
			#/
			n_last_gameskill = level.gameskill;
			if(level.gameskill < level.gameSkillLowest)
			{
				level.gameSkillLowest = level.gameskill;
				MatchRecordSetLevelDifficultyForIndex(2, level.gameskill);
			}
			if(level.gameskill > level.gameSkillHighest)
			{
				level.gameSkillHighest = level.gameskill;
				MatchRecordSetLevelDifficultyForIndex(3, level.gameskill);
			}
			foreach(player in GetPlayers())
			{
				player clientfield::set_player_uimodel("serverDifficulty", level.gameskill);
			}
		}
		wait(1);
	}
}

/*
	Name: coop_enemy_accuracy_scalar_watcher
	Namespace: gameskill
	Checksum: 0x289D9EBA
	Offset: 0x3170
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function coop_enemy_accuracy_scalar_watcher()
{
	level flagsys::wait_till("load_main_complete");
	level flag::wait_till("all_players_connected");
	while(level.players.size > 1)
	{
		players = GetPlayers("allies");
		level.coop_enemy_accuracy_scalar = get_coop_enemy_accuracy_modifier();
		wait(0.5);
	}
}

/*
	Name: coop_friendly_accuracy_scalar_watcher
	Namespace: gameskill
	Checksum: 0xBF83D5EE
	Offset: 0x3218
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function coop_friendly_accuracy_scalar_watcher()
{
	level flagsys::wait_till("load_main_complete");
	level flag::wait_till("all_players_connected");
	while(level.players.size > 1)
	{
		players = GetPlayers("allies");
		level.coop_friendly_accuracy_scalar = get_coop_friendly_accuracy_modifier();
		wait(0.5);
	}
}

/*
	Name: coop_axis_accuracy_scaler
	Namespace: gameskill
	Checksum: 0x93A87C73
	Offset: 0x32C0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function coop_axis_accuracy_scaler()
{
	self endon("death");
	initialValue = self.baseAccuracy;
	self.baseAccuracy = initialValue * get_coop_enemy_accuracy_modifier();
	wait(RandomFloatRange(3, 5));
}

/*
	Name: coop_allies_accuracy_scaler
	Namespace: gameskill
	Checksum: 0x6D942F6
	Offset: 0x3328
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function coop_allies_accuracy_scaler()
{
	self endon("death");
	initialValue = self.baseAccuracy;
	while(level.players.size > 1)
	{
		if(!isdefined(level.coop_friendly_accuracy_scalar))
		{
			wait(0.5);
			continue;
		}
		self.baseAccuracy = initialValue * level.coop_friendly_accuracy_scalar;
		wait(RandomFloatRange(3, 5));
	}
}

/*
	Name: coop_player_threat_bias_adjuster
	Namespace: gameskill
	Checksum: 0x527855E2
	Offset: 0x33B0
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function coop_player_threat_bias_adjuster()
{
	while(1)
	{
		wait(5);
		if(level.auto_adjust_threatbias)
		{
			players = GetPlayers("allies");
			for(i = 0; i < players.size; i++)
			{
				enable_auto_adjust_threatbias(players[i]);
			}
		}
	}
}

/*
	Name: enable_auto_adjust_threatbias
	Namespace: gameskill
	Checksum: 0x3A945AA6
	Offset: 0x3448
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function enable_auto_adjust_threatbias(player)
{
	level.auto_adjust_threatbias = 1;
	players = level.players;
	level.coop_player_threatbias_scalar = get_coop_friendly_threat_bias_scalar();
	if(!isdefined(level.coop_player_threatbias_scalar))
	{
		level.coop_player_threatbias_scalar = 1;
	}
	player.threatbias = Int(get_player_threat_bias() * level.coop_player_threatbias_scalar);
}

/*
	Name: setDiffStructArrays
	Namespace: gameskill
	Checksum: 0x81FC3DD3
	Offset: 0x34E8
	Size: 0x129
	Parameters: 0
	Flags: None
*/
function setDiffStructArrays()
{
	reload = 0;
	/#
		reload = 1;
	#/
	if(reload || !isdefined(level.s_game_difficulty))
	{
		level.s_game_difficulty = [];
		level.s_game_difficulty[0] = struct::get_script_bundle("gamedifficulty", "gamedifficulty_easy");
		level.s_game_difficulty[1] = struct::get_script_bundle("gamedifficulty", "gamedifficulty_medium");
		level.s_game_difficulty[2] = struct::get_script_bundle("gamedifficulty", "gamedifficulty_hard");
		level.s_game_difficulty[3] = struct::get_script_bundle("gamedifficulty", "gamedifficulty_veteran");
		level.s_game_difficulty[4] = struct::get_script_bundle("gamedifficulty", "gamedifficulty_realistic");
	}
}

/*
	Name: get_player_threat_bias
	Namespace: gameskill
	Checksum: 0xFEF970B2
	Offset: 0x3620
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_player_threat_bias()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].threatbias;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_player_xp_difficulty_multiplier
	Namespace: gameskill
	Checksum: 0x54C0056E
	Offset: 0x3680
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function get_player_xp_difficulty_multiplier()
{
	setDiffStructArrays();
	diff_xp_mult = level.s_game_difficulty[level.gameskill].difficulty_xp_multiplier;
	if(isdefined(diff_xp_mult))
	{
		return diff_xp_mult;
	}
	else
	{
		return 1;
	}
}

/*
	Name: get_health_overlay_cutoff
	Namespace: gameskill
	Checksum: 0x26289C48
	Offset: 0x36E0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_health_overlay_cutoff()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].healthOverlayCutoff;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_enemy_pain_chance
	Namespace: gameskill
	Checksum: 0xD0D1979C
	Offset: 0x3740
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function get_enemy_pain_chance()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].enemyPainChance;
	modifier = get_coop_enemy_pain_chance_modifier();
	if(isdefined(diff_struct_value))
	{
		diff_struct_value = modifier * diff_struct_value;
		return diff_struct_value;
	}
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_player_death_invulnerable_time
	Namespace: gameskill
	Checksum: 0xC89A47A6
	Offset: 0x37D8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_player_death_invulnerable_time()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].player_deathInvulnerableTime;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_base_enemy_accuracy
	Namespace: gameskill
	Checksum: 0x899ADC6C
	Offset: 0x3838
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_base_enemy_accuracy()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].base_enemy_accuracy;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_player_difficulty_health
	Namespace: gameskill
	Checksum: 0x837CB2E2
	Offset: 0x3898
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_player_difficulty_health()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].playerDifficultyHealth;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_player_hit_invuln_time
	Namespace: gameskill
	Checksum: 0x98BD5271
	Offset: 0x38F8
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function get_player_hit_invuln_time()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].playerHitInvulnTime;
	modifier = get_coop_hit_invulnerability_modifier();
	if(isdefined(diff_struct_value))
	{
		diff_struct_value = modifier * diff_struct_value;
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_miss_time_constant
	Namespace: gameskill
	Checksum: 0x2C1888C5
	Offset: 0x3980
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_miss_time_constant()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].missTimeConstant;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_miss_time_reset_delay
	Namespace: gameskill
	Checksum: 0x93F6832D
	Offset: 0x39E0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_miss_time_reset_delay()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].missTimeResetDelay;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_miss_time_distance_factor
	Namespace: gameskill
	Checksum: 0x90361532
	Offset: 0x3A40
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_miss_time_distance_factor()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].missTimeDistanceFactor;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_dog_health
	Namespace: gameskill
	Checksum: 0x97747351
	Offset: 0x3AA0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_dog_health()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].DOG_HEALTH;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_dog_press_time
	Namespace: gameskill
	Checksum: 0x2C5AC59
	Offset: 0x3B00
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_dog_press_time()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].dog_presstime;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_dog_hits_before_kill
	Namespace: gameskill
	Checksum: 0x3C4108A1
	Offset: 0x3B60
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_dog_hits_before_kill()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].dog_hits_before_kill;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_long_regen_time
	Namespace: gameskill
	Checksum: 0xCD547DD2
	Offset: 0x3BC0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_long_regen_time()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].longRegenTime;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_player_health_regular_regen_delay
	Namespace: gameskill
	Checksum: 0xFBF91624
	Offset: 0x3C20
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_player_health_regular_regen_delay()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].playerHealth_RegularRegenDelay;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_worthy_damage_ratio
	Namespace: gameskill
	Checksum: 0x94FAF59A
	Offset: 0x3C80
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function get_worthy_damage_ratio()
{
	setDiffStructArrays();
	diff_struct_value = level.s_game_difficulty[level.gameskill].worthyDamageRatio;
	if(isdefined(diff_struct_value))
	{
		return diff_struct_value;
	}
	else
	{
		return 0;
	}
}

/*
	Name: get_coop_enemy_accuracy_modifier
	Namespace: gameskill
	Checksum: 0xBB2F5A71
	Offset: 0x3CE0
	Size: 0x145
	Parameters: 0
	Flags: None
*/
function get_coop_enemy_accuracy_modifier()
{
	setDiffStructArrays();
	switch(level.players.size)
	{
		case 1:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].one_player_coopEnemyAccuracyScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 2:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].two_player_coopEnemyAccuracyScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 3:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].three_player_coopEnemyAccuracyScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 4:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].four_player_coopEnemyAccuracyScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
	}
	return 1;
}

/*
	Name: get_coop_friendly_accuracy_modifier
	Namespace: gameskill
	Checksum: 0xD9255E96
	Offset: 0x3E30
	Size: 0x151
	Parameters: 0
	Flags: None
*/
function get_coop_friendly_accuracy_modifier()
{
	setDiffStructArrays();
	switch(level.players.size)
	{
		case 1:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].one_player_coopFriendlyAccuracyScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 2:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].two_player_coopFriendlyAccuracyScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 3:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].three_player_coopFriendlyAccuracyScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 4:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].four_player_coopFriendlyAccuracyScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case default:
		{
			return 1;
		}
	}
}

/*
	Name: get_coop_friendly_threat_bias_scalar
	Namespace: gameskill
	Checksum: 0x3D1E7358
	Offset: 0x3F90
	Size: 0x151
	Parameters: 0
	Flags: None
*/
function get_coop_friendly_threat_bias_scalar()
{
	setDiffStructArrays();
	switch(level.players.size)
	{
		case 1:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].one_player_coopFriendlyThreatBiasScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 2:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].two_player_coopFriendlyThreatBiasScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 3:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].three_player_coopFriendlyThreatBiasScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 4:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].four_player_coopFriendlyThreatBiasScalar;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case default:
		{
			return 1;
		}
	}
}

/*
	Name: get_coop_player_health_modifier
	Namespace: gameskill
	Checksum: 0xAA733A55
	Offset: 0x40F0
	Size: 0x151
	Parameters: 0
	Flags: None
*/
function get_coop_player_health_modifier()
{
	setDiffStructArrays();
	switch(level.players.size)
	{
		case 1:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].one_player_coopPlayerDifficultyHealth;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 2:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].two_player_coopPlayerDifficultyHealth;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 3:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].three_player_coopPlayerDifficultyHealth;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 4:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].four_player_coopPlayerDifficultyHealth;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case default:
		{
			return 1;
		}
	}
}

/*
	Name: get_coop_player_death_invulnerable_time_modifier
	Namespace: gameskill
	Checksum: 0x8C5A7AF5
	Offset: 0x4250
	Size: 0x151
	Parameters: 0
	Flags: None
*/
function get_coop_player_death_invulnerable_time_modifier()
{
	setDiffStructArrays();
	switch(level.players.size)
	{
		case 1:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].one_player_deathInvulnerableTimeModifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 2:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].two_player_deathInvulnerableTimeModifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 3:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].three_player_deathInvulnerableTimeModifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 4:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].four_player_deathInvulnerableTimeModifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case default:
		{
			return 1;
		}
	}
}

/*
	Name: get_coop_hit_invulnerability_modifier
	Namespace: gameskill
	Checksum: 0x8F491374
	Offset: 0x43B0
	Size: 0x145
	Parameters: 0
	Flags: None
*/
function get_coop_hit_invulnerability_modifier()
{
	setDiffStructArrays();
	switch(level.players.size)
	{
		case 1:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].one_player_hit_invulnerability_modifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 2:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].two_player_hit_invulnerability_modifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 3:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].three_player_hit_invulnerability_modifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 4:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].four_player_hit_invulnerability_modifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
	}
	return 1;
}

/*
	Name: get_coop_enemy_pain_chance_modifier
	Namespace: gameskill
	Checksum: 0xB373AC07
	Offset: 0x4500
	Size: 0x145
	Parameters: 0
	Flags: None
*/
function get_coop_enemy_pain_chance_modifier()
{
	setDiffStructArrays();
	switch(level.players.size)
	{
		case 1:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].one_player_enemy_pain_chance_modifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 2:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].two_player_enemy_pain_chance_modifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 3:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].three_player_enemy_pain_chance_modifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
		case 4:
		{
			diff_struct_value = level.s_game_difficulty[level.gameskill].four_player_enemy_pain_chance_modifier;
			if(isdefined(diff_struct_value))
			{
				return diff_struct_value;
			}
			else
			{
				return 0;
			}
			break;
		}
	}
	return 1;
}

/*
	Name: get_general_difficulty_level
	Namespace: gameskill
	Checksum: 0x9D1C89A4
	Offset: 0x4650
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function get_general_difficulty_level()
{
	value = level.gameskill + level.players.size - 1;
	if(value < 0)
	{
		value = 0;
	}
	return value;
}

/*
	Name: player_eligible_for_death_invulnerability
	Namespace: gameskill
	Checksum: 0xA43FD0DD
	Offset: 0x46A0
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function player_eligible_for_death_invulnerability()
{
	player = self;
	if(level.gameskill >= 4)
	{
		return 0;
	}
	if(!isdefined(self.eligible_for_death_invulnerability))
	{
		self.eligible_for_death_invulnerability = 1;
	}
	return self.eligible_for_death_invulnerability;
}

/*
	Name: monitor_player_death_invulnerability_eligibility
	Namespace: gameskill
	Checksum: 0xE61DD83C
	Offset: 0x46F0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function monitor_player_death_invulnerability_eligibility()
{
	self endon("disconnect");
	self endon("death");
	while(!self.eligible_for_death_invulnerability)
	{
		if(self.health >= self.maxhealth)
		{
			self.eligible_for_death_invulnerability = 1;
		}
		wait(0.05);
	}
}

/*
	Name: adjust_damage_for_player_health
	Namespace: gameskill
	Checksum: 0x7B492B4A
	Offset: 0x4750
	Size: 0xA9
	Parameters: 7
	Flags: None
*/
function adjust_damage_for_player_health(player, eAttacker, eInflictor, iDamage, weapon, sHitLoc, sMeansOfDamage)
{
	coop_healthscalar = get_coop_player_health_modifier();
	player_difficulty_health = get_player_difficulty_health() * coop_healthscalar;
	player_damage_difficulty_modifier = 100 / player_difficulty_health;
	iDamage = iDamage * player_damage_difficulty_modifier;
	return iDamage;
}

/*
	Name: adjust_melee_damage
	Namespace: gameskill
	Checksum: 0x7AFB1ECC
	Offset: 0x4808
	Size: 0x12D
	Parameters: 7
	Flags: None
*/
function adjust_melee_damage(player, eAttacker, eInflictor, iDamage, weapon, sHitLoc, sMeansOfDamage)
{
	if(sMeansOfDamage == "MOD_MELEE" || sMeansOfDamage == "MOD_MELEE_WEAPON_BUTT" && IsEntity(eAttacker))
	{
		iDamage = iDamage / 5;
		if(iDamage > 40)
		{
			playerForward = AnglesToForward(player.angles);
			toAttacker = VectorNormalize(eAttacker.origin - player.origin);
			if(VectorDot(playerForward, toAttacker) < 0.342)
			{
				iDamage = 40;
			}
		}
	}
	return iDamage;
}

/*
	Name: accuracy_buildup_over_time_init
	Namespace: gameskill
	Checksum: 0x645EB3BB
	Offset: 0x4940
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function accuracy_buildup_over_time_init()
{
	self endon("death");
	self.baseAccuracy = self.accuracy;
}

/*
	Name: accuracy_buildup_before_fire
	Namespace: gameskill
	Checksum: 0x8FFF7FA8
	Offset: 0x4968
	Size: 0x4CB
	Parameters: 1
	Flags: None
*/
function accuracy_buildup_before_fire(ai)
{
	self endon("death");
	if(GetDvarInt("ai_codeGameskill"))
	{
		return;
	}
	while(1)
	{
		if(isdefined(ai.enemy))
		{
			if(isPlayer(ai.enemy))
			{
				if(!isdefined(ai.lastEnemyShotAt))
				{
					ai.lastEnemyShotAt = ai.enemy;
					ai.buildupAccuracyModifier = 0;
					ai.shootTimeStart = GetTime();
					ai.lastShotTime = ai.shootTimeStart;
				}
				if(ai.enemy != ai.lastEnemyShotAt)
				{
					ai.lastEnemyShotAt = ai.enemy;
					ai.buildupAccuracyModifier = 0;
					ai.shootTimeStart = GetTime();
					ai.lastShotTime = ai.shootTimeStart;
				}
				else
				{
					ai.miss_time_constant = get_miss_time_constant();
					ai.miss_time_distance_factor = get_miss_time_distance_factor();
					ai.miss_time_reset_delay = get_miss_time_reset_delay();
					if(ai.accurateFire)
					{
						ai.miss_time_reset_delay = ai.miss_time_reset_delay * 2;
					}
					shotTime = GetTime();
					timeShooting = shotTime - ai.shootTimeStart;
					Distance = Distance(ai.origin, ai.enemy.origin);
					missTime = ai.miss_time_constant * 1000;
					accuracyBuildupTime = missTime + Distance * ai.miss_time_distance_factor;
					targetFacingAngle = AnglesToForward(ai.enemy.angles);
					angleFromTarget = VectorNormalize(ai.origin - ai.enemy.origin);
					if(VectorDot(targetFacingAngle, angleFromTarget) < 0.7)
					{
						accuracyBuildupTime = accuracyBuildupTime * 2;
					}
					if(shotTime - ai.lastShotTime > ai.miss_time_reset_delay)
					{
						ai.buildupAccuracyModifier = 0;
						ai.shootTimeStart = shotTime;
						timeShooting = 0;
					}
					if(timeShooting > accuracyBuildupTime)
					{
						ai.buildupAccuracyModifier = 1;
					}
					if(timeShooting <= accuracyBuildupTime && timeShooting > accuracyBuildupTime * 0.66)
					{
						ai.buildupAccuracyModifier = 0.66;
					}
					if(timeShooting <= accuracyBuildupTime * 0.66 && timeShooting > accuracyBuildupTime * 0.33)
					{
						ai.buildupAccuracyModifier = 0.33;
					}
					if(timeShooting <= accuracyBuildupTime * 0.33)
					{
						ai.buildupAccuracyModifier = 0;
					}
					ai.lastShotTime = shotTime;
				}
			}
			else
			{
				ai.buildupAccuracyModifier = 1;
			}
			ai.accuracy = ai.baseAccuracy * ai.buildupAccuracyModifier;
		}
		self waittill("about_to_shoot");
	}
}

