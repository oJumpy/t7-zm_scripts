#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace namespace_6caa802f;

/*
	Name: __init__sytem__
	Namespace: namespace_6caa802f
	Checksum: 0xC0C4313B
	Offset: 0x198
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_sword_flay", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_6caa802f
	Checksum: 0xC10F4D85
	Offset: 0x1D8
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_sword_flay", "time", 150, &enable, &disable, undefined);
	bgb::function_3422638b("zm_bgb_sword_flay", &actor_damage_override);
	bgb::function_e22c6124("zm_bgb_sword_flay", &vehicle_damage_override);
}

/*
	Name: enable
	Namespace: namespace_6caa802f
	Checksum: 0x99EC1590
	Offset: 0x290
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function enable()
{
}

/*
	Name: disable
	Namespace: namespace_6caa802f
	Checksum: 0x99EC1590
	Offset: 0x2A0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function disable()
{
}

/*
	Name: actor_damage_override
	Namespace: namespace_6caa802f
	Checksum: 0xCD14ACEE
	Offset: 0x2B0
	Size: 0xDF
	Parameters: 12
	Flags: None
*/
function actor_damage_override(inflictor, attacker, damage, flags, meansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(meansOfDeath === "MOD_MELEE")
	{
		damage = damage * 5;
		if(self.health - damage <= 0 && isdefined(attacker) && isPlayer(attacker))
		{
			attacker zm_stats::increment_challenge_stat("GUM_GOBBLER_SWORD_FLAY");
		}
	}
	return damage;
}

/*
	Name: vehicle_damage_override
	Namespace: namespace_6caa802f
	Checksum: 0xC12369CB
	Offset: 0x398
	Size: 0xA1
	Parameters: 15
	Flags: None
*/
function vehicle_damage_override(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal)
{
	if(sMeansOfDeath === "MOD_MELEE")
	{
		iDamage = iDamage * 5;
	}
	return iDamage;
}

