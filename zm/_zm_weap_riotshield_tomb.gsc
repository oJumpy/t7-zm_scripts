#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\craftables\_zm_craft_shield;

#namespace namespace_4ee929d9;

/*
	Name: __init__sytem__
	Namespace: namespace_4ee929d9
	Checksum: 0x3BC626A9
	Offset: 0x230
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_tomb_shield", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_4ee929d9
	Checksum: 0x8B2512DB
	Offset: 0x278
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_craft_shield::init("craft_shield_zm", "tomb_shield", "wpn_t7_zmb_hd_origins_shield_dmg00_world");
	level.weaponRiotshield = GetWeapon("tomb_shield");
	zm_equipment::register("tomb_shield", &"ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_RIOTSHIELD_HOWTO", undefined, "riotshield");
}

/*
	Name: __main__
	Namespace: namespace_4ee929d9
	Checksum: 0xAABE1C15
	Offset: 0x300
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function __main__()
{
	zm_equipment::register_for_level("tomb_shield");
	zm_equipment::Include("tomb_shield");
}

