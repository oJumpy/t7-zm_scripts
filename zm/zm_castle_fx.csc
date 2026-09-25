#using scripts\codescripts\struct;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace namespace_35f5e9b2;

/*
	Name: precache_util_fx
	Namespace: namespace_35f5e9b2
	Checksum: 0x99EC1590
	Offset: 0x1F0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function precache_util_fx()
{
}

/*
	Name: main
	Namespace: namespace_35f5e9b2
	Checksum: 0x24FEC0E7
	Offset: 0x200
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function main()
{
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
}

/*
	Name: precache_scripted_fx
	Namespace: namespace_35f5e9b2
	Checksum: 0xF9CDE396
	Offset: 0x240
	Size: 0x8D
	Parameters: 0
	Flags: None
*/
function precache_scripted_fx()
{
	level._effect["zapper"] = "dlc1/castle/fx_elec_trap_castle";
	level._effect["rocket_warning_smoke"] = "smoke/fx_smk_ambient_cieling_newworld";
	level._effect["rocket_warning_fire"] = "explosions/fx_exp_vtol_crash_trail_prologue";
	level._effect["rocket_side_blast"] = "fire/fx_fire_side_lrg";
	level._effect["death_ray_shock_eyes"] = "zombie/fx_tesla_shock_eyes_zmb";
}

/*
	Name: precache_createfx_fx
	Namespace: namespace_35f5e9b2
	Checksum: 0x99EC1590
	Offset: 0x2D8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function precache_createfx_fx()
{
}

