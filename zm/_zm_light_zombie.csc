#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_elemental_zombies;

#namespace zm_light_zombie;

/*
	Name: __init__sytem__
	Namespace: zm_light_zombie
	Checksum: 0xB1B5EB6E
	Offset: 0x2F0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_light_zombie", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_light_zombie
	Checksum: 0x57C1363B
	Offset: 0x330
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_fx();
	register_clientfields();
}

/*
	Name: init_fx
	Namespace: zm_light_zombie
	Checksum: 0x40A47149
	Offset: 0x360
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function init_fx()
{
	level._effect["light_zombie_fx"] = "dlc1/zmb_weapon/fx_bow_wolf_wrap_torso";
	level._effect["light_zombie_suicide"] = "explosions/fx_exp_grenade_flshbng";
	level._effect["dlc1/zmb_weapon/fx_bow_wolf_impact_zm"] = "lihgt_zombie_damage_fx";
}

/*
	Name: register_clientfields
	Namespace: zm_light_zombie
	Checksum: 0xFD5B8FD5
	Offset: 0x3C0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("actor", "light_zombie_clientfield_aura_fx", 15000, 1, "int", &function_98e8bc87, 0, 0);
	clientfield::register("actor", "light_zombie_clientfield_death_fx", 15000, 1, "int", &function_9127e2f8, 0, 0);
	clientfield::register("actor", "light_zombie_clientfield_damaged_fx", 15000, 1, "counter", &function_ad4789b4, 0, 0);
}

/*
	Name: function_9127e2f8
	Namespace: zm_light_zombie
	Checksum: 0xD3C8763
	Offset: 0x4A8
	Size: 0x97
	Parameters: 7
	Flags: None
*/
function function_9127e2f8(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(oldVal !== newVal && newVal === 1)
	{
		FX = PlayFXOnTag(localClientNum, level._effect["light_zombie_suicide"], self, "j_spineupper");
	}
}

/*
	Name: function_ad4789b4
	Namespace: zm_light_zombie
	Checksum: 0x19E4ADF
	Offset: 0x548
	Size: 0x143
	Parameters: 7
	Flags: None
*/
function function_ad4789b4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		if(isdefined(level._effect["dlc1/zmb_weapon/fx_bow_wolf_impact_zm"]))
		{
			playsound(localClientNum, "gdt_electro_bounce", self.origin);
			locs = Array("j_wrist_le", "j_wrist_ri");
			FX = PlayFXOnTag(localClientNum, level._effect["dlc1/zmb_weapon/fx_bow_wolf_impact_zm"], self, Array::random(locs));
			SetFXIgnorePause(localClientNum, FX, 1);
		}
	}
}

/*
	Name: function_98e8bc87
	Namespace: zm_light_zombie
	Checksum: 0x577939D8
	Offset: 0x698
	Size: 0xAB
	Parameters: 7
	Flags: None
*/
function function_98e8bc87(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(newVal))
	{
		return;
	}
	if(newVal == 1)
	{
		FX = PlayFXOnTag(localClientNum, level._effect["light_zombie_fx"], self, "j_spineupper");
		SetFXIgnorePause(localClientNum, FX, 1);
	}
}

