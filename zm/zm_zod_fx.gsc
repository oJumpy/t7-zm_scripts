#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace namespace_47b9c241;

/*
	Name: main
	Namespace: namespace_47b9c241
	Checksum: 0x688A3529
	Offset: 0x2C0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function main()
{
	precache_scripted_fx();
	precache_createfx_fx();
}

/*
	Name: precache_scripted_fx
	Namespace: namespace_47b9c241
	Checksum: 0xD3FC4666
	Offset: 0x2F0
	Size: 0xE1
	Parameters: 0
	Flags: None
*/
function precache_scripted_fx()
{
	level._effect["idgun_cocoon_off"] = "zombie/fx_idgun_cocoon_explo_zod_zmb";
	level._effect["pap_basin_glow"] = "zombie/fx_ritual_pap_basin_fire_zod_zmb";
	level._effect["pap_basin_glow_lg"] = "zombie/fx_ritual_pap_basin_fire_lg_zod_zmb";
	level._effect["cultist_crate_personal_item"] = "zombie/fx_cultist_crate_smk_zod_zmb";
	level._effect["robot_landing"] = "zombie/fx_robot_helper_jump_landing_zod_zmb";
	level._effect["robot_sky_trail"] = "zombie/fx_robot_helper_trail_sky_zod_zmb";
	level._effect["robot_ground_spawn"] = "zombie/fx_robot_helper_ground_tell_zod_zmb";
	level._effect["portal_shortcut_closed"] = "zombie/fx_quest_portal_tear_zod_zmb";
}

/*
	Name: precache_createfx_fx
	Namespace: namespace_47b9c241
	Checksum: 0x99EC1590
	Offset: 0x3E0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function precache_createfx_fx()
{
}

