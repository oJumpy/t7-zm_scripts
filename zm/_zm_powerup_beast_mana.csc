#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace namespace_6500cb2b;

/*
	Name: __init__sytem__
	Namespace: namespace_6500cb2b
	Checksum: 0x6EC27E63
	Offset: 0xF8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_beast_mana", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_6500cb2b
	Checksum: 0xA44738F2
	Offset: 0x138
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("beast_mana");
	zm_powerups::add_zombie_powerup("beast_mana");
}

