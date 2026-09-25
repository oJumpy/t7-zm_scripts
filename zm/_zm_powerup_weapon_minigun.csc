#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_weapon_minigun;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0x445C73A
	Offset: 0x120
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_weapon_minigun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0xF6B74897
	Offset: 0x160
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("minigun");
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("minigun", "powerup_mini_gun");
	}
}

