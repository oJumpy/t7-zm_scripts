#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_attackables;

/*
	Name: __init__sytem__
	Namespace: zm_attackables
	Checksum: 0xD3AD68F8
	Offset: 0x2F8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_attackables", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_attackables
	Checksum: 0xAB6F11D8
	Offset: 0x340
	Size: 0x1A5
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.attackableCallback = &attackable_callback;
	level.ATTACKABLES = struct::get_array("scriptbundle_attackables", "classname");
	foreach(attackable in level.ATTACKABLES)
	{
		attackable.bundle = struct::get_script_bundle("attackables", attackable.scriptbundlename);
		if(isdefined(attackable.target))
		{
			attackable.slot = struct::get_array(attackable.target, "targetname");
		}
		attackable.is_active = 0;
		attackable.health = attackable.bundle.max_health;
		if(GetDvarInt("zm_attackables") > 0)
		{
			attackable.is_active = 1;
			attackable.health = 1000;
		}
	}
}

/*
	Name: __main__
	Namespace: zm_attackables
	Checksum: 0x99EC1590
	Offset: 0x4F0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: get_attackable
	Namespace: zm_attackables
	Checksum: 0xB1B7FE98
	Offset: 0x500
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function get_attackable()
{
	foreach(attackable in level.ATTACKABLES)
	{
		if(!(isdefined(attackable.is_active) && attackable.is_active))
		{
			continue;
		}
		dist = Distance(self.origin, attackable.origin);
		if(dist < attackable.bundle.aggro_distance)
		{
			if(attackable get_attackable_slot(self))
			{
				return attackable;
			}
		}
		/#
			if(GetDvarInt("Dev Block strings are not supported") > 1)
			{
				if(attackable get_attackable_slot(self))
				{
					return attackable;
				}
			}
		#/
	}
	return undefined;
}

/*
	Name: get_attackable_slot
	Namespace: zm_attackables
	Checksum: 0x61FB08C
	Offset: 0x668
	Size: 0xD5
	Parameters: 1
	Flags: None
*/
function get_attackable_slot(entity)
{
	self clear_slots();
	foreach(slot in self.slot)
	{
		if(!isdefined(slot.entity))
		{
			slot.entity = entity;
			entity.attackable_slot = slot;
			return 1;
		}
	}
	return 0;
}

/*
	Name: clear_slots
	Namespace: zm_attackables
	Checksum: 0xD7AF7903
	Offset: 0x748
	Size: 0xE3
	Parameters: 0
	Flags: Private
*/
function private clear_slots()
{
	foreach(slot in self.slot)
	{
		if(!isalive(slot.entity))
		{
			slot.entity = undefined;
			continue;
		}
		if(isdefined(slot.entity.missingLegs) && slot.entity.missingLegs)
		{
			slot.entity = undefined;
		}
	}
}

/*
	Name: activate
	Namespace: zm_attackables
	Checksum: 0x6E4E8D03
	Offset: 0x838
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function activate()
{
	self.is_active = 1;
	if(self.health <= 0)
	{
		self.health = self.bundle.max_health;
	}
}

/*
	Name: deactivate
	Namespace: zm_attackables
	Checksum: 0xB70A0AD9
	Offset: 0x878
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function deactivate()
{
	self.is_active = 0;
}

/*
	Name: do_damage
	Namespace: zm_attackables
	Checksum: 0x1522F874
	Offset: 0x890
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function do_damage(damage)
{
	self.health = self.health - damage;
	self notify("attackable_damaged");
	if(self.health <= 0)
	{
		self notify("attackable_deactivated");
		if(!(isdefined(self.b_deferred_deactivation) && self.b_deferred_deactivation))
		{
			self deactivate();
		}
	}
}

/*
	Name: attackable_callback
	Namespace: zm_attackables
	Checksum: 0xBF7F2EA3
	Offset: 0x910
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function attackable_callback(entity)
{
	if(entity.archetype === "thrasher" && (self.scriptbundlename === "zm_island_trap_plant_attackable" || self.scriptbundlename === "zm_island_trap_plant_upgraded_attackable"))
	{
		self do_damage(self.health);
	}
	else
	{
		self do_damage(entity.meleeWeapon.meleeDamage);
	}
}

