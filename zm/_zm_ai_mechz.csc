#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_elemental_zombies;

#namespace namespace_ef567265;

/*
	Name: __init__sytem__
	Namespace: namespace_ef567265
	Checksum: 0x4D7F8D7A
	Offset: 0xF8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_mechz", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_ef567265
	Checksum: 0x99EC1590
	Offset: 0x140
	Size: 0x3
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__()
{
}

/*
	Name: __main__
	Namespace: namespace_ef567265
	Checksum: 0xF2AF64D0
	Offset: 0x150
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	visionset_mgr::register_overlay_info_style_burn("mechz_player_burn", 5000, 15, 1.5);
}

