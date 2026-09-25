#using scripts\codescripts\struct;
#using scripts\shared\math_shared;
#using scripts\zm\_zm_stats;
#using scripts\zm\gametypes\_zm_gametype;

#namespace ZCLASSIC;

/*
	Name: main
	Namespace: ZCLASSIC
	Checksum: 0xC3EB8D6B
	Offset: 0x110
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function main()
{
	zm_gametype::main();
	level.onPrecacheGameType = &onPrecacheGameType;
	level.onStartGameType = &onStartGameType;
	level._game_module_custom_spawn_init_func = &zm_gametype::custom_spawn_init_func;
	level._game_module_stat_update_func = &zm_stats::survival_classic_custom_stat_update;
}

/*
	Name: onPrecacheGameType
	Namespace: ZCLASSIC
	Checksum: 0xEC319984
	Offset: 0x190
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function onPrecacheGameType()
{
	level.playerSuicideAllowed = 1;
	level.canPlayerSuicide = &zm_gametype::canPlayerSuicide;
}

/*
	Name: onStartGameType
	Namespace: ZCLASSIC
	Checksum: 0xE1C16F5E
	Offset: 0x1C0
	Size: 0x153
	Parameters: 0
	Flags: None
*/
function onStartGameType()
{
	level.spawnMins = (0, 0, 0);
	level.spawnMaxs = (0, 0, 0);
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		level.spawnMins = math::expand_mins(level.spawnMins, struct.origin);
		level.spawnMaxs = math::expand_maxs(level.spawnMaxs, struct.origin);
	}
	level.mapCenter = math::find_box_center(level.spawnMins, level.spawnMaxs);
	setMapCenter(level.mapCenter);
}

