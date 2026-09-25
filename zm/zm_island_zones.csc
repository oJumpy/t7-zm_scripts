#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace namespace_9d2fabb6;

/*
	Name: init
	Namespace: namespace_9d2fabb6
	Checksum: 0x3A38C980
	Offset: 0x190
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("scriptmover", "vine_door_play_fx", 9000, 1, "int", &function_e63cb60e, 0, 0);
}

/*
	Name: function_e63cb60e
	Namespace: namespace_9d2fabb6
	Checksum: 0x1E219594
	Offset: 0x1E8
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function function_e63cb60e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, level._effect["door_vine_fx"], self, "tag_fx_origin");
}

/*
	Name: main
	Namespace: namespace_9d2fabb6
	Checksum: 0x99EC1590
	Offset: 0x260
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function main()
{
}

