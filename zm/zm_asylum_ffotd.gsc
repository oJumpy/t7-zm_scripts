#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace namespace_1e5daa72;

/*
	Name: main_start
	Namespace: namespace_1e5daa72
	Checksum: 0x99EC1590
	Offset: 0x1F8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function main_start()
{
}

/*
	Name: main_end
	Namespace: namespace_1e5daa72
	Checksum: 0x73C5CE6D
	Offset: 0x208
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function main_end()
{
	spawncollision("collision_player_wall_64x64x10", "collider", (1256, 355.5, 197), VectorScale((0, 1, 0), 270));
}

