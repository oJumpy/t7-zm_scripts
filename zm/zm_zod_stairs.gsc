#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_poweronswitch;

#namespace namespace_de48615;

/*
	Name: __init__sytem__
	Namespace: namespace_de48615
	Checksum: 0x40BB9F1F
	Offset: 0x340
	Size: 0x2B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_stairs", undefined, &__main__, undefined);
}

/*
	Name: __main__
	Namespace: namespace_de48615
	Checksum: 0x6057B528
	Offset: 0x378
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level thread function_680ab134();
}

/*
	Name: function_680ab134
	Namespace: namespace_de48615
	Checksum: 0xC9FA6B54
	Offset: 0x3A0
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_680ab134()
{
	if(!isdefined(level.var_7cf3398a))
	{
		level.var_7cf3398a = [];
		function_e83b9d25("slums", 11);
		function_e83b9d25("canal", 12);
		function_e83b9d25("theater", 13);
		function_e83b9d25("start", 14);
		function_e83b9d25("brothel", 16);
		function_e83b9d25("underground", 15);
	}
}

/*
	Name: function_e83b9d25
	Namespace: namespace_de48615
	Checksum: 0xEF2AA094
	Offset: 0x488
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function function_e83b9d25(var_d42f02cf, n_power_index)
{
	if(!isdefined(level.var_7cf3398a[n_power_index]))
	{
		function_9b385ca5();
		level.var_7cf3398a[n_power_index] = var_3f5d3dd7;
		function_e83b9d25(level.var_7cf3398a[n_power_index], var_d42f02cf);
		function_128dbfb9();
	}
}

#namespace namespace_3f5d3dd7;

/*
	Name: function_e83b9d25
	Namespace: namespace_3f5d3dd7
	Checksum: 0x9CEBAFAF
	Offset: 0x518
	Size: 0x233
	Parameters: 2
	Flags: None
*/
function function_e83b9d25(var_d42f02cf, n_power_index)
{
	self.var_5fd95ddf = 0;
	self.var_5db129b = 0.1;
	self.var_8ba3e653 = var_d42f02cf;
	self.var_ae9b1946 = GetEntArray("stair_step", "targetname");
	self.var_1c98028c = GetEntArray("stair_blocker", "targetname");
	self.var_f3446503 = GetEntArray("stair_clip", "targetname");
	self.var_f2f66550 = struct::get_array("stair_staircase", "targetname");
	self.var_39624e3b = struct::get_array("stair_gate", "targetname");
	self.var_ae9b1946 = Array::filter(self.var_ae9b1946, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_1c98028c = Array::filter(self.var_1c98028c, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_f3446503 = Array::filter(self.var_f3446503, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_f2f66550 = Array::filter(self.var_f2f66550, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_39624e3b = Array::filter(self.var_39624e3b, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_19295d02 = n_power_index;
	self.var_7a01aaae = 0;
}

/*
	Name: function_128dbfb9
	Namespace: namespace_3f5d3dd7
	Checksum: 0xE69F1BAA
	Offset: 0x758
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_128dbfb9()
{
	function_c59fb890(0, 1);
	self thread function_713998cd();
}

/*
	Name: function_1bfbfa4c
	Namespace: namespace_3f5d3dd7
	Checksum: 0xDFC8A256
	Offset: 0x798
	Size: 0x47
	Parameters: 2
	Flags: None
*/
function function_1bfbfa4c(e_entity, var_d42f02cf)
{
	if(!isdefined(e_entity.script_string) || e_entity.script_string != var_d42f02cf)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_e080d454
	Namespace: namespace_3f5d3dd7
	Checksum: 0xC0DFD74F
	Offset: 0x7E8
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function function_e080d454()
{
	return self.var_1c98028c[0];
}

/*
	Name: function_713998cd
	Namespace: namespace_3f5d3dd7
	Checksum: 0x4CC52059
	Offset: 0x800
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_713998cd()
{
	function_d7d72e14();
	function_c59fb890(1, 0);
}

/*
	Name: function_d7d72e14
	Namespace: namespace_3f5d3dd7
	Checksum: 0x73F11971
	Offset: 0x838
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_d7d72e14()
{
	level flag::wait_till("power_on" + self.var_19295d02);
}

/*
	Name: function_c59fb890
	Namespace: namespace_3f5d3dd7
	Checksum: 0xF80D374F
	Offset: 0x870
	Size: 0x53B
	Parameters: 2
	Flags: None
*/
function function_c59fb890(var_ebe89e4d, var_4faef07e)
{
	if(self.var_8ba3e653 != "underground" && self.var_8ba3e653 != "club" && var_ebe89e4d && !var_4faef07e)
	{
		self.var_f2f66550[0] scene::Play("p7_fxanim_zm_zod_mechanical_stairs_bundle");
		foreach(var_a7c049ac in self.var_39624e3b)
		{
			var_a7c049ac thread scene::Play("p7_fxanim_zm_zod_gate_scissor_short_bundle");
		}
		self.var_5fd95ddf = 2;
		self.var_f3446503[0] function_64c24459();
		self.var_f3446503[0] connectpaths();
		return;
	}
	if(var_4faef07e)
	{
		var_8cf4ae15 = 0.05;
		var_3bdcaf84 = 0.05;
	}
	else
	{
		var_8cf4ae15 = 0.5;
		var_3bdcaf84 = 0.25;
	}
	if(var_ebe89e4d)
	{
		self.var_5fd95ddf = 1;
	}
	else
	{
		self.var_5fd95ddf = 3;
	}
	if(!var_ebe89e4d)
	{
		foreach(var_4c225fa1 in self.var_1c98028c)
		{
			self thread function_fe51d425(var_4c225fa1, !var_ebe89e4d, 64, var_3bdcaf84);
		}
	}
	foreach(var_6de2b083 in self.var_ae9b1946)
	{
		if(var_ebe89e4d && isdefined(var_6de2b083.script_noteworthy) && var_6de2b083.script_noteworthy == "swing_door" && isdefined(var_6de2b083.angles) && isdefined(var_6de2b083.script_float))
		{
			self thread function_15ee241e(var_6de2b083, var_6de2b083.angles, var_6de2b083.script_float, 0.5);
		}
		else
		{
			self thread function_fe51d425(var_6de2b083, var_ebe89e4d, var_6de2b083.script_int, var_8cf4ae15);
		}
		if(isdefined(self.var_5db129b))
		{
			wait(self.var_5db129b);
		}
	}
	wait(var_8cf4ae15);
	if(var_ebe89e4d)
	{
		foreach(var_4c225fa1 in self.var_1c98028c)
		{
			self thread function_fe51d425(var_4c225fa1, !var_ebe89e4d, 64, var_3bdcaf84);
		}
	}
	else if(var_ebe89e4d)
	{
		self.var_5fd95ddf = 2;
		self.var_f3446503[0] function_64c24459();
		self.var_f3446503[0] connectpaths();
	}
	else
	{
		self.var_5fd95ddf = 0;
		self.var_f3446503[0] SetVisibleToAll();
		self.var_f3446503[0] disconnectpaths();
	}
	if(var_ebe89e4d)
	{
		if(isdefined(self.var_ae9b1946[0].script_flag_set))
		{
			level flag::set(self.var_ae9b1946[0].script_flag_set);
		}
	}
}

/*
	Name: function_fe51d425
	Namespace: namespace_3f5d3dd7
	Checksum: 0x1D4685A5
	Offset: 0xDB8
	Size: 0x93
	Parameters: 4
	Flags: None
*/
function function_fe51d425(e_mover, var_ebe89e4d, var_b09b5614, n_duration)
{
	if(!var_ebe89e4d)
	{
		var_b09b5614 = var_b09b5614 * -1;
	}
	v_offset = anglesToUp((0, 0, 0)) * var_b09b5614;
	e_mover moveto(e_mover.origin + v_offset, n_duration);
}

/*
	Name: function_15ee241e
	Namespace: namespace_3f5d3dd7
	Checksum: 0xDF28C6E0
	Offset: 0xE58
	Size: 0x4B
	Parameters: 4
	Flags: None
*/
function function_15ee241e(e_mover, v_angles, n_rotate, n_duration)
{
	e_mover RotateTo(v_angles + (0, n_rotate, 0), n_duration);
}

/*
	Name: function_64c24459
	Namespace: namespace_3f5d3dd7
	Checksum: 0x51E71B8A
	Offset: 0xEB0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_64c24459()
{
	self moveto(self.origin - VectorScale((0, 0, 1), 10000), 0.05);
	wait(0.05);
}

/*
	Name: function_9b385ca5
	Namespace: namespace_3f5d3dd7
	Checksum: 0x99EC1590
	Offset: 0xF00
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
}

/*
	Name: function_5fba2032
	Namespace: namespace_3f5d3dd7
	Checksum: 0x99EC1590
	Offset: 0xF10
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_de48615;

/*
	Name: function_3f5d3dd7
	Namespace: namespace_de48615
	Checksum: 0x90830356
	Offset: 0xF20
	Size: 0x265
	Parameters: 0
	Flags: 6
*/
function private autoexec function_3f5d3dd7()
{
	classes.var_3f5d3dd7[0] = spawnstruct();
	classes.var_3f5d3dd7[0].__vtable[1606033458] = &namespace_3f5d3dd7::function_5fba2032;
	classes.var_3f5d3dd7[0].__vtable[-1690805083] = &namespace_3f5d3dd7::function_9b385ca5;
	classes.var_3f5d3dd7[0].__vtable[1690453081] = &namespace_3f5d3dd7::function_64c24459;
	classes.var_3f5d3dd7[0].__vtable[367928350] = &namespace_3f5d3dd7::function_15ee241e;
	classes.var_3f5d3dd7[0].__vtable[-28191707] = &namespace_3f5d3dd7::function_fe51d425;
	classes.var_3f5d3dd7[0].__vtable[-979388272] = &namespace_3f5d3dd7::function_c59fb890;
	classes.var_3f5d3dd7[0].__vtable[-673763820] = &namespace_3f5d3dd7::function_d7d72e14;
	classes.var_3f5d3dd7[0].__vtable[1899600077] = &namespace_3f5d3dd7::function_713998cd;
	classes.var_3f5d3dd7[0].__vtable[-528427948] = &namespace_3f5d3dd7::function_e080d454;
	classes.var_3f5d3dd7[0].__vtable[469498444] = &namespace_3f5d3dd7::function_1bfbfa4c;
	classes.var_3f5d3dd7[0].__vtable[311279545] = &namespace_3f5d3dd7::function_128dbfb9;
	classes.var_3f5d3dd7[0].__vtable[-398746331] = &namespace_3f5d3dd7::function_e83b9d25;
}

