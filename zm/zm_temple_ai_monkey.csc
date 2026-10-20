#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_temple_ai_monkey;

/*
	Name: __init__sytem__
	Namespace: zm_temple_ai_monkey
	Checksum: 0x3B3BC1D2
	Offset: 0x110
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_temple_ai_monkey", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_temple_ai_monkey
	Checksum: 0x43758031
	Offset: 0x150
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "monkey_ragdoll", 21000, 1, "int", &monkey_ragdoll, 1, 0);
}

/*
	Name: monkey_ragdoll
	Namespace: zm_temple_ai_monkey
	Checksum: 0xF5D19323
	Offset: 0x1A8
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function monkey_ragdoll(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		self suppressragdollselfcollision(1);
	}
}

