#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_util;

#namespace namespace_6c640490;

/*
	Name: __init__sytem__
	Namespace: namespace_6c640490
	Checksum: 0x8031D76C
	Offset: 0x3A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_side_ee_distant_monster", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_6c640490
	Checksum: 0x99EC1590
	Offset: 0x3E8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __init__()
{
}

/*
	Name: main
	Namespace: namespace_6c640490
	Checksum: 0xBE0B4F08
	Offset: 0x3F8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function main()
{
	var_53564731 = GetEnt("ee_vista_monster", "targetname");
	level thread function_e94b80b9();
	/#
		level thread function_abe01b4d();
	#/
}

/*
	Name: on_player_spawned
	Namespace: namespace_6c640490
	Checksum: 0x99EC1590
	Offset: 0x460
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
}

/*
	Name: function_e94b80b9
	Namespace: namespace_6c640490
	Checksum: 0xA4956A7D
	Offset: 0x470
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_e94b80b9()
{
	while(level.round_number < 50)
	{
		level waittill("start_of_round");
	}
	var_d95fb733 = 0;
	do
	{
		foreach(player in level.activePlayers)
		{
			if(zm_utility::is_player_valid(player) && player HasWeapon(level.var_c003f5b, 1))
			{
				var_d95fb733 = 1;
			}
		}
		wait(2);
	}
	while(!(!isdefined(var_d95fb733) && var_d95fb733));
	function_549b07cb();
}

/*
	Name: function_549b07cb
	Namespace: namespace_6c640490
	Checksum: 0x25E29879
	Offset: 0x590
	Size: 0x1D3
	Parameters: 0
	Flags: None
*/
function function_549b07cb()
{
	e_vehicle = vehicle::simple_spawn_single("veh_distant_monster");
	e_vehicle Hide();
	nd_start = GetVehicleNode(e_vehicle.target, "targetname");
	e_vehicle AttachPath(nd_start);
	var_53564731 = GetEnt("ee_vista_monster", "targetname");
	var_53564731 SetForceNoCull();
	var_53564731.origin = e_vehicle.origin;
	var_53564731.angles = e_vehicle.angles;
	var_53564731 LinkTo(e_vehicle);
	e_vehicle SetSpeed(5, 100);
	e_vehicle StartPath();
	var_53564731 playsound("zmb_distant_monster_mash");
	e_vehicle waittill("reached_end_node");
	e_vehicle.delete_on_death = 1;
	e_vehicle notify("death");
	if(!isalive(e_vehicle))
	{
		e_vehicle delete();
	}
}

/*
	Name: function_abe01b4d
	Namespace: namespace_6c640490
	Checksum: 0xEF872461
	Offset: 0x770
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_abe01b4d()
{
	/#
		zm_devgui::function_4acecab5(&function_603ad7e1);
		level.var_7b18dfab = 0;
		AddDebugCommand("Dev Block strings are not supported");
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_603ad7e1
	Namespace: namespace_6c640490
	Checksum: 0xBF55FBE2
	Offset: 0x7E8
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function function_603ad7e1(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				function_549b07cb();
				return 1;
			}
			case "Dev Block strings are not supported":
			{
				level.var_7b18dfab = !level.var_7b18dfab;
				return 1;
			}
		}
		return 0;
	#/
}

