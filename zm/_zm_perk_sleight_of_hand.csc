#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_sleight_of_hand;

/*
	Name: __init__sytem__
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0xC56D1F8E
	Offset: 0x1B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_sleight_of_hand", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0xE2F65A4C
	Offset: 0x1F0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	enable_sleight_of_hand_perk_for_level();
}

/*
	Name: enable_sleight_of_hand_perk_for_level
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0xF427234C
	Offset: 0x210
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function enable_sleight_of_hand_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_fastreload", &sleight_of_hand_client_field_func, &sleight_of_hand_code_callback_func);
	zm_perks::register_perk_effects("specialty_fastreload", "sleight_light");
	zm_perks::register_perk_init_thread("specialty_fastreload", &init_sleight_of_hand);
}

/*
	Name: init_sleight_of_hand
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0xB352172
	Offset: 0x2A0
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function init_sleight_of_hand()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["sleight_light"] = "zombie/fx_perk_sleight_of_hand_zmb";
	}
}

/*
	Name: sleight_of_hand_client_field_func
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0x2562D5B1
	Offset: 0x2E0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function sleight_of_hand_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.sleight_of_hand", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: sleight_of_hand_code_callback_func
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0x99EC1590
	Offset: 0x328
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function sleight_of_hand_code_callback_func()
{
}

