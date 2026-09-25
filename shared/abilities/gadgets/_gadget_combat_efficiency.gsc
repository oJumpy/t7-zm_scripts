#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_combat_efficiency;

/*
	Name: __init__sytem__
	Namespace: _gadget_combat_efficiency
	Checksum: 0x6025846D
	Offset: 0x268
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_combat_efficiency", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_combat_efficiency
	Checksum: 0xA3ACAB4B
	Offset: 0x2A8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(15, &gadget_combat_efficiency_on_activate, &gadget_combat_efficiency_on_off);
	ability_player::register_gadget_possession_callbacks(15, &gadget_combat_efficiency_on_give, &gadget_combat_efficiency_on_take);
	ability_player::register_gadget_flicker_callbacks(15, &gadget_combat_efficiency_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(15, &gadget_combat_efficiency_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(15, &gadget_combat_efficiency_is_flickering);
	ability_player::register_gadget_ready_callbacks(15, &gadget_combat_efficiency_ready);
}

/*
	Name: gadget_combat_efficiency_is_inuse
	Namespace: _gadget_combat_efficiency
	Checksum: 0xF4B326E2
	Offset: 0x398
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_combat_efficiency_is_inuse(slot)
{
	return self GadgetIsActive(slot);
}

/*
	Name: gadget_combat_efficiency_is_flickering
	Namespace: _gadget_combat_efficiency
	Checksum: 0x26B7ED4C
	Offset: 0x3C8
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_combat_efficiency_is_flickering(slot)
{
	return self GadgetFlickering(slot);
}

/*
	Name: gadget_combat_efficiency_on_flicker
	Namespace: _gadget_combat_efficiency
	Checksum: 0x72B9A96A
	Offset: 0x3F8
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_combat_efficiency_on_flicker(slot, weapon)
{
}

/*
	Name: gadget_combat_efficiency_on_give
	Namespace: _gadget_combat_efficiency
	Checksum: 0x86BEB7D8
	Offset: 0x418
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_combat_efficiency_on_give(slot, weapon)
{
}

/*
	Name: gadget_combat_efficiency_on_take
	Namespace: _gadget_combat_efficiency
	Checksum: 0x9622AB3D
	Offset: 0x438
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_combat_efficiency_on_take(slot, weapon)
{
}

/*
	Name: gadget_combat_efficiency_on_connect
	Namespace: _gadget_combat_efficiency
	Checksum: 0x99EC1590
	Offset: 0x458
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function gadget_combat_efficiency_on_connect()
{
}

/*
	Name: gadget_combat_efficiency_on_spawn
	Namespace: _gadget_combat_efficiency
	Checksum: 0x56D095A6
	Offset: 0x468
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function gadget_combat_efficiency_on_spawn()
{
	self.combatEfficiencyLastOnTime = 0;
}

/*
	Name: gadget_combat_efficiency_on_activate
	Namespace: _gadget_combat_efficiency
	Checksum: 0xEBD65B40
	Offset: 0x480
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function gadget_combat_efficiency_on_activate(slot, weapon)
{
	self._gadget_combat_efficiency = 1;
	self._gadget_combat_efficiency_success = 0;
	self.scoreStreaksEarnedPerUse = 0;
	self.combatEfficiencyLastOnTime = GetTime();
}

/*
	Name: gadget_combat_efficiency_on_off
	Namespace: _gadget_combat_efficiency
	Checksum: 0xCF12E675
	Offset: 0x4D0
	Size: 0xE7
	Parameters: 2
	Flags: None
*/
function gadget_combat_efficiency_on_off(slot, weapon)
{
	self._gadget_combat_efficiency = 0;
	self.combatEfficiencyLastOnTime = GetTime();
	self addweaponstat(self.heroAbility, "scorestreaks_earned_2", Int(self.scoreStreaksEarnedPerUse / 2));
	self addweaponstat(self.heroAbility, "scorestreaks_earned_3", Int(self.scoreStreaksEarnedPerUse / 3));
	if(isalive(self) && isdefined(level.playGadgetSuccess))
	{
		self [[level.playGadgetSuccess]](weapon);
	}
}

/*
	Name: gadget_combat_efficiency_ready
	Namespace: _gadget_combat_efficiency
	Checksum: 0x523910E
	Offset: 0x5C0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_combat_efficiency_ready(slot, weapon)
{
}

/*
	Name: set_gadget_combat_efficiency_status
	Namespace: _gadget_combat_efficiency
	Checksum: 0x20109CDE
	Offset: 0x5E0
	Size: 0xB3
	Parameters: 3
	Flags: None
*/
function set_gadget_combat_efficiency_status(weapon, status, time)
{
	timeStr = "";
	if(isdefined(time))
	{
		timeStr = "^3" + ", time: " + time;
	}
	if(GetDvarInt("scr_cpower_debug_prints") > 0)
	{
		self IPrintLnBold("Gadget Combat Efficiency " + weapon.name + ": " + status + timeStr);
	}
}

