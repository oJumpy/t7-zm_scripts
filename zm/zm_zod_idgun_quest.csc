#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#namespace zm_zod_idgun_quest;

/*
	Name: __init__sytem__
	Namespace: zm_zod_idgun_quest
	Checksum: 0x826F946
	Offset: 0x188
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_idgun_quest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_idgun_quest
	Checksum: 0x57843B39
	Offset: 0x1C8
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("world", "add_idgun_to_box", 1, 4, "int", &add_idgun_to_box, 0, 0);
	clientfield::register("world", "remove_idgun_from_box", 1, 4, "int", &remove_idgun_from_box, 0, 0);
}

/*
	Name: add_idgun_to_box
	Namespace: zm_zod_idgun_quest
	Checksum: 0x849DB830
	Offset: 0x268
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function add_idgun_to_box(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	weapon_idgun = GetWeapon("idgun" + "_" + newVal);
	AddZombieBoxWeapon(weapon_idgun, weapon_idgun.worldmodel, weapon_idgun.isDualWield);
}

/*
	Name: remove_idgun_from_box
	Namespace: zm_zod_idgun_quest
	Checksum: 0xD392FF6
	Offset: 0x310
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function remove_idgun_from_box(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	weapon_idgun = GetWeapon("idgun" + "_" + newVal);
	removezombieboxweapon(weapon_idgun);
}

