#using scripts\codescripts\struct;
#using scripts\shared\system_shared;

#namespace global_fx;

/*
	Name: __init__sytem__
	Namespace: global_fx
	Checksum: 0x3DA3D744
	Offset: 0x138
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("global_fx", &__init__, &main, undefined);
}

/*
	Name: __init__
	Namespace: global_fx
	Checksum: 0x87812E0B
	Offset: 0x180
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __init__()
{
	wind_initial_setting();
}

/*
	Name: main
	Namespace: global_fx
	Checksum: 0x4C072555
	Offset: 0x1A0
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function main()
{
	check_for_wind_override();
}

/*
	Name: wind_initial_setting
	Namespace: global_fx
	Checksum: 0x6795A472
	Offset: 0x1C0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function wind_initial_setting()
{
	SetSavedDvar("enable_global_wind", 0);
	SetSavedDvar("wind_global_vector", "0 0 0");
	SetSavedDvar("wind_global_low_altitude", 0);
	SetSavedDvar("wind_global_hi_altitude", 10000);
	SetSavedDvar("wind_global_low_strength_percent", 0.5);
}

/*
	Name: check_for_wind_override
	Namespace: global_fx
	Checksum: 0xEDBEFB1E
	Offset: 0x260
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function check_for_wind_override()
{
	if(isdefined(level.custom_wind_callback))
	{
		level thread [[level.custom_wind_callback]]();
	}
}

