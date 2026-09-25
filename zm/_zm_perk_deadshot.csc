#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_deadshot;

/*
	Name: __init__sytem__
	Namespace: zm_perk_deadshot
	Checksum: 0x4447CFAA
	Offset: 0x1B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_deadshot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_deadshot
	Checksum: 0x9AF53617
	Offset: 0x1F0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	enable_deadshot_perk_for_level();
}

/*
	Name: enable_deadshot_perk_for_level
	Namespace: zm_perk_deadshot
	Checksum: 0xD75ACCE3
	Offset: 0x210
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function enable_deadshot_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_deadshot", &deadshot_client_field_func, &deadshot_code_callback_func);
	zm_perks::register_perk_effects("specialty_deadshot", "deadshot_light");
	zm_perks::register_perk_init_thread("specialty_deadshot", &init_deadshot);
}

/*
	Name: init_deadshot
	Namespace: zm_perk_deadshot
	Checksum: 0x5ED23D72
	Offset: 0x2A0
	Size: 0x35
	Parameters: 0
	Flags: None
*/
function init_deadshot()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["deadshot_light"] = "_t6/misc/fx_zombie_cola_dtap_on";
	}
}

/*
	Name: deadshot_client_field_func
	Namespace: zm_perk_deadshot
	Checksum: 0xBA20A7D4
	Offset: 0x2E0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function deadshot_client_field_func()
{
	clientfield::register("toplayer", "deadshot_perk", 1, 1, "int", &player_deadshot_perk_handler, 0, 1);
	clientfield::register("clientuimodel", "hudItems.perks.dead_shot", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: deadshot_code_callback_func
	Namespace: zm_perk_deadshot
	Checksum: 0x99EC1590
	Offset: 0x370
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function deadshot_code_callback_func()
{
}

/*
	Name: player_deadshot_perk_handler
	Namespace: zm_perk_deadshot
	Checksum: 0x8E1DC9FB
	Offset: 0x380
	Size: 0xF3
	Parameters: 7
	Flags: None
*/
function player_deadshot_perk_handler(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!self isLocalPlayer() || IsSpectating(localClientNum, 0) || (isdefined(level.localPlayers[localClientNum]) && self GetEntityNumber() != level.localPlayers[localClientNum] GetEntityNumber()))
	{
		return;
	}
	if(newVal)
	{
		self UseAlternateAimParams();
	}
	else
	{
		self ClearAlternateAimParams();
	}
}

