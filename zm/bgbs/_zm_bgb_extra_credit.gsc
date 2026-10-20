#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_extra_credit;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_extra_credit
	Checksum: 0xED280D97
	Offset: 0x190
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_extra_credit", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_extra_credit
	Checksum: 0x86932F6
	Offset: 0x1D0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_extra_credit", "activated", 4, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: zm_bgb_extra_credit
	Checksum: 0xF80A50FA
	Offset: 0x230
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function activation()
{
	powerup_origin = self bgb::get_player_dropped_powerup_origin();
	self thread function_b18c3b2d(powerup_origin);
}

/*
	Name: function_b18c3b2d
	Namespace: zm_bgb_extra_credit
	Checksum: 0xD8283FFF
	Offset: 0x280
	Size: 0xD3
	Parameters: 1
	Flags: None
*/
function function_b18c3b2d(origin)
{
	self endon("disconnect");
	self endon("bled_out");
	e_powerup = zm_powerups::specific_powerup_drop("bonus_points_player", origin, undefined, undefined, 0.1);
	e_powerup.bonus_points_powerup_override = &function_3258dd42;
	wait(1);
	if(isdefined(e_powerup) && (!e_powerup zm::in_enabled_playable_area() && !e_powerup zm::in_life_brush()))
	{
		level thread bgb::powerup_stolen_by_sam(e_powerup);
	}
}

/*
	Name: function_3258dd42
	Namespace: zm_bgb_extra_credit
	Checksum: 0xF150569D
	Offset: 0x360
	Size: 0x7
	Parameters: 0
	Flags: None
*/
function function_3258dd42()
{
	return 1250;
}

