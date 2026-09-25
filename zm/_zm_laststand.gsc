#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_laststand;

/*
	Name: __init__sytem__
	Namespace: zm_laststand
	Checksum: 0xFAD1CDBB
	Offset: 0x680
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_laststand", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_laststand
	Checksum: 0xF3743730
	Offset: 0x6C0
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	laststand_global_init();
	level.laststand_update_clientfields = [];
	for(i = 0; i < 4; i++)
	{
		level.laststand_update_clientfields[i] = "laststand_update" + i;
		clientfield::register("world", level.laststand_update_clientfields[i], 1, 5, "counter");
	}
	level.weaponSuicide = GetWeapon("death_self");
	level.primaryProgressBarX = 0;
	level.primaryProgressBarY = 110;
	level.primaryProgressBarHeight = 4;
	level.primaryProgressBarWidth = 120;
	level.primaryProgressBarY_ss = 280;
	if(GetDvarString("revive_trigger_radius") == "")
	{
		SetDvar("revive_trigger_radius", "40");
	}
	level.lastStandGetupAllowed = 0;
	if(!isdefined(level.vsmgr_prio_visionset_zm_laststand))
	{
		level.vsmgr_prio_visionset_zm_laststand = 1000;
	}
	visionset_mgr::register_info("visionset", "zombie_last_stand", 1, level.vsmgr_prio_visionset_zm_laststand, 31, 1, &visionset_mgr::ramp_in_thread_per_player, 0);
	if(!isdefined(level.vsmgr_prio_visionset_zm_death))
	{
		level.vsmgr_prio_visionset_zm_death = 1100;
	}
	visionset_mgr::register_info("visionset", "zombie_death", 1, level.vsmgr_prio_visionset_zm_death, 31, 1, &visionset_mgr::ramp_in_thread_per_player, 0);
}

/*
	Name: laststand_global_init
	Namespace: zm_laststand
	Checksum: 0x829613EA
	Offset: 0x8C8
	Size: 0xA5
	Parameters: 0
	Flags: None
*/
function laststand_global_init()
{
	level.CONST_LASTSTAND_GETUP_COUNT_START = 0;
	level.CONST_LASTSTAND_GETUP_BAR_START = 0.5;
	level.CONST_LASTSTAND_GETUP_BAR_REGEN = 0.0025;
	level.CONST_LASTSTAND_GETUP_BAR_DAMAGE = 0.1;
	level.player_name_directive = [];
	level.player_name_directive[0] = &"ZOMBIE_PLAYER_NAME_0";
	level.player_name_directive[1] = &"ZOMBIE_PLAYER_NAME_1";
	level.player_name_directive[2] = &"ZOMBIE_PLAYER_NAME_2";
	level.player_name_directive[3] = &"ZOMBIE_PLAYER_NAME_3";
}

/*
	Name: player_last_stand_stats
	Namespace: zm_laststand
	Checksum: 0x32CE7C9D
	Offset: 0x978
	Size: 0x2DB
	Parameters: 9
	Flags: None
*/
function player_last_stand_stats(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	if(isdefined(attacker) && isPlayer(attacker) && attacker != self)
	{
		if("zcleansed" == level.gametype)
		{
			demo::bookmark("kill", GetTime(), attacker, self, 0, eInflictor);
		}
		if("zcleansed" == level.gametype)
		{
			if(!(isdefined(attacker.is_zombie) && attacker.is_zombie))
			{
				attacker.kills++;
			}
			else
			{
				attacker.downs++;
			}
		}
		else
		{
			attacker.kills++;
		}
		attacker zm_stats::increment_client_stat("kills");
		attacker zm_stats::increment_player_stat("kills");
		attacker addweaponstat(weapon, "kills", 1);
		if(zm_utility::is_headshot(weapon, sHitLoc, sMeansOfDeath))
		{
			attacker.headshots++;
			attacker zm_stats::increment_client_stat("headshots");
			attacker addweaponstat(weapon, "headshots", 1);
			attacker zm_stats::increment_player_stat("headshots");
		}
	}
	self increment_downed_stat();
	if(level flag::get("solo_game") && !self.lives && getnumconnectedplayers() < 2)
	{
		self zm_stats::increment_client_stat("deaths");
		self zm_stats::increment_player_stat("deaths");
		self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
	}
}

/*
	Name: increment_downed_stat
	Namespace: zm_laststand
	Checksum: 0xD77D42B9
	Offset: 0xC60
	Size: 0x10B
	Parameters: 0
	Flags: None
*/
function increment_downed_stat()
{
	if("zcleansed" != level.gametype)
	{
		self.downs++;
	}
	self zm_stats::increment_global_stat("TOTAL_DOWNS");
	self zm_stats::increment_map_stat("TOTAL_DOWNS");
	self zm_stats::increment_client_stat("downs");
	self add_weighted_down();
	self zm_stats::increment_player_stat("downs");
	zoneName = self zm_utility::get_current_zone();
	if(!isdefined(zoneName))
	{
		zoneName = "";
	}
	self RecordPlayerDownZombies(zoneName);
}

/*
	Name: PlayerLastStand
	Namespace: zm_laststand
	Checksum: 0x6070820B
	Offset: 0xD78
	Size: 0x43B
	Parameters: 9
	Flags: None
*/
function PlayerLastStand(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self notify("entering_last_stand");
	self DisableWeaponCycling();
	if(isdefined(level._game_module_player_laststand_callback))
	{
		self [[level._game_module_player_laststand_callback]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	}
	if(self laststand::player_is_in_laststand())
	{
		return;
	}
	if(isdefined(self.in_zombify_call) && self.in_zombify_call)
	{
		return;
	}
	self thread player_last_stand_stats(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	if(isdefined(level.playerlaststand_func))
	{
		[[level.playerlaststand_func]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	}
	self.health = 1;
	self.laststand = 1;
	self set_ignoreme(1);
	callback::callback("hash_6751ab5b");
	self thread gameobjects::on_player_last_stand();
	if(!(isdefined(self.no_revive_trigger) && self.no_revive_trigger))
	{
		self revive_trigger_spawn();
	}
	else
	{
		self UndoLastStand();
	}
	if(isdefined(self.is_zombie) && self.is_zombie)
	{
		self TakeAllWeapons();
		if(isdefined(attacker) && isPlayer(attacker) && attacker != self)
		{
			attacker notify("killed_a_zombie_player", eInflictor, self, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
		}
	}
	else
	{
		self laststand_disable_player_weapons();
		self laststand_give_pistol();
	}
	if(isdefined(level.playerSuicideAllowed) && level.playerSuicideAllowed && GetPlayers().size > 1)
	{
		if(!isdefined(level.canPlayerSuicide) || self [[level.canPlayerSuicide]]())
		{
			self thread suicide_trigger_spawn();
		}
	}
	if(isdefined(self.disabled_perks))
	{
		self.disabled_perks = [];
	}
	if(level.lastStandGetupAllowed)
	{
		self thread laststand_getup();
	}
	else
	{
		bleedout_time = GetDvarFloat("player_lastStandBleedoutTime");
		if(isdefined(self.n_bleedout_time_multiplier))
		{
			bleedout_time = bleedout_time * self.n_bleedout_time_multiplier;
		}
		level clientfield::increment("laststand_update" + self GetEntityNumber(), 30);
		self thread laststand_bleedout(bleedout_time);
	}
	demo::bookmark("player_downed", GetTime(), self);
	self notify("player_downed");
	self thread refire_player_downed();
	self thread laststand::cleanup_laststand_on_disconnect();
}

/*
	Name: refire_player_downed
	Namespace: zm_laststand
	Checksum: 0xAC0B3F6B
	Offset: 0x11C0
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function refire_player_downed()
{
	self endon("player_revived");
	self endon("death");
	self endon("disconnect");
	wait(1);
	if(self.num_perks)
	{
		self notify("player_downed");
	}
}

/*
	Name: laststand_disable_player_weapons
	Namespace: zm_laststand
	Checksum: 0x811E5AD9
	Offset: 0x1210
	Size: 0x49D
	Parameters: 0
	Flags: None
*/
function laststand_disable_player_weapons()
{
	self DisableWeaponCycling();
	weaponInventory = self GetWeaponsList(1);
	self.laststandPrimaryWeapons = self GetWeaponsListPrimaries();
	self.lastActiveWeapon = self GetCurrentWeapon();
	quickswitch = 0;
	if(isdefined(self) && self IsSwitchingWeapons())
	{
		quickswitch = 1;
	}
	if(self IsThrowingGrenade() && zm_utility::is_offhand_weapon(self.lastActiveWeapon))
	{
		quickswitch = 1;
	}
	if(zm_utility::is_hero_weapon(self.lastActiveWeapon))
	{
		quickswitch = 1;
	}
	if(self.lastActiveWeapon.isRiotShield)
	{
		quickswitch = 1;
	}
	if(quickswitch)
	{
		if(isdefined(self.laststandPrimaryWeapons) && self.laststandPrimaryWeapons.size > 0)
		{
			self SwitchToWeaponImmediate();
		}
		else
		{
			self zm_weapons::give_fallback_weapon(1);
		}
		self util::waittill_any_timeout(1, "weapon_change_complete");
	}
	self.lastActiveWeapon = self GetCurrentWeapon();
	self SetLastStandPrevWeap(self.lastActiveWeapon);
	self.laststandpistol = undefined;
	self.hadpistol = 0;
	for(i = 0; i < weaponInventory.size; i++)
	{
		weapon = weaponInventory[i];
		wclass = weapon.weapClass;
		if(weapon.isBallisticKnife)
		{
			wclass = "knife";
		}
		if(wclass == "pistol" || wclass == "pistol spread" || wclass == "pistolspread" && !isdefined(self.laststandpistol))
		{
			self.laststandpistol = weapon;
			self.hadpistol = 1;
		}
		if(weapon == level.weaponReviveTool || weapon === self.weaponReviveTool)
		{
			self zm_stats::increment_client_stat("failed_sacrifices");
			self zm_stats::increment_player_stat("failed_sacrifices");
		}
		else if(weapon.isPerkBottle)
		{
			self TakeWeapon(weapon);
			self.lastActiveWeapon = level.weaponNone;
			continue;
		}
		if(isdefined(zm_utility::get_gamemode_var("item_meat_weapon")))
		{
			if(weapon == zm_utility::get_gamemode_var("item_meat_weapon"))
			{
				self TakeWeapon(weapon);
				self.lastActiveWeapon = level.weaponNone;
				continue;
			}
		}
	}
	if(isdefined(self.hadpistol) && self.hadpistol && isdefined(level.zombie_last_stand_pistol_memory))
	{
		self [[level.zombie_last_stand_pistol_memory]]();
	}
	if(!isdefined(self.laststandpistol))
	{
		if(!isdefined(self.hasCompletedSuperEE))
		{
			self.hasCompletedSuperEE = self zm_stats::get_global_stat("DARKOPS_GENESIS_SUPER_EE") > 0;
		}
		if(self.hasCompletedSuperEE)
		{
			self.laststandpistol = level.super_ee_weapon;
		}
		else
		{
			self.laststandpistol = level.laststandpistol;
		}
	}
	self notify("weapons_taken_for_last_stand");
}

/*
	Name: laststand_enable_player_weapons
	Namespace: zm_laststand
	Checksum: 0x4DA5832E
	Offset: 0x16B8
	Size: 0x22D
	Parameters: 0
	Flags: None
*/
function laststand_enable_player_weapons()
{
	if(self hasPerk("specialty_additionalprimaryweapon") && isdefined(self.weapon_taken_by_losing_specialty_additionalprimaryweapon))
	{
		if(isdefined(level.return_additionalprimaryweapon))
		{
			self [[level.return_additionalprimaryweapon]](self.weapon_taken_by_losing_specialty_additionalprimaryweapon);
		}
		else
		{
			self zm_weapons::give_build_kit_weapon(self.weapon_taken_by_losing_specialty_additionalprimaryweapon);
		}
	}
	else if(isdefined(self.weapon_taken_by_losing_specialty_additionalprimaryweapon) && self.lastActiveWeapon == self.weapon_taken_by_losing_specialty_additionalprimaryweapon)
	{
		self.lastActiveWeapon = level.weaponNone;
	}
	if(isdefined(self.hadpistol) && !self.hadpistol && isdefined(self.laststandpistol))
	{
		self TakeWeapon(self.laststandpistol);
	}
	if(isdefined(self.hadpistol) && self.hadpistol == 1 && isdefined(level.zombie_last_stand_ammo_return) && isdefined(self.laststandpistol))
	{
		[[level.zombie_last_stand_ammo_return]]();
	}
	self EnableWeaponCycling();
	self EnableOffhandWeapons();
	if(self.lastActiveWeapon != level.weaponNone && self HasWeapon(self.lastActiveWeapon) && !zm_utility::is_placeable_mine(self.lastActiveWeapon) && !zm_equipment::is_equipment(self.lastActiveWeapon) && !zm_utility::is_hero_weapon(self.lastActiveWeapon))
	{
		self SwitchToWeapon(self.lastActiveWeapon);
	}
	else
	{
		self SwitchToWeapon();
	}
	self.laststandpistol = undefined;
}

/*
	Name: laststand_has_players_weapons_returned
	Namespace: zm_laststand
	Checksum: 0x2508235B
	Offset: 0x18F0
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function laststand_has_players_weapons_returned(e_player)
{
	if(isdefined(e_player.laststandpistol))
	{
		return 0;
	}
	return 1;
}

/*
	Name: laststand_clean_up_on_disconnect
	Namespace: zm_laststand
	Checksum: 0x857B1750
	Offset: 0x1920
	Size: 0x103
	Parameters: 3
	Flags: None
*/
function laststand_clean_up_on_disconnect(e_revivee, w_reviver, w_revive_tool)
{
	self endon("do_revive_ended_normally");
	reviveTrigger = e_revivee.reviveTrigger;
	e_revivee waittill("disconnect");
	if(isdefined(reviveTrigger))
	{
		reviveTrigger delete();
	}
	self laststand::cleanup_suicide_hud();
	if(isdefined(self.reviveProgressBar))
	{
		self.reviveProgressBar hud::destroyElem();
	}
	if(isdefined(self.reviveTextHud))
	{
		self.reviveTextHud destroy();
	}
	if(isdefined(w_reviver) && isdefined(w_revive_tool))
	{
		self revive_give_back_weapons(w_reviver, w_revive_tool);
	}
}

/*
	Name: laststand_clean_up_reviving_any
	Namespace: zm_laststand
	Checksum: 0x93A66EBA
	Offset: 0x1A30
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function laststand_clean_up_reviving_any(e_revivee)
{
	self endon("do_revive_ended_normally");
	e_revivee util::waittill_any("disconnect", "zombified", "stop_revive_trigger");
	self.is_reviving_any--;
	if(0 > self.is_reviving_any)
	{
		self.is_reviving_any = 0;
	}
	if(isdefined(self.reviveProgressBar))
	{
		self.reviveProgressBar hud::destroyElem();
	}
	if(isdefined(self.reviveTextHud))
	{
		self.reviveTextHud destroy();
	}
}

/*
	Name: laststand_give_pistol
	Namespace: zm_laststand
	Checksum: 0xB093F9FA
	Offset: 0x1AF0
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function laststand_give_pistol()
{
	/#
		Assert(isdefined(self.laststandpistol));
	#/
	/#
		Assert(self.laststandpistol != level.weaponNone);
	#/
	if(isdefined(level.zombie_last_stand))
	{
		[[level.zombie_last_stand]]();
	}
	else
	{
		self GiveWeapon(self.laststandpistol);
		self giveMaxAmmo(self.laststandpistol);
		self SwitchToWeapon(self.laststandpistol);
	}
	self thread wait_switch_weapon(1, self.laststandpistol);
}

/*
	Name: wait_switch_weapon
	Namespace: zm_laststand
	Checksum: 0x95858956
	Offset: 0x1BE8
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function wait_switch_weapon(n_delay, w_weapon)
{
	self endon("player_revived");
	self endon("player_suicide");
	self endon("zombified");
	self endon("disconnect");
	wait(n_delay);
	self SwitchToWeapon(w_weapon);
}

/*
	Name: laststand_bleedout
	Namespace: zm_laststand
	Checksum: 0x4C189C15
	Offset: 0x1C58
	Size: 0x2F3
	Parameters: 1
	Flags: None
*/
function laststand_bleedout(delay)
{
	self endon("player_revived");
	self endon("player_suicide");
	self endon("zombified");
	self endon("disconnect");
	if(isdefined(self.is_zombie) && self.is_zombie || (isdefined(self.no_revive_trigger) && self.no_revive_trigger))
	{
		self notify("bled_out");
		util::wait_network_frame();
		self bleed_out();
		return;
	}
	self clientfield::set("zmbLastStand", 1);
	self.bleedout_time = delay;
	n_default_bleedout_time = GetDvarFloat("player_lastStandBleedoutTime");
	n_bleedout_time = self.bleedout_time;
	n_start_time = GetTime();
	while(self.bleedout_time > Int(delay * 0.5))
	{
		if(n_bleedout_time > n_default_bleedout_time && !isdefined(self.n_bleedout_time_multiplier))
		{
			n_current_time = GetTime();
			n_total_time = n_current_time - n_start_time / 1000;
			if(n_total_time > n_default_bleedout_time)
			{
				delay = 4;
				self.bleedout_time = 2;
				break;
			}
		}
		self.bleedout_time = self.bleedout_time - 1;
		wait(1);
	}
	visionset_mgr::activate("visionset", "zombie_death", self, delay * 0.5);
	while(self.bleedout_time > 0)
	{
		self.bleedout_time = self.bleedout_time - 1;
		level clientfield::increment("laststand_update" + self GetEntityNumber(), self.bleedout_time + 1);
		wait(1);
	}
	while(isdefined(self.reviveTrigger) && isdefined(self.reviveTrigger.beingRevived) && self.reviveTrigger.beingRevived == 1)
	{
		wait(0.1);
	}
	self notify("bled_out");
	util::wait_network_frame();
	self bleed_out();
}

/*
	Name: bleed_out
	Namespace: zm_laststand
	Checksum: 0xFEFF0EB3
	Offset: 0x1F58
	Size: 0x23B
	Parameters: 0
	Flags: None
*/
function bleed_out()
{
	self laststand::cleanup_suicide_hud();
	if(isdefined(self.reviveTrigger))
	{
		self.reviveTrigger delete();
	}
	self.reviveTrigger = undefined;
	self clientfield::set("zmbLastStand", 0);
	self zm_stats::increment_client_stat("deaths");
	self zm_stats::increment_player_stat("deaths");
	self zm_pers_upgrades_functions::pers_upgrade_jugg_player_death_stat();
	self RecordPlayerDeathZombies();
	self.last_bleed_out_time = GetTime();
	self zm_equipment::take();
	self zm_hero_weapon::take_hero_weapon();
	level clientfield::increment("laststand_update" + self GetEntityNumber(), 1);
	demo::bookmark("zm_player_bledout", GetTime(), self, undefined, 1);
	level notify("bleed_out", self.characterindex);
	self UndoLastStand();
	visionset_mgr::deactivate("visionset", "zombie_last_stand", self);
	visionset_mgr::deactivate("visionset", "zombie_death", self);
	if(isdefined(level.is_zombie_level) && level.is_zombie_level)
	{
		self thread [[level.player_becomes_zombie]]();
	}
	else if(isdefined(level.is_specops_level) && level.is_specops_level)
	{
		self thread [[level.spawnSpectator]]();
	}
	else
	{
		self set_ignoreme(0);
	}
}

/*
	Name: suicide_trigger_spawn
	Namespace: zm_laststand
	Checksum: 0x47FC10A8
	Offset: 0x21A0
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function suicide_trigger_spawn()
{
	radius = GetDvarInt("revive_trigger_radius");
	self.suicidePrompt = newClientHudElem(self);
	self.suicidePrompt.alignX = "center";
	self.suicidePrompt.alignY = "middle";
	self.suicidePrompt.horzAlign = "center";
	self.suicidePrompt.vertAlign = "bottom";
	self.suicidePrompt.y = -170;
	if(self IsSplitscreen())
	{
		self.suicidePrompt.y = -132;
	}
	self.suicidePrompt.foreground = 1;
	self.suicidePrompt.font = "default";
	self.suicidePrompt.fontscale = 1.5;
	self.suicidePrompt.alpha = 1;
	self.suicidePrompt.color = (1, 1, 1);
	self.suicidePrompt.hidewheninmenu = 1;
	self thread suicide_trigger_think();
}

/*
	Name: suicide_trigger_think
	Namespace: zm_laststand
	Checksum: 0xC26AA55D
	Offset: 0x2328
	Size: 0x271
	Parameters: 0
	Flags: None
*/
function suicide_trigger_think()
{
	self endon("disconnect");
	self endon("zombified");
	self endon("stop_revive_trigger");
	self endon("player_revived");
	self endon("bled_out");
	self endon("fake_death");
	level endon("end_game");
	level endon("stop_suicide_trigger");
	self thread laststand::clean_up_suicide_hud_on_end_game();
	self thread laststand::clean_up_suicide_hud_on_bled_out();
	while(self useButtonPressed())
	{
		wait(1);
	}
	if(!isdefined(self.suicidePrompt))
	{
		return;
	}
	while(1)
	{
		wait(0.1);
		if(!isdefined(self.suicidePrompt))
		{
			continue;
		}
		self.suicidePrompt setText(&"ZOMBIE_BUTTON_TO_SUICIDE");
		if(!self is_suiciding())
		{
			continue;
		}
		self.pre_suicide_weapon = self GetCurrentWeapon();
		self GiveWeapon(level.weaponSuicide);
		self SwitchToWeapon(level.weaponSuicide);
		duration = self doCowardsWayAnims();
		suicide_success = suicide_do_suicide(duration);
		self.laststand = undefined;
		self TakeWeapon(level.weaponSuicide);
		if(suicide_success)
		{
			self notify("player_suicide");
			util::wait_network_frame();
			self zm_stats::increment_client_stat("suicides");
			self bleed_out();
			return;
		}
		self SwitchToWeapon(self.pre_suicide_weapon);
		self.pre_suicide_weapon = undefined;
	}
}

/*
	Name: suicide_do_suicide
	Namespace: zm_laststand
	Checksum: 0x7304A51
	Offset: 0x25A8
	Size: 0x307
	Parameters: 1
	Flags: None
*/
function suicide_do_suicide(duration)
{
	level endon("end_game");
	level endon("stop_suicide_trigger");
	suicideTime = duration;
	timer = 0;
	suicided = 0;
	self.suicidePrompt setText("");
	if(!isdefined(self.suicideProgressBar))
	{
		self.suicideProgressBar = self hud::createPrimaryProgressBar();
	}
	if(!isdefined(self.suicideTextHud))
	{
		self.suicideTextHud = newClientHudElem(self);
	}
	self.suicideProgressBar hud::updateBar(0.01, 1 / suicideTime);
	self.suicideTextHud.alignX = "center";
	self.suicideTextHud.alignY = "middle";
	self.suicideTextHud.horzAlign = "center";
	self.suicideTextHud.vertAlign = "bottom";
	self.suicideTextHud.y = -173;
	if(self IsSplitscreen())
	{
		self.suicideTextHud.y = -147;
	}
	self.suicideTextHud.foreground = 1;
	self.suicideTextHud.font = "default";
	self.suicideTextHud.fontscale = 1.8;
	self.suicideTextHud.alpha = 1;
	self.suicideTextHud.color = (1, 1, 1);
	self.suicideTextHud.hidewheninmenu = 1;
	self.suicideTextHud setText(&"ZOMBIE_SUICIDING");
	while(self is_suiciding())
	{
		wait(0.05);
		timer = timer + 0.05;
		if(timer >= suicideTime)
		{
			suicided = 1;
			break;
		}
	}
	if(isdefined(self.suicideProgressBar))
	{
		self.suicideProgressBar hud::destroyElem();
	}
	if(isdefined(self.suicideTextHud))
	{
		self.suicideTextHud destroy();
	}
	if(isdefined(self.suicidePrompt))
	{
		self.suicidePrompt setText(&"ZOMBIE_BUTTON_TO_SUICIDE");
	}
	return suicided;
}

/*
	Name: can_suicide
	Namespace: zm_laststand
	Checksum: 0x9193FF27
	Offset: 0x28B8
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function can_suicide()
{
	if(!isalive(self))
	{
		return 0;
	}
	if(!self laststand::player_is_in_laststand())
	{
		return 0;
	}
	if(!isdefined(self.suicidePrompt))
	{
		return 0;
	}
	if(isdefined(self.is_zombie) && self.is_zombie)
	{
		return 0;
	}
	if(isdefined(level.intermission) && level.intermission)
	{
		return 0;
	}
	return 1;
}

/*
	Name: is_suiciding
	Namespace: zm_laststand
	Checksum: 0x65451413
	Offset: 0x2948
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function is_suiciding(revivee)
{
	return self useButtonPressed() && can_suicide();
}

/*
	Name: revive_trigger_spawn
	Namespace: zm_laststand
	Checksum: 0x6CD1E842
	Offset: 0x2990
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function revive_trigger_spawn()
{
	if(isdefined(level.revive_trigger_spawn_override_link))
	{
		[[level.revive_trigger_spawn_override_link]](self);
	}
	else
	{
		radius = GetDvarInt("revive_trigger_radius");
		self.reviveTrigger = spawn("trigger_radius", (0, 0, 0), 0, radius, radius);
		self.reviveTrigger setHintString("");
		self.reviveTrigger setcursorhint("HINT_NOICON");
		self.reviveTrigger SetMovingPlatformEnabled(1);
		self.reviveTrigger EnableLinkTo();
		self.reviveTrigger.origin = self.origin;
		self.reviveTrigger LinkTo(self);
		self.reviveTrigger SetInvisibleToPlayer(self);
		self.reviveTrigger.beingRevived = 0;
		self.reviveTrigger.createtime = GetTime();
	}
	self thread revive_trigger_think();
}

/*
	Name: revive_trigger_think
	Namespace: zm_laststand
	Checksum: 0x931BE956
	Offset: 0x2B10
	Size: 0x521
	Parameters: 1
	Flags: None
*/
function revive_trigger_think(t_secondary)
{
	self endon("disconnect");
	self endon("zombified");
	self endon("stop_revive_trigger");
	level endon("end_game");
	self endon("death");
	while(1)
	{
		wait(0.05);
		if(isdefined(t_secondary))
		{
			t_revive = t_secondary;
		}
		else
		{
			t_revive = self.reviveTrigger;
		}
		t_revive setHintString("");
		for(i = 0; i < level.players.size; i++)
		{
			n_depth = 0;
			n_depth = self DepthInWater();
			if(isdefined(t_secondary))
			{
				if(level.players[i] can_revive(self, 1, 1) && level.players[i] istouching(t_revive) || n_depth > 20)
				{
					t_revive setReviveHintString(&"ZOMBIE_BUTTON_TO_REVIVE_PLAYER", self.team);
					break;
				}
				continue;
			}
			if(level.players[i] can_revive_via_override(self) || level.players[i] can_revive(self) || n_depth > 20)
			{
				t_revive setReviveHintString(&"ZOMBIE_BUTTON_TO_REVIVE_PLAYER", self.team);
				break;
			}
		}
		for(i = 0; i < level.players.size; i++)
		{
			e_reviver = level.players[i];
			if(self == e_reviver || !e_reviver is_reviving(self, t_secondary))
			{
				continue;
			}
			if(!isdefined(e_reviver.s_revive_override_used) || e_reviver.s_revive_override_used.b_use_revive_tool)
			{
				w_revive_tool = level.weaponReviveTool;
				if(isdefined(e_reviver.weaponReviveTool))
				{
					w_revive_tool = e_reviver.weaponReviveTool;
				}
				w_reviver = e_reviver GetCurrentWeapon();
				/#
					Assert(isdefined(w_reviver));
				#/
				if(w_reviver == w_revive_tool)
				{
					continue;
				}
				e_reviver GiveWeapon(w_revive_tool);
				e_reviver SwitchToWeapon(w_revive_tool);
				e_reviver SetWeaponAmmoStock(w_revive_tool, 1);
				e_reviver thread revive_give_back_weapons_when_done(w_reviver, w_revive_tool, self);
			}
			else
			{
				w_reviver = undefined;
				w_revive_tool = undefined;
			}
			b_revive_successful = e_reviver revive_do_revive(self, w_reviver, w_revive_tool, t_secondary);
			e_reviver notify("revive_done");
			if(isPlayer(self))
			{
				self AllowJump(1);
			}
			self.laststand = undefined;
			if(b_revive_successful)
			{
				if(isdefined(level.a_revive_success_perk_func))
				{
					foreach(func in level.a_revive_success_perk_func)
					{
						self [[func]]();
					}
				}
				self thread revive_success(e_reviver);
				self laststand::cleanup_suicide_hud();
				self notify("stop_revive_trigger");
				return;
			}
		}
	}
}

/*
	Name: revive_give_back_weapons_wait
	Namespace: zm_laststand
	Checksum: 0x837F5DE9
	Offset: 0x3040
	Size: 0x5D
	Parameters: 2
	Flags: None
*/
function revive_give_back_weapons_wait(e_reviver, e_revivee)
{
	e_revivee endon("disconnect");
	e_revivee endon("zombified");
	e_revivee endon("stop_revive_trigger");
	level endon("end_game");
	e_revivee endon("death");
	e_reviver waittill("revive_done");
}

/*
	Name: revive_give_back_weapons_when_done
	Namespace: zm_laststand
	Checksum: 0x97A18D1D
	Offset: 0x30A8
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function revive_give_back_weapons_when_done(w_reviver, w_revive_tool, e_revivee)
{
	revive_give_back_weapons_wait(self, e_revivee);
	self revive_give_back_weapons(w_reviver, w_revive_tool);
}

/*
	Name: revive_give_back_weapons
	Namespace: zm_laststand
	Checksum: 0x3C6EBBE8
	Offset: 0x3108
	Size: 0x10B
	Parameters: 2
	Flags: None
*/
function revive_give_back_weapons(w_reviver, w_revive_tool)
{
	self TakeWeapon(w_revive_tool);
	if(self laststand::player_is_in_laststand())
	{
		return;
	}
	if(isdefined(level.revive_give_back_weapons_custom_func) && self [[level.revive_give_back_weapons_custom_func]](w_reviver))
	{
		return;
	}
	if(w_reviver != level.weaponNone && !zm_utility::is_placeable_mine(w_reviver) && !zm_equipment::is_equipment(w_reviver) && !w_reviver.isFlourishWeapon && self HasWeapon(w_reviver))
	{
		self zm_weapons::switch_back_primary_weapon(w_reviver);
	}
	else
	{
		self zm_weapons::switch_back_primary_weapon();
	}
}

/*
	Name: can_revive
	Namespace: zm_laststand
	Checksum: 0x85CFE637
	Offset: 0x3220
	Size: 0x2FD
	Parameters: 3
	Flags: None
*/
function can_revive(e_revivee, ignore_sight_checks, ignore_touch_checks)
{
	if(!isdefined(ignore_sight_checks))
	{
		ignore_sight_checks = 0;
	}
	if(!isdefined(ignore_touch_checks))
	{
		ignore_touch_checks = 0;
	}
	if(!isdefined(e_revivee.reviveTrigger))
	{
		return 0;
	}
	if(!isalive(self))
	{
		return 0;
	}
	if(self laststand::player_is_in_laststand())
	{
		return 0;
	}
	if(self.team != e_revivee.team)
	{
		return 0;
	}
	if(isdefined(self.is_zombie) && self.is_zombie)
	{
		return 0;
	}
	if(self zm_utility::has_powerup_weapon())
	{
		return 0;
	}
	if(self zm_utility::has_hero_weapon())
	{
		return 0;
	}
	if(isdefined(level.can_revive_use_depthinwater_test) && level.can_revive_use_depthinwater_test && e_revivee DepthInWater() > 10)
	{
		return 1;
	}
	if(isdefined(level.can_revive) && ![[level.can_revive]](e_revivee))
	{
		return 0;
	}
	if(isdefined(level.can_revive_game_module) && ![[level.can_revive_game_module]](e_revivee))
	{
		return 0;
	}
	if(!ignore_sight_checks && isdefined(level.revive_trigger_should_ignore_sight_checks))
	{
		ignore_sight_checks = [[level.revive_trigger_should_ignore_sight_checks]](self);
		if(ignore_sight_checks && isdefined(e_revivee.reviveTrigger.beingRevived) && e_revivee.reviveTrigger.beingRevived == 1)
		{
			ignore_touch_checks = 1;
		}
	}
	if(!ignore_touch_checks)
	{
		if(!self istouching(e_revivee.reviveTrigger))
		{
			return 0;
		}
	}
	if(!ignore_sight_checks)
	{
		if(!self laststand::is_facing(e_revivee))
		{
			return 0;
		}
		if(!SightTracePassed(self.origin + VectorScale((0, 0, 1), 50), e_revivee.origin + VectorScale((0, 0, 1), 30), 0, undefined))
		{
			return 0;
		}
		if(!BulletTracePassed(self.origin + VectorScale((0, 0, 1), 50), e_revivee.origin + VectorScale((0, 0, 1), 30), 0, undefined))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: is_reviving
	Namespace: zm_laststand
	Checksum: 0x6BB4DD14
	Offset: 0x3528
	Size: 0xB9
	Parameters: 2
	Flags: None
*/
function is_reviving(e_revivee, t_secondary)
{
	if(self is_reviving_via_override(e_revivee))
	{
		return 1;
	}
	if(isdefined(t_secondary))
	{
		return self useButtonPressed() && self can_revive(e_revivee, 1, 1) && self istouching(t_secondary);
	}
	return self useButtonPressed() && can_revive(e_revivee);
}

/*
	Name: is_reviving_any
	Namespace: zm_laststand
	Checksum: 0xEC94B82D
	Offset: 0x35F0
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function is_reviving_any()
{
	return isdefined(self.is_reviving_any) && self.is_reviving_any;
}

/*
	Name: revive_get_revive_time
	Namespace: zm_laststand
	Checksum: 0x51786D81
	Offset: 0x3610
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function revive_get_revive_time(e_revivee)
{
	reviveTime = 3;
	if(self hasPerk("specialty_quickrevive"))
	{
		reviveTime = reviveTime / 2;
	}
	if(self zm_pers_upgrades_functions::pers_revive_active())
	{
		reviveTime = reviveTime * 0.5;
	}
	if(isdefined(self.get_revive_time))
	{
		reviveTime = self [[self.get_revive_time]](e_revivee);
	}
	return reviveTime;
}

/*
	Name: revive_do_revive
	Namespace: zm_laststand
	Checksum: 0x5B65AFB1
	Offset: 0x36C0
	Size: 0x5FF
	Parameters: 4
	Flags: None
*/
function revive_do_revive(e_revivee, w_reviver, w_revive_tool, t_secondary)
{
	/#
		Assert(self is_reviving(e_revivee, t_secondary));
	#/
	reviveTime = self revive_get_revive_time(e_revivee);
	timer = 0;
	revived = 0;
	e_revivee.reviveTrigger.beingRevived = 1;
	name = level.player_name_directive[self GetEntityNumber()];
	e_revivee.revive_hud setText(&"ZOMBIE_PLAYER_IS_REVIVING_YOU", name);
	e_revivee laststand::revive_hud_show_n_fade(3);
	e_revivee.reviveTrigger setHintString("");
	if(isPlayer(e_revivee))
	{
		e_revivee startrevive(self);
	}
	if(0 && !isdefined(self.reviveProgressBar))
	{
		self.reviveProgressBar = self hud::createPrimaryProgressBar();
	}
	if(!isdefined(self.reviveTextHud))
	{
		self.reviveTextHud = newClientHudElem(self);
	}
	self thread laststand_clean_up_on_disconnect(e_revivee, w_reviver, w_revive_tool);
	if(!isdefined(self.is_reviving_any))
	{
		self.is_reviving_any = 0;
	}
	self.is_reviving_any++;
	self thread laststand_clean_up_reviving_any(e_revivee);
	if(isdefined(self.reviveProgressBar))
	{
		self.reviveProgressBar hud::updateBar(0.01, 1 / reviveTime);
	}
	self.reviveTextHud.alignX = "center";
	self.reviveTextHud.alignY = "middle";
	self.reviveTextHud.horzAlign = "center";
	self.reviveTextHud.vertAlign = "bottom";
	self.reviveTextHud.y = -113;
	if(self IsSplitscreen())
	{
		self.reviveTextHud.y = -347;
	}
	self.reviveTextHud.foreground = 1;
	self.reviveTextHud.font = "default";
	self.reviveTextHud.fontscale = 1.8;
	self.reviveTextHud.alpha = 1;
	self.reviveTextHud.color = (1, 1, 1);
	self.reviveTextHud.hidewheninmenu = 1;
	if(self zm_pers_upgrades_functions::pers_revive_active())
	{
		self.reviveTextHud.color = (0.5, 0.5, 1);
	}
	self.reviveTextHud setText(&"ZOMBIE_REVIVING");
	self thread check_for_failed_revive(e_revivee);
	while(self is_reviving(e_revivee, t_secondary))
	{
		wait(0.05);
		timer = timer + 0.05;
		if(self laststand::player_is_in_laststand())
		{
			break;
		}
		if(isdefined(e_revivee.reviveTrigger.auto_revive) && e_revivee.reviveTrigger.auto_revive == 1)
		{
			break;
		}
		if(timer >= reviveTime)
		{
			revived = 1;
			break;
		}
	}
	if(isdefined(self.reviveProgressBar))
	{
		self.reviveProgressBar hud::destroyElem();
	}
	if(isdefined(self.reviveTextHud))
	{
		self.reviveTextHud destroy();
	}
	if(isdefined(e_revivee.reviveTrigger.auto_revive) && e_revivee.reviveTrigger.auto_revive == 1)
	{
	}
	else if(!revived)
	{
		if(isPlayer(e_revivee))
		{
			e_revivee stoprevive(self);
		}
	}
	e_revivee.reviveTrigger setHintString(&"ZOMBIE_BUTTON_TO_REVIVE_PLAYER");
	e_revivee.reviveTrigger.beingRevived = 0;
	self notify("do_revive_ended_normally");
	self.is_reviving_any--;
	if(!revived)
	{
		e_revivee thread checkforbleedout(self);
	}
	return revived;
}

/*
	Name: checkforbleedout
	Namespace: zm_laststand
	Checksum: 0x63E1C1AF
	Offset: 0x3CC8
	Size: 0x9F
	Parameters: 1
	Flags: None
*/
function checkforbleedout(player)
{
	self endon("player_revived");
	self endon("player_suicide");
	self endon("disconnect");
	player endon("disconnect");
	if(isdefined(player) && zm_utility::is_Classic())
	{
		if(!isdefined(player.failed_revives))
		{
			player.failed_revives = 0;
		}
		player.failed_revives++;
		player notify("player_failed_revive");
	}
}

/*
	Name: auto_revive
	Namespace: zm_laststand
	Checksum: 0x9BE30147
	Offset: 0x3D70
	Size: 0x303
	Parameters: 2
	Flags: None
*/
function auto_revive(reviver, dont_enable_weapons)
{
	if(isdefined(self.reviveTrigger))
	{
		self.reviveTrigger.auto_revive = 1;
		if(self.reviveTrigger.beingRevived == 1)
		{
			while(1)
			{
				if(!isdefined(self.reviveTrigger) || self.reviveTrigger.beingRevived == 0)
				{
					break;
				}
				util::wait_network_frame();
			}
		}
		if(isdefined(self.reviveTrigger))
		{
			self.reviveTrigger.auto_trigger = 0;
		}
	}
	self RevivePlayer();
	self zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 0);
	self clientfield::set("zmbLastStand", 0);
	self notify("stop_revive_trigger");
	if(isdefined(self.reviveTrigger))
	{
		self.reviveTrigger delete();
		self.reviveTrigger = undefined;
	}
	self laststand::cleanup_suicide_hud();
	visionset_mgr::deactivate("visionset", "zombie_last_stand", self);
	visionset_mgr::deactivate("visionset", "zombie_death", self);
	self notify("clear_red_flashing_overlay");
	self AllowJump(1);
	self util::delay(2, "death", &set_ignoreme, 0);
	self.laststand = undefined;
	if(!(isdefined(level.isresetting_grief) && level.isresetting_grief))
	{
		if(isPlayer(reviver))
		{
			reviver.revives++;
			reviver zm_stats::increment_client_stat("revives");
			reviver zm_stats::increment_player_stat("revives");
			self RecordPlayerReviveZombies(reviver);
			demo::bookmark("zm_player_revived", GetTime(), reviver, self);
		}
	}
	self notify("player_revived", reviver);
	wait(0.05);
	if(!isdefined(dont_enable_weapons) || dont_enable_weapons == 0)
	{
		self laststand_enable_player_weapons();
	}
}

/*
	Name: remote_revive
	Namespace: zm_laststand
	Checksum: 0xBA4C687C
	Offset: 0x4080
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function remote_revive(reviver)
{
	if(!self laststand::player_is_in_laststand())
	{
		return;
	}
	self playsound("zmb_character_remote_revived");
	self thread auto_revive(reviver);
}

/*
	Name: revive_success
	Namespace: zm_laststand
	Checksum: 0xFD0E21EA
	Offset: 0x40E8
	Size: 0x32B
	Parameters: 2
	Flags: None
*/
function revive_success(reviver, b_track_stats)
{
	if(!isdefined(b_track_stats))
	{
		b_track_stats = 1;
	}
	if(!isPlayer(self))
	{
		self notify("player_revived", reviver);
		return;
	}
	if(isdefined(b_track_stats) && b_track_stats)
	{
		demo::bookmark("zm_player_revived", GetTime(), reviver, self);
	}
	self notify("player_revived", reviver);
	reviver notify("player_did_a_revive", self);
	self RevivePlayer();
	self zm_perks::perk_set_max_health_if_jugg("health_reboot", 1, 0);
	if(isdefined(self.pers_upgrades_awarded["perk_lose"]) && self.pers_upgrades_awarded["perk_lose"])
	{
		self thread zm_pers_upgrades_functions::pers_upgrade_perk_lose_restore();
	}
	if(!isdefined(level.isresetting_grief) && level.isresetting_grief && (isdefined(b_track_stats) && b_track_stats))
	{
		reviver.revives++;
		reviver zm_stats::increment_client_stat("revives");
		reviver zm_stats::increment_player_stat("revives");
		reviver xp_revive_once_per_round(self);
		self RecordPlayerReviveZombies(reviver);
		reviver.upgrade_fx_origin = self.origin;
	}
	if(zm_utility::is_Classic() && (isdefined(b_track_stats) && b_track_stats))
	{
		zm_pers_upgrades_functions::pers_increment_revive_stat(reviver);
	}
	if(isdefined(b_track_stats) && b_track_stats)
	{
		reviver thread check_for_sacrifice();
	}
	self clientfield::set("zmbLastStand", 0);
	self.reviveTrigger delete();
	self.reviveTrigger = undefined;
	self laststand::cleanup_suicide_hud();
	self util::delay(2, "death", &set_ignoreme, 0);
	visionset_mgr::deactivate("visionset", "zombie_last_stand", self);
	visionset_mgr::deactivate("visionset", "zombie_death", self);
	wait(0.05);
	self laststand_enable_player_weapons();
}

/*
	Name: xp_revive_once_per_round
	Namespace: zm_laststand
	Checksum: 0x19FE3493
	Offset: 0x4420
	Size: 0xAD
	Parameters: 1
	Flags: None
*/
function xp_revive_once_per_round(player_being_revived)
{
	if(!isdefined(self.number_revives_per_round))
	{
		self.number_revives_per_round = [];
	}
	if(!isdefined(self.number_revives_per_round[player_being_revived.characterindex]))
	{
		self.number_revives_per_round[player_being_revived.characterindex] = 0;
	}
	if(self.number_revives_per_round[player_being_revived.characterindex] == 0)
	{
		scoreevents::processScoreEvent("revive_an_ally", self);
	}
	self.number_revives_per_round[player_being_revived.characterindex]++;
}

/*
	Name: set_ignoreme
	Namespace: zm_laststand
	Checksum: 0x49CD6B10
	Offset: 0x44D8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function set_ignoreme(b_ignoreme)
{
	if(!isdefined(self.laststand_ignoreme))
	{
		self.laststand_ignoreme = 0;
	}
	if(b_ignoreme != self.laststand_ignoreme)
	{
		self.laststand_ignoreme = b_ignoreme;
		if(b_ignoreme)
		{
			self zm_utility::increment_ignoreme();
		}
		else
		{
			self zm_utility::decrement_ignoreme();
		}
	}
}

/*
	Name: revive_force_revive
	Namespace: zm_laststand
	Checksum: 0xDB33622A
	Offset: 0x4558
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function revive_force_revive(reviver)
{
	/#
		Assert(isdefined(self));
	#/
	/#
		Assert(isPlayer(self));
	#/
	/#
		Assert(self laststand::player_is_in_laststand());
	#/
	self thread revive_success(reviver);
}

/*
	Name: player_getup_setup
	Namespace: zm_laststand
	Checksum: 0xF69CE144
	Offset: 0x45F0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function player_getup_setup()
{
	/#
		println("Dev Block strings are not supported");
	#/
	self.laststand_info = spawnstruct();
	self.laststand_info.type_getup_lives = level.CONST_LASTSTAND_GETUP_COUNT_START;
}

/*
	Name: laststand_getup
	Namespace: zm_laststand
	Checksum: 0x4BEDEC30
	Offset: 0x4650
	Size: 0x133
	Parameters: 0
	Flags: None
*/
function laststand_getup()
{
	self endon("player_revived");
	self endon("disconnect");
	/#
		println("Dev Block strings are not supported");
	#/
	self laststand::update_lives_remaining(0);
	self clientfield::set("zmbLastStand", 1);
	self.laststand_info.getup_bar_value = level.CONST_LASTSTAND_GETUP_BAR_START;
	self thread laststand::laststand_getup_hud();
	self thread laststand_getup_damage_watcher();
	while(self.laststand_info.getup_bar_value < 1)
	{
		self.laststand_info.getup_bar_value = self.laststand_info.getup_bar_value + level.CONST_LASTSTAND_GETUP_BAR_REGEN;
		wait(0.05);
	}
	self auto_revive(self);
	self clientfield::set("zmbLastStand", 0);
}

/*
	Name: laststand_getup_damage_watcher
	Namespace: zm_laststand
	Checksum: 0x1C268730
	Offset: 0x4790
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function laststand_getup_damage_watcher()
{
	self endon("player_revived");
	self endon("disconnect");
	while(1)
	{
		self waittill("damage");
		self.laststand_info.getup_bar_value = self.laststand_info.getup_bar_value - level.CONST_LASTSTAND_GETUP_BAR_DAMAGE;
		if(self.laststand_info.getup_bar_value < 0)
		{
			self.laststand_info.getup_bar_value = 0;
		}
	}
}

/*
	Name: check_for_sacrifice
	Namespace: zm_laststand
	Checksum: 0x58DF4D9C
	Offset: 0x4820
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function check_for_sacrifice()
{
	self util::delay_notify("sacrifice_denied", 1);
	self endon("sacrifice_denied");
	self waittill("player_downed");
	self zm_stats::increment_client_stat("sacrifices");
	self zm_stats::increment_player_stat("sacrifices");
}

/*
	Name: check_for_failed_revive
	Namespace: zm_laststand
	Checksum: 0xF0ED170C
	Offset: 0x48A8
	Size: 0xA3
	Parameters: 1
	Flags: None
*/
function check_for_failed_revive(e_revivee)
{
	self endon("disconnect");
	e_revivee endon("disconnect");
	e_revivee endon("player_suicide");
	self notify("checking_for_failed_revive");
	self endon("checking_for_failed_revive");
	e_revivee endon("player_revived");
	e_revivee waittill("bled_out");
	self zm_stats::increment_client_stat("failed_revives");
	self zm_stats::increment_player_stat("failed_revives");
}

/*
	Name: add_weighted_down
	Namespace: zm_laststand
	Checksum: 0x531C95C3
	Offset: 0x4958
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function add_weighted_down()
{
	if(!level.curr_gametype_affects_rank)
	{
		return;
	}
	weighted_down = 1000;
	if(level.round_number > 0)
	{
		weighted_down = Int(1000 / ceil(level.round_number / 5));
	}
	self AddPlayerStat("weighted_downs", weighted_down);
}

/*
	Name: register_revive_override
	Namespace: zm_laststand
	Checksum: 0x87CF43BA
	Offset: 0x49F8
	Size: 0xED
	Parameters: 3
	Flags: None
*/
function register_revive_override(func_is_reviving, func_can_revive, b_use_revive_tool)
{
	if(!isdefined(func_can_revive))
	{
		func_can_revive = undefined;
	}
	if(!isdefined(b_use_revive_tool))
	{
		b_use_revive_tool = 0;
	}
	if(!isdefined(self.a_s_revive_overrides))
	{
		self.a_s_revive_overrides = [];
	}
	s_revive_override = spawnstruct();
	s_revive_override.func_is_reviving = func_is_reviving;
	if(isdefined(func_can_revive))
	{
		s_revive_override.func_can_revive = func_can_revive;
	}
	else
	{
		s_revive_override.func_can_revive = func_is_reviving;
	}
	s_revive_override.b_use_revive_tool = b_use_revive_tool;
	self.a_s_revive_overrides[self.a_s_revive_overrides.size] = s_revive_override;
	return s_revive_override;
}

/*
	Name: deregister_revive_override
	Namespace: zm_laststand
	Checksum: 0x5B6C5064
	Offset: 0x4AF0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function deregister_revive_override(s_revive_override)
{
	if(isdefined(self.a_s_revive_overrides))
	{
		ArrayRemoveValue(self.a_s_revive_overrides, s_revive_override);
	}
}

/*
	Name: can_revive_via_override
	Namespace: zm_laststand
	Checksum: 0x68426BAE
	Offset: 0x4B30
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function can_revive_via_override(e_revivee)
{
	if(isdefined(self.a_s_revive_overrides))
	{
		for(i = 0; i < self.a_s_revive_overrides.size; i++)
		{
			if(self [[self.a_s_revive_overrides[i].func_can_revive]](e_revivee))
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: is_reviving_via_override
	Namespace: zm_laststand
	Checksum: 0xEAB66055
	Offset: 0x4BB0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function is_reviving_via_override(e_revivee)
{
	if(isdefined(self.a_s_revive_overrides))
	{
		for(i = 0; i < self.a_s_revive_overrides.size; i++)
		{
			if(self [[self.a_s_revive_overrides[i].func_is_reviving]](e_revivee))
			{
				self.s_revive_override_used = self.a_s_revive_overrides[i];
				return 1;
			}
		}
	}
	self.s_revive_override_used = undefined;
	return 0;
}

