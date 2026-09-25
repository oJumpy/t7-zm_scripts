#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\callbacks_shared;
#using scripts\zm\_zm_utility;

#namespace zm_ffotd;

/*
	Name: main_start
	Namespace: zm_ffotd
	Checksum: 0x99EC1590
	Offset: 0x128
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function main_start()
{
}

/*
	Name: main_end
	Namespace: zm_ffotd
	Checksum: 0x7CCBC53E
	Offset: 0x138
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function main_end()
{
	difficulty = 1;
	column = Int(difficulty) + 1;
	zombie_utility::set_zombie_var("zombie_move_speed_multiplier", 4, 0, column);
}

/*
	Name: optimize_for_splitscreen
	Namespace: zm_ffotd
	Checksum: 0xCBCB8C24
	Offset: 0x1A8
	Size: 0x4F
	Parameters: 0
	Flags: None
*/
function optimize_for_splitscreen()
{
	if(!isdefined(level.var_7064bd2e))
	{
		level.var_7064bd2e = 3;
	}
	if(level.var_7064bd2e)
	{
		if(GetDvarInt("splitscreen_playerCount") >= level.var_7064bd2e)
		{
			return 1;
		}
	}
	return 0;
}

