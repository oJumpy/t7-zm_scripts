#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace thief;

/*
	Name: __init__sytem__
	Namespace: thief
	Checksum: 0x645AFB8D
	Offset: 0x868
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_thief", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: thief
	Checksum: 0x6C13FA14
	Offset: 0x8A8
	Size: 0x26B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "thief_state", 11000, 2, "int");
	clientfield::register("toplayer", "thief_weapon_option", 11000, 4, "int");
	ability_player::register_gadget_activation_callbacks(44, &gadget_thief_on_activate, &gadget_thief_on_deactivate);
	ability_player::register_gadget_possession_callbacks(44, &gadget_thief_on_give, &gadget_thief_on_take);
	ability_player::register_gadget_flicker_callbacks(44, &gadget_thief_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(44, &gadget_thief_is_inuse);
	ability_player::register_gadget_ready_callbacks(44, &gadget_thief_is_ready);
	ability_player::register_gadget_is_flickering_callbacks(44, &gadget_thief_is_flickering);
	clientfield::register("scriptmover", "gadget_thief_fx", 11000, 1, "int");
	clientfield::register("clientuimodel", "playerAbilities.playerGadget3.flashStart", 11000, 3, "int");
	clientfield::register("clientuimodel", "playerAbilities.playerGadget3.flashEnd", 11000, 3, "int");
	callback::on_connect(&gadget_thief_on_connect);
	callback::on_spawned(&gadget_thief_on_player_spawn);
	setup_gadget_thief_array();
	level.gadgetThiefTimeCharge = 0;
	level.gadgetThiefShutdownFullcharge = GetDvarInt("gadgetThiefShutdownFullCharge", 1);
	/#
		level thread updateDvars();
	#/
}

/*
	Name: updateDvars
	Namespace: thief
	Checksum: 0xF51BB4D
	Offset: 0xB20
	Size: 0x3F
	Parameters: 0
	Flags: None
*/
function updateDvars()
{
	/#
		while(1)
		{
			level.gadgetThiefTimeCharge = GetDvarInt("Dev Block strings are not supported", 0);
			wait(1);
		}
	#/
}

/*
	Name: setup_gadget_thief_array
	Namespace: thief
	Checksum: 0xB755B5E2
	Offset: 0xB68
	Size: 0x1D5
	Parameters: 0
	Flags: None
*/
function setup_gadget_thief_array()
{
	weapons = EnumerateWeapons("weapon");
	level.gadgetthiefArray = [];
	for(i = 0; i < weapons.size; i++)
	{
		if(weapons[i].isgadget && weapons[i].isHeroWeapon == 1)
		{
			if(weapons[i].name != "gadget_thief" && weapons[i].name != "gadget_roulette" && weapons[i].name != "hero_bowlauncher2" && weapons[i].name != "hero_bowlauncher3" && weapons[i].name != "hero_bowlauncher4" && weapons[i].name != "hero_pineapple_grenade" && weapons[i].name != "gadget_speed_burst" && weapons[i].name != "hero_minigun_body3" && weapons[i].name != "hero_lightninggun_arc")
			{
				ArrayInsert(level.gadgetthiefArray, weapons[i], 0);
			}
		}
	}
}

/*
	Name: gadget_thief_is_inuse
	Namespace: thief
	Checksum: 0x86FDE913
	Offset: 0xD48
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_thief_is_inuse(slot)
{
	return self GadgetIsActive(slot);
}

/*
	Name: gadget_thief_is_flickering
	Namespace: thief
	Checksum: 0x32161E00
	Offset: 0xD78
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_thief_is_flickering(slot)
{
	return self GadgetFlickering(slot);
}

/*
	Name: gadget_thief_on_flicker
	Namespace: thief
	Checksum: 0xB1063DE9
	Offset: 0xDA8
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gadget_thief_on_flicker(slot, weapon)
{
	self thread gadget_thief_flicker(slot, weapon);
}

/*
	Name: gadget_thief_on_give
	Namespace: thief
	Checksum: 0x32653016
	Offset: 0xDE8
	Size: 0x1A3
	Parameters: 2
	Flags: None
*/
function gadget_thief_on_give(slot, weapon)
{
	self.gadget_thief_kill_callback = &gadget_thief_kill_callback;
	self.gadget_thief_slot = slot;
	self thread gadget_thief_active(slot, weapon);
	if(SessionModeIsMultiplayerGame())
	{
		self.isThief = 1;
	}
	self clientfield::set_to_player("thief_state", 0);
	if(isdefined(self GadgetPowerGet(slot)))
	{
	}
	else
	{
	}
	currentPower = 0;
	savedPower = 0;
	if(isdefined(self.pers["held_gadgets_power"]) && isdefined(self.pers["hash_c35f137f"]) && isdefined(self.pers["held_gadgets_power"][self.pers["hash_c35f137f"]]))
	{
		savedPower = self.pers["held_gadgets_power"][self.pers["hash_c35f137f"]];
	}
	if(currentPower >= 100 || savedPower >= 100)
	{
		self.giveStolenWeaponOnSpawn = 1;
		self.giveStolenWeaponSlot = slot;
	}
}

/*
	Name: gadget_thief_kill_callback
	Namespace: thief
	Checksum: 0x56A2A451
	Offset: 0xF98
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function gadget_thief_kill_callback(victim, weapon)
{
	/#
		Assert(isdefined(self.gadget_thief_slot));
	#/
	self thread handleThiefKill(self.gadget_thief_slot, weapon, victim);
}

/*
	Name: gadget_thief_on_take
	Namespace: thief
	Checksum: 0xA7A1FFAA
	Offset: 0x1000
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gadget_thief_on_take(slot, weapon)
{
	/#
		if(level.var_e76bb7e3 === 1)
		{
			self.isThief = 0;
		}
	#/
}

/*
	Name: gadget_thief_on_connect
	Namespace: thief
	Checksum: 0xE4040F63
	Offset: 0x1040
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function gadget_thief_on_connect()
{
	self.pers["hash_c5c4a13f"] = 1;
	/#
		level.var_bc61f38b = GetDvarInt("Dev Block strings are not supported", 0);
		if(level.var_bc61f38b)
		{
			self thread function_8da00c80();
		}
	#/
}

/*
	Name: gadget_thief_on_player_spawn
	Namespace: thief
	Checksum: 0x3DF4EBFF
	Offset: 0x10B0
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function gadget_thief_on_player_spawn()
{
	if(self.isThief === 1)
	{
		self thread watchHeroWeaponChanged();
		if(self.giveStolenWeaponOnSpawn === 1)
		{
			self givePreviouslyEarnedSpecialistWeapon(self.giveStolenWeaponSlot, 1);
			self GadgetPowerSet(self.giveStolenWeaponSlot, 100);
			self.giveStolenWeaponOnSpawn = undefined;
			self.giveStolenWeaponSlot = undefined;
		}
	}
}

/*
	Name: watch_entity_shutdown
	Namespace: thief
	Checksum: 0x99EC1590
	Offset: 0x1148
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function watch_entity_shutdown()
{
}

/*
	Name: gadget_thief_on_activate
	Namespace: thief
	Checksum: 0xE299EC34
	Offset: 0x1158
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_thief_on_activate(slot, weapon)
{
}

/*
	Name: gadget_thief_is_ready
	Namespace: thief
	Checksum: 0x21A9851
	Offset: 0x1178
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_thief_is_ready(slot, weapon)
{
}

/*
	Name: gadget_thief_active
	Namespace: thief
	Checksum: 0xE407A7C
	Offset: 0x1198
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function gadget_thief_active(slot, weapon)
{
	waittillframeend;
	if(isdefined(self.pers["hash_c35f137f"]) && weapon.name != "gadget_thief")
	{
		self thread gadget_give_random_gadget(slot, weapon, self.pers["hash_476984c8"]);
	}
	self thread watchForHeroKill(slot);
}

/*
	Name: getStolenHeroWeapon
	Namespace: thief
	Checksum: 0x5B807518
	Offset: 0x1230
	Size: 0x171
	Parameters: 1
	Flags: None
*/
function getStolenHeroWeapon(gadget)
{
	if(gadget.isHeroWeapon == 0)
	{
		heroWeaponEquivalent = "";
		switch(gadget.name)
		{
			case "gadget_flashback":
			{
				heroWeaponEquivalent = "hero_lightninggun";
				break;
			}
			case "gadget_combat_efficiency":
			{
				heroWeaponEquivalent = "hero_annihilator";
				break;
			}
			case "gadget_heat_wave":
			{
				heroWeaponEquivalent = "hero_flamethrower";
				break;
			}
			case "gadget_vision_pulse":
			{
				heroWeaponEquivalent = "hero_bowlauncher";
				break;
			}
			case "gadget_speed_burst":
			{
				heroWeaponEquivalent = "hero_gravityspikes";
				break;
			}
			case "gadget_camo":
			{
				heroWeaponEquivalent = "hero_armblade";
				break;
			}
			case "gadget_armor":
			{
				heroWeaponEquivalent = "hero_pineapplegun";
				break;
			}
			case "gadget_resurrect":
			{
				heroWeaponEquivalent = "hero_chemicalgelgun";
				break;
			}
			case "gadget_clone":
			{
				heroWeaponEquivalent = "hero_minigun";
				break;
			}
		}
		if(heroWeaponEquivalent != "")
		{
			heroWeapon = GetWeapon(heroWeaponEquivalent);
		}
	}
	else
	{
		heroWeapon = gadget;
	}
	return heroWeapon;
}

/*
	Name: resetFlashStartAndEndAfterDelay
	Namespace: thief
	Checksum: 0xD99D4A12
	Offset: 0x13B0
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function resetFlashStartAndEndAfterDelay(delay)
{
	self notify("resetFlashStartAndEnd");
	self endon("resetFlashStartAndEnd");
	wait(delay);
	self clientfield::set_player_uimodel("playerAbilities.playerGadget3.flashStart", 0);
	self clientfield::set_player_uimodel("playerAbilities.playerGadget3.flashEnd", 0);
}

/*
	Name: getThiefPowerGain
	Namespace: thief
	Checksum: 0xCE642199
	Offset: 0x1428
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function getThiefPowerGain()
{
	gadgetThiefKillPowerGain = GetDvarFloat("gadgetThiefKillPowerGain", 12.5);
	if(isdefined(GetGametypeSetting("scoreThiefPowerGainFactor")))
	{
	}
	else
	{
	}
	thiefGametypeFactor = 1;
	gadgetThiefKillPowerGain = gadgetThiefKillPowerGain * thiefGametypeFactor;
	return gadgetThiefKillPowerGain;
}

/*
	Name: handleThiefKill
	Namespace: thief
	Checksum: 0xDF54EDC8
	Offset: 0x14C8
	Size: 0x383
	Parameters: 3
	Flags: None
*/
function handleThiefKill(slot, weapon, victim)
{
	if(isdefined(weapon) && !killstreaks::is_killstreak_weapon(weapon) && !weapon.isHeroWeapon && isalive(self))
	{
		if(self GadgetIsActive(slot) == 0)
		{
			power = self GadgetPowerGet(slot);
			gadgetThiefKillPowerGain = getThiefPowerGain();
			gadgetThiefKillPowerGainWithoutMultiplier = getThiefPowerGain();
			if(isdefined(victim GadgetPowerGet(0)))
			{
			}
			else
			{
			}
			victimGadgetPower = 0;
			alwaysPerformGain = 0;
			if(alwaysPerformGain || power < 100)
			{
				if(victimGadgetPower == 100)
				{
					self playsoundtoplayer("mpl_bm_specialist_bar_thief", self);
				}
				else
				{
					self playsoundtoplayer("mpl_bm_specialist_bar_thief", self);
				}
			}
			currentPower = power + gadgetThiefKillPowerGain;
			if(power < 80 && currentPower >= 80 && currentPower < 100)
			{
				if(self hasPerk("specialty_overcharge"))
				{
					currentPower = 100;
				}
			}
			if(currentPower >= 100)
			{
				wasFullyCharged = power >= 100;
				self earnedSpecialistWeapon(victim, slot, wasFullyCharged);
			}
			self clientfield::set_player_uimodel("playerAbilities.playerGadget3.flashStart", Int(power / gadgetThiefKillPowerGainWithoutMultiplier));
			self clientfield::set_player_uimodel("playerAbilities.playerGadget3.flashEnd", Int(currentPower / gadgetThiefKillPowerGainWithoutMultiplier));
			self thread resetFlashStartAndEndAfterDelay(3);
			self GadgetPowerSet(slot, currentPower);
		}
		else if(isPlayer(victim) && self.pers["hash_476984c8"] === victim.entnum && weapon.isHeroWeapon)
		{
			scoreevents::processScoreEvent("kill_enemy_with_their_hero_weapon", self);
		}
	}
}

/*
	Name: earnedSpecialistWeapon
	Namespace: thief
	Checksum: 0x9BB3AF16
	Offset: 0x1858
	Size: 0x303
	Parameters: 4
	Flags: None
*/
function earnedSpecialistWeapon(victim, slot, wasFullyCharged, stolenHeroWeapon)
{
	if(!isdefined(victim))
	{
		return;
	}
	heroWeapon = undefined;
	victimIsBlackjack = victim.isThief === 1 || victim.isRoulette === 1;
	if(victimIsBlackjack)
	{
		if(isdefined(stolenHeroWeapon))
		{
			heroWeapon = stolenHeroWeapon;
		}
		else if(isdefined(victim.pers["hash_c35f137f"]) && victim.pers["hash_c35f137f"].isHeroWeapon === 1)
		{
			heroWeapon = victim.pers["hash_c35f137f"];
		}
	}
	if(!isdefined(heroWeapon))
	{
		victimGadget = victim._gadgets_player[0];
		heroWeapon = getStolenHeroWeapon(victimGadget);
	}
	if(wasFullyCharged)
	{
		if(isdefined(heroWeapon) && isdefined(self.pers["hash_c35f137f"]) && heroWeapon != self.pers["hash_c35f137f"] && (!isdefined(self.pers["hash_5c5e3658"]) || heroWeapon != self.pers["hash_5c5e3658"]) && self.pers["hash_c5c4a13f"])
		{
			self thread giveFlipWeapon(slot, victim, heroWeapon);
		}
	}
	else
	{
		self clientfield::set_to_player("thief_state", 1);
		self clientfield::set_to_player("thief_weapon_option", 0);
		self thread gadget_give_random_gadget(slot, heroWeapon, victim.entnum);
		self.pers["hash_5c5e3658"] = undefined;
		self.thief_new_gadget_time = GetTime();
		if(isdefined(self.pers["hash_c35f137f"]) && self.pers["hash_c35f137f"].isHeroWeapon === 1)
		{
			self handleStolenScoreEvent(self.pers["hash_c35f137f"]);
		}
		self playsoundtoplayer("mpl_bm_specialist_bar_filled", self);
	}
}

/*
	Name: giveFlipWeapon
	Namespace: thief
	Checksum: 0xA8AAD111
	Offset: 0x1B68
	Size: 0x1BB
	Parameters: 3
	Flags: None
*/
function giveFlipWeapon(slot, victim, heroWeapon)
{
	self notify("give_flip_weapon_singleton");
	self endon("give_flip_weapon_singleton");
	if(isdefined(self.last_thief_give_flip_time))
	{
	}
	else
	{
	}
	previousGiveFlipTime = 0;
	self.last_thief_give_flip_time = GetTime();
	alreadyGivenFlipThisFrame = previousGiveFlipTime == self.last_thief_give_flip_time;
	self.pers["hash_5c5e3658"] = heroWeapon;
	victimBodyIndex = GetVictimBodyIndex(victim, heroWeapon);
	self handleStolenScoreEvent(heroWeapon);
	self notify("thief_flip_activated", self.last_thief_give_flip_time);
	if(self.last_thief_give_flip_time - previousGiveFlipTime > 99)
	{
		self playsoundtoplayer("mpl_bm_specialist_coin_place", self);
	}
	if(isdefined(self.thief_new_gadget_time))
	{
	}
	else
	{
	}
	elapsed_time = self.thief_new_gadget_time - 0 * 0.001;
	if(elapsed_time < 0.75)
	{
		wait(0.75 - elapsed_time);
	}
	self clientfield::set_to_player("thief_state", 2);
	self thread watchForOptionUse(slot, victimBodyIndex, 0);
}

/*
	Name: givePreviouslyEarnedSpecialistWeapon
	Namespace: thief
	Checksum: 0x25FE5033
	Offset: 0x1D30
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function givePreviouslyEarnedSpecialistWeapon(slot, justSpawned)
{
	if(isdefined(self.pers["hash_c35f137f"]))
	{
		self thread gadget_give_random_gadget(slot, self.pers["hash_c35f137f"], self.pers["hash_476984c8"], justSpawned);
		if(isdefined(self.pers["hash_5c5e3658"]))
		{
			self thread watchForOptionUse(slot, self.pers["hash_6de3aefa"], justSpawned);
		}
	}
}

/*
	Name: disable_hero_gadget_activation
	Namespace: thief
	Checksum: 0xA1081A37
	Offset: 0x1DE0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function disable_hero_gadget_activation(duration)
{
	self endon("death");
	self endon("disconnect");
	self endon("thief_flip_activated");
	self DisableOffhandSpecial();
	wait(duration);
	self EnableOffhandSpecial();
}

/*
	Name: failsafe_reenable_offhand_special
	Namespace: thief
	Checksum: 0x39F462E5
	Offset: 0x1E48
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function failsafe_reenable_offhand_special()
{
	self endon("end_failsafe_reenable_offhand_special");
	wait(3);
	if(isdefined(self))
	{
		self EnableOffhandSpecial();
	}
}

/*
	Name: handleStolenScoreEvent
	Namespace: thief
	Checksum: 0x27CFB19F
	Offset: 0x1E88
	Size: 0x203
	Parameters: 1
	Flags: None
*/
function handleStolenScoreEvent(heroWeapon)
{
	switch(heroWeapon.name)
	{
		case "hero_minigun":
		case "hero_minigun_body3":
		{
			event = "minigun_stolen";
			label = "SCORE_MINIGUN_STOLEN";
			break;
		}
		case "hero_flamethrower":
		{
			event = "flamethrower_stolen";
			label = "SCORE_FLAMETHROWER_STOLEN";
			break;
		}
		case "hero_lightninggun":
		case "hero_lightninggun_arc":
		{
			event = "lightninggun_stolen";
			label = "SCORE_LIGHTNINGGUN_STOLEN";
			break;
		}
		case "hero_chemicalgelgun":
		case "hero_firefly_swarm":
		{
			event = "gelgun_stolen";
			label = "SCORE_GELGUN_STOLEN";
			break;
		}
		case "hero_pineapple_grenade":
		case "hero_pineapplegun":
		{
			event = "pineapple_stolen";
			label = "SCORE_PINEAPPLE_STOLEN";
			break;
		}
		case "hero_armblade":
		{
			event = "armblades_stolen";
			label = "SCORE_ARMBLADES_STOLEN";
			break;
		}
		case "hero_bowlauncher":
		case "hero_bowlauncher2":
		case "hero_bowlauncher3":
		case "hero_bowlauncher4":
		{
			event = "bowlauncher_stolen";
			label = "SCORE_BOWLAUNCHER_STOLEN";
			break;
		}
		case "hero_gravityspikes":
		{
			event = "gravityspikes_stolen";
			label = "SCORE_GRAVITYSPIKES_STOLEN";
			break;
		}
		case "hero_annihilator":
		{
			event = "annihilator_stolen";
			label = "SCORE_ANNIHILATOR_STOLEN";
			break;
		}
		case default:
		{
			return;
		}
	}
	self LUINotifyEvent(&"score_event", 5, istring(label), 0, 0, 0, 1);
}

/*
	Name: watchForHeroKill
	Namespace: thief
	Checksum: 0x9603C5FB
	Offset: 0x2098
	Size: 0x207
	Parameters: 1
	Flags: None
*/
function watchForHeroKill(slot)
{
	self notify("watchForThiefKill_singleton");
	self endon("watchForThiefKill_singleton");
	self.gadgetThiefActive = 1;
	while(1)
	{
		self waittill("hero_shutdown_gadget", heroGadget, victim);
		stolenHeroWeapon = getStolenHeroWeapon(heroGadget);
		performClientSideEffect = 0;
		if(performClientSideEffect)
		{
			self spawnThiefBeamEffect(victim.origin);
			clientSideEffect = spawn("script_model", victim.origin);
			clientSideEffect clientfield::set("gadget_thief_fx", 1);
			clientSideEffect thread waitThenDelete(5);
		}
		if(isdefined(level.gadgetThiefShutdownFullcharge) && level.gadgetThiefShutdownFullcharge)
		{
			if(self GadgetIsActive(slot) == 0)
			{
				scoreevents::processScoreEvent("thief_shutdown_enemy", self);
				power = self GadgetPowerGet(slot);
				self GadgetPowerSet(slot, 100);
				wasFullyCharged = power >= 100;
				self earnedSpecialistWeapon(victim, slot, wasFullyCharged, stolenHeroWeapon);
			}
		}
	}
}

/*
	Name: spawnThiefBeamEffect
	Namespace: thief
	Checksum: 0xB9CBEDA
	Offset: 0x22A8
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function spawnThiefBeamEffect(origin)
{
	clientSideEffect = spawn("script_model", origin);
	clientSideEffect clientfield::set("gadget_thief_fx", 1);
	clientSideEffect thread waitThenDelete(5);
}

/*
	Name: function_8da00c80
	Namespace: thief
	Checksum: 0x76089856
	Offset: 0x2328
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function function_8da00c80()
{
	/#
		while(1)
		{
			self waittill("killed_enemy_player", victim);
			self spawnThiefBeamEffect(victim.origin);
			clientSideEffect = spawn("Dev Block strings are not supported", victim.origin);
			clientSideEffect clientfield::set("Dev Block strings are not supported", 1);
			clientSideEffect thread waitThenDelete(5);
		}
	#/
}

/*
	Name: waitThenDelete
	Namespace: thief
	Checksum: 0x5D3F197C
	Offset: 0x23F0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function waitThenDelete(time)
{
	wait(time);
	self delete();
}

/*
	Name: gadget_give_random_gadget
	Namespace: thief
	Checksum: 0x7274BF44
	Offset: 0x2420
	Size: 0x20B
	Parameters: 4
	Flags: None
*/
function gadget_give_random_gadget(slot, weapon, weaponStolenFromEntnum, justSpawned)
{
	if(!isdefined(justSpawned))
	{
		justSpawned = 0;
	}
	previousGadget = undefined;
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self._gadgets_player[i]))
		{
			if(!isdefined(previousGadget))
			{
				previousGadget = self._gadgets_player[i];
			}
			self TakeWeapon(self._gadgets_player[i]);
		}
	}
	if(!isdefined(weapon))
	{
		weapon = Array::random(level.gadgetthiefArray);
	}
	selectedWeapon = weapon;
	/#
		if(GetDvarInt("Dev Block strings are not supported", -1) != -1)
		{
			selectedWeapon = level.gadgetthiefArray[GetDvarInt("Dev Block strings are not supported", -1)];
		}
	#/
	self GiveWeapon(selectedWeapon);
	self GadgetCharging(slot, level.gadgetThiefTimeCharge);
	self.gadgetThiefChargingSlot = slot;
	self.pers["hash_c35f137f"] = selectedWeapon;
	self.pers["hash_476984c8"] = weaponStolenFromEntnum;
	if(!isdefined(previousGadget) || previousGadget != selectedWeapon)
	{
		self notify("thief_hero_weapon_changed", justSpawned, selectedWeapon);
	}
	self thread watchGadgetActivated(slot);
}

/*
	Name: watchForOptionUse
	Namespace: thief
	Checksum: 0xBFCC443B
	Offset: 0x2638
	Size: 0x1F7
	Parameters: 3
	Flags: None
*/
function watchForOptionUse(slot, victimBodyIndex, justSpawned)
{
	self endon("death");
	self endon("hero_gadget_activated");
	self notify("watchForOptionUse_thief_singleton");
	self endon("watchForOptionUse_thief_singleton");
	if(self.pers["hash_c5c4a13f"] == 0)
	{
		return;
	}
	self clientfield::set_to_player("thief_weapon_option", victimBodyIndex + 1);
	self.pers["hash_6de3aefa"] = victimBodyIndex;
	if(!justSpawned)
	{
		wait(0.85);
		self EnableOffhandSpecial();
		self notify("end_failsafe_reenable_offhand_special");
	}
	while(1)
	{
		if(self dpad_left_pressed())
		{
			self clientfield::set_to_player("thief_state", 1);
			self clientfield::set_to_player("thief_weapon_option", 0);
			self.pers["hash_c35f137f"] = self.pers["hash_5c5e3658"];
			self.pers["hash_5c5e3658"] = undefined;
			self.pers["hash_c5c4a13f"] = 0;
			self thread gadget_give_random_gadget(slot, self.pers["hash_c35f137f"], self.pers["hash_476984c8"]);
			if(isdefined(level.playGadgetReady))
			{
				self thread [[level.playGadgetReady]](self.pers["hash_c35f137f"], 1);
			}
			return;
		}
		wait(0.05);
	}
}

/*
	Name: dpad_left_pressed
	Namespace: thief
	Checksum: 0x4596C014
	Offset: 0x2838
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function dpad_left_pressed()
{
	return self ActionSlotThreeButtonPressed();
}

/*
	Name: watchHeroWeaponChanged
	Namespace: thief
	Checksum: 0x9C74B7FC
	Offset: 0x2860
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function watchHeroWeaponChanged()
{
	self notify("watchHeroWeaponChanged_singleton");
	self endon("watchHeroWeaponChanged_singleton");
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		self waittill("thief_hero_weapon_changed", justSpawned, newWeapon);
		if(justSpawned)
		{
			if(isdefined(newWeapon) && isdefined(newWeapon.gadgetReadySoundPlayer))
			{
				self playsoundtoplayer(newWeapon.gadgetReadySoundPlayer, self);
			}
		}
		else
		{
			self playsoundtoplayer("mpl_bm_specialist_thief", self);
		}
	}
}

/*
	Name: watchGadgetActivated
	Namespace: thief
	Checksum: 0x13B99CCD
	Offset: 0x2938
	Size: 0x1C3
	Parameters: 1
	Flags: None
*/
function watchGadgetActivated(slot)
{
	self notify("watchGadgetActivated_singleton");
	self endon("watchGadgetActivated_singleton");
	self waittill("hero_gadget_activated");
	self clientfield::set_to_player("thief_weapon_option", 0);
	self.pers["hash_c35f137f"] = undefined;
	self.pers["hash_5c5e3658"] = undefined;
	self.pers["hash_c5c4a13f"] = 1;
	self waittill("heroAbility_off");
	power = self GadgetPowerGet(slot);
	power = Int(power / getThiefPowerGain()) * getThiefPowerGain();
	self GadgetPowerSet(slot, power);
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self._gadgets_player[i]))
		{
			self TakeWeapon(self._gadgets_player[i]);
		}
	}
	self GiveWeapon(GetWeapon("gadget_thief"));
	self clientfield::set_to_player("thief_state", 0);
}

/*
	Name: gadget_thief_on_deactivate
	Namespace: thief
	Checksum: 0x8CC4CF03
	Offset: 0x2B08
	Size: 0xBF
	Parameters: 2
	Flags: None
*/
function gadget_thief_on_deactivate(slot, weapon)
{
	self waittill("heroAbility_off");
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self._gadgets_player[i]))
		{
			self TakeWeapon(self._gadgets_player[i]);
		}
	}
	self GiveWeapon(weapon);
	self GadgetCharging(slot, level.gadgetThiefTimeCharge);
	self.gadgetThiefChargingSlot = slot;
}

/*
	Name: gadget_thief_flicker
	Namespace: thief
	Checksum: 0x2DFC9126
	Offset: 0x2BD0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_thief_flicker(slot, weapon)
{
}

/*
	Name: set_gadget_status
	Namespace: thief
	Checksum: 0x10A85E9A
	Offset: 0x2BF0
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function set_gadget_status(status, time)
{
	timeStr = "";
	if(isdefined(time))
	{
		timeStr = "^3" + ", time: " + time;
	}
	if(GetDvarInt("scr_cpower_debug_prints") > 0)
	{
		self IPrintLnBold("Gadget thief: " + status + timeStr);
	}
}

/*
	Name: GetVictimBodyIndex
	Namespace: thief
	Checksum: 0x88CA1205
	Offset: 0x2C98
	Size: 0x151
	Parameters: 2
	Flags: None
*/
function GetVictimBodyIndex(victim, heroWeapon)
{
	bodyIndex = victim GetCharacterBodyType();
	if(bodyIndex == 9)
	{
		switch(heroWeapon.name)
		{
			case "hero_minigun":
			case "hero_minigun_body3":
			{
				bodyIndex = 6;
				break;
			}
			case "hero_flamethrower":
			{
				bodyIndex = 8;
				break;
			}
			case "hero_lightninggun":
			{
				bodyIndex = 2;
				break;
			}
			case "hero_chemicalgelgun":
			{
				bodyIndex = 5;
				break;
			}
			case "hero_pineapplegun":
			{
				bodyIndex = 3;
				break;
			}
			case "hero_armblade":
			{
				bodyIndex = 7;
				break;
			}
			case "hero_bowlauncher":
			case "hero_bowlauncher2":
			case "hero_bowlauncher3":
			case "hero_bowlauncher4":
			{
				bodyIndex = 1;
				break;
			}
			case "hero_gravityspikes":
			{
				bodyIndex = 0;
				break;
			}
			case "hero_annihilator":
			case default:
			{
				bodyIndex = 4;
				break;
			}
		}
	}
	return bodyIndex;
}

