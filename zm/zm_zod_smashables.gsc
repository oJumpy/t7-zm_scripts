#using scripts\codescripts\struct;
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
#using scripts\zm\zm_zod_portals;
#using scripts\zm\zm_zod_quest;

#namespace namespace_783690d8;

/*
	Name: __init__sytem__
	Namespace: namespace_783690d8
	Checksum: 0x873314BF
	Offset: 0x408
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_smashables", &__init__, undefined, undefined);
}

#namespace namespace_1143ac18;

/*
	Name: function_9b385ca5
	Namespace: namespace_1143ac18
	Checksum: 0xC1BB7744
	Offset: 0x448
	Size: 0x27
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.var_e9913a67 = [];
	self.var_22f50938 = [];
	self.var_b147f2bf = [];
}

/*
	Name: init
	Namespace: namespace_1143ac18
	Checksum: 0x1CBC39F5
	Offset: 0x478
	Size: 0x1A3
	Parameters: 1
	Flags: None
*/
function init(e_trigger)
{
	self.m_e_trigger = e_trigger;
	self.var_874b5dbf = GetEntArray(e_trigger.target, "targetname");
	self.var_889ff800 = GetNodeArray(e_trigger.target, "targetname");
	foreach(node in self.var_889ff800)
	{
		if(isdefined(node.script_noteworthy) && node.script_noteworthy == "air_beast_node")
		{
			UnlinkTraversal(node);
		}
	}
	function_89be164a(e_trigger);
	function_17dbc3e9();
	function_f559704d();
	function_80d521ff(1);
	function_6ea46467(1);
	thread main();
}

/*
	Name: function_32f1f123
	Namespace: namespace_1143ac18
	Checksum: 0x9B0E0A50
	Offset: 0x628
	Size: 0x2B
	Parameters: 2
	Flags: None
*/
function function_32f1f123(var_55b30dc8, arg)
{
	self.var_8c958204 = var_55b30dc8;
	self.var_b94c1eb = arg;
}

/*
	Name: function_f559704d
	Namespace: namespace_1143ac18
	Checksum: 0xDF483AB
	Offset: 0x660
	Size: 0x1E9
	Parameters: 0
	Flags: Private
*/
function private function_f559704d()
{
	if(!isdefined(self.m_e_trigger.script_parameters))
	{
		return;
	}
	a_params = StrTok(self.m_e_trigger.script_parameters, ",");
	foreach(var_b57e3a38 in a_params)
	{
		self.var_22f50938[var_b57e3a38] = 1;
		if(var_b57e3a38 == "connect_paths")
		{
			add_callback(&namespace_783690d8::function_1e436158);
			continue;
		}
		if(var_b57e3a38 == "any_damage")
		{
			foreach(e_clip in self.var_874b5dbf)
			{
				thread function_4b1eb226(e_clip);
			}
			continue;
		}
		/#
			/#
				ASSERTMSG("Dev Block strings are not supported" + var_b57e3a38 + "Dev Block strings are not supported" + self.m_e_trigger.targetname + "Dev Block strings are not supported");
			#/
		#/
	}
}

/*
	Name: function_61ed2bc3
	Namespace: namespace_1143ac18
	Checksum: 0xF0928BEC
	Offset: 0x858
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_61ed2bc3(var_f2eb1416)
{
	return isdefined(self.var_22f50938[var_f2eb1416]) && self.var_22f50938[var_f2eb1416];
}

/*
	Name: add_model
	Namespace: namespace_1143ac18
	Checksum: 0xC0BB2836
	Offset: 0x890
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function add_model(e_model)
{
	if(!isdefined(self.var_b147f2bf))
	{
		self.var_b147f2bf = [];
	}
	else if(!IsArray(self.var_b147f2bf))
	{
		self.var_b147f2bf = Array(self.var_b147f2bf);
	}
	self.var_b147f2bf[self.var_b147f2bf.size] = e_model;
	if(function_61ed2bc3("any_damage"))
	{
		thread function_4b1eb226(e_model);
	}
	function_80d521ff(self.var_40a64b9d);
	function_6ea46467(1);
}

/*
	Name: function_17dbc3e9
	Namespace: namespace_1143ac18
	Checksum: 0x10F788AF
	Offset: 0x978
	Size: 0x15B
	Parameters: 0
	Flags: Private
*/
function private function_17dbc3e9()
{
	var_c661ffbe = struct::get(self.m_e_trigger.target, "targetname");
	if(isdefined(var_c661ffbe) && isdefined(var_c661ffbe.scriptbundlename))
	{
		if(!isdefined(level.var_4c3d0fb8))
		{
			level.var_4c3d0fb8 = [];
		}
		if(!isdefined(level.var_4c3d0fb8[var_c661ffbe.scriptbundlename]))
		{
			level.var_4c3d0fb8[var_c661ffbe.scriptbundlename] = var_c661ffbe.scriptbundlename;
		}
		if(function_3408f1a2())
		{
			self thread function_82bc26b5();
		}
		else
		{
			level scene::init(self.m_e_trigger.target, "targetname");
		}
		var_5b3a6271 = function_3408f1a2();
		add_callback(&namespace_783690d8::function_31bb7714, var_5b3a6271, self.var_afea543d, self.var_6e27ff4);
	}
}

/*
	Name: function_82bc26b5
	Namespace: namespace_1143ac18
	Checksum: 0x28B91CA8
	Offset: 0xAE0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_82bc26b5()
{
	wait(1);
	level clientfield::set("breakable_show", self.var_afea543d);
	level clientfield::set("breakable_hide", self.var_6e27ff4);
}

/*
	Name: function_80d521ff
	Namespace: namespace_1143ac18
	Checksum: 0x2F57BE24
	Offset: 0xB40
	Size: 0xA7
	Parameters: 1
	Flags: Private
*/
function private function_80d521ff(var_451c9181)
{
	foreach(e_model in self.var_b147f2bf)
	{
		e_model clientfield::set("bminteract", var_451c9181);
	}
	self.var_40a64b9d = var_451c9181;
}

/*
	Name: function_6ea46467
	Namespace: namespace_1143ac18
	Checksum: 0xECDA0067
	Offset: 0xBF0
	Size: 0xB9
	Parameters: 1
	Flags: Private
*/
function private function_6ea46467(var_451c9181)
{
	foreach(e_model in self.var_b147f2bf)
	{
		if(var_451c9181)
		{
			e_model clientfield::set("set_fade_material", 1);
			continue;
		}
		e_model thread function_d8055c34();
	}
}

/*
	Name: function_d8055c34
	Namespace: namespace_1143ac18
	Checksum: 0x3F763D8E
	Offset: 0xCB8
	Size: 0x35
	Parameters: 0
	Flags: Private
*/
function private function_d8055c34()
{
	self thread function_387c449e();
	wait(10);
	if(isdefined(self))
	{
		self notify("hash_13f02a5d");
	}
}

/*
	Name: function_387c449e
	Namespace: namespace_1143ac18
	Checksum: 0x4BC00414
	Offset: 0xCF8
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private function_387c449e()
{
	self waittill("hash_13f02a5d");
	self clientfield::set("set_fade_material", 0);
}

/*
	Name: main
	Namespace: namespace_1143ac18
	Checksum: 0x9C3FA03F
	Offset: 0xD30
	Size: 0x2A7
	Parameters: 0
	Flags: Private
*/
function private main()
{
	self.m_e_trigger waittill("trigger", who);
	if(isdefined(who))
	{
		who notify("hash_d8f4150d");
	}
	foreach(model in self.var_b147f2bf)
	{
		if(model.targetname == "fxanim_beast_door")
		{
			model playsound("zmb_bm_interaction_door");
		}
		if(model.targetname == "fxanim_crate_breakable_01")
		{
			model playsound("zmb_bm_interaction_crate_large");
		}
		if(model.targetname == "fxanim_crate_breakable_02")
		{
			model playsound("zmb_bm_interaction_crate_small");
		}
		if(model.targetname == "fxanim_crate_breakable_03")
		{
			model playsound("zmb_bm_interaction_crate_small");
		}
	}
	function_10514fab();
	foreach(e_clip in self.var_874b5dbf)
	{
		e_clip delete();
	}
	function_80d521ff(0);
	function_6ea46467(0);
	if(isdefined(self.m_e_trigger.script_flag_set))
	{
		level flag::set(self.m_e_trigger.script_flag_set);
	}
	if(isdefined(self.var_8c958204))
	{
		[[self.var_8c958204]](self.var_b94c1eb);
	}
}

/*
	Name: function_10514fab
	Namespace: namespace_1143ac18
	Checksum: 0x2A99CCBA
	Offset: 0xFE0
	Size: 0x17F
	Parameters: 0
	Flags: Private
*/
function private function_10514fab()
{
	foreach(var_45e75a74 in self.var_e9913a67)
	{
		switch(var_45e75a74.params.size)
		{
			case 0:
			{
				self thread [[var_45e75a74.fn]]();
				break;
			}
			case 1:
			{
				self thread [[var_45e75a74.fn]](var_45e75a74.params[0]);
				break;
			}
			case 2:
			{
				self thread [[var_45e75a74.fn]](var_45e75a74.params[0], var_45e75a74.params[1]);
				break;
			}
			case 3:
			{
				self thread [[var_45e75a74.fn]](var_45e75a74.params[0], var_45e75a74.params[1], var_45e75a74.params[2]);
				break;
			}
		}
	}
}

/*
	Name: add_callback
	Namespace: namespace_1143ac18
	Checksum: 0x9092C83D
	Offset: 0x1168
	Size: 0x2E9
	Parameters: 4
	Flags: None
*/
function add_callback(var_8643a121, param1, param2, param3)
{
	/#
		Assert(isdefined(var_8643a121) && IsFunctionPtr(var_8643a121));
	#/
	s = spawnstruct();
	s.fn = var_8643a121;
	s.params = [];
	if(isdefined(param1))
	{
		if(!isdefined(s.params))
		{
			s.params = [];
		}
		else if(!IsArray(s.params))
		{
			s.params = Array(s.params);
		}
		s.params[s.params.size] = param1;
	}
	if(isdefined(param2))
	{
		if(!isdefined(s.params))
		{
			s.params = [];
		}
		else if(!IsArray(s.params))
		{
			s.params = Array(s.params);
		}
		s.params[s.params.size] = param2;
	}
	if(isdefined(param3))
	{
		if(!isdefined(s.params))
		{
			s.params = [];
		}
		else if(!IsArray(s.params))
		{
			s.params = Array(s.params);
		}
		s.params[s.params.size] = param3;
	}
	if(!isdefined(self.var_e9913a67))
	{
		self.var_e9913a67 = [];
	}
	else if(!IsArray(self.var_e9913a67))
	{
		self.var_e9913a67 = Array(self.var_e9913a67);
	}
	self.var_e9913a67[self.var_e9913a67.size] = s;
}

/*
	Name: function_4b1eb226
	Namespace: namespace_1143ac18
	Checksum: 0x99C7CBB2
	Offset: 0x1460
	Size: 0xEB
	Parameters: 1
	Flags: None
*/
function function_4b1eb226(e_clip)
{
	e_clip SetCanDamage(1);
	while(1)
	{
		e_clip waittill("damage", var_bee83e92, e_attacker, v_dir, v_pos, str_type);
		if(isdefined(e_attacker) && isPlayer(e_attacker) && (isdefined(e_attacker.beastmode) && e_attacker.beastmode) && str_type === "MOD_MELEE")
		{
			self.m_e_trigger notify("trigger", e_attacker);
			break;
		}
	}
}

/*
	Name: function_89be164a
	Namespace: namespace_1143ac18
	Checksum: 0xB649329C
	Offset: 0x1558
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function function_89be164a(e_trigger)
{
	if(isdefined(e_trigger.script_int) && isdefined(e_trigger.script_percent))
	{
		self.var_afea543d = e_trigger.script_int;
		self.var_6e27ff4 = e_trigger.script_percent;
	}
	else
	{
		self.var_afea543d = 0;
		self.var_6e27ff4 = 0;
	}
}

/*
	Name: function_3408f1a2
	Namespace: namespace_1143ac18
	Checksum: 0x80B5AD1F
	Offset: 0x15E0
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function function_3408f1a2()
{
	if(self.var_afea543d && self.var_6e27ff4)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_5fba2032
	Namespace: namespace_1143ac18
	Checksum: 0x99EC1590
	Offset: 0x1610
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_783690d8;

/*
	Name: function_1143ac18
	Namespace: namespace_783690d8
	Checksum: 0x7100D8FD
	Offset: 0x1620
	Size: 0x3B5
	Parameters: 0
	Flags: 6
*/
function private autoexec function_1143ac18()
{
	classes.var_1143ac18[0] = spawnstruct();
	classes.var_1143ac18[0].__vtable[1606033458] = &namespace_1143ac18::function_5fba2032;
	classes.var_1143ac18[0].__vtable[873001378] = &namespace_1143ac18::function_3408f1a2;
	classes.var_1143ac18[0].__vtable[-1984031158] = &namespace_1143ac18::function_89be164a;
	classes.var_1143ac18[0].__vtable[1260302886] = &namespace_1143ac18::function_4b1eb226;
	classes.var_1143ac18[0].__vtable[-565835896] = &namespace_1143ac18::add_callback;
	classes.var_1143ac18[0].__vtable[273764267] = &namespace_1143ac18::function_10514fab;
	classes.var_1143ac18[0].__vtable[-762254342] = &namespace_1143ac18::main;
	classes.var_1143ac18[0].__vtable[947668126] = &namespace_1143ac18::function_387c449e;
	classes.var_1143ac18[0].__vtable[-670737356] = &namespace_1143ac18::function_d8055c34;
	classes.var_1143ac18[0].__vtable[1856267367] = &namespace_1143ac18::function_6ea46467;
	classes.var_1143ac18[0].__vtable[-2133515777] = &namespace_1143ac18::function_80d521ff;
	classes.var_1143ac18[0].__vtable[-2101598539] = &namespace_1143ac18::function_82bc26b5;
	classes.var_1143ac18[0].__vtable[400278505] = &namespace_1143ac18::function_17dbc3e9;
	classes.var_1143ac18[0].__vtable[562466628] = &namespace_1143ac18::add_model;
	classes.var_1143ac18[0].__vtable[1642933187] = &namespace_1143ac18::function_61ed2bc3;
	classes.var_1143ac18[0].__vtable[-178687923] = &namespace_1143ac18::function_f559704d;
	classes.var_1143ac18[0].__vtable[854716707] = &namespace_1143ac18::function_32f1f123;
	classes.var_1143ac18[0].__vtable[-1017222485] = &namespace_1143ac18::init;
	classes.var_1143ac18[0].__vtable[-1690805083] = &namespace_1143ac18::function_9b385ca5;
}

/*
	Name: __init__
	Namespace: namespace_783690d8
	Checksum: 0x6A6BFEE7
	Offset: 0x19E0
	Size: 0xB1
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level thread function_9303865();
	foreach(var_a3d1f031 in level.var_4c3d0fb8)
	{
		scene::add_scene_func(var_a3d1f031, &function_b0597c09, "init");
	}
}

/*
	Name: function_98f24ad1
	Namespace: namespace_783690d8
	Checksum: 0xEE087432
	Offset: 0x1AA0
	Size: 0xBD
	Parameters: 1
	Flags: Private
*/
function private function_98f24ad1(str_targetname)
{
	foreach(var_e535841d in level.var_ac1aab64)
	{
		if(isdefined(var_e535841d.m_e_trigger.target) && var_e535841d.m_e_trigger.target == str_targetname)
		{
			return var_e535841d;
		}
	}
	return undefined;
}

/*
	Name: function_b0597c09
	Namespace: namespace_783690d8
	Checksum: 0xD83FC7C7
	Offset: 0x1B68
	Size: 0xE5
	Parameters: 1
	Flags: Private
*/
function private function_b0597c09(a_models)
{
	var_e535841d = undefined;
	foreach(e_model in a_models)
	{
		if(!isdefined(var_e535841d))
		{
			var_e535841d = function_98f24ad1(e_model._o_scene._e_root.targetname);
		}
		if(isdefined(var_e535841d))
		{
			add_model(var_e535841d);
		}
	}
}

/*
	Name: function_9303865
	Namespace: namespace_783690d8
	Checksum: 0xE898167C
	Offset: 0x1C58
	Size: 0x299
	Parameters: 0
	Flags: Private
*/
function private function_9303865()
{
	level.var_ac1aab64 = [];
	var_5b2a4fe5 = GetEntArray("beast_melee_only", "script_noteworthy");
	n_id = 0;
	foreach(trigger in var_5b2a4fe5)
	{
		str_id = "smash_unnamed_" + n_id;
		if(isdefined(trigger.targetname))
		{
			str_id = trigger.targetname;
		}
		else
		{
			trigger.targetname = str_id;
			n_id++;
		}
		if(isdefined(level.var_ac1aab64[str_id]))
		{
			/#
				/#
					ASSERTMSG("Dev Block strings are not supported" + str_id + "Dev Block strings are not supported");
				#/
			#/
			continue;
		}
		function_9b385ca5();
		var_bb87fb61 = var_1143ac18;
		level.var_ac1aab64[str_id] = var_bb87fb61;
		if(IsSubStr(str_id, "portal"))
		{
			function_32f1f123(var_bb87fb61, &namespace_8e2647d0::function_54ec766b);
		}
		if(IsSubStr(str_id, "memento"))
		{
			function_32f1f123(var_bb87fb61, &namespace_1f61c67f::function_c2c28545);
		}
		if(IsSubStr(str_id, "beast_kiosk"))
		{
			function_32f1f123(var_bb87fb61, &function_98a01ab9);
		}
		if(str_id === "unlock_quest_key")
		{
			function_32f1f123(var_bb87fb61, &function_1c061892);
		}
		init(var_bb87fb61);
	}
}

/*
	Name: function_98a01ab9
	Namespace: namespace_783690d8
	Checksum: 0x194D5801
	Offset: 0x1F00
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_98a01ab9(str_id)
{
	function_14a1c32c("beast_mode_kiosk_unavailable", str_id);
	function_14a1c32c("beast_mode_kiosk", str_id);
}

/*
	Name: function_14a1c32c
	Namespace: namespace_783690d8
	Checksum: 0xC71A8978
	Offset: 0x1F58
	Size: 0xD9
	Parameters: 2
	Flags: None
*/
function function_14a1c32c(str_targetname, str_id)
{
	triggers = GetEntArray(str_targetname, "targetname");
	foreach(trigger in triggers)
	{
		if(trigger.script_noteworthy === str_id)
		{
			trigger.var_5c0036b3 = 1;
		}
	}
}

/*
	Name: function_1c061892
	Namespace: namespace_783690d8
	Checksum: 0xBD1DD1BD
	Offset: 0x2040
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function function_1c061892(str_id)
{
	level.var_c913a45f = 1;
}

/*
	Name: add_callback
	Namespace: namespace_783690d8
	Checksum: 0xF72C2CB0
	Offset: 0x2060
	Size: 0xA7
	Parameters: 5
	Flags: None
*/
function add_callback(targetname, var_8643a121, param1, param2, param3)
{
	var_bb87fb61 = level.var_ac1aab64[targetname];
	if(!isdefined(var_bb87fb61))
	{
		/#
			/#
				ASSERTMSG("Dev Block strings are not supported" + targetname + "Dev Block strings are not supported");
			#/
		#/
		return;
	}
	add_callback(var_bb87fb61, var_8643a121, param1, param2);
}

/*
	Name: function_1e436158
	Namespace: namespace_783690d8
	Checksum: 0x3E491AF4
	Offset: 0x2110
	Size: 0xE1
	Parameters: 0
	Flags: Private
*/
function private function_1e436158()
{
	self.var_874b5dbf[0] connectpaths();
	if(isdefined(self.var_889ff800))
	{
		foreach(node in self.var_889ff800)
		{
			if(isdefined(node.script_noteworthy) && node.script_noteworthy == "air_beast_node")
			{
				LinkTraversal(node);
			}
		}
	}
}

/*
	Name: function_31bb7714
	Namespace: namespace_783690d8
	Checksum: 0xEF2183CD
	Offset: 0x2200
	Size: 0xD3
	Parameters: 3
	Flags: Private
*/
function private function_31bb7714(var_5b3a6271, var_bc554281, var_6bf8cfb8)
{
	str_fxanim = self.m_e_trigger.target;
	s_fxanim = struct::get(str_fxanim, "targetname");
	if(var_bc554281)
	{
		level clientfield::set("breakable_hide", var_bc554281);
	}
	level scene::Play(str_fxanim, "targetname");
	if(var_6bf8cfb8)
	{
		level clientfield::set("breakable_show", var_6bf8cfb8);
	}
}

