#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;

#namespace bgb_token;

/*
	Name: __init__sytem__
	Namespace: bgb_token
	Checksum: 0xE9DC99BF
	Offset: 0x200
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bgb_token", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: bgb_token
	Checksum: 0x52543F79
	Offset: 0x248
	Size: 0x3B
	Parameters: 0
	Flags: Private
*/
function private __init__()
{
	if(!function_4922937f())
	{
		return;
	}
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: __main__
	Namespace: bgb_token
	Checksum: 0xC773B658
	Offset: 0x290
	Size: 0xFB
	Parameters: 0
	Flags: Private
*/
function private __main__()
{
	if(!function_4922937f())
	{
		return;
	}
	if(!isdefined(level.var_a73c4888))
	{
		level.var_a73c4888 = -1;
	}
	if(!isdefined(level.var_baa8fd09))
	{
		level.var_baa8fd09 = 3600;
	}
	if(!isdefined(level.var_342aa5b2))
	{
		level.var_342aa5b2 = 0.33;
	}
	if(!isdefined(level.var_4d1d42c7))
	{
		level.var_4d1d42c7 = 5;
	}
	if(!isdefined(level.var_5f0752c5))
	{
		level.var_5f0752c5 = 1000;
	}
	if(!isdefined(level.var_af87760a))
	{
		level.var_af87760a = 0.33;
	}
	if(!isdefined(level.var_bc978de9))
	{
		level.var_bc978de9 = 8;
	}
	if(!isdefined(level.var_c50e9bdb))
	{
		level.var_c50e9bdb = 9;
	}
	/#
		level thread setup_devgui();
	#/
}

/*
	Name: on_player_spawned
	Namespace: bgb_token
	Checksum: 0xC86CD741
	Offset: 0x398
	Size: 0x5F
	Parameters: 0
	Flags: Private
*/
function private on_player_spawned()
{
	if(!isdefined(self.var_27b6cdab))
	{
		self.var_27b6cdab = self zm_stats::get_global_stat("BGB_TOKEN_LAST_GIVEN_TIME");
		self.var_f191a1fc = 0;
		self.var_bc978de9 = level.var_bc978de9 + level.round_number - 1;
	}
}

/*
	Name: function_4922937f
	Namespace: bgb_token
	Checksum: 0xDED9743F
	Offset: 0x400
	Size: 0x65
	Parameters: 0
	Flags: Private
*/
function private function_4922937f()
{
	if(!isdefined(level.bgb_in_use) && level.bgb_in_use || !level.onlineGame || !GetDvarInt("loot_enabled"))
	{
		return 0;
	}
	if(function_77110410())
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_c2f81136
	Namespace: bgb_token
	Checksum: 0xE77678E5
	Offset: 0x470
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function function_c2f81136(increment)
{
	if(!function_4922937f())
	{
		return;
	}
	foreach(player in level.players)
	{
		if(isdefined(player.var_bc978de9))
		{
			player.var_bc978de9 = player.var_bc978de9 + increment;
		}
	}
}

/*
	Name: setup_devgui
	Namespace: bgb_token
	Checksum: 0x519B1518
	Offset: 0x540
	Size: 0x8B
	Parameters: 0
	Flags: Private
*/
function private setup_devgui()
{
	/#
		waittillframeend;
		SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
		var_33b4e7c1 = "Dev Block strings are not supported";
		AddDebugCommand(var_33b4e7c1 + "Dev Block strings are not supported" + "Dev Block strings are not supported" + "Dev Block strings are not supported");
		level thread function_a29384f8();
	#/
}

/*
	Name: function_a29384f8
	Namespace: bgb_token
	Checksum: 0xD305B917
	Offset: 0x5D8
	Size: 0x87
	Parameters: 0
	Flags: Private
*/
function private function_a29384f8()
{
	/#
		for(;;)
		{
			var_2e29895e = GetDvarString("Dev Block strings are not supported");
			if(var_2e29895e != "Dev Block strings are not supported")
			{
				level.players[0] function_32692a60();
			}
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(0.5);
		}
	#/
}

/*
	Name: function_32692a60
	Namespace: bgb_token
	Checksum: 0xA9E07ABA
	Offset: 0x668
	Size: 0x12B
	Parameters: 0
	Flags: Private
*/
function private function_32692a60()
{
	var_90491adb = Int(self function_5d823f3c());
	for(count = 0; count < var_90491adb; count++)
	{
		self function_6ed2bf5();
	}
	self.var_f191a1fc = self.var_f191a1fc + var_90491adb;
	self.var_bc978de9 = self.var_bc978de9 + level.var_c50e9bdb;
	self.var_27b6cdab = self zm_stats::get_global_stat("TIME_PLAYED_TOTAL");
	self zm_stats::set_global_stat("BGB_TOKEN_LAST_GIVEN_TIME", self.var_27b6cdab);
	UploadStats(self);
	self function_fac43b6c("3", var_90491adb);
}

/*
	Name: function_2d75b98d
	Namespace: bgb_token
	Checksum: 0xFB292A0
	Offset: 0x7A0
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private function_2d75b98d(var_ce9d31c4)
{
	if(RandomFloat(1) < var_ce9d31c4)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_51cf4361
	Namespace: bgb_token
	Checksum: 0x9FEF18D2
	Offset: 0x7E0
	Size: 0x1EB
	Parameters: 1
	Flags: None
*/
function function_51cf4361(var_5561679e)
{
	if(!function_4922937f())
	{
		return;
	}
	if(0 <= level.var_a73c4888 && self.var_f191a1fc >= level.var_a73c4888)
	{
		return;
	}
	var_6865f10f = self zm_stats::get_global_stat("TIME_PLAYED_TOTAL");
	if(var_6865f10f - level.var_baa8fd09 > self.var_27b6cdab)
	{
		if(function_2d75b98d(level.var_342aa5b2))
		{
			self function_32692a60();
		}
		return;
	}
	if(level.round_number < level.var_4d1d42c7)
	{
		return;
	}
	var_95d14cf5 = math::clamp(var_5561679e, 0, level.var_5f0752c5);
	var_741485e6 = float(var_95d14cf5) / level.var_5f0752c5;
	if(!function_2d75b98d(var_741485e6 * level.var_af87760a))
	{
		return;
	}
	var_edfe0eb4 = self.var_bc978de9 - level.round_number;
	if(1 > var_edfe0eb4)
	{
		var_edfe0eb4 = 1;
	}
	var_b8a1486b = float(var_edfe0eb4 * var_edfe0eb4);
	if(!function_2d75b98d(1 / var_b8a1486b))
	{
		return;
	}
	self function_32692a60();
}

