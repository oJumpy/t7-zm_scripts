#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_game_module;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\gametypes\_zm_gametype;

#namespace namespace_a026fc99;

/*
	Name: Precache
	Namespace: namespace_a026fc99
	Checksum: 0x99EC1590
	Offset: 0x1B8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function Precache()
{
}

/*
	Name: main
	Namespace: namespace_a026fc99
	Checksum: 0xC5F36992
	Offset: 0x1C8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function main()
{
	level flag::wait_till("initial_blackscreen_passed");
	level flag::set("power_on");
	zm_treasure_chest_init();
}

/*
	Name: zm_treasure_chest_init
	Namespace: namespace_a026fc99
	Checksum: 0x6B5EF0A4
	Offset: 0x228
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function zm_treasure_chest_init()
{
	chest1 = struct::get("start_chest", "script_noteworthy");
	level.chests = [];
	if(!isdefined(level.chests))
	{
		level.chests = [];
	}
	else if(!IsArray(level.chests))
	{
		level.chests = Array(level.chests);
	}
	level.chests[level.chests.size] = chest1;
	zm_magicbox::treasure_chest_init("start_chest");
}

