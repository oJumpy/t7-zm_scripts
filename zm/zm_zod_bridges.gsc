#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_f76f5b63;

/*
	Name: __init__sytem__
	Namespace: namespace_f76f5b63
	Checksum: 0xD1F51EE3
	Offset: 0x330
	Size: 0x2B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_bridges", undefined, &__main__, undefined);
}

/*
	Name: __main__
	Namespace: namespace_f76f5b63
	Checksum: 0x9B24A9A6
	Offset: 0x368
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level thread function_cc211d40();
}

/*
	Name: function_cc211d40
	Namespace: namespace_f76f5b63
	Checksum: 0xEE322FE9
	Offset: 0x390
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_cc211d40()
{
	if(!isdefined(level.var_701d7eb))
	{
		level.var_701d7eb = [];
	}
	if(!isdefined(level.var_c70d218))
	{
		level.var_c70d218 = [];
		function_69d1a149("slums", 1);
		function_69d1a149("canal", 2);
		function_69d1a149("theater", 3);
	}
}

/*
	Name: function_69d1a149
	Namespace: namespace_f76f5b63
	Checksum: 0x645BB9C5
	Offset: 0x430
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function function_69d1a149(var_d42f02cf, n_index)
{
	function_9b385ca5();
	level.var_c70d218[n_index] = var_1f041243;
	function_69d1a149(level.var_c70d218[n_index]);
}

#namespace namespace_1f041243;

/*
	Name: function_69d1a149
	Namespace: namespace_1f041243
	Checksum: 0x5FFBAC61
	Offset: 0x488
	Size: 0x3C3
	Parameters: 1
	Flags: None
*/
function function_69d1a149(var_d42f02cf)
{
	self.var_8ba3e653 = var_d42f02cf;
	var_5fd95ddf = 0;
	var_5db129b = 0.1;
	door_name = var_d42f02cf + "_bridge_door";
	var_e8ecea33 = GetEntArray(door_name, "script_noteworthy");
	self.var_1c98028c = GetEntArray("bridge_blocker", "targetname");
	var_a2660e03 = GetEntArray("bridge_clip_blocker", "targetname");
	var_ed804e7f = GetEntArray("bridge_walkway", "targetname");
	var_bb00a9de = GetEntArray("bridge_pull_trigger", "targetname");
	var_60dfdb84 = GetEntArray("bridge_pull_target", "targetname");
	self.var_1c98028c = Array::filter(self.var_1c98028c, 0, &function_1bfbfa4c, var_d42f02cf);
	var_a2660e03 = Array::filter(var_a2660e03, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_17d1cc44 = var_a2660e03[0];
	var_ed804e7f = Array::filter(var_ed804e7f, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_746f1e93 = var_ed804e7f[0];
	var_60dfdb84 = Array::filter(var_60dfdb84, 0, &function_1bfbfa4c, var_d42f02cf);
	self.var_c7107160 = var_60dfdb84[0];
	self.var_7a01aaae = 0;
	self.var_746f1e93 SetInvisibleToAll();
	foreach(var_4c225fa1 in self.var_1c98028c)
	{
		var_4c225fa1 useanimtree(-1);
	}
	self.var_746f1e93 useanimtree(-1);
	self.var_c7107160 SetGrapplableType(3);
	Array::add(level.var_701d7eb, self.var_c7107160, 0);
	self.var_c7107160 clientfield::set("bminteract", 3);
	self thread bridge_connect(var_e8ecea33[0], var_e8ecea33[1]);
}

/*
	Name: function_1bfbfa4c
	Namespace: namespace_1f041243
	Checksum: 0x5A78BAE8
	Offset: 0x858
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
	Name: bridge_connect
	Namespace: namespace_1f041243
	Checksum: 0xCEED0C4D
	Offset: 0x8A8
	Size: 0x1CB
	Parameters: 2
	Flags: None
*/
function bridge_connect(var_f68bad2e, var_d08932c5)
{
	util::waittill_any_ents_two(var_f68bad2e, "trigger", var_d08932c5, "trigger");
	foreach(var_4c225fa1 in self.var_1c98028c)
	{
		var_4c225fa1 SetAnim(%p7_fxanim_zm_zod_gate_scissor_short_open_anim);
	}
	self.var_746f1e93 SetAnim(%p7_fxanim_zm_zod_beast_bridge_open_anim);
	self.var_746f1e93 SetVisibleToAll();
	self.var_c7107160 SetInvisibleToAll();
	self.var_c7107160 clientfield::set("bminteract", 0);
	self.var_c7107160 SetGrapplableType(0);
	level.var_701d7eb = Array::exclude(level.var_701d7eb, self.var_c7107160);
	wait(1);
	self.var_17d1cc44 function_64c24459();
	self.var_17d1cc44 connectpaths();
	function_35b36f55();
}

/*
	Name: function_35b36f55
	Namespace: namespace_1f041243
	Checksum: 0xB3E1E759
	Offset: 0xA80
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_35b36f55()
{
	var_c7c6602e = self.var_8ba3e653 + "_district_zone_high";
	if(!zm_zonemgr::zone_is_enabled(var_c7c6602e))
	{
		zm_zonemgr::zone_init(var_c7c6602e);
		zm_zonemgr::enable_zone(var_c7c6602e);
	}
	zm_zonemgr::add_adjacent_zone(self.var_8ba3e653 + "_district_zone_B", var_c7c6602e, "enter_" + self.var_8ba3e653 + "_district_high_from_B");
}

/*
	Name: function_64c24459
	Namespace: namespace_1f041243
	Checksum: 0xE2E1D080
	Offset: 0xB38
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
	Namespace: namespace_1f041243
	Checksum: 0x99EC1590
	Offset: 0xB88
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
}

/*
	Name: function_5fba2032
	Namespace: namespace_1f041243
	Checksum: 0x99EC1590
	Offset: 0xB98
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_f76f5b63;

/*
	Name: function_1f041243
	Namespace: namespace_f76f5b63
	Checksum: 0xEC7B2580
	Offset: 0xBA8
	Size: 0x175
	Parameters: 0
	Flags: 6
*/
function private autoexec function_1f041243()
{
	classes.var_1f041243[0] = spawnstruct();
	classes.var_1f041243[0].__vtable[1606033458] = &namespace_1f041243::function_5fba2032;
	classes.var_1f041243[0].__vtable[-1690805083] = &namespace_1f041243::function_9b385ca5;
	classes.var_1f041243[0].__vtable[1690453081] = &namespace_1f041243::function_64c24459;
	classes.var_1f041243[0].__vtable[900951893] = &namespace_1f041243::function_35b36f55;
	classes.var_1f041243[0].__vtable[644748357] = &namespace_1f041243::bridge_connect;
	classes.var_1f041243[0].__vtable[469498444] = &namespace_1f041243::function_1bfbfa4c;
	classes.var_1f041243[0].__vtable[1775345993] = &namespace_1f041243::function_69d1a149;
}

