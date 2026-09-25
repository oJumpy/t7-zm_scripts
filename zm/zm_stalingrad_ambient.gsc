#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_c71bfefb;

/*
	Name: __init__sytem__
	Namespace: namespace_c71bfefb
	Checksum: 0x5D309F37
	Offset: 0x298
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_ambient", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_c71bfefb
	Checksum: 0xD151ED8E
	Offset: 0x2E0
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level flag::init("ambient_mortar_fire_on");
	clientfield::register("scriptmover", "ambient_mortar_strike", 12000, 2, "int");
	clientfield::register("scriptmover", "ambient_artillery_strike", 12000, 2, "int");
	clientfield::register("world", "power_on_level", 12000, 1, "int");
	level thread function_8c898920();
}

/*
	Name: __main__
	Namespace: namespace_c71bfefb
	Checksum: 0x45CE0EF6
	Offset: 0x3B8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level thread wait_for_power();
}

/*
	Name: function_46a16b31
	Namespace: namespace_c71bfefb
	Checksum: 0xB4CB2B8F
	Offset: 0x3E0
	Size: 0x1FD
	Parameters: 0
	Flags: None
*/
function function_46a16b31()
{
	level.var_10752e7a = [];
	var_10752e7a = struct::get_array("ambient_mortar", "targetname");
	foreach(var_b058183b in var_10752e7a)
	{
		str_location = var_b058183b.script_string;
		if(!isdefined(level.var_10752e7a[str_location]))
		{
			level.var_10752e7a[str_location] = [];
		}
		if(!isdefined(level.var_10752e7a[str_location]))
		{
			level.var_10752e7a[str_location] = [];
		}
		else if(!IsArray(level.var_10752e7a[str_location]))
		{
			level.var_10752e7a[str_location] = Array(level.var_10752e7a[str_location]);
		}
		level.var_10752e7a[str_location][level.var_10752e7a[str_location].size] = var_b058183b;
	}
	level.var_2b8ea588 = [];
	for(i = 0; i < 6; i++)
	{
		level.var_2b8ea588[i] = util::spawn_model("tag_origin", (0, 0, 0));
		level.var_2b8ea588[i].var_1dcdd471 = 0;
	}
}

/*
	Name: function_8c898920
	Namespace: namespace_c71bfefb
	Checksum: 0xD6ED29EC
	Offset: 0x5E8
	Size: 0x347
	Parameters: 0
	Flags: None
*/
function function_8c898920()
{
	level flag::wait_till("all_players_spawned");
	if(GetDvarInt("splitscreen_playerCount") >= 2)
	{
		return;
	}
	level flag::set("ambient_mortar_fire_on");
	function_46a16b31();
	wait(RandomFloatRange(20, 30));
	while(1)
	{
		if(!level flag::get("ambient_mortar_fire_on"))
		{
			level flag::wait_till("ambient_mortar_fire_on");
		}
		do
		{
			var_165e92cc = Array::random(level.activePlayers);
			str_zone = var_165e92cc zm_zonemgr::get_player_zone();
			if(isdefined(str_zone))
			{
				var_32db8f92 = StrTok(str_zone, "_");
				str_zone = var_32db8f92[0];
				if(str_zone == "powered")
				{
					if(var_32db8f92[2] == "A")
					{
						str_zone = "red";
					}
					else
					{
						str_zone = "yellow";
					}
				}
			}
			wait(0.05);
		}
		while(!(!isdefined(str_zone) || !isdefined(level.var_10752e7a[str_zone])));
		if(str_zone == "pavlovs" || str_zone == "alley")
		{
			var_e3975fbf = 1;
		}
		else
		{
			var_e3975fbf = 0;
		}
		var_89d001a3 = randomIntRange(10, 15);
		for(i = 0; i < var_89d001a3; i++)
		{
			var_620fe12a = function_7af373ba(str_zone);
			if(isdefined(var_620fe12a))
			{
				var_620fe12a thread function_8affee60(var_e3975fbf);
			}
			wait(RandomFloatRange(0.5, 1.5));
		}
		if(!flag::get("nikolai_start") || (flag::get("nikolai_start") && flag::get("nikolai_complete")))
		{
			level function_20bdb71();
		}
		wait(RandomFloatRange(45, 60));
	}
}

/*
	Name: function_20bdb71
	Namespace: namespace_c71bfefb
	Checksum: 0xB1812FCE
	Offset: 0x938
	Size: 0x41
	Parameters: 0
	Flags: None
*/
function function_20bdb71()
{
	level endon("hash_cb701c27");
	for(i = 0; i < 2; i++)
	{
		level waittill("start_of_round");
	}
}

/*
	Name: function_7af373ba
	Namespace: namespace_c71bfefb
	Checksum: 0xE2D1A99F
	Offset: 0x988
	Size: 0x16B
	Parameters: 1
	Flags: None
*/
function function_7af373ba(str_zone)
{
	var_b8f2d177 = [];
	var_d8f8470c = ArrayCopy(level.var_10752e7a[str_zone]);
	b_all_points_used = 0;
	while(!var_b8f2d177.size)
	{
		foreach(var_b058183b in var_d8f8470c)
		{
			if(!isdefined(var_b058183b.var_afe3e55f) || b_all_points_used)
			{
				var_b058183b.var_afe3e55f = 0;
			}
			if(!var_b058183b.var_afe3e55f)
			{
				Array::add(var_b8f2d177, var_b058183b, 0);
			}
		}
		if(!var_b8f2d177.size)
		{
			b_all_points_used = 1;
		}
		wait(0.05);
	}
	var_b058183b = Array::random(var_b8f2d177);
	return var_b058183b;
}

/*
	Name: function_8affee60
	Namespace: namespace_c71bfefb
	Checksum: 0x3B6A51C1
	Offset: 0xB00
	Size: 0x15F
	Parameters: 1
	Flags: None
*/
function function_8affee60(var_e3975fbf)
{
	i = 0;
	while(level.var_2b8ea588[i].var_1dcdd471 == 1)
	{
		i++;
		if(i == level.var_2b8ea588.size)
		{
			i = 0;
			wait(0.05);
		}
	}
	level.var_2b8ea588[i].origin = self.origin;
	level.var_2b8ea588[i].var_1dcdd471 = 1;
	if(var_e3975fbf)
	{
		var_efccacc4 = "ambient_mortar_strike";
	}
	else
	{
		var_efccacc4 = "ambient_artillery_strike";
	}
	var_23919be6 = self.script_int + 1;
	level.var_2b8ea588[i] clientfield::set(var_efccacc4, var_23919be6);
	wait(3);
	level.var_2b8ea588[i] clientfield::set(var_efccacc4, 0);
	level.var_2b8ea588[i].var_1dcdd471 = 0;
}

/*
	Name: wait_for_power
	Namespace: namespace_c71bfefb
	Checksum: 0x57B82CD3
	Offset: 0xC68
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function wait_for_power()
{
	level flag::wait_till("power_on");
	level clientfield::set("power_on_level", 1);
}

