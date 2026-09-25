#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_powerups;

#namespace namespace_e581e076;

/*
	Name: __init__sytem__
	Namespace: namespace_e581e076
	Checksum: 0xD7FF5007
	Offset: 0x1D0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_demonic_rune", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_e581e076
	Checksum: 0xE4CED1F7
	Offset: 0x210
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "demonic_rune_fx", 5000, 1, "int", &function_4a94c040, 0, 0);
	zm_powerups::include_zombie_powerup("demonic_rune_lor");
	zm_powerups::add_zombie_powerup("demonic_rune_lor");
	zm_powerups::include_zombie_powerup("demonic_rune_ulla");
	zm_powerups::add_zombie_powerup("demonic_rune_ulla");
	zm_powerups::include_zombie_powerup("demonic_rune_oth");
	zm_powerups::add_zombie_powerup("demonic_rune_oth");
	zm_powerups::include_zombie_powerup("demonic_rune_zor");
	zm_powerups::add_zombie_powerup("demonic_rune_zor");
	zm_powerups::include_zombie_powerup("demonic_rune_mar");
	zm_powerups::add_zombie_powerup("demonic_rune_mar");
	zm_powerups::include_zombie_powerup("demonic_rune_uja");
	zm_powerups::add_zombie_powerup("demonic_rune_uja");
}

/*
	Name: function_4a94c040
	Namespace: namespace_e581e076
	Checksum: 0x50A77DED
	Offset: 0x388
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_4a94c040(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		PlayFXOnTag(localClientNum, "dlc1/castle/fx_demon_gate_rune_glow", self, "tag_origin");
	}
}

