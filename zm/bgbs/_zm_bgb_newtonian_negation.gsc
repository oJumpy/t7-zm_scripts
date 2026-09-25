#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_5bdced82;

/*
	Name: __init__sytem__
	Namespace: namespace_5bdced82
	Checksum: 0xE91D8A00
	Offset: 0x1A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_newtonian_negation", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_5bdced82
	Checksum: 0x17A758B2
	Offset: 0x1E8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_newtonian_negation", "time", 1500, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_5bdced82
	Checksum: 0xC088CF25
	Offset: 0x250
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function enable()
{
	function_2b4ff13a(1);
	self thread function_7d6ddd3a();
}

/*
	Name: function_7d6ddd3a
	Namespace: namespace_5bdced82
	Checksum: 0x7D77B374
	Offset: 0x290
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_7d6ddd3a()
{
	self endon("hash_7e8cbf8f");
	self waittill("disconnect");
	thread disable();
}

/*
	Name: disable
	Namespace: namespace_5bdced82
	Checksum: 0xB239C052
	Offset: 0x2C8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function disable()
{
	if(isdefined(self))
	{
		self notify("hash_7e8cbf8f");
	}
	foreach(player in level.players)
	{
		if(player !== self && player bgb::is_enabled("zm_bgb_newtonian_negation"))
		{
			return;
		}
	}
	function_2b4ff13a(0);
	zombie_utility::clear_all_corpses();
}

/*
	Name: function_2b4ff13a
	Namespace: namespace_5bdced82
	Checksum: 0xD8054583
	Offset: 0x3B0
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_2b4ff13a(var_365c612)
{
	if(var_365c612)
	{
		SetDvar("phys_gravity_dir", (0, 0, -1));
	}
	else
	{
		SetDvar("phys_gravity_dir", (0, 0, 1));
	}
}

