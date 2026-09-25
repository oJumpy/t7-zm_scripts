#using scripts\shared\flagsys_shared;

#namespace zm_prototype_fx;

/*
	Name: main
	Namespace: zm_prototype_fx
	Checksum: 0x98208AE6
	Offset: 0x1F8
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function main()
{
	scriptedFX();
	level thread fx_overrides();
}

/*
	Name: scriptedFX
	Namespace: zm_prototype_fx
	Checksum: 0xD148B8B5
	Offset: 0x230
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function scriptedFX()
{
	level._effect["large_ceiling_dust"] = "dlc5/zmhd/fx_dust_ceiling_impact_lg_mdbrown";
	level._effect["poltergeist"] = "dlc5/zmhd/fx_zombie_couch_effect";
	level._effect["nuke_dust"] = "maps/zombie/fx_zombie_body_nuke_dust";
	level._effect["lght_marker"] = "dlc5/tomb/fx_tomb_marker";
	level._effect["lght_marker_flare"] = "dlc5/tomb/fx_tomb_marker_fl";
	level._effect["zombie_grain"] = "misc/fx_zombie_grain_cloud";
}

/*
	Name: fx_overrides
	Namespace: zm_prototype_fx
	Checksum: 0x3884262C
	Offset: 0x2E8
	Size: 0x3D
	Parameters: 0
	Flags: None
*/
function fx_overrides()
{
	level flagsys::wait_till("load_main_complete");
	level._effect["additionalprimaryweapon_light"] = "dlc5/zmhd/fx_perk_mule_kick";
}

