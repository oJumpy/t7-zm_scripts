#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_perk_staminup;

/*
	Name: __init__sytem__
	Namespace: zm_perk_staminup
	Checksum: 0xD1504B87
	Offset: 0x330
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_staminup", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_staminup
	Checksum: 0x84D59C04
	Offset: 0x370
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	enable_staminup_perk_for_level();
}

/*
	Name: enable_staminup_perk_for_level
	Namespace: zm_perk_staminup
	Checksum: 0x808A4B49
	Offset: 0x390
	Size: 0xF3
	Parameters: 0
	Flags: None
*/
function enable_staminup_perk_for_level()
{
	zm_perks::register_perk_basic_info("specialty_staminup", "marathon", 2000, &"ZOMBIE_PERK_MARATHON", GetWeapon("zombie_perk_bottle_marathon"));
	zm_perks::register_perk_precache_func("specialty_staminup", &staminup_precache);
	zm_perks::register_perk_clientfields("specialty_staminup", &staminup_register_clientfield, &staminup_set_clientfield);
	zm_perks::register_perk_machine("specialty_staminup", &staminup_perk_machine_setup);
	zm_perks::register_perk_host_migration_params("specialty_staminup", "vending_marathon", "marathon_light");
}

/*
	Name: staminup_precache
	Namespace: zm_perk_staminup
	Checksum: 0xB674A3AA
	Offset: 0x490
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function staminup_precache()
{
	if(isdefined(level.staminup_precache_override_func))
	{
		[[level.staminup_precache_override_func]]();
		return;
	}
	level._effect["marathon_light"] = "zombie/fx_perk_stamin_up_zmb";
	level.machine_assets["specialty_staminup"] = spawnstruct();
	level.machine_assets["specialty_staminup"].weapon = GetWeapon("zombie_perk_bottle_marathon");
	level.machine_assets["specialty_staminup"].off_model = "p7_zm_vending_marathon";
	level.machine_assets["specialty_staminup"].on_model = "p7_zm_vending_marathon";
}

/*
	Name: staminup_register_clientfield
	Namespace: zm_perk_staminup
	Checksum: 0x810BF9CE
	Offset: 0x578
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function staminup_register_clientfield()
{
	clientfield::register("clientuimodel", "hudItems.perks.marathon", 1, 2, "int");
}

/*
	Name: staminup_set_clientfield
	Namespace: zm_perk_staminup
	Checksum: 0xF0C8EFD6
	Offset: 0x5B8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function staminup_set_clientfield(State)
{
	self clientfield::set_player_uimodel("hudItems.perks.marathon", State);
}

/*
	Name: staminup_perk_machine_setup
	Namespace: zm_perk_staminup
	Checksum: 0x2522895
	Offset: 0x5F0
	Size: 0xBB
	Parameters: 4
	Flags: None
*/
function staminup_perk_machine_setup(use_trigger, perk_machine, bump_trigger, collision)
{
	use_trigger.script_sound = "mus_perks_stamin_jingle";
	use_trigger.script_string = "marathon_perk";
	use_trigger.script_label = "mus_perks_stamin_sting";
	use_trigger.target = "vending_marathon";
	perk_machine.script_string = "marathon_perk";
	perk_machine.targetname = "vending_marathon";
	if(isdefined(bump_trigger))
	{
		bump_trigger.script_string = "marathon_perk";
	}
}

