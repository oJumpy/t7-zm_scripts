#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_equip_hacker;

#namespace namespace_359e846b;

/*
	Name: hack_wallbuys
	Namespace: namespace_359e846b
	Checksum: 0xDA2B6FAF
	Offset: 0x180
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function hack_wallbuys()
{
	weapon_spawns = struct::get_array("weapon_upgrade", "targetname");
	for(i = 0; i < weapon_spawns.size; i++)
	{
		if(weapon_spawns[i].weapon.type == "grenade")
		{
			continue;
		}
		if(weapon_spawns[i].weapon.type == "melee")
		{
			continue;
		}
		if(weapon_spawns[i].weapon.type == "mine")
		{
			continue;
		}
		if(weapon_spawns[i].weapon.type == "bomb")
		{
			continue;
		}
		struct = spawnstruct();
		struct.origin = weapon_spawns[i].origin;
		struct.radius = 48;
		struct.height = 48;
		struct.script_float = 2;
		struct.script_int = 3000;
		struct.wallbuy = weapon_spawns[i];
		namespace_6d813654::register_pooled_hackable_struct(struct, &wallbuy_hack);
	}
	bowie_triggers = GetEntArray("bowie_upgrade", "targetname");
	Array::thread_all(bowie_triggers, &namespace_6d813654::hide_hint_when_hackers_active);
}

/*
	Name: wallbuy_hack
	Namespace: namespace_359e846b
	Checksum: 0x961C1C94
	Offset: 0x3B0
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function wallbuy_hack(hacker)
{
	self.wallbuy.trigger_stub.hacked = 1;
	self.clientFieldName = self.wallbuy.zombie_weapon_upgrade + "_" + self.origin;
	level clientfield::set(self.clientFieldName, 2);
	namespace_6d813654::deregister_hackable_struct(self);
}

