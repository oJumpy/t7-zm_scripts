#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_8b3a30e2;

/*
	Name: __init__sytem__
	Namespace: namespace_8b3a30e2
	Checksum: 0xAE8AC95E
	Offset: 0x178
	Size: 0x4B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_lucky_crit", &__init__, undefined, Array("aat", "bgb"));
}

/*
	Name: __init__
	Namespace: namespace_8b3a30e2
	Checksum: 0xB37E3ABF
	Offset: 0x1D0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!isdefined(level.aat_in_use) && level.aat_in_use || (!isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_lucky_crit", "rounds", 1, undefined, undefined, undefined);
	AAT::register_reroll("zm_bgb_lucky_crit", 2, &active, "t7_hud_zm_aat_bgb");
}

/*
	Name: active
	Namespace: namespace_8b3a30e2
	Checksum: 0xE867DF8D
	Offset: 0x270
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function active()
{
	return bgb::is_enabled("zm_bgb_lucky_crit");
}

