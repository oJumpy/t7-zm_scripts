#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_utility;

#namespace namespace_a528e918;

/*
	Name: __init__sytem__
	Namespace: namespace_a528e918
	Checksum: 0x3F5E0D4A
	Offset: 0x178
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_challenges_tomb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_a528e918
	Checksum: 0x5A1A0D0E
	Offset: 0x1B8
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "challenges.challenge_complete_1", 21000, 2, "int", &zm_utility::setInventoryUIModels, 0, 1);
	clientfield::register("toplayer", "challenges.challenge_complete_2", 21000, 2, "int", &zm_utility::setInventoryUIModels, 0, 1);
	clientfield::register("toplayer", "challenges.challenge_complete_3", 21000, 2, "int", &zm_utility::setInventoryUIModels, 0, 1);
	clientfield::register("toplayer", "challenges.challenge_complete_4", 21000, 2, "int", &function_2d46c9fd, 0, 1);
}

/*
	Name: function_2d46c9fd
	Namespace: namespace_a528e918
	Checksum: 0x6D8295F5
	Offset: 0x2E8
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_2d46c9fd(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 2 && IsSpectating(localClientNum))
	{
		return;
	}
	zm_utility::setSharedInventoryUIModels(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump);
}

