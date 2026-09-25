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
		rat_shared::function_e98bbc2e("Dev Block strings are not supported", &function_1601ebff);
	#/
}

/*
	Name: function_1601ebff
	Namespace: rat
	Checksum: 0x4E9D15A5
	Offset: 0x1B8
	Size: 0x513
	Parameters: 2
	Flags: None
*/
function function_1601ebff(params, var_15472a05)
{
	/#
		if(!isdefined(var_15472a05))
		{
			var_15472a05 = 1;
		}
		if(var_15472a05)
		{
			wait(10);
		}
		enemy = zm_devgui::devgui_zombie_spawn();
		enemy.is_rat_test = 1;
		var_5efb51a3 = [];
		var_37719c46 = [];
		var_836df595 = [];
		var_45d4f9c0 = [];
		SIZE = 0;
		var_a1b9d24c = 0;
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
					var_86c3615c = enemy SetGoal(node.origin);
					if(!var_86c3615c)
					{
						var_5efb51a3[SIZE] = loc.origin;
						var_37719c46[SIZE] = node.origin;
						SIZE++;
					}
					wait(0.2);
					for(j = 0; j < node.attack_spots.size; j++)
					{
						var_ed8c2b54 = enemy SetGoal(node.attack_spots[j]);
						if(!var_ed8c2b54)
						{
							var_836df595[var_a1b9d24c] = loc.origin;
							var_45d4f9c0[var_a1b9d24c] = node.attack_spots[j];
							var_a1b9d24c++;
						}
						wait(0.2);
					}
				}
			}
		}
		if(var_15472a05)
		{
			var_20c24355 = "Dev Block strings are not supported";
			for(i = 0; i < SIZE; i++)
			{
				var_20c24355 = var_20c24355 + "Dev Block strings are not supported" + var_5efb51a3[i] + "Dev Block strings are not supported" + var_37719c46[i] + "Dev Block strings are not supported";
			}
			for(i = 0; i < var_a1b9d24c; i++)
			{
				var_20c24355 = var_20c24355 + "Dev Block strings are not supported" + var_836df595[i] + "Dev Block strings are not supported" + var_45d4f9c0[i] + "Dev Block strings are not supported";
			}
			if(SIZE > 0 || var_a1b9d24c > 0)
			{
				function_6f515a70(params.var_4af46077, 0, var_20c24355);
			}
			else
			{
				function_6f515a70(params.var_4af46077, 1);
			}
		}
	#/
}

