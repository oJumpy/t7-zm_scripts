#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_juggernaut;

/*
	Name: __init__sytem__
	Namespace: zm_perk_juggernaut
	Checksum: 0x8E42B9EF
	Offset: 0x198
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_juggernaut", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_juggernaut
	Checksum: 0xC167C737
	Offset: 0x1D8
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function __init__()
{
	zm_perks::register_perk_clientfields("specialty_armorvest", &juggernaut_client_field_func, &juggernaut_code_callback_func);
	zm_perks::register_perk_effects("specialty_armorvest", "jugger_light");
	zm_perks::register_perk_init_thread("specialty_armorvest", &init_juggernaut);
}

/*
	Name: init_juggernaut
	Namespace: zm_perk_juggernaut
	Checksum: 0xE64DA626
	Offset: 0x268
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function init_juggernaut()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["jugger_light"] = "zombie/fx_perk_juggernaut_zmb";
	}
}

/*
	Name: juggernaut_client_field_func
	Namespace: zm_perk_juggernaut
	Checksum: 0x3DECC15D
	Offset: 0x2A8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function juggernaut_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.juggernaut", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: juggernaut_code_callback_func
	Namespace: zm_perk_juggernaut
	Checksum: 0x99EC1590
	Offset: 0x2F0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function juggernaut_code_callback_func()
{
}

