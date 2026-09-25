#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace namespace_1d58b607;

/*
	Name: __init__sytem__
	Namespace: namespace_1d58b607
	Checksum: 0xF29379B0
	Offset: 0xF0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_quad", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_1d58b607
	Checksum: 0x658CEB5B
	Offset: 0x130
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_blur("zm_ai_quad_blur", 21000, 1, 0.1, 0.5, 4);
}

