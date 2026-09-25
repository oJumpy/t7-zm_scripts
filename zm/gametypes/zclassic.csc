#using scripts\codescripts\struct;

#namespace ZCLASSIC;

/*
	Name: main
	Namespace: ZCLASSIC
	Checksum: 0x300D1F10
	Offset: 0x98
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function main()
{
	level._zombie_gameModePrecache = &onPrecacheGameType;
	level._zombie_gamemodeMain = &onStartGameType;
	/#
		println("Dev Block strings are not supported");
	#/
}

/*
	Name: onPrecacheGameType
	Namespace: ZCLASSIC
	Checksum: 0x9F25CF76
	Offset: 0xF8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function onPrecacheGameType()
{
	/#
		println("Dev Block strings are not supported");
	#/
}

/*
	Name: onStartGameType
	Namespace: ZCLASSIC
	Checksum: 0x3386BC5D
	Offset: 0x128
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function onStartGameType()
{
	/#
		println("Dev Block strings are not supported");
	#/
}

