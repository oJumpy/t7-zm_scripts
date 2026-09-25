#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_equip_hacker;

#namespace namespace_b03b0164;

/*
	Name: hack_packapunch
	Namespace: namespace_b03b0164
	Checksum: 0x6A95005A
	Offset: 0x150
	Size: 0x17B
	Parameters: 0
	Flags: None
*/
function hack_packapunch()
{
	vending_weapon_upgrade_trigger = GetEntArray("pack_a_punch", "script_noteworthy");
	perk = GetEnt(vending_weapon_upgrade_trigger[0].target, "targetname");
	if(isdefined(perk))
	{
		struct = spawnstruct();
		struct.origin = perk.origin + AnglesToRight(perk.angles) * 26 + VectorScale((0, 0, 1), 48);
		struct.radius = 48;
		struct.height = 48;
		struct.script_float = 5;
		struct.script_int = -1000;
		level._pack_hack_struct = struct;
		namespace_6d813654::register_pooled_hackable_struct(level._pack_hack_struct, &packapunch_hack);
		level._pack_hack_struct pack_trigger_think();
	}
}

/*
	Name: pack_trigger_think
	Namespace: namespace_b03b0164
	Checksum: 0x3EA69EAD
	Offset: 0x2D8
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function pack_trigger_think()
{
	if(!level flag::exists("enter_nml"))
	{
		return;
	}
	while(1)
	{
		level flag::wait_till("enter_nml");
		self.script_int = -1000;
		while(level flag::get("enter_nml"))
		{
			wait(1);
		}
	}
}

/*
	Name: packapunch_hack
	Namespace: namespace_b03b0164
	Checksum: 0x73D40910
	Offset: 0x368
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function packapunch_hack(hacker)
{
	namespace_6d813654::deregister_hackable_struct(level._pack_hack_struct);
	level._pack_hack_struct.script_int = 0;
	level notify("packapunch_hacked");
}

