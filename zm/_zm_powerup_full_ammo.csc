#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_full_ammo;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_full_ammo
	Checksum: 0xF8C0504E
	Offset: 0x108
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_full_ammo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_full_ammo
	Checksum: 0x465F7BCA
	Offset: 0x148
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("full_ammo");
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("full_ammo");
	}
}

