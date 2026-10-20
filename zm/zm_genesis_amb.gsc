#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_weaponobjects;

#namespace zm_genesis_amb;

/*
	Name: main
	Namespace: zm_genesis_amb
	Checksum: 0x25FAD8DD
	Offset: 0x1D0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function main()
{
	level flag::init("ambient_solar_flares_on");
	level thread function_25b0085d();
}

/*
	Name: function_25b0085d
	Namespace: zm_genesis_amb
	Checksum: 0xDBA4D479
	Offset: 0x218
	Size: 0x237
	Parameters: 0
	Flags: None
*/
function function_25b0085d()
{
	level waittill("start_zombie_round_logic");
	if(GetDvarInt("splitscreen_playerCount") >= 2)
	{
		return;
	}
	level flag::set("ambient_solar_flares_on");
	while(1)
	{
		wait(RandomFloatRange(40, 60));
		var_9a813858 = 0;
		if(!level flag::get("ambient_solar_flares_on"))
		{
			level flag::wait_till("ambient_solar_flares_on");
		}
		do
		{
			str_target_zone = undefined;
			e_player_rand = Array::random(level.activePlayers);
			if(!isdefined(e_player_rand.island_name))
			{
				wait(0.5);
			}
			else
			{
				str_zone = e_player_rand.island_name;
				var_32db8f92 = StrTok(str_zone, "_");
				str_target_zone = var_32db8f92[0];
				if(str_target_zone === "apothicon")
				{
					str_target_zone = undefined;
					wait(0.5);
				}
				else
				{
					wait(0.05);
				}
			}
		}
		while(!!isdefined(str_target_zone));
		if(str_target_zone == "start")
		{
			str_target_zone = "sheffield";
		}
		n_flare = randomIntRange(1, 4);
		var_3f75b0e3 = "lgtexp_solarflare_" + str_target_zone + "_0" + n_flare;
		exploder::exploder_duration(var_3f75b0e3, 4);
	}
}

