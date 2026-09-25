#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_staminup;

/*
	Name: __init__sytem__
	Namespace: zm_perk_staminup
	Checksum: 0x750B5A10
	Offset: 0x198
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
	Checksum: 0xA1F0B948
	Offset: 0x1D8
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
	Checksum: 0xD279C7DA
	Offset: 0x1F8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function enable_staminup_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_staminup", &staminup_client_field_func, &staminup_callback_func);
	zm_perks::register_perk_effects("specialty_staminup", "marathon_light");
	zm_perks::register_perk_init_thread("specialty_staminup", &init_staminup);
}

/*
	Name: init_staminup
	Namespace: zm_perk_staminup
	Checksum: 0x768DD7A0
	Offset: 0x288
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function init_staminup()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["marathon_light"] = "zombie/fx_perk_stamin_up_zmb";
	}
}

/*
	Name: staminup_client_field_func
	Namespace: zm_perk_staminup
	Checksum: 0x5D09FB7F
	Offset: 0x2C8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function staminup_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.marathon", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: staminup_callback_func
	Namespace: zm_perk_staminup
	Checksum: 0x99EC1590
	Offset: 0x310
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function staminup_callback_func()
{
}

