#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\abilities\gadgets\_gadget_active_camo;
#using scripts\shared\abilities\gadgets\_gadget_armor;
#using scripts\shared\abilities\gadgets\_gadget_cacophany;
#using scripts\shared\abilities\gadgets\_gadget_camo;
#using scripts\shared\abilities\gadgets\_gadget_cleanse;
#using scripts\shared\abilities\gadgets\_gadget_clone;
#using scripts\shared\abilities\gadgets\_gadget_combat_efficiency;
#using scripts\shared\abilities\gadgets\_gadget_concussive_wave;
#using scripts\shared\abilities\gadgets\_gadget_es_strike;
#using scripts\shared\abilities\gadgets\_gadget_exo_breakdown;
#using scripts\shared\abilities\gadgets\_gadget_firefly_swarm;
#using scripts\shared\abilities\gadgets\_gadget_flashback;
#using scripts\shared\abilities\gadgets\_gadget_forced_malfunction;
#using scripts\shared\abilities\gadgets\_gadget_heat_wave;
#using scripts\shared\abilities\gadgets\_gadget_hero_weapon;
#using scripts\shared\abilities\gadgets\_gadget_iff_override;
#using scripts\shared\abilities\gadgets\_gadget_immolation;
#using scripts\shared\abilities\gadgets\_gadget_misdirection;
#using scripts\shared\abilities\gadgets\_gadget_mrpukey;
#using scripts\shared\abilities\gadgets\_gadget_other;
#using scripts\shared\abilities\gadgets\_gadget_overdrive;
#using scripts\shared\abilities\gadgets\_gadget_rapid_strike;
#using scripts\shared\abilities\gadgets\_gadget_ravage_core;
#using scripts\shared\abilities\gadgets\_gadget_resurrect;
#using scripts\shared\abilities\gadgets\_gadget_roulette;
#using scripts\shared\abilities\gadgets\_gadget_security_breach;
#using scripts\shared\abilities\gadgets\_gadget_sensory_overload;
#using scripts\shared\abilities\gadgets\_gadget_servo_shortout;
#using scripts\shared\abilities\gadgets\_gadget_shock_field;
#using scripts\shared\abilities\gadgets\_gadget_smokescreen;
#using scripts\shared\abilities\gadgets\_gadget_speed_burst;
#using scripts\shared\abilities\gadgets\_gadget_surge;
#using scripts\shared\abilities\gadgets\_gadget_system_overload;
#using scripts\shared\abilities\gadgets\_gadget_thief;
#using scripts\shared\abilities\gadgets\_gadget_unstoppable_force;
#using scripts\shared\abilities\gadgets\_gadget_vision_pulse;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\replay_gun;

#namespace ability_player;

/*
	Name: __init__sytem__
	Namespace: ability_player
	Checksum: 0x15DADA27
	Offset: 0xBA8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ability_player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ability_player
	Checksum: 0x1171DEF3
	Offset: 0xBE8
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_abilities();
	setup_clientfields();
	level thread gadgets_wait_for_game_end();
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	callback::on_disconnect(&on_player_disconnect);
	if(!isdefined(level._gadgets_level))
	{
		level._gadgets_level = [];
	}
	/#
		level thread abilities_devgui_init();
	#/
}

/*
	Name: init_abilities
	Namespace: ability_player
	Checksum: 0x99EC1590
	Offset: 0xCC0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function init_abilities()
{
}

/*
	Name: setup_clientfields
	Namespace: ability_player
	Checksum: 0x99EC1590
	Offset: 0xCD0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function setup_clientfields()
{
}

/*
	Name: on_player_connect
	Namespace: ability_player
	Checksum: 0x47B2A0B0
	Offset: 0xCE0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	if(!isdefined(self._gadgets_player))
	{
		self._gadgets_player = [];
	}
	/#
		self thread abilities_devgui_player_connect();
	#/
}

/*
	Name: on_player_spawned
	Namespace: ability_player
	Checksum: 0xC335CAFA
	Offset: 0xD20
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self thread gadgets_wait_for_death();
	self.heroAbilityActivateTime = undefined;
	self.heroAbilityDectivateTime = undefined;
	self.heroAbilityActive = undefined;
}

/*
	Name: on_player_disconnect
	Namespace: ability_player
	Checksum: 0x2BD5899D
	Offset: 0xD60
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function on_player_disconnect()
{
	/#
		self thread abilities_devgui_player_disconnect();
	#/
}

/*
	Name: is_using_any_gadget
	Namespace: ability_player
	Checksum: 0x67E528A2
	Offset: 0xD88
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function is_using_any_gadget()
{
	if(!isPlayer(self))
	{
		return 0;
	}
	for(i = 0; i < 3; i++)
	{
		if(self gadget_is_in_use(i))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: gadgets_save_power
	Namespace: ability_player
	Checksum: 0xFDECCBA7
	Offset: 0xE00
	Size: 0x135
	Parameters: 1
	Flags: None
*/
function gadgets_save_power(game_ended)
{
	for(slot = 0; slot < 3; slot++)
	{
		if(!isdefined(self._gadgets_player[slot]))
		{
			continue;
		}
		gadgetWeapon = self._gadgets_player[slot];
		powerLeft = self GadgetPowerChange(slot, 0);
		if(game_ended && gadget_is_in_use(slot))
		{
			self GadgetDeactivate(slot, gadgetWeapon);
			if(gadgetWeapon.gadget_power_round_end_active_penalty > 0)
			{
				powerLeft = powerLeft - gadgetWeapon.gadget_power_round_end_active_penalty;
				powerLeft = max(0, powerLeft);
			}
		}
		self.pers["held_gadgets_power"][gadgetWeapon] = powerLeft;
	}
}

/*
	Name: gadgets_wait_for_death
	Namespace: ability_player
	Checksum: 0x31CAD955
	Offset: 0xF40
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function gadgets_wait_for_death()
{
	self endon("disconnect");
	self.pers["held_gadgets_power"] = [];
	self waittill("death");
	if(!isdefined(self._gadgets_player))
	{
		return;
	}
	self gadgets_save_power(0);
}

/*
	Name: gadgets_wait_for_game_end
	Namespace: ability_player
	Checksum: 0xAAE251B8
	Offset: 0xFA0
	Size: 0xE9
	Parameters: 0
	Flags: None
*/
function gadgets_wait_for_game_end()
{
	level waittill("game_ended");
	players = GetPlayers();
	foreach(player in players)
	{
		if(!isalive(player))
		{
			continue;
		}
		if(!isdefined(player._gadgets_player))
		{
			continue;
		}
		player gadgets_save_power(1);
	}
}

/*
	Name: script_set_cclass
	Namespace: ability_player
	Checksum: 0x4E354DAC
	Offset: 0x1098
	Size: 0x27
	Parameters: 2
	Flags: None
*/
function script_set_cclass(cclass, save)
{
	if(!isdefined(save))
	{
		save = 1;
	}
}

/*
	Name: update_gadget
	Namespace: ability_player
	Checksum: 0xEAA6C6C6
	Offset: 0x10C8
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function update_gadget(weapon)
{
}

/*
	Name: register_gadget
	Namespace: ability_player
	Checksum: 0x6C63B481
	Offset: 0x10E0
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function register_gadget(type)
{
	if(!isdefined(level._gadgets_level))
	{
		level._gadgets_level = [];
	}
	if(!isdefined(level._gadgets_level[type]))
	{
		level._gadgets_level[type] = spawnstruct();
		level._gadgets_level[type].should_notify = 1;
	}
}

/*
	Name: register_gadget_should_notify
	Namespace: ability_player
	Checksum: 0x58A8BC5D
	Offset: 0x1160
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function register_gadget_should_notify(type, should_notify)
{
	register_gadget(type);
	if(isdefined(should_notify))
	{
		level._gadgets_level[type].should_notify = should_notify;
	}
}

/*
	Name: register_gadget_possession_callbacks
	Namespace: ability_player
	Checksum: 0x16CF01D6
	Offset: 0x11C0
	Size: 0x271
	Parameters: 3
	Flags: None
*/
function register_gadget_possession_callbacks(type, on_give, on_take)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].on_give))
	{
		level._gadgets_level[type].on_give = [];
	}
	if(!isdefined(level._gadgets_level[type].on_take))
	{
		level._gadgets_level[type].on_take = [];
	}
	if(isdefined(on_give))
	{
		if(!isdefined(level._gadgets_level[type].on_give))
		{
			level._gadgets_level[type].on_give = [];
		}
		else if(!IsArray(level._gadgets_level[type].on_give))
		{
			level._gadgets_level[type].on_give = Array(level._gadgets_level[type].on_give);
		}
		level._gadgets_level[type].on_give[level._gadgets_level[type].on_give.size] = on_give;
	}
	if(isdefined(on_take))
	{
		if(!isdefined(level._gadgets_level[type].on_take))
		{
			level._gadgets_level[type].on_take = [];
		}
		else if(!IsArray(level._gadgets_level[type].on_take))
		{
			level._gadgets_level[type].on_take = Array(level._gadgets_level[type].on_take);
		}
		level._gadgets_level[type].on_take[level._gadgets_level[type].on_take.size] = on_take;
	}
}

/*
	Name: register_gadget_activation_callbacks
	Namespace: ability_player
	Checksum: 0x39D1228D
	Offset: 0x1440
	Size: 0x271
	Parameters: 3
	Flags: None
*/
function register_gadget_activation_callbacks(type, turn_on, turn_off)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].turn_on))
	{
		level._gadgets_level[type].turn_on = [];
	}
	if(!isdefined(level._gadgets_level[type].turn_off))
	{
		level._gadgets_level[type].turn_off = [];
	}
	if(isdefined(turn_on))
	{
		if(!isdefined(level._gadgets_level[type].turn_on))
		{
			level._gadgets_level[type].turn_on = [];
		}
		else if(!IsArray(level._gadgets_level[type].turn_on))
		{
			level._gadgets_level[type].turn_on = Array(level._gadgets_level[type].turn_on);
		}
		level._gadgets_level[type].turn_on[level._gadgets_level[type].turn_on.size] = turn_on;
	}
	if(isdefined(turn_off))
	{
		if(!isdefined(level._gadgets_level[type].turn_off))
		{
			level._gadgets_level[type].turn_off = [];
		}
		else if(!IsArray(level._gadgets_level[type].turn_off))
		{
			level._gadgets_level[type].turn_off = Array(level._gadgets_level[type].turn_off);
		}
		level._gadgets_level[type].turn_off[level._gadgets_level[type].turn_off.size] = turn_off;
	}
}

/*
	Name: register_gadget_flicker_callbacks
	Namespace: ability_player
	Checksum: 0x4130076E
	Offset: 0x16C0
	Size: 0x149
	Parameters: 2
	Flags: None
*/
function register_gadget_flicker_callbacks(type, on_flicker)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].on_flicker))
	{
		level._gadgets_level[type].on_flicker = [];
	}
	if(isdefined(on_flicker))
	{
		if(!isdefined(level._gadgets_level[type].on_flicker))
		{
			level._gadgets_level[type].on_flicker = [];
		}
		else if(!IsArray(level._gadgets_level[type].on_flicker))
		{
			level._gadgets_level[type].on_flicker = Array(level._gadgets_level[type].on_flicker);
		}
		level._gadgets_level[type].on_flicker[level._gadgets_level[type].on_flicker.size] = on_flicker;
	}
}

/*
	Name: register_gadget_ready_callbacks
	Namespace: ability_player
	Checksum: 0xD6638E12
	Offset: 0x1818
	Size: 0x149
	Parameters: 2
	Flags: None
*/
function register_gadget_ready_callbacks(type, ready_func)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].on_ready))
	{
		level._gadgets_level[type].on_ready = [];
	}
	if(isdefined(ready_func))
	{
		if(!isdefined(level._gadgets_level[type].on_ready))
		{
			level._gadgets_level[type].on_ready = [];
		}
		else if(!IsArray(level._gadgets_level[type].on_ready))
		{
			level._gadgets_level[type].on_ready = Array(level._gadgets_level[type].on_ready);
		}
		level._gadgets_level[type].on_ready[level._gadgets_level[type].on_ready.size] = ready_func;
	}
}

/*
	Name: register_gadget_primed_callbacks
	Namespace: ability_player
	Checksum: 0x5425F352
	Offset: 0x1970
	Size: 0x149
	Parameters: 2
	Flags: None
*/
function register_gadget_primed_callbacks(type, primed_func)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].on_primed))
	{
		level._gadgets_level[type].on_primed = [];
	}
	if(isdefined(primed_func))
	{
		if(!isdefined(level._gadgets_level[type].on_primed))
		{
			level._gadgets_level[type].on_primed = [];
		}
		else if(!IsArray(level._gadgets_level[type].on_primed))
		{
			level._gadgets_level[type].on_primed = Array(level._gadgets_level[type].on_primed);
		}
		level._gadgets_level[type].on_primed[level._gadgets_level[type].on_primed.size] = primed_func;
	}
}

/*
	Name: register_gadget_is_inuse_callbacks
	Namespace: ability_player
	Checksum: 0x5FD2674E
	Offset: 0x1AC8
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function register_gadget_is_inuse_callbacks(type, inuse_func)
{
	register_gadget(type);
	if(isdefined(inuse_func))
	{
		level._gadgets_level[type].isInUse = inuse_func;
	}
}

/*
	Name: register_gadget_is_flickering_callbacks
	Namespace: ability_player
	Checksum: 0x7814EF64
	Offset: 0x1B28
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function register_gadget_is_flickering_callbacks(type, flickering_func)
{
	register_gadget(type);
	if(isdefined(flickering_func))
	{
		level._gadgets_level[type].isFlickering = flickering_func;
	}
}

/*
	Name: register_gadget_failed_activate_callback
	Namespace: ability_player
	Checksum: 0x871D9F5E
	Offset: 0x1B88
	Size: 0x149
	Parameters: 2
	Flags: None
*/
function register_gadget_failed_activate_callback(type, failed_activate)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].failed_activate))
	{
		level._gadgets_level[type].failed_activate = [];
	}
	if(isdefined(failed_activate))
	{
		if(!isdefined(level._gadgets_level[type].failed_activate))
		{
			level._gadgets_level[type].failed_activate = [];
		}
		else if(!IsArray(level._gadgets_level[type].failed_activate))
		{
			level._gadgets_level[type].failed_activate = Array(level._gadgets_level[type].failed_activate);
		}
		level._gadgets_level[type].failed_activate[level._gadgets_level[type].failed_activate.size] = failed_activate;
	}
}

/*
	Name: gadget_is_in_use
	Namespace: ability_player
	Checksum: 0x4336353A
	Offset: 0x1CE0
	Size: 0xC9
	Parameters: 1
	Flags: None
*/
function gadget_is_in_use(slot)
{
	if(isdefined(self._gadgets_player[slot]))
	{
		if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
		{
			if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].isInUse))
			{
				return self [[level._gadgets_level[self._gadgets_player[slot].gadget_type].isInUse]](slot);
			}
		}
	}
	return self GadgetIsActive(slot);
}

/*
	Name: gadget_is_flickering
	Namespace: ability_player
	Checksum: 0xCCC9FBCA
	Offset: 0x1DB8
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function gadget_is_flickering(slot)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return 0;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].isFlickering))
	{
		return 0;
	}
	return self [[level._gadgets_level[self._gadgets_player[slot].gadget_type].isFlickering]](slot);
}

/*
	Name: give_gadget
	Namespace: ability_player
	Checksum: 0x92DF06EF
	Offset: 0x1E50
	Size: 0x22B
	Parameters: 2
	Flags: None
*/
function give_gadget(slot, weapon)
{
	if(isdefined(self._gadgets_player[slot]))
	{
		self take_gadget(slot, self._gadgets_player[slot]);
	}
	for(eSlot = 0; eSlot < 3; eSlot++)
	{
		existingGadget = self._gadgets_player[eSlot];
		if(isdefined(existingGadget) && existingGadget == weapon)
		{
			self take_gadget(eSlot, existingGadget);
		}
	}
	self._gadgets_player[slot] = weapon;
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_give))
		{
			foreach(on_give in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_give)
			{
				self [[on_give]](slot, weapon);
			}
		}
	}
	else if(SessionModeIsMultiplayerGame())
	{
		if(isdefined(weapon))
		{
		}
		else
		{
		}
		self.heroAbilityName = undefined;
	}
}

/*
	Name: take_gadget
	Namespace: ability_player
	Checksum: 0x673409B5
	Offset: 0x2088
	Size: 0x137
	Parameters: 2
	Flags: None
*/
function take_gadget(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_take))
		{
			foreach(on_take in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_take)
			{
				self [[on_take]](slot, weapon);
			}
		}
	}
	self._gadgets_player[slot] = undefined;
}

/*
	Name: turn_gadget_on
	Namespace: ability_player
	Checksum: 0x9EEFB215
	Offset: 0x21C8
	Size: 0x303
	Parameters: 2
	Flags: None
*/
function turn_gadget_on(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	self.playedGadgetSuccess = 0;
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].turn_on))
		{
			foreach(turn_on in level._gadgets_level[self._gadgets_player[slot].gadget_type].turn_on)
			{
				self [[turn_on]](slot, weapon);
				self trackHeroPowerActivated(game["timepassed"]);
				level notify("hero_gadget_activated", self, weapon);
				self notify("hero_gadget_activated", weapon);
			}
		}
	}
	else if(isdefined(level.cybercom) && isdefined(level.cybercom._ability_turn_on))
	{
		self [[level.cybercom._ability_turn_on]](slot, weapon);
	}
	self.pers["heroGadgetNotified"] = 0;
	xuid = self getXuid();
	bbPrint("mpheropowerevents", "spawnid %d gametime %d name %s powerstate %s playername %s xuid %s", getplayerspawnid(self), GetTime(), self._gadgets_player[slot].name, "activated", self.name, xuid);
	if(isdefined(level.playGadgetActivate))
	{
		self [[level.playGadgetActivate]](weapon);
	}
	if(weapon.gadget_type != 14)
	{
		if(isdefined(self.isNearDeath) && self.isNearDeath == 1)
		{
			if(isdefined(level.heroAbilityActivateNearDeath))
			{
				[[level.heroAbilityActivateNearDeath]]();
			}
		}
		self.heroAbilityActivateTime = GetTime();
		self.heroAbilityActive = 1;
		self.heroAbility = weapon;
	}
	self thread ability_power::power_consume_timer_think(slot, weapon);
}

/*
	Name: turn_gadget_off
	Namespace: ability_player
	Checksum: 0xA9A853A1
	Offset: 0x24D8
	Size: 0x33B
	Parameters: 2
	Flags: None
*/
function turn_gadget_off(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].turn_off))
	{
		foreach(turn_off in level._gadgets_level[self._gadgets_player[slot].gadget_type].turn_off)
		{
			self [[turn_off]](slot, weapon);
			dead = self.health <= 0;
			self trackHeroPowerExpired(game["timepassed"], dead, self.heroweaponShots, self.heroweaponHits);
		}
	}
	else if(isdefined(level.cybercom) && isdefined(level.cybercom._ability_turn_off))
	{
		self [[level.cybercom._ability_turn_off]](slot, weapon);
	}
	if(weapon.gadget_type != 14)
	{
		if(self IsEmpJammed() == 1)
		{
			self GadgetTargetResult(0);
			if(isdefined(level.callbackEndHeroSpecialistEMP))
			{
				if(isdefined(weapon.gadget_turnoff_onempjammed) && weapon.gadget_turnoff_onempjammed == 1)
				{
					self thread [[level.callbackEndHeroSpecialistEMP]]();
				}
			}
		}
		self.heroAbilityDectivateTime = GetTime();
		self.heroAbilityActive = undefined;
		self.heroAbility = weapon;
	}
	self notify("heroAbility_off", weapon);
	xuid = self getXuid();
	bbPrint("mpheropowerevents", "spawnid %d gametime %d name %s powerstate %s playername %s xuid %s", getplayerspawnid(self), GetTime(), self._gadgets_player[slot].name, "expired", self.name, xuid);
	if(isdefined(level.oldschool) && level.oldschool)
	{
		self TakeWeapon(weapon);
	}
}

/*
	Name: gadget_CheckHeroAbilityKill
	Namespace: ability_player
	Checksum: 0x884ADF33
	Offset: 0x2820
	Size: 0x281
	Parameters: 1
	Flags: None
*/
function gadget_CheckHeroAbilityKill(attacker)
{
	heroAbilityStat = 0;
	if(isdefined(attacker.heroAbility))
	{
		switch(attacker.heroAbility.name)
		{
			case "gadget_armor":
			case "gadget_clone":
			case "gadget_heat_wave":
			case "gadget_speed_burst":
			{
				if(isdefined(attacker.heroAbilityActive) || (isdefined(attacker.heroAbilityDectivateTime) && attacker.heroAbilityDectivateTime > GetTime() - 100))
				{
					heroAbilityStat = 1;
				}
				break;
			}
			case "gadget_camo":
			case "gadget_flashback":
			case "gadget_resurrect":
			{
				if(isdefined(attacker.heroAbilityActive) || (isdefined(attacker.heroAbilityDectivateTime) && attacker.heroAbilityDectivateTime > GetTime() - 6000))
				{
					heroAbilityStat = 1;
				}
				break;
			}
			case "gadget_vision_pulse":
			{
				if(isdefined(attacker.visionPulseSpottedEnemyTime))
				{
					timeCutoff = GetTime();
					if(attacker.visionPulseSpottedEnemyTime + 10000 > timeCutoff)
					{
						for(i = 0; i < attacker.visionPulseSpottedEnemy.size; i++)
						{
							spottedEnemy = attacker.visionPulseSpottedEnemy[i];
							if(spottedEnemy == self)
							{
								if(self.lastspawntime < attacker.visionPulseSpottedEnemyTime)
								{
									heroAbilityStat = 1;
									break;
								}
							}
						}
					}
				}
			}
			case "gadget_combat_efficiency":
			{
				else
				{
				}
				else
				{
				}
				if(isdefined(attacker._gadget_combat_efficiency) && attacker._gadget_combat_efficiency == 1)
				{
					heroAbilityStat = 1;
					break;
				}
				else if(isdefined(attacker.combatEfficiencyLastOnTime) && attacker.combatEfficiencyLastOnTime > GetTime() - 100)
				{
					heroAbilityStat = 1;
					break;
				}
			}
		}
	}
	return heroAbilityStat;
}

/*
	Name: gadget_flicker
	Namespace: ability_player
	Checksum: 0xE69D06FC
	Offset: 0x2AB0
	Size: 0x129
	Parameters: 2
	Flags: None
*/
function gadget_flicker(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_flicker))
	{
		foreach(on_flicker in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_flicker)
		{
			self [[on_flicker]](slot, weapon);
		}
	}
}

/*
	Name: gadget_ready
	Namespace: ability_player
	Checksum: 0x91D0226A
	Offset: 0x2BE8
	Size: 0x3AD
	Parameters: 2
	Flags: None
*/
function gadget_ready(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].should_notify) && level._gadgets_level[self._gadgets_player[slot].gadget_type].should_notify)
	{
		if(isdefined(level.statsTableID))
		{
			itemRow = TableLookupRowNum(level.statsTableID, 4, self._gadgets_player[slot].name);
			if(itemRow > -1)
			{
				index = Int(TableLookupColumnForRow(level.statsTableID, itemRow, 0));
				if(index != 0)
				{
					self LUINotifyEvent(&"hero_weapon_received", 1, index);
					self LUINotifyEventToSpectators(&"hero_weapon_received", 1, index);
				}
			}
		}
		if(!isdefined(level.gameEnded) || !level.gameEnded)
		{
			if(!isdefined(self.pers["heroGadgetNotified"]) || !self.pers["heroGadgetNotified"])
			{
				self.pers["heroGadgetNotified"] = 1;
				if(isdefined(level.playGadgetReady))
				{
					self [[level.playGadgetReady]](weapon);
				}
				self trackHeroPowerAvailable(game["timepassed"]);
			}
		}
	}
	xuid = self getXuid();
	bbPrint("mpheropowerevents", "spawnid %d gametime %d name %s powerstate %s playername %s xuid %s", getplayerspawnid(self), GetTime(), self._gadgets_player[slot].name, "ready", self.name, xuid);
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_ready))
	{
		foreach(on_ready in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_ready)
		{
			self [[on_ready]](slot, weapon);
		}
	}
}

/*
	Name: gadget_primed
	Namespace: ability_player
	Checksum: 0x8CA4D2AE
	Offset: 0x2FA0
	Size: 0x129
	Parameters: 2
	Flags: None
*/
function gadget_primed(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_primed))
	{
		foreach(on_primed in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_primed)
		{
			self [[on_primed]](slot, weapon);
		}
	}
}

/*
	Name: abilities_print
	Namespace: ability_player
	Checksum: 0x99DAABCB
	Offset: 0x30D8
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function abilities_print(STR)
{
	/#
		toprint = "Dev Block strings are not supported" + STR;
		println(toprint);
	#/
}

/*
	Name: abilities_devgui_init
	Namespace: ability_player
	Checksum: 0x2504E69E
	Offset: 0x3128
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function abilities_devgui_init()
{
	/#
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		SetDvar("Dev Block strings are not supported", 0);
		if(IsDedicated())
		{
			return;
		}
		level.abilities_devgui_base = "Dev Block strings are not supported";
		level thread abilities_devgui_think();
	#/
}

/*
	Name: abilities_devgui_player_connect
	Namespace: ability_player
	Checksum: 0x5774A221
	Offset: 0x31D0
	Size: 0xAF
	Parameters: 0
	Flags: None
*/
function abilities_devgui_player_connect()
{
	/#
		if(!isdefined(level.abilities_devgui_base))
		{
			return;
		}
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] != self)
			{
				continue;
			}
			abilities_devgui_add_player_commands(level.abilities_devgui_base, players[i].playerName, i + 1);
			return;
		}
	#/
}

/*
	Name: abilities_devgui_add_player_commands
	Namespace: ability_player
	Checksum: 0x8AF9FB44
	Offset: 0x3288
	Size: 0xB7
	Parameters: 3
	Flags: None
*/
function abilities_devgui_add_player_commands(root, pname, index)
{
	/#
		add_cmd_with_root = "Dev Block strings are not supported" + root + pname + "Dev Block strings are not supported";
		pId = "Dev Block strings are not supported" + index;
		menu_index = 1;
		menu_index = abilities_devgui_add_gadgets(add_cmd_with_root, pId, menu_index);
		menu_index = abilities_devgui_add_power(add_cmd_with_root, pId, menu_index);
	#/
}

/*
	Name: abilities_devgui_add_player_command
	Namespace: ability_player
	Checksum: 0x10C2ECE4
	Offset: 0x3348
	Size: 0xD3
	Parameters: 6
	Flags: None
*/
function abilities_devgui_add_player_command(root, pId, cmdname, menu_index, cmddvar, argdvar)
{
	/#
		if(!isdefined(argdvar))
		{
			argdvar = "Dev Block strings are not supported";
		}
		AddDebugCommand(root + cmdname + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + pId + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + cmddvar + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + argdvar + "Dev Block strings are not supported");
	#/
}

/*
	Name: abilities_devgui_add_power
	Namespace: ability_player
	Checksum: 0xB088DF98
	Offset: 0x3428
	Size: 0xBF
	Parameters: 3
	Flags: None
*/
function abilities_devgui_add_power(add_cmd_with_root, pId, menu_index)
{
	/#
		root = add_cmd_with_root + "Dev Block strings are not supported" + menu_index + "Dev Block strings are not supported";
		abilities_devgui_add_player_command(root, pId, "Dev Block strings are not supported", 1, "Dev Block strings are not supported", "Dev Block strings are not supported");
		abilities_devgui_add_player_command(root, pId, "Dev Block strings are not supported", 2, "Dev Block strings are not supported", "Dev Block strings are not supported");
		menu_index++;
		return menu_index;
	#/
}

/*
	Name: abilities_devgui_add_gadgets
	Namespace: ability_player
	Checksum: 0x4550D7DC
	Offset: 0x34F0
	Size: 0x177
	Parameters: 3
	Flags: None
*/
function abilities_devgui_add_gadgets(add_cmd_with_root, pId, menu_index)
{
	/#
		a_weapons = EnumerateWeapons("Dev Block strings are not supported");
		a_hero = [];
		a_abilities = [];
		for(i = 0; i < a_weapons.size; i++)
		{
			if(a_weapons[i].isgadget)
			{
				if(a_weapons[i].inventoryType == "Dev Block strings are not supported")
				{
					ArrayInsert(a_hero, a_weapons[i], 0);
					continue;
				}
				ArrayInsert(a_abilities, a_weapons[i], 0);
			}
		}
		abilities_devgui_add_player_weapons(add_cmd_with_root, pId, a_abilities, "Dev Block strings are not supported", menu_index);
		menu_index++;
		abilities_devgui_add_player_weapons(add_cmd_with_root, pId, a_hero, "Dev Block strings are not supported", menu_index);
		menu_index++;
		return menu_index;
	#/
}

/*
	Name: abilities_devgui_add_player_weapons
	Namespace: ability_player
	Checksum: 0x1B3BA78A
	Offset: 0x3670
	Size: 0xC5
	Parameters: 5
	Flags: None
*/
function abilities_devgui_add_player_weapons(root, pId, a_weapons, weapon_type, menu_index)
{
	/#
		if(isdefined(a_weapons))
		{
			player_devgui_root = root + weapon_type + "Dev Block strings are not supported";
			for(i = 0; i < a_weapons.size; i++)
			{
				abilities_devgui_add_player_weap_command(player_devgui_root, pId, a_weapons[i].name, i + 1);
				wait(0.05);
			}
		}
	#/
}

/*
	Name: abilities_devgui_add_player_weap_command
	Namespace: ability_player
	Checksum: 0xE2DAE482
	Offset: 0x3740
	Size: 0xAB
	Parameters: 4
	Flags: None
*/
function abilities_devgui_add_player_weap_command(root, pId, weap_name, cmdindex)
{
	/#
		AddDebugCommand(root + weap_name + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + pId + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported" + weap_name + "Dev Block strings are not supported");
	#/
}

/*
	Name: abilities_devgui_player_disconnect
	Namespace: ability_player
	Checksum: 0x6FAD21CC
	Offset: 0x37F8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function abilities_devgui_player_disconnect()
{
	/#
		if(!isdefined(level.abilities_devgui_base))
		{
			return;
		}
		remove_cmd_with_root = "Dev Block strings are not supported" + level.abilities_devgui_base + self.playerName + "Dev Block strings are not supported";
		util::add_queued_debug_command(remove_cmd_with_root);
	#/
}

/*
	Name: abilities_devgui_think
	Namespace: ability_player
	Checksum: 0x4528A55A
	Offset: 0x3860
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function abilities_devgui_think()
{
	/#
		for(;;)
		{
			cmd = GetDvarString("Dev Block strings are not supported");
			if(cmd == "Dev Block strings are not supported")
			{
				wait(0.05);
				continue;
			}
			arg = GetDvarString("Dev Block strings are not supported");
			switch(cmd)
			{
				case "Dev Block strings are not supported":
				{
					abilities_devgui_handle_player_command(cmd, &abilities_devgui_power_fill);
					break;
				}
				case "Dev Block strings are not supported":
				{
					abilities_devgui_handle_player_command(cmd, &abilities_devgui_power_toggle_auto_fill);
					break;
				}
				case "Dev Block strings are not supported":
				{
					abilities_devgui_handle_player_command(cmd, &abilities_devgui_give, arg);
				}
				case "Dev Block strings are not supported":
				{
					break;
				}
				case default:
				{
					break;
				}
			}
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(0.5);
		}
	#/
}

/*
	Name: abilities_devgui_give
	Namespace: ability_player
	Checksum: 0x91375EF0
	Offset: 0x39B8
	Size: 0x145
	Parameters: 1
	Flags: None
*/
function abilities_devgui_give(weapon_name)
{
	/#
		level.devgui_giving_abilities = 1;
		for(i = 0; i < 3; i++)
		{
			if(isdefined(self._gadgets_player[i]))
			{
				self TakeWeapon(self._gadgets_player[i]);
			}
		}
		self notify("gadget_devgui_give");
		weapon = GetWeapon(weapon_name);
		self GiveWeapon(weapon);
		if(self util::is_bot())
		{
			slot = self GadgetGetSlot(weapon);
			self GadgetPowerSet(slot, 100);
			self bot::activate_hero_gadget(weapon);
		}
		level.devgui_giving_abilities = undefined;
	#/
}

/*
	Name: abilities_devgui_handle_player_command
	Namespace: ability_player
	Checksum: 0xAC66A026
	Offset: 0x3B08
	Size: 0x10B
	Parameters: 3
	Flags: None
*/
function abilities_devgui_handle_player_command(cmd, playercallback, pcb_param)
{
	/#
		pId = GetDvarInt("Dev Block strings are not supported");
		if(pId > 0)
		{
			player = GetPlayers()[pId - 1];
			if(isdefined(player))
			{
				if(isdefined(pcb_param))
				{
					player thread [[playercallback]](pcb_param);
				}
				else
				{
					player thread [[playercallback]]();
				}
			}
		}
		else
		{
			Array::thread_all(GetPlayers(), playercallback, pcb_param);
		}
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
	#/
}

/*
	Name: abilities_devgui_power_fill
	Namespace: ability_player
	Checksum: 0xE1EABF1B
	Offset: 0x3C20
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function abilities_devgui_power_fill()
{
	/#
		if(!isdefined(self) || !isdefined(self._gadgets_player))
		{
			return;
		}
		for(i = 0; i < 3; i++)
		{
			if(isdefined(self._gadgets_player[i]))
			{
				self GadgetPowerSet(i, self._gadgets_player[i].gadget_powermax);
			}
		}
	#/
}

/*
	Name: abilities_devgui_power_toggle_auto_fill
	Namespace: ability_player
	Checksum: 0x24513600
	Offset: 0x3CB8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function abilities_devgui_power_toggle_auto_fill()
{
	/#
		if(!isdefined(self) || !isdefined(self._gadgets_player))
		{
			return;
		}
		self.abilities_devgui_power_toggle_auto_fill = !isdefined(self.abilities_devgui_power_toggle_auto_fill) && self.abilities_devgui_power_toggle_auto_fill;
		self thread abilities_devgui_power_toggle_auto_fill_think();
	#/
}

/*
	Name: abilities_devgui_power_toggle_auto_fill_think
	Namespace: ability_player
	Checksum: 0xC26C35E5
	Offset: 0x3D18
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function abilities_devgui_power_toggle_auto_fill_think()
{
	/#
		self endon("disconnect");
		self notify("auto_fill_think");
		self endon("auto_fill_think");
		while(!isdefined(self) || !isdefined(self._gadgets_player))
		{
			return;
			if(!(isdefined(self.abilities_devgui_power_toggle_auto_fill) && self.abilities_devgui_power_toggle_auto_fill))
			{
				return;
			}
			for(i = 0; i < 3; i++)
			{
				if(isdefined(self._gadgets_player[i]))
				{
					if(!self gadget_is_in_use(i) && self GadgetCharging(i))
					{
						self GadgetPowerSet(i, self._gadgets_player[i].gadget_powermax);
					}
				}
			}
			wait(1);
		}
	#/
}

