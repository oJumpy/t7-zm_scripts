#using scripts\codescripts\struct;

#namespace weapon_utils;

/*
	Name: isPistol
	Namespace: weapon_utils
	Checksum: 0x180C1CF2
	Offset: 0x108
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function isPistol(weapon)
{
	return isdefined(level.side_arm_array[weapon]);
}

/*
	Name: isFlashOrStunWeapon
	Namespace: weapon_utils
	Checksum: 0x85DF2E2F
	Offset: 0x130
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function isFlashOrStunWeapon(weapon)
{
	return weapon.isFlash || weapon.isStun;
}

/*
	Name: isFlashOrStunDamage
	Namespace: weapon_utils
	Checksum: 0xFC3F9FA0
	Offset: 0x168
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function isFlashOrStunDamage(weapon, meansOfDeath)
{
	return isFlashOrStunWeapon(weapon) && (meansOfDeath == "MOD_GRENADE_SPLASH" || meansOfDeath == "MOD_GAS");
}

/*
	Name: isMeleeMOD
	Namespace: weapon_utils
	Checksum: 0x973E275C
	Offset: 0x1C0
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function isMeleeMOD(mod)
{
	return mod == "MOD_MELEE" || mod == "MOD_MELEE_WEAPON_BUTT" || mod == "MOD_MELEE_ASSASSINATE";
}

/*
	Name: isPunch
	Namespace: weapon_utils
	Checksum: 0xF47D39A2
	Offset: 0x200
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function isPunch(weapon)
{
	return weapon.type == "melee" && weapon.rootweapon.name == "bare_hands";
}

/*
	Name: isKnife
	Namespace: weapon_utils
	Checksum: 0x2C58E787
	Offset: 0x250
	Size: 0x47
	Parameters: 1
	Flags: None
*/
function isKnife(weapon)
{
	return weapon.type == "melee" && weapon.rootweapon.name == "knife_loadout";
}

/*
	Name: isNonBareHandsMelee
	Namespace: weapon_utils
	Checksum: 0xF7F9B479
	Offset: 0x2A0
	Size: 0x59
	Parameters: 1
	Flags: None
*/
function isNonBareHandsMelee(weapon)
{
	return weapon.type == "melee" && weapon.rootweapon.name != "bare_hands" || weapon.isBallisticKnife;
}

