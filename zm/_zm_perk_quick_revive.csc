#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_quick_revive;

/*
	Name: __init__sytem__
	Namespace: zm_perk_quick_revive
	Checksum: 0x8C742804
	Offset: 0x1A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_quick_revive", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_quick_revive
	Checksum: 0xD75B83C7
	Offset: 0x1E8
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	enable_quick_revive_perk_for_level();
}

/*
	Name: enable_quick_revive_perk_for_level
	Namespace: zm_perk_quick_revive
	Checksum: 0xA207372
	Offset: 0x208
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function enable_quick_revive_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_quickrevive", &quick_revive_client_field_func, &quick_revive_callback_func);
	zm_perks::register_perk_effects("specialty_quickrevive", "revive_light");
	zm_perks::register_perk_init_thread("specialty_quickrevive", &init_quick_revive);
}

/*
	Name: init_quick_revive
	Namespace: zm_perk_quick_revive
	Checksum: 0x3C566F20
	Offset: 0x298
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function init_quick_revive()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["revive_light"] = "zombie/fx_perk_quick_revive_zmb";
	}
}

/*
	Name: quick_revive_client_field_func
	Namespace: zm_perk_quick_revive
	Checksum: 0x699B66A3
	Offset: 0x2D8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function quick_revive_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.quick_revive", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: quick_revive_callback_func
	Namespace: zm_perk_quick_revive
	Checksum: 0x99EC1590
	Offset: 0x320
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function quick_revive_callback_func()
{
}

