#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_ee_lights;

/*
	Name: main
	Namespace: zm_tomb_ee_lights
	Checksum: 0x6AEB2AFB
	Offset: 0x130
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function main()
{
	clientfield::register("world", "light_show", 21000, 2, "int", &choose_light_show, 0, 0);
}

/*
	Name: choose_light_show
	Namespace: zm_tomb_ee_lights
	Checksum: 0x57188C94
	Offset: 0x188
	Size: 0x139
	Parameters: 7
	Flags: None
*/
function choose_light_show(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	switch(newVal)
	{
		case 1:
		{
			level.light_on_color = VectorScale((1, 1, 1), 2);
			level.light_off_color = VectorScale((1, 1, 1), 0.25);
			break;
		}
		case 2:
		{
			level.light_on_color = (2, 0.1, 0.1);
			level.light_off_color = (0.5, 0.1, 0.1);
			break;
		}
		case 3:
		{
			level.light_on_color = (0.1, 2, 0.1);
			level.light_off_color = (0.1, 0.5, 0.1);
			break;
		}
		case default:
		{
			level.light_on_color = undefined;
			level.light_off_color = undefined;
			break;
		}
	}
}

