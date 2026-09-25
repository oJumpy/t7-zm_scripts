#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_bot;

/*
	Name: __init__sytem__
	Namespace: zm_bot
	Checksum: 0xE8A73F01
	Offset: 0x1F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bot
	Checksum: 0xD54B1689
	Offset: 0x238
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	/#
		println("Dev Block strings are not supported");
	#/
	/#
		level.onBotSpawned = &on_bot_spawned;
		level.var_93a32db5 = &bot_combat::get_ai_threats;
		level.botPreCombat = &bot::coop_pre_combat;
		level.botPostCombat = &bot::coop_post_combat;
		level.botIdle = &bot::follow_coop_players;
		level.botDevguiCmd = &bot::coop_bot_devgui_cmd;
		thread function_6e62d3e3();
	#/
}

/*
	Name: function_6e62d3e3
	Namespace: zm_bot
	Checksum: 0xB1F46EEA
	Offset: 0x308
	Size: 0x1E7
	Parameters: 0
	Flags: None
*/
function function_6e62d3e3()
{
	/#
		botCount = 0;
		AddDebugCommand("Dev Block strings are not supported");
		while(1)
		{
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				while(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					if(botCount > 0 && RandomInt(100) > 60)
					{
						AddDebugCommand("Dev Block strings are not supported");
						botCount--;
						function_aacf4c41("Dev Block strings are not supported" + botCount);
					}
					else if(botCount < GetDvarInt("Dev Block strings are not supported") && RandomInt(100) > 50)
					{
						AddDebugCommand("Dev Block strings are not supported");
						botCount++;
						function_aacf4c41("Dev Block strings are not supported" + botCount);
					}
					wait(randomIntRange(1, 3));
				}
				break;
			}
			while(botCount > 0)
			{
				AddDebugCommand("Dev Block strings are not supported");
				botCount--;
				function_aacf4c41("Dev Block strings are not supported" + botCount);
				wait(1);
			}
			wait(1);
		}
	#/
}

/*
	Name: on_bot_spawned
	Namespace: zm_bot
	Checksum: 0x18071DF4
	Offset: 0x4F8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function on_bot_spawned()
{
	/#
		host = bot::get_host_player();
		loadout = host zm_weapons::player_get_loadout();
		self zm_weapons::player_give_loadout(loadout);
	#/
}

/*
	Name: function_aacf4c41
	Namespace: zm_bot
	Checksum: 0x95D1E69
	Offset: 0x568
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_aacf4c41(var_69ae6753)
{
	/#
		IPrintLnBold(var_69ae6753);
		if(isdefined(level.name))
		{
			println("Dev Block strings are not supported" + level.name + "Dev Block strings are not supported" + var_69ae6753);
		}
	#/
}

