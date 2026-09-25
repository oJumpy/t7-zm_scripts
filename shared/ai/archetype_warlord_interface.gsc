#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\warlord;

#namespace WarlordInterface;

/*
	Name: RegisterWarlordInterfaceAttributes
	Namespace: WarlordInterface
	Checksum: 0xB93C4B1A
	Offset: 0xE8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function RegisterWarlordInterfaceAttributes()
{
	ai::RegisterMatchedInterface("warlord", "can_be_meleed", 0, Array(1, 0));
}

/*
	Name: AddPreferedPoint
	Namespace: WarlordInterface
	Checksum: 0x8EA2474C
	Offset: 0x130
	Size: 0x4B
	Parameters: 4
	Flags: None
*/
function AddPreferedPoint(position, min_duration, max_duration, name)
{
	WarlordServerUtils::AddPreferedPoint(self, position, min_duration, max_duration, name);
}

/*
	Name: DeletePreferedPoint
	Namespace: WarlordInterface
	Checksum: 0x3C9366C3
	Offset: 0x188
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function DeletePreferedPoint(name)
{
	WarlordServerUtils::DeletePreferedPoint(self, name);
}

/*
	Name: ClearAllPreferedPoints
	Namespace: WarlordInterface
	Checksum: 0x195BB928
	Offset: 0x1B8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function ClearAllPreferedPoints()
{
	WarlordServerUtils::ClearAllPreferedPoints(self);
}

/*
	Name: ClearPreferedPointsOutsideGoal
	Namespace: WarlordInterface
	Checksum: 0x1BE4A021
	Offset: 0x1E0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function ClearPreferedPointsOutsideGoal()
{
	WarlordServerUtils::ClearPreferedPointsOutsideGoal(self);
}

/*
	Name: SetWarlordAggressiveMode
	Namespace: WarlordInterface
	Checksum: 0xF5A33898
	Offset: 0x208
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function SetWarlordAggressiveMode(b_aggressive_mode)
{
	WarlordServerUtils::SetWarlordAggressiveMode(self);
}

