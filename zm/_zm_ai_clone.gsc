#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_clone;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace namespace_bd8be9f1;

/*
	Name: __init__sytem__
	Namespace: namespace_bd8be9f1
	Checksum: 0x3656668A
	Offset: 0x3A8
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_clone", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_bd8be9f1
	Checksum: 0x82D72A9F
	Offset: 0x3F0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level flag::init("thrasher_round");
	/#
		execdevgui("Dev Block strings are not supported");
		thread function_78933fc2();
	#/
	init();
}

/*
	Name: __main__
	Namespace: namespace_bd8be9f1
	Checksum: 0x5D118D13
	Offset: 0x460
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function __main__()
{
	register_clientfields();
}

/*
	Name: register_clientfields
	Namespace: namespace_bd8be9f1
	Checksum: 0x99EC1590
	Offset: 0x480
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
}

/*
	Name: init
	Namespace: namespace_bd8be9f1
	Checksum: 0xF72A6783
	Offset: 0x490
	Size: 0x13
	Parameters: 0
	Flags: None
*/
function init()
{
	Precache();
}

/*
	Name: Precache
	Namespace: namespace_bd8be9f1
	Checksum: 0x99EC1590
	Offset: 0x4B0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function Precache()
{
}

/*
	Name: function_78933fc2
	Namespace: namespace_bd8be9f1
	Checksum: 0x1A73A026
	Offset: 0x4C0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_78933fc2()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		zm_devgui::function_4acecab5(&function_46924c5);
	#/
}

/*
	Name: function_46924c5
	Namespace: namespace_bd8be9f1
	Checksum: 0x52E3CFD0
	Offset: 0x510
	Size: 0x1E5
	Parameters: 1
	Flags: None
*/
function function_46924c5(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				players = GetPlayers();
				queryResult = PositionQuery_Source_Navigation(players[0].origin, 128, 256, 128, 20);
				if(isdefined(queryResult) && queryResult.data.size > 0)
				{
					clone = SpawnActor("Dev Block strings are not supported", queryResult.data[0].origin, (0, 0, 0), "Dev Block strings are not supported", 1);
					clone CloneServerUtils::clonePlayerLook(clone, players[0], players[0]);
				}
				break;
			}
			case "Dev Block strings are not supported":
			{
				clones = GetAIArchetypeArray("Dev Block strings are not supported");
				if(clones.size > 0)
				{
					foreach(clone in clones)
					{
						clone kill();
					}
				}
				break;
			}
		}
	#/
}

