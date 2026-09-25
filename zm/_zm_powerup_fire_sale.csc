#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_fire_sale;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_fire_sale
	Checksum: 0xF14025C5
	Offset: 0x118
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_fire_sale", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_fire_sale
	Checksum: 0x18E04E00
	Offset: 0x158
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("fire_sale");
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("fire_sale", "powerup_fire_sale");
	}
}

