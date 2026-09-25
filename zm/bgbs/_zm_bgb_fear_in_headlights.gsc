#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace namespace_105bda17;

/*
	Name: __init__sytem__
	Namespace: namespace_105bda17
	Checksum: 0xFE62B444
	Offset: 0x1F0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_fear_in_headlights", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_105bda17
	Checksum: 0x5EB6920C
	Offset: 0x230
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_fear_in_headlights", "activated", 1, undefined, undefined, &validation, &activation);
}

/*
	Name: function_b13c2f15
	Namespace: namespace_105bda17
	Checksum: 0x45567D84
	Offset: 0x2A0
	Size: 0x83
	Parameters: 0
	Flags: Private
*/
function private function_b13c2f15()
{
	self endon("hash_4e7f43fc");
	self waittill("death");
	if(isdefined(self) && self IsPaused())
	{
		self SetEntityPaused(0);
		if(!self IsRagdoll())
		{
			self StartRagdoll();
		}
	}
}

/*
	Name: function_b8eb33c5
	Namespace: namespace_105bda17
	Checksum: 0x12DC37BE
	Offset: 0x330
	Size: 0xAB
	Parameters: 1
	Flags: Private
*/
function private function_b8eb33c5(ai)
{
	ai notify("hash_4e7f43fc");
	ai thread function_b13c2f15();
	ai SetEntityPaused(1);
	ai.var_70a58794 = ai.b_ignore_cleanup;
	ai.b_ignore_cleanup = 1;
	ai.var_7f7a0b19 = ai.is_inert;
	ai.is_inert = 1;
}

/*
	Name: function_31a2964e
	Namespace: namespace_105bda17
	Checksum: 0x4053149D
	Offset: 0x3E8
	Size: 0xA7
	Parameters: 1
	Flags: Private
*/
function private function_31a2964e(ai)
{
	ai notify("hash_4e7f43fc");
	ai SetEntityPaused(0);
	if(isdefined(ai.var_7f7a0b19))
	{
		ai.is_inert = ai.var_7f7a0b19;
	}
	if(isdefined(ai.var_70a58794))
	{
		ai.b_ignore_cleanup = ai.var_70a58794;
	}
	else
	{
		ai.b_ignore_cleanup = 0;
	}
}

/*
	Name: function_723d94f5
	Namespace: namespace_105bda17
	Checksum: 0xAA2BEEBD
	Offset: 0x498
	Size: 0x1B1
	Parameters: 3
	Flags: Private
*/
function private function_723d94f5(allai, trace, degree)
{
	if(!isdefined(degree))
	{
		degree = 45;
	}
	var_f1649153 = allai;
	players = GetPlayers();
	var_445b9352 = cos(degree);
	foreach(player in players)
	{
		var_f1649153 = player CantSeeEntities(var_f1649153, var_445b9352, trace);
	}
	foreach(ai in var_f1649153)
	{
		if(isalive(ai))
		{
			function_31a2964e(ai);
		}
	}
}

/*
	Name: validation
	Namespace: namespace_105bda17
	Checksum: 0x528443D1
	Offset: 0x658
	Size: 0x25
	Parameters: 0
	Flags: None
*/
function validation()
{
	if(bgb::is_team_active("zm_bgb_fear_in_headlights"))
	{
		return 0;
	}
	return 1;
}

/*
	Name: activation
	Namespace: namespace_105bda17
	Checksum: 0xE94CB83F
	Offset: 0x688
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function activation()
{
	self endon("disconnect");
	self thread function_deeb696f();
	self playsound("zmb_bgb_fearinheadlights_start");
	self PlayLoopSound("zmb_bgb_fearinheadlights_loop");
	self thread function_2715245a();
	self bgb::run_timer(120);
	self notify("hash_2715245a");
}

/*
	Name: function_deeb696f
	Namespace: namespace_105bda17
	Checksum: 0xB4D3AC8
	Offset: 0x738
	Size: 0x317
	Parameters: 0
	Flags: None
*/
function function_deeb696f()
{
	self endon("disconnect");
	self endon("hash_2715245a");
	var_bd6badee = 1200 * 1200;
	while(1)
	{
		allai = GetAIArray();
		foreach(ai in allai)
		{
			if(isdefined(ai.var_48cabef5) && ai [[ai.var_48cabef5]]())
			{
				continue;
			}
			if(isalive(ai) && !ai IsPaused() && ai.team == level.zombie_team && !ai ishidden() && (!isdefined(ai.bgbIgnoreFearInHeadlights) && ai.bgbIgnoreFearInHeadlights))
			{
				function_b8eb33c5(ai);
			}
		}
		var_e4760c66 = [];
		var_e37fbbbd = [];
		foreach(ai in allai)
		{
			if(isdefined(ai.aat_turned) && ai.aat_turned && ai IsPaused())
			{
				function_31a2964e(ai);
				continue;
			}
			if(Distance2DSquared(ai.origin, self.origin) >= var_bd6badee)
			{
				var_e4760c66[var_e4760c66.size] = ai;
				continue;
			}
			var_e37fbbbd[var_e37fbbbd.size] = ai;
		}
		function_723d94f5(var_e4760c66, 1);
		function_723d94f5(var_e37fbbbd, 0, 75);
		wait(0.05);
	}
}

/*
	Name: function_2715245a
	Namespace: namespace_105bda17
	Checksum: 0x95068479
	Offset: 0xA58
	Size: 0x119
	Parameters: 0
	Flags: None
*/
function function_2715245a()
{
	str_notify = self util::waittill_any_return("death", "kill_fear_in_headlights");
	if(str_notify == "kill_fear_in_headlights")
	{
		self StopLoopSound();
		self playsound("zmb_bgb_fearinheadlights_end");
	}
	allai = GetAIArray();
	foreach(ai in allai)
	{
		function_31a2964e(ai);
	}
}

