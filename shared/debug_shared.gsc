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
		thread debug_draw_tuning_sphere();
	#/
}

/*
	Name: debug_draw_tuning_sphere
	Namespace: debug
	Checksum: 0xAD4BB121
	Offset: 0x138
	Size: 0x249
	Parameters: 0
	Flags: None
*/
function debug_draw_tuning_sphere()
{
	/#
		n_sphere_radius = 0;
		v_text_position = (0, 0, 0);
		n_text_scale = 1;
		while(1)
		{
			n_sphere_radius = GetDvarFloat("Dev Block strings are not supported", 0);
			while(n_sphere_radius >= 1)
			{
				players = GetPlayers();
				if(isdefined(players[0]))
				{
					n_sphere_radius = GetDvarFloat("Dev Block strings are not supported", 0);
					circle(players[0].origin, n_sphere_radius, (1, 0, 0), 0, 1, 16);
					n_text_scale = sqrt(n_sphere_radius * 2.5) / 2;
					vForward = AnglesToForward(players[0].angles);
					v_text_position = players[0].origin + vForward * n_sphere_radius;
					sides = Int(10 * 1 + Int(n_text_scale) % 100);
					sphere(v_text_position, n_text_scale, (1, 0, 0), 1, 1, sides, 16);
					print3d(v_text_position + VectorScale((0, 0, 1), 20), n_sphere_radius, (1, 0, 0), 1, n_text_scale / 14, 16);
				}
				wait(0.05);
			}
			wait(1);
		}
	#/
}

