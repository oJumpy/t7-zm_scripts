#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_4a25f1d2;

/*
	Name: __init__sytem__
	Namespace: namespace_4a25f1d2
	Checksum: 0x36DE24E4
	Offset: 0x170
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_board_to_death", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_4a25f1d2
	Checksum: 0xAD1708BC
	Offset: 0x1B0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_board_to_death", "time", 300, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: namespace_4a25f1d2
	Checksum: 0x283366A0
	Offset: 0x218
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function enable()
{
	self thread function_3c61f2df();
}

/*
	Name: disable
	Namespace: namespace_4a25f1d2
	Checksum: 0x99EC1590
	Offset: 0x240
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function disable()
{
}

/*
	Name: function_3c61f2df
	Namespace: namespace_4a25f1d2
	Checksum: 0x1C8C7534
	Offset: 0x250
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_3c61f2df()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("hash_994d5e9e");
	while(1)
	{
		self waittill("boarding_window", var_c62a5d83);
		self bgb::do_one_shot_use();
		self thread function_64ea6cea(var_c62a5d83);
	}
}

/*
	Name: function_64ea6cea
	Namespace: namespace_4a25f1d2
	Checksum: 0x21A8FC74
	Offset: 0x2D0
	Size: 0x165
	Parameters: 1
	Flags: None
*/
function function_64ea6cea(var_c62a5d83)
{
	wait(0.3);
	a_ai = GetAITeamArray(level.zombie_team);
	a_closest = ArraySortClosest(a_ai, var_c62a5d83.origin, a_ai.size, 0, 180);
	for(i = 0; i < a_closest.size; i++)
	{
		if(a_closest[i].archetype === "zombie" && isalive(a_closest[i]))
		{
			a_closest[i] DoDamage(a_closest[i].health + 100, a_closest[i].origin);
			a_closest[i] playsound("zmb_bgb_boardtodeath_imp");
			wait(RandomFloatRange(0.05, 0.2));
		}
	}
}

