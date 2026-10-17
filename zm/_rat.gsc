#using scripts\shared\array_shared;
#using scripts\shared\rat_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;

#namespace rat;

/*
	Name: __init__sytem__
	Namespace: rat
	Checksum: 0x1F2990B3
	Offset: 0x100
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("Dev Block strings are not supported", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: rat
	Checksum: 0x7B1372C7
	Offset: 0x140
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		rat_shared::init();
		level.rat.common.getHostPlayer = &util::getHostPlayer;
		rat_shared::addratscriptcmd("Dev Block strings are not supported", &derriesezombiespawnnavmeshtest);
	#/
}

/*
	Name: derriesezombiespawnnavmeshtest
	Namespace: rat
	Checksum: 0x4E9D15A5
	Offset: 0x1B8
	Size: 0x513
	Parameters: 2
	Flags: None
*/
function derriesezombiespawnnavmeshtest(params, inrat)
{
	/#
		if(!isdefined(inrat))
		{
			inrat = 1;
		}
		if(inrat)
		{
			wait(10);
		}
		enemy = zm_devgui::devgui_zombie_spawn();
		enemy.is_rat_test = 1;
		failed_spawn_origin = [];
		failed_node_origin = [];
		failed_attack_spot_spawn_origin = [];
		failed_attack_spot = [];
		SIZE = 0;
		failed_attack_spot_size = 0;
		wait(0.2);
		foreach(zone in level.zones)
		{
			foreach(loc in zone.a_loc_types["Dev Block strings are not supported"])
			{
				angles = (0, 0, 0);
				enemy ForceTeleport(loc.origin, angles);
				wait(0.2);
				node = undefined;
				for(j = 0; j < level.exterior_goals.size; j++)
				{
					if(isdefined(level.exterior_goals[j].script_string) && level.exterior_goals[j].script_string == loc.script_string)
					{
						node = level.exterior_goals[j];
					}
				}
				if(isdefined(node))
				{
					ispath = enemy SetGoal(node.origin);
					if(!ispath)
					{
						failed_spawn_origin[SIZE] = loc.origin;
						failed_node_origin[SIZE] = node.origin;
						SIZE++;
					}
					wait(0.2);
					for(j = 0; j < node.attack_spots.size; j++)
					{
						isattackpath = enemy SetGoal(node.attack_spots[j]);
						if(!isattackpath)
						{
							failed_attack_spot_spawn_origin[failed_attack_spot_size] = loc.origin;
							failed_attack_spot[failed_attack_spot_size] = node.attack_spots[j];
							failed_attack_spot_size++;
						}
						wait(0.2);
					}
				}
			}
		}
		if(inrat)
		{
			errmsg = "Dev Block strings are not supported";
			for(i = 0; i < SIZE; i++)
			{
				errmsg = errmsg + "Dev Block strings are not supported" + failed_spawn_origin[i] + "Dev Block strings are not supported" + failed_node_origin[i] + "Dev Block strings are not supported";
			}
			for(i = 0; i < failed_attack_spot_size; i++)
			{
				errmsg = errmsg + "Dev Block strings are not supported" + failed_attack_spot_spawn_origin[i] + "Dev Block strings are not supported" + failed_attack_spot[i] + "Dev Block strings are not supported";
			}
			if(SIZE > 0 || failed_attack_spot_size > 0)
			{
				ratreportcommandresult(params._id, 0, errmsg);
			}
			else
			{
				ratreportcommandresult(params._id, 1);
			}
		}
	#/
}

