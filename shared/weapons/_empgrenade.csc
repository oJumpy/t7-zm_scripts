#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_flashgrenades;

#namespace empgrenade;

/*
	Name: __init__sytem__
	Namespace: empgrenade
	Checksum: 0xB225A7F3
	Offset: 0x2F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("empgrenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: empgrenade
	Checksum: 0x6AF1CE46
	Offset: 0x338
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "empd", 1, 1, "int", &onEmpChanged, 0, 1);
	clientfield::register("toplayer", "empd_monitor_distance", 1, 1, "int", &onEmpMonitorDistanceChanged, 0, 0);
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: onEmpChanged
	Namespace: empgrenade
	Checksum: 0x49592E32
	Offset: 0x3F8
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function onEmpChanged(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	localPlayer = GetLocalPlayer(localClientNum);
	if(newVal == 1)
	{
		self StartEmpEffects(localPlayer);
	}
	else
	{
		already_distance_monitored = localPlayer clientfield::get_to_player("empd_monitor_distance") == 1;
		if(!already_distance_monitored)
		{
			self StopEmpEffects(localPlayer, oldVal);
		}
	}
}

/*
	Name: StartEmpEffects
	Namespace: empgrenade
	Checksum: 0xC136734F
	Offset: 0x4E0
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function StartEmpEffects(localPlayer, bWasTimeJump)
{
	if(!isdefined(bWasTimeJump))
	{
		bWasTimeJump = 0;
	}
	filter::init_filter_tactical(localPlayer);
	filter::enable_filter_tactical(localPlayer, 2);
	filter::set_filter_tactical_amount(localPlayer, 2, 1);
	if(!bWasTimeJump)
	{
		playsound(0, "mpl_plr_emp_activate", (0, 0, 0));
	}
	audio::playloopat("mpl_plr_emp_looper", (0, 0, 0));
}

/*
	Name: StopEmpEffects
	Namespace: empgrenade
	Checksum: 0x62D0955
	Offset: 0x5A8
	Size: 0xB3
	Parameters: 3
	Flags: None
*/
function StopEmpEffects(localPlayer, oldVal, bWasTimeJump)
{
	if(!isdefined(bWasTimeJump))
	{
		bWasTimeJump = 0;
	}
	filter::init_filter_tactical(localPlayer);
	filter::disable_filter_tactical(localPlayer, 2);
	if(oldVal != 0 && !bWasTimeJump)
	{
		playsound(0, "mpl_plr_emp_deactivate", (0, 0, 0));
	}
	audio::stoploopat("mpl_plr_emp_looper", (0, 0, 0));
}

/*
	Name: on_player_spawned
	Namespace: empgrenade
	Checksum: 0x8BBCB603
	Offset: 0x668
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function on_player_spawned(localClientNum)
{
	self endon("disconnect");
	localPlayer = GetLocalPlayer(localClientNum);
	if(localPlayer != self)
	{
		return;
	}
	curVal = localPlayer clientfield::get_to_player("empd_monitor_distance");
	inKillCam = GetInKillcam(localClientNum);
	if(curVal > 0 && localPlayer IsEmpJammed())
	{
		StartEmpEffects(localPlayer, inKillCam);
		localPlayer MonitorDistance(localClientNum);
	}
	else
	{
		StopEmpEffects(localPlayer, 0, 1);
		localPlayer notify("end_emp_monitor_distance");
	}
}

/*
	Name: onEmpMonitorDistanceChanged
	Namespace: empgrenade
	Checksum: 0x53C80090
	Offset: 0x790
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function onEmpMonitorDistanceChanged(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	localPlayer = GetLocalPlayer(localClientNum);
	if(newVal == 1)
	{
		StartEmpEffects(localPlayer, bWasTimeJump);
		localPlayer MonitorDistance(localClientNum);
	}
	else
	{
		StopEmpEffects(localPlayer, oldVal, bWasTimeJump);
		localPlayer notify("end_emp_monitor_distance");
	}
}

/*
	Name: MonitorDistance
	Namespace: empgrenade
	Checksum: 0xFC778972
	Offset: 0x870
	Size: 0x2E7
	Parameters: 1
	Flags: None
*/
function MonitorDistance(localClientNum)
{
	localPlayer = self;
	localPlayer endon("entityshutdown");
	localPlayer endon("end_emp_monitor_distance");
	localPlayer endon("team_changed");
	if(localPlayer IsEmpJammed() == 0)
	{
		return;
	}
	distance_to_closest_enemy_emp_ui_model = GetUIModel(GetUIModelForController(localClientNum), "distanceToClosestEnemyEmpKillstreak");
	new_distance = 0;
	max_static_value = GetDvarFloat("ks_emp_fullscreen_maxStaticValue");
	min_static_value = GetDvarFloat("ks_emp_fullscreen_minStaticValue");
	min_radius_max_static = GetDvarFloat("ks_emp_fullscreen_minRadiusMaxStatic");
	max_radius_min_static = GetDvarFloat("ks_emp_fullscreen_maxRadiusMinStatic");
	if(isdefined(distance_to_closest_enemy_emp_ui_model))
	{
		while(1)
		{
			/#
				max_static_value = GetDvarFloat("Dev Block strings are not supported");
				min_static_value = GetDvarFloat("Dev Block strings are not supported");
				min_radius_max_static = GetDvarFloat("Dev Block strings are not supported");
				max_radius_min_static = GetDvarFloat("Dev Block strings are not supported");
			#/
			new_distance = GetUIModelValue(distance_to_closest_enemy_emp_ui_model);
			range = max_radius_min_static - min_radius_max_static;
			if(range <= 0)
			{
			}
			else
			{
			}
			current_static_value = max_static_value - new_distance - min_radius_max_static / range;
			current_static_value = math::clamp(current_static_value, min_static_value, max_static_value);
			emp_grenaded = localPlayer clientfield::get_to_player("empd") == 1;
			if(emp_grenaded && current_static_value < 1)
			{
				current_static_value = 1;
			}
			filter::set_filter_tactical_amount(localPlayer, 2, current_static_value);
			wait(0.1);
		}
	}
}

