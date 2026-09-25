#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace namespace_66b3c421;

/*
	Name: __init__sytem__
	Namespace: namespace_66b3c421
	Checksum: 0x97F9BE4A
	Offset: 0x1B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_crawl_space", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_66b3c421
	Checksum: 0x83252F4C
	Offset: 0x1F0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_crawl_space", "activated", 5, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: namespace_66b3c421
	Checksum: 0xBB425F2F
	Offset: 0x250
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function activation()
{
	a_ai = GetAIArray();
	for(i = 0; i < a_ai.size; i++)
	{
		if(isdefined(a_ai[i]) && isalive(a_ai[i]) && a_ai[i].archetype === "zombie" && isdefined(a_ai[i].gibdef))
		{
			var_5a3ad5d6 = DistanceSquared(self.origin, a_ai[i].origin);
			if(var_5a3ad5d6 < 360000)
			{
				a_ai[i] zombie_utility::makeZombieCrawler();
			}
		}
	}
}

