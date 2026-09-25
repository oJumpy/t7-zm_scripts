#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_62ef2c38;

/*
	Name: __init__sytem__
	Namespace: namespace_62ef2c38
	Checksum: 0xCE329ACC
	Offset: 0x1A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_now_you_see_me", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_62ef2c38
	Checksum: 0x1607A289
	Offset: 0x1E8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_now_you_see_me", "activated");
	visionset_mgr::register_visionset_info("zm_bgb_now_you_see_me", 1, 31, undefined, "zm_bgb_in_plain_sight");
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_bgb_now_you_see_me", 1, 1, "pstfx_zm_bgb_now_you_see_me");
}

