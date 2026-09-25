#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craft_shield;

#namespace zm_equip_turret;

/*
	Name: __init__sytem__
	Namespace: zm_equip_turret
	Checksum: 0x51325EC6
	Offset: 0x1C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_rocketshield", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_equip_turret
	Checksum: 0xB06DA0D2
	Offset: 0x208
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "rs_ammo", 1, 1, "int", &set_rocketshield_ammo, 0, 0);
}

/*
	Name: set_rocketshield_ammo
	Namespace: zm_equip_turret
	Checksum: 0x4FD71D43
	Offset: 0x260
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function set_rocketshield_ammo(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 1, 0, 0);
	}
	else
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

