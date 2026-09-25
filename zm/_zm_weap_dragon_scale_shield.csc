#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_dragon_strike;
#using scripts\zm\_zm_weapons;

#namespace namespace_8215525;

/*
	Name: __init__sytem__
	Namespace: namespace_8215525
	Checksum: 0x5EBD6D12
	Offset: 0x320
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_dragonshield", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_8215525
	Checksum: 0xE23126A3
	Offset: 0x360
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "ds_ammo", 12000, 1, "int", &function_3b8ce539, 0, 0);
	clientfield::register("allplayers", "burninate", 12000, 1, "counter", &function_adc7474a, 0, 0);
	clientfield::register("allplayers", "burninate_upgraded", 12000, 1, "counter", &function_627dd7e5, 0, 0);
	clientfield::register("actor", "dragonshield_snd_projectile_impact", 12000, 1, "counter", &function_7ba84100, 0, 0);
	clientfield::register("vehicle", "dragonshield_snd_projectile_impact", 12000, 1, "counter", &function_7ba84100, 0, 0);
	clientfield::register("actor", "dragonshield_snd_zombie_knockdown", 12000, 1, "counter", &function_d2012501, 0, 0);
	clientfield::register("vehicle", "dragonshield_snd_zombie_knockdown", 12000, 1, "counter", &function_d2012501, 0, 0);
}

/*
	Name: function_3b8ce539
	Namespace: namespace_8215525
	Checksum: 0xAA9D3096
	Offset: 0x568
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_3b8ce539(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
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

/*
	Name: function_adc7474a
	Namespace: namespace_8215525
	Checksum: 0xF18DBB7A
	Offset: 0x618
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_adc7474a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(self isLocalPlayer())
	{
		PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_dragon_shield_fire_1p", self, "tag_flash");
	}
	else
	{
		PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_dragon_shield_fire_3p", self, "tag_flash");
	}
}

/*
	Name: function_627dd7e5
	Namespace: namespace_8215525
	Checksum: 0x2C66E416
	Offset: 0x6C8
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_627dd7e5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(self isLocalPlayer())
	{
		PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_dragon_shield_fire_1p_up", self, "tag_flash");
	}
	else
	{
		PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_dragon_shield_fire_3p_up", self, "tag_flash");
	}
}

/*
	Name: function_7ba84100
	Namespace: namespace_8215525
	Checksum: 0x17DC5F73
	Offset: 0x778
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_7ba84100(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playsound(localClientNum, "vox_dragonshield_forcehit", self.origin);
	playsound(localClientNum, "wpn_dragonshield_proj_impact", self.origin);
}

/*
	Name: function_d2012501
	Namespace: namespace_8215525
	Checksum: 0xBA4B1BD4
	Offset: 0x810
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_d2012501(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playsound(localClientNum, "fly_dragonshield_forcehit", self.origin);
}

