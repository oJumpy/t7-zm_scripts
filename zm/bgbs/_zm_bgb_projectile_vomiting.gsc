#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_a5a0319c;

/*
	Name: __init__sytem__
	Namespace: namespace_a5a0319c
	Checksum: 0xF631C93
	Offset: 0x210
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_projectile_vomiting", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_a5a0319c
	Checksum: 0x34D7B1E0
	Offset: 0x250
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("actor", "projectile_vomit", 12000, 1, "counter");
	bgb::register("zm_bgb_projectile_vomiting", "rounds", 5, &enable, &disable, undefined);
	bgb::function_2b341a2e("zm_bgb_projectile_vomiting", &actor_death_override);
}

/*
	Name: enable
	Namespace: namespace_a5a0319c
	Checksum: 0x99EC1590
	Offset: 0x310
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function enable()
{
}

/*
	Name: disable
	Namespace: namespace_a5a0319c
	Checksum: 0x99EC1590
	Offset: 0x320
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function disable()
{
}

/*
	Name: actor_death_override
	Namespace: namespace_a5a0319c
	Checksum: 0xAD3199E8
	Offset: 0x330
	Size: 0x75
	Parameters: 1
	Flags: None
*/
function actor_death_override(attacker)
{
	if(isdefined(self.damageMod))
	{
		switch(self.damageMod)
		{
			case "MOD_EXPLOSIVE":
			case "MOD_GRENADE":
			case "MOD_GRENADE_SPLASH":
			case "MOD_PROJECTILE":
			case "MOD_PROJECTILE_SPLASH":
			{
				clientfield::increment("projectile_vomit", 1);
				break;
			}
		}
	}
}

