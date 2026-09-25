#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_free_perk;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_free_perk
	Checksum: 0xE57FF11C
	Offset: 0xF0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_free_perk", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_free_perk
	Checksum: 0xEAFA8A4E
	Offset: 0x130
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("free_perk");
	zm_powerups::add_zombie_powerup("free_perk");
}

