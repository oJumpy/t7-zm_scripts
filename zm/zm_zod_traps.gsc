#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_bb;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_zod_quest;

#namespace namespace_d8d03071;

/*
	Name: __init__sytem__
	Namespace: namespace_d8d03071
	Checksum: 0xB414E397
	Offset: 0x528
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_traps", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_d8d03071
	Checksum: 0x1B9AB328
	Offset: 0x568
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "trap_chain_state", 1, 2, "int");
	clientfield::register("scriptmover", "trap_chain_location", 1, 2, "int");
}

/*
	Name: init_traps
	Namespace: namespace_d8d03071
	Checksum: 0x87FFF9BD
	Offset: 0x5D8
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function init_traps()
{
	if(!isdefined(level.var_bd9e44cc))
	{
		level.var_bd9e44cc = [];
		function_f46f1aeb("theater");
		function_f46f1aeb("slums");
		function_f46f1aeb("canals");
		function_f46f1aeb("pap");
	}
	flag::wait_till("all_players_spawned");
	function_89303c72(undefined);
}

/*
	Name: function_f46f1aeb
	Namespace: namespace_d8d03071
	Checksum: 0x69AC3FEF
	Offset: 0x690
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_f46f1aeb(str_area_name)
{
	if(!isdefined(level.var_bd9e44cc[str_area_name]))
	{
		function_9b385ca5();
		level.var_bd9e44cc[str_area_name] = var_a32cae3d;
		function_f46f1aeb(level.var_bd9e44cc[str_area_name]);
	}
}

/*
	Name: function_89303c72
	Namespace: namespace_d8d03071
	Checksum: 0xA031D45B
	Offset: 0x6F8
	Size: 0x1E3
	Parameters: 1
	Flags: None
*/
function function_89303c72(var_f6caa7fd)
{
	var_cdd779bd = getArrayKeys(level.var_bd9e44cc);
	foreach(str_index in var_cdd779bd)
	{
		if(str_index != "pap")
		{
			level.var_bd9e44cc[str_index].var_5fd95ddf = 1;
			function_8aa04a46();
			function_d84562ad(level.var_bd9e44cc[str_index]);
			function_e95944e1();
		}
	}
	level.var_bd9e44cc["pap"].var_5fd95ddf = 0;
	function_8aa04a46();
	function_d84562ad(level.var_bd9e44cc["pap"]);
	function_e95944e1();
	level thread function_8144bbbe();
}

/*
	Name: function_8144bbbe
	Namespace: namespace_d8d03071
	Checksum: 0x887FCCEF
	Offset: 0x8E8
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function function_8144bbbe()
{
	level flag::wait_till("pap_door_open");
	level.var_bd9e44cc["pap"].var_5fd95ddf = 1;
	function_8aa04a46();
	function_d84562ad(level.var_bd9e44cc["pap"]);
	function_e95944e1();
}

#namespace namespace_a32cae3d;

/*
	Name: function_f46f1aeb
	Namespace: namespace_a32cae3d
	Checksum: 0x8E2E5E79
	Offset: 0x9B0
	Size: 0x49B
	Parameters: 1
	Flags: None
*/
function function_f46f1aeb(str_area_name)
{
	self.var_5fd95ddf = 1;
	self.var_7a01aaae = 0;
	self.var_54d81d07 = 0;
	self.var_159266ff = 1000;
	self.var_2ac38075 = 25;
	self.var_3e336f90 = 25;
	self.var_1e59abc0 = 1;
	self.var_8bfee5e9 = 0.25;
	self.var_820db121 = 25;
	self.var_12a7c9a2 = 6500;
	self.var_cec4c4e3 = &"ZM_ZOD_TRAP_CHAIN_UNAVAILABLE";
	self.var_42b9bb70 = &"ZM_ZOD_TRAP_CHAIN_AVAILABLE";
	self.var_9f1e30f5 = &"ZM_ZOD_TRAP_CHAIN_ACTIVE";
	self.var_9082d410 = &"ZM_ZOD_TRAP_CHAIN_COOLDOWN";
	var_69299131 = GetEntArray("trap_chain_damage", "targetname");
	var_69299131 = Array::filter(var_69299131, 0, &function_1bfbfa4c, str_area_name);
	var_f0bc3cc1 = GetEntArray("trap_chain_rumble", "targetname");
	var_f0bc3cc1 = Array::filter(var_69299131, 0, &function_1bfbfa4c, str_area_name);
	self.var_7d0ff937 = GetEntArray("trap_chain_heart", "targetname");
	self.var_7d0ff937 = Array::filter(self.var_7d0ff937, 0, &function_1bfbfa4c, str_area_name);
	self.var_2fbb8bbb = GetEntArray("use_trap_chain", "targetname");
	self.var_2fbb8bbb = Array::filter(self.var_2fbb8bbb, 0, &function_1bfbfa4c, str_area_name);
	function_e95944e1();
	Array::thread_all(self.var_2fbb8bbb, &function_10b03792, self);
	var_d186b130 = [];
	var_d186b130[0] = "theater";
	var_d186b130[1] = "slums";
	var_d186b130[2] = "canals";
	var_d186b130[3] = "pap";
	foreach(heart in self.var_7d0ff937)
	{
		for(i = 0; i < var_d186b130.size; i++)
		{
			if(var_d186b130[i] == heart.var_47c44e16)
			{
				heart clientfield::set("trap_chain_location", i);
			}
		}
	}
	self.var_faf8139 = var_69299131[0];
	self.var_723e9919 = var_f0bc3cc1[0];
	var_29a9b54e = struct::get_array("trap_chain_audio_loc", "targetname");
	var_29a9b54e = Array::filter(var_29a9b54e, 0, &function_1bfbfa4c, str_area_name);
	self.var_366b1f63 = var_29a9b54e[0];
	self.var_366b1f63 = spawn("script_origin", self.var_366b1f63.origin);
	self.var_99b965df = 0;
	self thread function_8e2169c7();
}

/*
	Name: function_1bfbfa4c
	Namespace: namespace_a32cae3d
	Checksum: 0x7E4FB803
	Offset: 0xE58
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function function_1bfbfa4c(e_entity, str_area_name)
{
	if(e_entity.var_47c44e16 !== str_area_name)
	{
		return 0;
	}
	return 1;
}

/*
	Name: function_10b03792
	Namespace: namespace_a32cae3d
	Checksum: 0xB6D7F878
	Offset: 0xE98
	Size: 0x257
	Parameters: 1
	Flags: None
*/
function function_10b03792(var_1f29d07e)
{
	while(1)
	{
		self waittill("trigger", who);
		if(who zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(who.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(who))
		{
			continue;
		}
		if(!who zm_score::can_player_purchase(var_1f29d07e.var_159266ff))
		{
			continue;
		}
		if(var_1f29d07e.var_5fd95ddf != 1)
		{
			continue;
		}
		var_1f29d07e.var_5fd95ddf = 2;
		var_1f29d07e.var_a24b1717 = who;
		bb::function_91f32a58(who, self, var_1f29d07e.var_159266ff, self.targetname, 0, "_trap", "_purchased");
		who zm_score::minus_to_player_score(var_1f29d07e.var_159266ff);
		function_e95944e1();
		function_d84562ad(var_1f29d07e);
		function_8aa04a46();
		who thread zm_audio::create_and_play_dialog("trap", "start");
		wait(var_1f29d07e.var_2ac38075);
		var_1f29d07e.var_5fd95ddf = 3;
		function_8aa04a46();
		function_d84562ad(var_1f29d07e);
		function_e95944e1();
		wait(var_1f29d07e.var_3e336f90);
		var_1f29d07e.var_5fd95ddf = 1;
		function_e95944e1();
		function_d84562ad(var_1f29d07e);
		function_8aa04a46();
	}
}

/*
	Name: function_e95944e1
	Namespace: namespace_a32cae3d
	Checksum: 0x5F2465E1
	Offset: 0x10F8
	Size: 0x11D
	Parameters: 0
	Flags: None
*/
function function_e95944e1()
{
	switch(self.var_5fd95ddf)
	{
		case 1:
		{
			Array::thread_all(self.var_2fbb8bbb, &hint_string, self.var_42b9bb70, self.var_159266ff);
			break;
		}
		case 2:
		{
			Array::thread_all(self.var_2fbb8bbb, &hint_string, self.var_9f1e30f5);
			break;
		}
		case 3:
		{
			Array::thread_all(self.var_2fbb8bbb, &hint_string, self.var_9082d410);
			break;
		}
		case 0:
		{
			Array::thread_all(self.var_2fbb8bbb, &hint_string, self.var_cec4c4e3);
			break;
		}
	}
}

/*
	Name: function_d84562ad
	Namespace: namespace_a32cae3d
	Checksum: 0xEFF06CA4
	Offset: 0x1220
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function function_d84562ad(t_use)
{
	switch(self.var_5fd95ddf)
	{
		case 1:
		{
			function_cfeaece1(self);
			break;
		}
		case 2:
		{
			function_53e7782e(self);
			break;
		}
		case 3:
		{
			function_f24ddcd3(self);
			break;
		}
		case 0:
		{
			function_b099e8e(self);
			break;
		}
	}
}

/*
	Name: function_cfeaece1
	Namespace: namespace_a32cae3d
	Checksum: 0x8BCD29B7
	Offset: 0x12C8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_cfeaece1(t_use)
{
	function_7e393675(undefined);
	self thread function_8e2169c7();
}

/*
	Name: function_53e7782e
	Namespace: namespace_a32cae3d
	Checksum: 0x3EAF304F
	Offset: 0x1320
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_53e7782e(t_use)
{
	if(!self.var_7a01aaae)
	{
		level thread zm_audio::sndMusicSystem_PlayState("trap");
		self.var_7a01aaae = 1;
	}
	var_74a8cf96 = 30;
	self thread function_7e393675(var_74a8cf96);
	wait(0.25);
	self.var_faf8139 playsound("zmb_trap_activate");
	self thread function_8e2169c7();
}

/*
	Name: function_f24ddcd3
	Namespace: namespace_a32cae3d
	Checksum: 0xFABC8336
	Offset: 0x13D8
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function function_f24ddcd3(t_use)
{
	function_7e393675(undefined);
	foreach(var_5404ad23 in self.var_7d0ff937)
	{
		var_5404ad23 moveto(var_5404ad23.origin - VectorScale((0, 0, -1), 32), 0.25);
	}
	wait(0.25);
	self thread function_8e2169c7();
}

/*
	Name: function_b099e8e
	Namespace: namespace_a32cae3d
	Checksum: 0x3FE25A4E
	Offset: 0x14E0
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_b099e8e(t_use)
{
	self thread function_8e2169c7();
}

/*
	Name: function_8aa04a46
	Namespace: namespace_a32cae3d
	Checksum: 0x17A3AA36
	Offset: 0x1520
	Size: 0xAD
	Parameters: 0
	Flags: None
*/
function function_8aa04a46()
{
	switch(self.var_5fd95ddf)
	{
		case 1:
		{
			function_cafd3848();
			break;
		}
		case 2:
		{
			function_d8823dfd();
			self notify("hash_1ec1ce0d", self, self);
			break;
		}
		case 3:
		{
			function_93369338();
			self notify("trap_done", self);
			break;
		}
		case 0:
		{
			function_6b0a262b();
			self notify("trap_done", self);
			break;
		}
	}
}

/*
	Name: function_cafd3848
	Namespace: namespace_a32cae3d
	Checksum: 0x944AFDAA
	Offset: 0x15D8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_cafd3848()
{
	self.var_faf8139 SetInvisibleToAll();
	self.var_faf8139 TriggerEnable(0);
}

/*
	Name: function_d8823dfd
	Namespace: namespace_a32cae3d
	Checksum: 0x46D92123
	Offset: 0x1618
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_d8823dfd()
{
	/#
		println("Dev Block strings are not supported");
	#/
	self.var_faf8139 SetVisibleToAll();
	self.var_faf8139 TriggerEnable(1);
	thread trap_damage();
}

/*
	Name: function_93369338
	Namespace: namespace_a32cae3d
	Checksum: 0xCE326D45
	Offset: 0x1690
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_93369338()
{
	self.var_faf8139 SetInvisibleToAll();
	self.var_faf8139 TriggerEnable(0);
}

/*
	Name: function_6b0a262b
	Namespace: namespace_a32cae3d
	Checksum: 0x9F6A23C4
	Offset: 0x16D0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_6b0a262b()
{
	self.var_faf8139 SetInvisibleToAll();
	self.var_faf8139 TriggerEnable(0);
}

/*
	Name: trap_damage
	Namespace: namespace_a32cae3d
	Checksum: 0x10350FC0
	Offset: 0x1710
	Size: 0x167
	Parameters: 0
	Flags: None
*/
function trap_damage()
{
	self endon("trap_done");
	self.var_faf8139._trap_type = "chain";
	while(1)
	{
		self.var_faf8139 waittill("trigger", ent);
		self.var_faf8139.activated_by_player = self.var_a24b1717;
		if(isPlayer(ent))
		{
			if(ent GetStance() == "prone" || ent function_679da569())
			{
				continue;
			}
			thread function_60ac5038(ent);
		}
		else if(isdefined(ent.marked_for_death))
		{
			continue;
		}
		if(isdefined(ent.missingLegs) && ent.missingLegs)
		{
			continue;
		}
		if(isdefined(ent.var_de36fc8))
		{
			ent [[ent.var_de36fc8]](self);
			continue;
		}
		thread function_35a5835b(ent);
	}
}

/*
	Name: function_60ac5038
	Namespace: namespace_a32cae3d
	Checksum: 0x3C64BFA
	Offset: 0x1880
	Size: 0x131
	Parameters: 1
	Flags: None
*/
function function_60ac5038(ent)
{
	ent endon("death");
	ent endon("disconnect");
	if(ent laststand::player_is_in_laststand())
	{
		return;
	}
	if(isdefined(ent.var_8da8b6a0))
	{
		return;
	}
	ent.var_8da8b6a0 = 1;
	if(!ent hasPerk("specialty_armorvest") || ent.health - 100 < 1)
	{
		ent DoDamage(self.var_820db121, ent.origin);
		ent.var_8da8b6a0 = undefined;
	}
	else
	{
		ent DoDamage(self.var_820db121 / 2, ent.origin);
		wait(self.var_1e59abc0);
		ent.var_8da8b6a0 = undefined;
	}
}

/*
	Name: function_35a5835b
	Namespace: namespace_a32cae3d
	Checksum: 0xA86C9C3B
	Offset: 0x19C0
	Size: 0x1D1
	Parameters: 1
	Flags: None
*/
function function_35a5835b(ent)
{
	ent endon("death");
	if(isdefined(ent.var_8da8b6a0))
	{
		return;
	}
	ent.var_8da8b6a0 = 1;
	if(isdefined(ent.maxhealth) && self.var_12a7c9a2 >= ent.maxhealth && !isVehicle(ent))
	{
		function_a99cc5f4(ent);
		ent DoDamage(ent.maxhealth * 0.5, ent.origin, self.var_faf8139, self.var_faf8139, "MOD_GRENADE");
		wait(self.var_8bfee5e9);
		function_a99cc5f4(ent);
		ent DoDamage(ent.maxhealth, ent.origin, self.var_faf8139, self.var_faf8139, "MOD_GRENADE");
		ent.var_8da8b6a0 = undefined;
	}
	else
	{
		function_a99cc5f4(ent);
		ent DoDamage(self.var_12a7c9a2, ent.origin, self.var_faf8139, self.var_faf8139, "MOD_GRENADE");
		wait(self.var_8bfee5e9);
		ent.var_8da8b6a0 = undefined;
	}
}

/*
	Name: function_a99cc5f4
	Namespace: namespace_a32cae3d
	Checksum: 0x1C926487
	Offset: 0x1BA0
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function function_a99cc5f4(ent)
{
	if(!isVehicle(ent) && ent.team != "allies")
	{
		ent.a.gib_ref = Array::random(Array("guts", "right_arm", "left_arm", "head"));
		ent thread zombie_death::do_gib();
		if(isPlayer(self.var_a24b1717))
		{
			self.var_a24b1717 zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_TRAP");
		}
	}
}

/*
	Name: function_8e2169c7
	Namespace: namespace_a32cae3d
	Checksum: 0xD20AFD6
	Offset: 0x1C90
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function function_8e2169c7()
{
	self.var_7d0ff937[0] clientfield::set("trap_chain_state", self.var_5fd95ddf);
}

/*
	Name: hint_string
	Namespace: namespace_a32cae3d
	Checksum: 0x2FBB851F
	Offset: 0x1CD0
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function hint_string(string, cost)
{
	if(isdefined(cost))
	{
		self setHintString(string, cost);
	}
	else
	{
		self setHintString(string);
	}
	self setcursorhint("HINT_NOICON");
}

/*
	Name: function_7e393675
	Namespace: namespace_a32cae3d
	Checksum: 0x98782565
	Offset: 0x1D58
	Size: 0x50D
	Parameters: 1
	Flags: None
*/
function function_7e393675(n_time)
{
	switch(self.var_5fd95ddf)
	{
		case 1:
		{
			foreach(var_5404ad23 in self.var_7d0ff937)
			{
				var_5404ad23 thread scene::Play("p7_fxanim_zm_zod_chain_trap_heart_low_bundle", var_5404ad23);
			}
			break;
		}
		case 2:
		{
			foreach(var_5404ad23 in self.var_7d0ff937)
			{
				var_5404ad23 scene::stop("p7_fxanim_zm_zod_chain_trap_heart_low_bundle");
			}
			for(i = 0; i < self.var_7d0ff937.size; i++)
			{
				var_5404ad23 = self.var_7d0ff937[i];
				if(i + 1 == self.var_7d0ff937.size)
				{
					var_5404ad23 scene::Play("p7_fxanim_zm_zod_chain_trap_heart_pull_bundle", var_5404ad23);
					continue;
				}
				var_5404ad23 thread scene::Play("p7_fxanim_zm_zod_chain_trap_heart_pull_bundle", var_5404ad23);
			}
			n_wait = n_time / 3;
			foreach(var_5404ad23 in self.var_7d0ff937)
			{
				var_5404ad23 thread scene::Play("p7_fxanim_zm_zod_chain_trap_heart_low_bundle", var_5404ad23);
			}
			wait(n_wait);
			foreach(var_5404ad23 in self.var_7d0ff937)
			{
				var_5404ad23 scene::stop("p7_fxanim_zm_zod_chain_trap_heart_low_bundle");
				var_5404ad23 thread scene::Play("p7_fxanim_zm_zod_chain_trap_heart_med_bundle", var_5404ad23);
			}
			wait(n_wait);
			foreach(var_5404ad23 in self.var_7d0ff937)
			{
				var_5404ad23 scene::stop("p7_fxanim_zm_zod_chain_trap_heart_med_bundle");
				var_5404ad23 thread scene::Play("p7_fxanim_zm_zod_chain_trap_heart_fast_bundle", var_5404ad23);
			}
			wait(n_wait);
			foreach(var_5404ad23 in self.var_7d0ff937)
			{
				var_5404ad23 scene::stop("p7_fxanim_zm_zod_chain_trap_heart_fast_bundle");
			}
			foreach(var_5404ad23 in self.var_7d0ff937)
			{
				var_5404ad23 thread scene::Play("p7_fxanim_zm_zod_chain_trap_heart_low_bundle", var_5404ad23);
			}
			break;
		}
		case 3:
		{
			break;
		}
		case 0:
		{
			break;
		}
	}
}

/*
	Name: function_9b385ca5
	Namespace: namespace_a32cae3d
	Checksum: 0x99EC1590
	Offset: 0x2270
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
}

/*
	Name: function_5fba2032
	Namespace: namespace_a32cae3d
	Checksum: 0x99EC1590
	Offset: 0x2280
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_d8d03071;

/*
	Name: function_a32cae3d
	Namespace: namespace_d8d03071
	Checksum: 0xB92A6FC4
	Offset: 0x2290
	Size: 0x475
	Parameters: 0
	Flags: 6
*/
function private autoexec function_a32cae3d()
{
	classes.var_a32cae3d[0] = spawnstruct();
	classes.var_a32cae3d[0].__vtable[1606033458] = &namespace_a32cae3d::function_5fba2032;
	classes.var_a32cae3d[0].__vtable[-1690805083] = &namespace_a32cae3d::function_9b385ca5;
	classes.var_a32cae3d[0].__vtable[2117678709] = &namespace_a32cae3d::function_7e393675;
	classes.var_a32cae3d[0].__vtable[-1654312830] = &namespace_a32cae3d::hint_string;
	classes.var_a32cae3d[0].__vtable[-1910412857] = &namespace_a32cae3d::function_8e2169c7;
	classes.var_a32cae3d[0].__vtable[-1449343500] = &namespace_a32cae3d::function_a99cc5f4;
	classes.var_a32cae3d[0].__vtable[900039515] = &namespace_a32cae3d::function_35a5835b;
	classes.var_a32cae3d[0].__vtable[1621905464] = &namespace_a32cae3d::function_60ac5038;
	classes.var_a32cae3d[0].__vtable[530915776] = &namespace_a32cae3d::trap_damage;
	classes.var_a32cae3d[0].__vtable[1795827243] = &namespace_a32cae3d::function_6b0a262b;
	classes.var_a32cae3d[0].__vtable[-1825139912] = &namespace_a32cae3d::function_93369338;
	classes.var_a32cae3d[0].__vtable[-662553091] = &namespace_a32cae3d::function_d8823dfd;
	classes.var_a32cae3d[0].__vtable[-889374648] = &namespace_a32cae3d::function_cafd3848;
	classes.var_a32cae3d[0].__vtable[-1969206714] = &namespace_a32cae3d::function_8aa04a46;
	classes.var_a32cae3d[0].__vtable[185179790] = &namespace_a32cae3d::function_b099e8e;
	classes.var_a32cae3d[0].__vtable[-229778221] = &namespace_a32cae3d::function_f24ddcd3;
	classes.var_a32cae3d[0].__vtable[1407678510] = &namespace_a32cae3d::function_53e7782e;
	classes.var_a32cae3d[0].__vtable[-806687519] = &namespace_a32cae3d::function_cfeaece1;
	classes.var_a32cae3d[0].__vtable[-666541395] = &namespace_a32cae3d::function_d84562ad;
	classes.var_a32cae3d[0].__vtable[-380025631] = &namespace_a32cae3d::function_e95944e1;
	classes.var_a32cae3d[0].__vtable[279984018] = &namespace_a32cae3d::function_10b03792;
	classes.var_a32cae3d[0].__vtable[469498444] = &namespace_a32cae3d::function_1bfbfa4c;
	classes.var_a32cae3d[0].__vtable[-194045205] = &namespace_a32cae3d::function_f46f1aeb;
}

