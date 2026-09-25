#using scripts\shared\array_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace debug;

/*
	Name: __init__sytem__
	Namespace: debug
	Checksum: 0x7638E90
	Offset: 0xD0
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
	Namespace: debug
	Checksum: 0x6E21C650
	Offset: 0x110
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		thread function_95733a17();
	#/
}

/*
	Name: function_95733a17
	Namespace: debug
	Checksum: 0xAD4BB121
	Offset: 0x138
	Size: 0x249
	Parameters: 0
	Flags: None
*/
function function_95733a17()
{
	/#
		var_4451d280 = 0;
		var_9db4638d = (0, 0, 0);
		var_5f25229a = 1;
		while(1)
		{
			var_4451d280 = GetDvarFloat("Dev Block strings are not supported", 0);
			while(var_4451d280 >= 1)
			{
				players = GetPlayers();
				if(isdefined(players[0]))
				{
					var_4451d280 = GetDvarFloat("Dev Block strings are not supported", 0);
					circle(players[0].origin, var_4451d280, (1, 0, 0), 0, 1, 16);
					var_5f25229a = sqrt(var_4451d280 * 2.5) / 2;
					vForward = AnglesToForward(players[0].angles);
					var_9db4638d = players[0].origin + vForward * var_4451d280;
					sides = Int(10 * 1 + Int(var_5f25229a) % 100);
					sphere(var_9db4638d, var_5f25229a, (1, 0, 0), 1, 1, sides, 16);
					print3d(var_9db4638d + VectorScale((0, 0, 1), 20), var_4451d280, (1, 0, 0), 1, var_5f25229a / 14, 16);
				}
				wait(0.05);
			}
			wait(1);
		}
	#/
}

