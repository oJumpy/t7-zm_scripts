#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_shield_charge;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_shield_charge
	Checksum: 0xCA25F467
	Offset: 0x100
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_shield_charge", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_shield_charge
	Checksum: 0x162F3777
	Offset: 0x140
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("shield_charge");
	zm_powerups::add_zombie_powerup("shield_charge");
}

