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
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace roulette;

/*
	Name: __init__sytem__
	Namespace: roulette
	Checksum: 0x5E5EDD60
	Offset: 0x3F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_roulette", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: roulette
	Checksum: 0xBBB057EB
	Offset: 0x438
	Size: 0x307
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "roulette_state", 11000, 2, "int");
	ability_player::register_gadget_activation_callbacks(43, &gadget_roulette_on_activate, &gadget_roulette_on_deactivate);
	ability_player::register_gadget_possession_callbacks(43, &gadget_roulette_on_give, &gadget_roulette_on_take);
	ability_player::register_gadget_flicker_callbacks(43, &gadget_roulette_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(43, &gadget_roulette_is_inuse);
	ability_player::register_gadget_ready_callbacks(43, &gadget_roulette_is_ready);
	ability_player::register_gadget_is_flickering_callbacks(43, &gadget_roulette_is_flickering);
	ability_player::register_gadget_should_notify(43, 0);
	callback::on_connect(&gadget_roulette_on_connect);
	callback::on_spawned(&gadget_roulette_on_player_spawn);
	if(SessionModeIsMultiplayerGame())
	{
		level.gadgetRouletteProbabilities = [];
		level.gadgetRouletteProbabilities[0] = 0;
		level.gadgetRouletteProbabilities[1] = 0;
		level.weaponNone = GetWeapon("none");
		level.gadget_roulette = GetWeapon("gadget_roulette");
		registerGadgetType("gadget_flashback", 1, 1);
		registerGadgetType("gadget_combat_efficiency", 1, 1);
		registerGadgetType("gadget_heat_wave", 1, 1);
		registerGadgetType("gadget_vision_pulse", 1, 1);
		registerGadgetType("gadget_speed_burst", 1, 1);
		registerGadgetType("gadget_camo", 1, 1);
		registerGadgetType("gadget_armor", 1, 1);
		registerGadgetType("gadget_resurrect", 1, 1);
		registerGadgetType("gadget_clone", 1, 1);
	}
	/#
	#/
}

/*
	Name: updateDvars
	Namespace: roulette
	Checksum: 0xA669FB93
	Offset: 0x748
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function updateDvars()
{
	/#
		while(1)
		{
			wait(1);
		}
	#/
}

/*
	Name: gadget_roulette_is_inuse
	Namespace: roulette
	Checksum: 0xCF390DEE
	Offset: 0x770
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_roulette_is_inuse(slot)
{
	return self GadgetIsActive(slot);
}

/*
	Name: gadget_roulette_is_flickering
	Namespace: roulette
	Checksum: 0xEFC80A36
	Offset: 0x7A0
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_roulette_is_flickering(slot)
{
	return self GadgetFlickering(slot);
}

/*
	Name: gadget_roulette_on_flicker
	Namespace: roulette
	Checksum: 0xF7719FE7
	Offset: 0x7D0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gadget_roulette_on_flicker(slot, weapon)
{
	self thread gadget_roulette_flicker(slot, weapon);
}

/*
	Name: gadget_roulette_on_give
	Namespace: roulette
	Checksum: 0x58E8B84D
	Offset: 0x810
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function gadget_roulette_on_give(slot, weapon)
{
	self clientfield::set_to_player("roulette_state", 0);
	if(SessionModeIsMultiplayerGame())
	{
		self.isRoulette = 1;
	}
}

/*
	Name: gadget_roulette_on_take
	Namespace: roulette
	Checksum: 0x10114E8E
	Offset: 0x870
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gadget_roulette_on_take(slot, weapon)
{
	/#
		if(level.var_e76bb7e3 === 1)
		{
			self.isRoulette = 0;
		}
	#/
}

/*
	Name: gadget_roulette_on_connect
	Namespace: roulette
	Checksum: 0x6B12EDDB
	Offset: 0x8B0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function gadget_roulette_on_connect()
{
	roulette_init_allow_spin();
}

/*
	Name: roulette_init_allow_spin
	Namespace: roulette
	Checksum: 0x2172C970
	Offset: 0x8D0
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function roulette_init_allow_spin()
{
	if(self.isRoulette === 1)
	{
		if(!isdefined(self.pers["hash_9f129a92"]))
		{
			self.pers["hash_9f129a92"] = 1;
		}
	}
}

/*
	Name: gadget_roulette_on_player_spawn
	Namespace: roulette
	Checksum: 0xA0D5FA2F
	Offset: 0x920
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function gadget_roulette_on_player_spawn()
{
	roulette_init_allow_spin();
}

/*
	Name: watch_entity_shutdown
	Namespace: roulette
	Checksum: 0x99EC1590
	Offset: 0x940
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function watch_entity_shutdown()
{
}

/*
	Name: gadget_roulette_on_activate
	Namespace: roulette
	Checksum: 0xEF5FFB71
	Offset: 0x950
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function gadget_roulette_on_activate(slot, weapon)
{
	gadget_roulette_give_earned_specialist(weapon, 1);
}

/*
	Name: gadget_roulette_is_ready
	Namespace: roulette
	Checksum: 0x1974859B
	Offset: 0x988
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function gadget_roulette_is_ready(slot, weapon)
{
	if(self GadgetIsActive(slot))
	{
		return;
	}
	gadget_roulette_give_earned_specialist(weapon, 0);
}

/*
	Name: gadget_roulette_give_earned_specialist
	Namespace: roulette
	Checksum: 0x7FA172B2
	Offset: 0x9E0
	Size: 0x8B
	Parameters: 2
	Flags: None
*/
function gadget_roulette_give_earned_specialist(weapon, playsound)
{
	self giveRandomWeapon(weapon, 1);
	if(playsound)
	{
		self playsoundtoplayer("mpl_bm_specialist_roulette", self);
	}
	self thread watchGadgetActivated(weapon);
	self thread watchRespin(weapon);
}

/*
	Name: disable_hero_gadget_activation
	Namespace: roulette
	Checksum: 0xCDA3E507
	Offset: 0xA78
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function disable_hero_gadget_activation(duration)
{
	self endon("death");
	self endon("disconnect");
	self endon("roulette_respin_activate");
	self DisableOffhandSpecial();
	wait(duration);
	self EnableOffhandSpecial();
}

/*
	Name: watchRespinGadgetActivated
	Namespace: roulette
	Checksum: 0x881435A2
	Offset: 0xAE0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function watchRespinGadgetActivated()
{
	self endon("watchRespinGadgetActivated");
	self endon("death");
	self endon("disconnect");
	self waittill("hero_gadget_activated");
	self clientfield::set_to_player("roulette_state", 0);
}

/*
	Name: watchRespin
	Namespace: roulette
	Checksum: 0xBED0D6BE
	Offset: 0xB40
	Size: 0x1B9
	Parameters: 1
	Flags: None
*/
function watchRespin(weapon)
{
	self endon("hero_gadget_activated");
	self notify("watchRespin");
	self endon("watchRespin");
	if(!isdefined(self.pers["hash_9f129a92"]) || self.pers["hash_9f129a92"] == 0)
	{
		return;
	}
	self thread watchRespinGadgetActivated();
	self clientfield::set_to_player("roulette_state", 1);
	wait(GetDvarFloat("scr_roulette_pre_respin_wait_time", 1.3));
	while(1)
	{
		if(!isdefined(self))
		{
			break;
		}
		if(self dpad_left_pressed())
		{
			self.pers["hash_65987563"] = undefined;
			self giveRandomWeapon(weapon, 0);
			self.pers["hash_9f129a92"] = 0;
			self notify("watchRespinGadgetActivated");
			self notify("roulette_respin_activate");
			self clientfield::set_to_player("roulette_state", 2);
			self playsoundtoplayer("mpl_bm_specialist_roulette", self);
			self thread reset_roulette_state_to_default();
			break;
		}
		wait(0.05);
	}
	if(isdefined(self))
	{
		self notify("watchRespinGadgetActivated");
	}
}

/*
	Name: failsafe_reenable_offhand_special
	Namespace: roulette
	Checksum: 0x204F4D19
	Offset: 0xD08
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
	Name: reset_roulette_state_to_default
	Namespace: roulette
	Checksum: 0x548918D1
	Offset: 0xD48
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function reset_roulette_state_to_default()
{
	self endon("death");
	self endon("disconnect");
	wait(0.5);
	self clientfield::set_to_player("roulette_state", 0);
}

/*
	Name: watchGadgetActivated
	Namespace: roulette
	Checksum: 0x79BBB368
	Offset: 0xD98
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function watchGadgetActivated(weapon)
{
	self endon("death");
	self notify("watchGadgetActivated");
	self endon("watchGadgetActivated");
	self waittill("hero_gadget_activated");
	self.pers["hash_9f129a92"] = 1;
	if(isdefined(weapon) || weapon.name != "gadget_roulette")
	{
		self clientfield::set_to_player("roulette_state", 0);
	}
}

/*
	Name: giveRandomWeapon
	Namespace: roulette
	Checksum: 0xF0C00B47
	Offset: 0xE38
	Size: 0x23D
	Parameters: 2
	Flags: None
*/
function giveRandomWeapon(weapon, isPrimaryRoll)
{
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self._gadgets_player[i]))
		{
			self TakeWeapon(self._gadgets_player[i]);
		}
	}
	randomWeapon = weapon;
	if(isdefined(self.pers["hash_65987563"]))
	{
		randomWeapon = self.pers["hash_65987563"];
	}
	else if(isdefined(self.pers["hash_cbcfa831"]) || isdefined(self.pers["hash_cbcfa832"]))
	{
		for(randomWeapon = getRandomGadget(isPrimaryRoll); randomWeapon == self.pers["hash_cbcfa831"] || (isdefined(self.pers["hash_cbcfa832"]) && randomWeapon == self.pers["hash_cbcfa832"]);  = getRandomGadget(isPrimaryRoll))
		{
		}
	}
	else
	{
		randomWeapon = getRandomGadget(isPrimaryRoll);
	}
	if(isdefined(level.playGadgetReady) && !isPrimaryRoll)
	{
		self thread [[level.playGadgetReady]](randomWeapon, !isPrimaryRoll);
	}
	self thread gadget_roulette_on_deactivate_helper(weapon);
	self GiveWeapon(randomWeapon);
	self.pers["hash_65987563"] = randomWeapon;
	self.pers["hash_cbcfa832"] = self.pers["hash_cbcfa831"];
	self.pers["hash_cbcfa831"] = randomWeapon;
}

/*
	Name: gadget_roulette_on_deactivate
	Namespace: roulette
	Checksum: 0x6B212ACD
	Offset: 0x1080
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function gadget_roulette_on_deactivate(slot, weapon)
{
	thread gadget_roulette_on_deactivate_helper(weapon);
}

/*
	Name: gadget_roulette_on_deactivate_helper
	Namespace: roulette
	Checksum: 0x123A51E0
	Offset: 0x10B8
	Size: 0x10B
	Parameters: 1
	Flags: None
*/
function gadget_roulette_on_deactivate_helper(weapon)
{
	self notify("gadget_roulette_on_deactivate_helper");
	self endon("gadget_roulette_on_deactivate_helper");
	self waittill("heroAbility_off", weapon_off);
	if(isdefined(weapon_off) && weapon_off.name == "gadget_speed_burst")
	{
		self waittill("heroAbility_off", weapon_off);
	}
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self) && isdefined(self._gadgets_player[i]))
		{
			self TakeWeapon(self._gadgets_player[i]);
		}
	}
	if(isdefined(self))
	{
		self GiveWeapon(level.gadget_roulette);
		self.pers["hash_65987563"] = undefined;
	}
}

/*
	Name: gadget_roulette_flicker
	Namespace: roulette
	Checksum: 0xE7AC1E92
	Offset: 0x11D0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_roulette_flicker(slot, weapon)
{
}

/*
	Name: set_gadget_status
	Namespace: roulette
	Checksum: 0x42E32B14
	Offset: 0x11F0
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
		self IPrintLnBold("Gadget Roulette: " + status + timeStr);
	}
}

/*
	Name: dpad_left_pressed
	Namespace: roulette
	Checksum: 0x786CCAB
	Offset: 0x1298
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function dpad_left_pressed()
{
	return self ActionSlotThreeButtonPressed();
}

/*
	Name: getRandomGadget
	Namespace: roulette
	Checksum: 0xB828D0D1
	Offset: 0x12C0
	Size: 0x165
	Parameters: 1
	Flags: None
*/
function getRandomGadget(isPrimaryRoll)
{
	if(isPrimaryRoll)
	{
		category = 0;
		totalCategory = 0;
	}
	else
	{
		category = 1;
		totalCategory = 1;
	}
	randomGadgetNumber = randomIntRange(1, level.gadgetRouletteProbabilities[totalCategory] + 1);
	gadgetNames = getArrayKeys(level.gadgetRouletteProbabilities);
	selectedGadget = "";
	foreach(gadget in gadgetNames)
	{
		randomGadgetNumber = randomGadgetNumber - level.gadgetRouletteProbabilities[gadget][category];
		if(randomGadgetNumber <= 0)
		{
			selectedGadget = gadget;
			break;
		}
	}
	return selectedGadget;
}

/*
	Name: registerGadgetType
	Namespace: roulette
	Checksum: 0xF54AEB64
	Offset: 0x1430
	Size: 0x125
	Parameters: 3
	Flags: None
*/
function registerGadgetType(gadgetNameString, primaryWeight, secondaryWeight)
{
	gadgetWeapon = GetWeapon(gadgetNameString);
	/#
		Assert(isdefined(gadgetWeapon));
	#/
	if(gadgetWeapon == level.weaponNone)
	{
		/#
			ASSERTMSG(gadgetNameString + "Dev Block strings are not supported");
		#/
	}
	if(!isdefined(level.gadgetRouletteProbabilities[gadgetWeapon]))
	{
		level.gadgetRouletteProbabilities[gadgetWeapon] = [];
	}
	level.gadgetRouletteProbabilities[gadgetWeapon][0] = primaryWeight;
	level.gadgetRouletteProbabilities[gadgetWeapon][1] = secondaryWeight;
	level.gadgetRouletteProbabilities[0] = level.gadgetRouletteProbabilities[0] + primaryWeight;
	level.gadgetRouletteProbabilities[1] = level.gadgetRouletteProbabilities[1] + secondaryWeight;
}

