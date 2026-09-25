#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_c63a0940;

/*
	Name: __init__sytem__
	Namespace: namespace_c63a0940
	Checksum: 0xEC95ED3F
	Offset: 0x300
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_side_ee_spore_hallucinations", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_c63a0940
	Checksum: 0x33F5B985
	Offset: 0x340
	Size: 0x1D9
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "hallucinate_bloody_walls", 9000, 1, "int", &function_38943e4d, 0, 0);
	clientfield::register("toplayer", "hallucinate_spooky_sounds", 9000, 1, "int", &function_f0aa6b80, 0, 0);
	var_68003f28 = function_244f59e6("side_ee_horror_room_lab_a");
	var_da07ae63 = function_244f59e6("side_ee_horror_room_lab_b");
	var_b40533fa = function_244f59e6("side_ee_horror_room_operation");
	level.var_d76c60c4 = ArrayCombine(var_68003f28, var_da07ae63, 0, 0);
	level.var_d76c60c4 = ArrayCombine(level.var_d76c60c4, var_b40533fa, 0, 0);
	foreach(var_27ae6b3e in level.var_d76c60c4)
	{
		function_733db26(var_27ae6b3e);
	}
}

/*
	Name: function_38943e4d
	Namespace: namespace_c63a0940
	Checksum: 0xB8E48930
	Offset: 0x528
	Size: 0x1E9
	Parameters: 7
	Flags: None
*/
function function_38943e4d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self thread LUI::screen_fade_in(1, "white");
	if(isdefined(newVal) && newVal)
	{
		foreach(var_78960d69 in level.var_d76c60c4)
		{
			function_c879924d(var_78960d69);
		}
		playsound(0, "zmb_spore_hallucinate_bloody_start", (0, 0, 0));
		self thread function_13d64112();
	}
	else
	{
		foreach(var_78960d69 in level.var_d76c60c4)
		{
			function_733db26(var_78960d69);
		}
		playsound(0, "zmb_spore_hallucinate_bloody_end", (0, 0, 0));
		level notify("hash_dad9c949");
	}
}

/*
	Name: function_f0aa6b80
	Namespace: namespace_c63a0940
	Checksum: 0x133B1B78
	Offset: 0x720
	Size: 0x129
	Parameters: 7
	Flags: None
*/
function function_f0aa6b80(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(newVal) && newVal)
	{
		playsound(0, "zmb_spore_hallucinate_start", (0, 0, 0));
		if(!isdefined(self.var_dafc6232))
		{
			self.var_dafc6232 = self PlayLoopSound("zmb_spore_hallucinate_lp_1", 2);
		}
		self thread function_13d64112();
	}
	else
	{
		playsound(0, "zmb_spore_hallucinate_end", (0, 0, 0));
		if(isdefined(self.var_dafc6232))
		{
			self StopLoopSound(self.var_dafc6232, 2);
			self.var_dafc6232 = undefined;
		}
		level notify("hash_dad9c949");
	}
}

/*
	Name: function_13d64112
	Namespace: namespace_c63a0940
	Checksum: 0x5965CCAF
	Offset: 0x858
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function function_13d64112()
{
	self notify("hash_dad9c949");
	self endon("hash_dad9c949");
	level endon("hash_dad9c949");
	self endon("disconnect");
	while(isdefined(self))
	{
		wait(randomIntRange(1, 8));
		self playsound(0, "zmb_spore_hallucinate_whisper");
	}
}

