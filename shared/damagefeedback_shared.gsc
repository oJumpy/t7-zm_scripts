#using scripts\codescripts\struct;
#using scripts\shared\abilities\gadgets\_gadget_armor;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons_shared;

#namespace damagefeedback;

/*
	Name: __init__sytem__
	Namespace: damagefeedback
	Checksum: 0xCC0BE710
	Offset: 0x460
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("damagefeedback", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: damagefeedback
	Checksum: 0x512F8A1A
	Offset: 0x4A0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
}

/*
	Name: init
	Namespace: damagefeedback
	Checksum: 0x99EC1590
	Offset: 0x4F0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init()
{
}

/*
	Name: on_player_connect
	Namespace: damagefeedback
	Checksum: 0xAEE135B6
	Offset: 0x500
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	if(!SessionModeIsMultiplayerGame())
	{
		self.hud_damagefeedback = newdamageindicatorhudelem(self);
		self.hud_damagefeedback.horzAlign = "center";
		self.hud_damagefeedback.vertAlign = "middle";
		self.hud_damagefeedback.x = -11;
		self.hud_damagefeedback.y = -11;
		self.hud_damagefeedback.alpha = 0;
		self.hud_damagefeedback.archived = 1;
		self.hud_damagefeedback SetShader("damage_feedback", 22, 44);
		self.hud_damagefeedback_additional = newdamageindicatorhudelem(self);
		self.hud_damagefeedback_additional.horzAlign = "center";
		self.hud_damagefeedback_additional.vertAlign = "middle";
		self.hud_damagefeedback_additional.x = -12;
		self.hud_damagefeedback_additional.y = -12;
		self.hud_damagefeedback_additional.alpha = 0;
		self.hud_damagefeedback_additional.archived = 1;
		self.hud_damagefeedback_additional SetShader("damage_feedback", 24, 48);
	}
}

/*
	Name: should_play_sound
	Namespace: damagefeedback
	Checksum: 0x2C4EF333
	Offset: 0x6B0
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function should_play_sound(mod)
{
	if(!isdefined(mod))
	{
		return 0;
	}
	switch(mod)
	{
		case "MOD_CRUSH":
		case "MOD_GRENADE_SPLASH":
		case "MOD_HIT_BY_OBJECT":
		case "MOD_MELEE":
		case "MOD_MELEE_ASSASSINATE":
		case "MOD_MELEE_WEAPON_BUTT":
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: update
	Namespace: damagefeedback
	Checksum: 0xD46F59FF
	Offset: 0x720
	Size: 0x80F
	Parameters: 7
	Flags: None
*/
function update(mod, inflictor, perkFeedback, weapon, victim, psOffsetTime, sHitLoc)
{
	if(!isPlayer(self))
	{
		return;
	}
	if(isdefined(self.noHitMarkers) && self.noHitMarkers)
	{
		return 0;
	}
	if(isdefined(weapon) && (isdefined(weapon.nohitmarker) && weapon.nohitmarker))
	{
		return;
	}
	if(!isdefined(self.lastHitMarkerTime))
	{
		self.lastHitMarkerTimes = [];
		self.lastHitMarkerTime = 0;
		self.lastHitMarkerOffsetTime = 0;
	}
	if(isdefined(psOffsetTime))
	{
		victim_id = victim GetEntityNumber();
		if(!isdefined(self.lastHitMarkerTimes[victim_id]))
		{
			self.lastHitMarkerTimes[victim_id] = 0;
		}
		if(self.lastHitMarkerTime == GetTime())
		{
			if(self.lastHitMarkerTimes[victim_id] === psOffsetTime)
			{
				return;
			}
		}
		self.lastHitMarkerOffsetTime = psOffsetTime;
		self.lastHitMarkerTimes[victim_id] = psOffsetTime;
	}
	else if(self.lastHitMarkerTime == GetTime())
	{
		return;
	}
	self.lastHitMarkerTime = GetTime();
	hitAlias = undefined;
	if(should_play_sound(mod))
	{
		if(isdefined(victim) && isdefined(victim.victimSoundMod))
		{
			switch(victim.victimSoundMod)
			{
				case "safeguard_robot":
				{
					hitAlias = "mpl_hit_alert_escort";
					break;
				}
				case default:
				{
					hitAlias = "mpl_hit_alert";
					break;
				}
			}
		}
		else if(isdefined(inflictor) && isdefined(inflictor.soundMod))
		{
			switch(inflictor.soundMod)
			{
				case "player":
				{
					if(isdefined(victim) && (isdefined(victim.isaiclone) && victim.isaiclone))
					{
						hitAlias = "mpl_hit_alert_clone";
					}
					else if(isdefined(victim) && isPlayer(victim) && victim flagsys::get("gadget_armor_on") && armor::armor_should_take_damage(inflictor, weapon, mod, sHitLoc))
					{
						hitAlias = "mpl_hit_alert_armor";
					}
					else if(isdefined(victim) && isPlayer(victim) && isdefined(victim.carryObject) && isdefined(victim.carryObject.hitSound) && isdefined(perkFeedback) && perkFeedback == "armor")
					{
						hitAlias = victim.carryObject.hitSound;
					}
					else if(mod == "MOD_BURNED")
					{
						hitAlias = "mpl_hit_alert_burn";
					}
					else
					{
						hitAlias = "mpl_hit_alert";
					}
					break;
				}
				case "heatwave":
				{
					hitAlias = "mpl_hit_alert_heatwave";
					break;
				}
				case "heli":
				{
					hitAlias = "mpl_hit_alert_air";
					break;
				}
				case "hpm":
				{
					hitAlias = "mpl_hit_alert_hpm";
					break;
				}
				case "taser_spike":
				{
					hitAlias = "mpl_hit_alert_taser_spike";
					break;
				}
				case "dog":
				case "straferun":
				{
					break;
				}
				case "firefly":
				{
					hitAlias = "mpl_hit_alert_firefly";
					break;
				}
				case "drone_land":
				{
					hitAlias = "mpl_hit_alert_air";
					break;
				}
				case "raps":
				{
					hitAlias = "mpl_hit_alert_air";
					break;
				}
				case "default_loud":
				{
					hitAlias = "mpl_hit_heli_gunner";
					break;
				}
				case default:
				{
					hitAlias = "mpl_hit_alert";
					break;
				}
			}
		}
		else if(mod == "MOD_BURNED")
		{
			hitAlias = "mpl_hit_alert_burn";
		}
		else
		{
			hitAlias = "mpl_hit_alert";
		}
	}
	if(isdefined(victim) && (isdefined(victim.isaiclone) && victim.isaiclone))
	{
		self PlayHitMarker(hitAlias);
		return;
	}
	damageStage = 1;
	if(isdefined(level.growing_hitmarker) && isdefined(victim) && isPlayer(victim))
	{
		damageStage = damage_feedback_get_stage(victim);
	}
	self PlayHitMarker(hitAlias, damageStage, perkFeedback, damage_feedback_get_dead(victim, mod, weapon, damageStage));
	if(isdefined(perkFeedback))
	{
		if(isdefined(self.hud_damagefeedback_additional))
		{
			switch(perkFeedback)
			{
				case "flakjacket":
				{
					self.hud_damagefeedback_additional SetShader("damage_feedback_flak", 24, 48);
					break;
				}
				case "tacticalMask":
				{
					self.hud_damagefeedback_additional SetShader("damage_feedback_tac", 24, 48);
					break;
				}
				case "armor":
				{
					self.hud_damagefeedback_additional SetShader("damage_feedback_armor", 24, 48);
					break;
				}
			}
			self.hud_damagefeedback_additional.alpha = 1;
			self.hud_damagefeedback_additional fadeOverTime(1);
			self.hud_damagefeedback_additional.alpha = 0;
		}
	}
	else if(isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
	}
	if(isdefined(self.hud_damagefeedback) && isdefined(level.growing_hitmarker) && isdefined(victim) && isPlayer(victim))
	{
		self thread damage_feedback_growth(victim, mod, weapon);
	}
	else if(isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback.x = -12;
		self.hud_damagefeedback.y = -12;
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

/*
	Name: damage_feedback_get_stage
	Namespace: damagefeedback
	Checksum: 0x84FEB203
	Offset: 0xF38
	Size: 0xF1
	Parameters: 1
	Flags: None
*/
function damage_feedback_get_stage(victim)
{
	if(isdefined(victim.laststand) && victim.laststand)
	{
		return 5;
	}
	else if(victim.health / victim.maxhealth > 0.74)
	{
		return 1;
	}
	else if(victim.health / victim.maxhealth > 0.49)
	{
		return 2;
	}
	else if(victim.health / victim.maxhealth > 0.24)
	{
		return 3;
	}
	else if(victim.health > 0)
	{
		return 4;
	}
	else
	{
		return 5;
	}
}

/*
	Name: damage_feedback_get_dead
	Namespace: damagefeedback
	Checksum: 0x9EF09F7C
	Offset: 0x1038
	Size: 0xED
	Parameters: 4
	Flags: None
*/
function damage_feedback_get_dead(victim, mod, weapon, stage)
{
	return stage == 5 && (mod == "MOD_BULLET" || mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET" || mod == "MOD_HEAD_SHOT") && (isdefined(weapon.isHeroWeapon) && !weapon.isHeroWeapon) && !killstreaks::is_killstreak_weapon(weapon) && !weapon.name === "siegebot_gun_turret" && !weapon.name === "siegebot_launcher_turret";
}

/*
	Name: damage_feedback_growth
	Namespace: damagefeedback
	Checksum: 0x124420A5
	Offset: 0x1130
	Size: 0x1B7
	Parameters: 3
	Flags: None
*/
function damage_feedback_growth(victim, mod, weapon)
{
	if(isdefined(self.hud_damagefeedback))
	{
		stage = damage_feedback_get_stage(victim);
		self.hud_damagefeedback.x = -11 + -1 * stage;
		self.hud_damagefeedback.y = -11 + -1 * stage;
		size_x = 22 + 2 * stage;
		size_y = size_x * 2;
		self.hud_damagefeedback SetShader("damage_feedback", size_x, size_y);
		if(damage_feedback_get_dead(victim, mod, weapon, stage))
		{
			self.hud_damagefeedback SetShader("damage_feedback_glow_orange", size_x, size_y);
			self thread kill_hitmarker_fade();
		}
		else
		{
			self.hud_damagefeedback SetShader("damage_feedback", size_x, size_y);
			self.hud_damagefeedback.alpha = 1;
			self.hud_damagefeedback fadeOverTime(1);
			self.hud_damagefeedback.alpha = 0;
		}
	}
}

/*
	Name: kill_hitmarker_fade
	Namespace: damagefeedback
	Checksum: 0x9954625D
	Offset: 0x12F0
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function kill_hitmarker_fade()
{
	self notify("kill_hitmarker_fade");
	self endon("kill_hitmarker_fade");
	self endon("disconnect");
	self.hud_damagefeedback.alpha = 1;
	wait(0.25);
	self.hud_damagefeedback fadeOverTime(0.3);
	self.hud_damagefeedback.alpha = 0;
}

/*
	Name: update_override
	Namespace: damagefeedback
	Checksum: 0x96FDE0
	Offset: 0x1378
	Size: 0x15F
	Parameters: 3
	Flags: None
*/
function update_override(icon, sound, additional_icon)
{
	if(!isPlayer(self))
	{
		return;
	}
	self playlocalsound(sound);
	if(isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback SetShader(icon, 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}
	if(isdefined(self.hud_damagefeedback_additional))
	{
		if(!isdefined(additional_icon))
		{
			self.hud_damagefeedback_additional.alpha = 0;
		}
		else
		{
			self.hud_damagefeedback_additional SetShader(additional_icon, 24, 48);
			self.hud_damagefeedback_additional.alpha = 1;
			self.hud_damagefeedback_additional fadeOverTime(1);
			self.hud_damagefeedback_additional.alpha = 0;
		}
	}
}

/*
	Name: update_special
	Namespace: damagefeedback
	Checksum: 0x53EFD249
	Offset: 0x14E0
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function update_special(hitEnt)
{
	if(!isPlayer(self))
	{
		return;
	}
	if(!isdefined(hitEnt))
	{
		return;
	}
	if(!isPlayer(hitEnt))
	{
		return;
	}
	wait(0.05);
	if(!isdefined(self.directionalHitArray))
	{
		self.directionalHitArray = [];
		hitEntNum = hitEnt GetEntityNumber();
		self.directionalHitArray[hitEntNum] = 1;
		self thread send_hit_special_event_at_frame_end(hitEnt);
	}
	else
	{
		hitEntNum = hitEnt GetEntityNumber();
		self.directionalHitArray[hitEntNum] = 1;
	}
}

/*
	Name: send_hit_special_event_at_frame_end
	Namespace: damagefeedback
	Checksum: 0xA662C161
	Offset: 0x15D8
	Size: 0x17D
	Parameters: 1
	Flags: None
*/
function send_hit_special_event_at_frame_end(hitEnt)
{
	self endon("disconnect");
	waittillframeend;
	enemysHit = 0;
	value = 1;
	entBitArray0 = 0;
	for(i = 0; i < 32; i++)
	{
		if(isdefined(self.directionalHitArray[i]) && self.directionalHitArray[i] != 0)
		{
			entBitArray0 = entBitArray0 + value;
			enemysHit++;
		}
		value = value * 2;
	}
	entBitArray1 = 0;
	for(i = 33; i < 64; i++)
	{
		if(isdefined(self.directionalHitArray[i]) && self.directionalHitArray[i] != 0)
		{
			entBitArray1 = entBitArray1 + value;
			enemysHit++;
		}
		value = value * 2;
	}
	if(enemysHit)
	{
		self directionalHitIndicator(entBitArray0, entBitArray1);
	}
	self.directionalHitArray = undefined;
	entBitArray0 = 0;
	entBitArray1 = 0;
}

/*
	Name: doDamageFeedback
	Namespace: damagefeedback
	Checksum: 0x9AD3C964
	Offset: 0x1760
	Size: 0xBD
	Parameters: 4
	Flags: None
*/
function doDamageFeedback(weapon, eInflictor, iDamage, sMeansOfDeath)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(isdefined(weapon.nohitmarker) && weapon.nohitmarker)
	{
		return 0;
	}
	if(level.allowHitMarkers == 0)
	{
		return 0;
	}
	if(level.allowHitMarkers == 1)
	{
		if(isdefined(sMeansOfDeath) && isdefined(iDamage))
		{
			if(isTacticalHitMarker(weapon, sMeansOfDeath, iDamage))
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: isTacticalHitMarker
	Namespace: damagefeedback
	Checksum: 0xFC86BB54
	Offset: 0x1828
	Size: 0x7F
	Parameters: 3
	Flags: None
*/
function isTacticalHitMarker(weapon, sMeansOfDeath, iDamage)
{
	if(weapons::is_grenade(weapon))
	{
		if("Smoke Grenade" == weapon.offhandClass)
		{
			if(sMeansOfDeath == "MOD_GRENADE_SPLASH")
			{
				return 1;
			}
		}
		else if(iDamage == 1)
		{
			return 1;
		}
	}
	return 0;
}

