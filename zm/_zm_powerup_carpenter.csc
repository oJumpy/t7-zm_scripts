#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_carpenter;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_carpenter
	Checksum: 0xDF600E67
	Offset: 0xF0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_carpenter", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_carpenter
	Checksum: 0x59681989
	Offset: 0x130
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("carpenter");
	zm_powerups::add_zombie_powerup("carpenter");
}

