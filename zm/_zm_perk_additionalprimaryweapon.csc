#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_additionalprimaryweapon;

/*
	Name: __init__sytem__
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0xAEF8FCBA
	Offset: 0x1E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_additionalprimaryweapon", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0xC88EEAB7
	Offset: 0x220
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	enable_additional_primary_weapon_perk_for_level();
}

/*
	Name: enable_additional_primary_weapon_perk_for_level
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0xCD616E89
	Offset: 0x240
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function enable_additional_primary_weapon_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_additionalprimaryweapon", &additional_primary_weapon_client_field_func, &additional_primary_weapon_code_callback_func);
	zm_perks::register_perk_effects("specialty_additionalprimaryweapon", "additionalprimaryweapon_light");
	zm_perks::register_perk_init_thread("specialty_additionalprimaryweapon", &init_additional_primary_weapon);
}

/*
	Name: init_additional_primary_weapon
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0x4C31119D
	Offset: 0x2D0
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function init_additional_primary_weapon()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["additionalprimaryweapon_light"] = "zombie/fx_perk_mule_kick_zmb";
	}
}

/*
	Name: additional_primary_weapon_client_field_func
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0x2B630B33
	Offset: 0x310
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function additional_primary_weapon_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.additional_primary_weapon", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: additional_primary_weapon_code_callback_func
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0x99EC1590
	Offset: 0x358
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function additional_primary_weapon_code_callback_func()
{
}

