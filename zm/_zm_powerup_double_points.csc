#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace zm_powerup_double_points;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_double_points
	Checksum: 0x22B46B31
	Offset: 0x128
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_double_points", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_double_points
	Checksum: 0xA1F39732
	Offset: 0x168
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_powerups::include_zombie_powerup("double_points");
	if(ToLower(GetDvarString("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("double_points", "powerup_double_points");
	}
}

