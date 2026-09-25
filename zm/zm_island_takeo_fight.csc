#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#namespace namespace_4e4a096c;

/*
	Name: __init__sytem__
	Namespace: namespace_4e4a096c
	Checksum: 0x67F9AF91
	Offset: 0x320
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_takeo_fight", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_4e4a096c
	Checksum: 0x73E17F9E
	Offset: 0x360
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "takeofight_teleport_fx", 9000, 1, "int", &function_c0e76be4, 0, 0);
	clientfield::register("scriptmover", "takeo_arm_hit_fx", 1, 3, "int", &function_863420f7, 0, 0);
}

/*
	Name: main
	Namespace: namespace_4e4a096c
	Checksum: 0x99EC1590
	Offset: 0x400
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function main()
{
}

/*
	Name: function_c0e76be4
	Namespace: namespace_4e4a096c
	Checksum: 0xFB816274
	Offset: 0x410
	Size: 0x3B
	Parameters: 7
	Flags: None
*/
function function_c0e76be4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
}

/*
	Name: function_863420f7
	Namespace: namespace_4e4a096c
	Checksum: 0xFC0251C8
	Offset: 0x458
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_863420f7(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal > 0)
	{
		str_tag = "tag_fx_eye" + newVal + "_jnt";
		self.var_2c75d806 = PlayFXOnTag(localClientNum, level._effect["takeofight_postule_burst"], self, str_tag);
	}
}

