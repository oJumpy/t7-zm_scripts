#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace namespace_50ac7dd1;

/*
	Name: __init__sytem__
	Namespace: namespace_50ac7dd1
	Checksum: 0xFA8C28D2
	Offset: 0x108
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_bonus_points_team", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_50ac7dd1
	Checksum: 0xED0A7EBE
	Offset: 0x148
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("bonus_points_team");
	zm_powerups::add_zombie_powerup("bonus_points_team");
}

