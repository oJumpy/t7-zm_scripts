#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_util;

#namespace namespace_a0023ae3;

/*
	Name: init
	Namespace: namespace_a0023ae3
	Checksum: 0x8CE06DDE
	Offset: 0x3F8
	Size: 0x183
	Parameters: 2
	Flags: None
*/
function init(var_53ca5e30, var_8b2e09ca)
{
	self.var_cac6e7ae = struct::get(var_53ca5e30, "targetname");
	self.var_9346a886 = var_8b2e09ca;
	self.var_89a7aad3 = 30;
	self.var_b46f18d4 = 0;
	self.var_35a35f82 = 100 / self.var_89a7aad3 * 0.1;
	self.var_3895bf80 = 5;
	self.var_3218a534 = self.var_3895bf80;
	self.var_a19cef5d = 220;
	self.var_d109e848 = self.var_a19cef5d * self.var_a19cef5d;
	self.var_13eba724 = self.var_a19cef5d;
	self.var_8070fe37 = self.var_13eba724 * self.var_13eba724;
	self.var_3647811a = &"ZM_ZOD_DEFEND_AREA_UNAVAILABLE";
	self.var_463d711d = &"ZM_ZOD_DEFEND_AREA_AVAILABLE";
	self.var_bfd4728d = &"ZM_ZOD_DEFEND_AREA_IN_PROGRESS";
	self.var_602ef511 = &function_bccaba63;
	var_38851ded = &function_86206edf;
	function_7a82ab47();
	self.var_5fd95ddf = 0;
	self.var_784ea913 = 0;
	function_f494e855();
}

/*
	Name: function_7a82ab47
	Namespace: namespace_a0023ae3
	Checksum: 0xA0DBF1B5
	Offset: 0x588
	Size: 0x1B7
	Parameters: 0
	Flags: None
*/
function function_7a82ab47()
{
	self.var_ce363bed = GetEntArray("ritual_zombie_spawner", "targetname");
	a_s_spawn_points = struct::get_array(self.var_9346a886, "targetname");
	foreach(s_spawn_point in a_s_spawn_points)
	{
		var_f9efb018 = spawn("script_model", s_spawn_point.origin);
		var_f9efb018 SetModel("tag_origin");
		var_f9efb018.origin = s_spawn_point.origin;
		var_f9efb018.angles = s_spawn_point.angles;
		if(!isdefined(self.var_c2c38644))
		{
			self.var_c2c38644 = [];
		}
		else if(!IsArray(self.var_c2c38644))
		{
			self.var_c2c38644 = Array(self.var_c2c38644);
		}
		self.var_c2c38644[self.var_c2c38644.size] = var_f9efb018;
	}
}

/*
	Name: function_ebd4e698
	Namespace: namespace_a0023ae3
	Checksum: 0x71FD5A1D
	Offset: 0x748
	Size: 0x17
	Parameters: 1
	Flags: None
*/
function function_ebd4e698(var_175bc9b5)
{
	self.var_602ef511 = var_175bc9b5;
}

/*
	Name: function_4cc0ffc1
	Namespace: namespace_a0023ae3
	Checksum: 0xF7E639A7
	Offset: 0x768
	Size: 0x67
	Parameters: 5
	Flags: None
*/
function function_4cc0ffc1(var_4204f55f, func_start, var_ca8be47e, var_8cd80362, arg1)
{
	self.var_f68b577b = var_4204f55f;
	self.var_542aaa76 = func_start;
	self.var_46491092 = var_ca8be47e;
	self.var_146da93e = var_8cd80362;
	self.var_20a1be38 = arg1;
}

/*
	Name: function_5b8cdc04
	Namespace: namespace_a0023ae3
	Checksum: 0x4D1ABDB8
	Offset: 0x7D8
	Size: 0x53
	Parameters: 4
	Flags: None
*/
function function_5b8cdc04(var_3c44c0e6, var_9f159069, var_12fe55ea, var_71882fb8)
{
	self.var_56b146ea = var_3c44c0e6;
	self.var_3dc82e65 = var_9f159069;
	self.var_290027ee = var_12fe55ea;
	self.var_8be792c4 = var_71882fb8;
}

/*
	Name: function_b9dda40b
	Namespace: namespace_a0023ae3
	Checksum: 0x58CBDD78
	Offset: 0x838
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function function_b9dda40b(var_8a526dce, var_11689cb)
{
	self.var_b8236eca = GetEnt(var_8a526dce, "targetname");
	self.var_52d55b67 = GetEnt(var_11689cb, "targetname");
	/#
		Assert(isdefined(self.var_b8236eca), "Dev Block strings are not supported");
	#/
	/#
		Assert(isdefined(self.var_52d55b67), "Dev Block strings are not supported");
	#/
}

/*
	Name: function_27323b36
	Namespace: namespace_a0023ae3
	Checksum: 0x82F5A088
	Offset: 0x8F8
	Size: 0x33
	Parameters: 1
	Flags: None
*/
function function_27323b36(n_duration)
{
	self.var_89a7aad3 = n_duration;
	self.var_35a35f82 = 100 / self.var_89a7aad3 * 0.1;
}

/*
	Name: start
	Namespace: namespace_a0023ae3
	Checksum: 0xD8419F75
	Offset: 0x938
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function start()
{
	var_329acd7d = (110, 110, 128);
	self.var_28f7dec3 = namespace_8e578893::function_c17c0335(self.var_cac6e7ae.origin, self.var_cac6e7ae.angles, var_329acd7d, 1);
	self.var_28f7dec3.var_501122d5 = self;
	self.var_28f7dec3.prompt_and_visibility_func = self.var_602ef511;
	self.var_784ea913 = 1;
	function_f494e855();
	self thread function_86206edf();
}

/*
	Name: function_a7fe9183
	Namespace: namespace_a0023ae3
	Checksum: 0x2BCE6B1E
	Offset: 0xA08
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_a7fe9183(b_is_available)
{
	if(b_is_available && self.var_5fd95ddf == 0)
	{
		self.var_5fd95ddf = 1;
	}
	else if(!b_is_available && self.var_5fd95ddf == 1)
	{
		self.var_5fd95ddf = 0;
	}
	function_f494e855();
}

/*
	Name: function_58ff5d0b
	Namespace: namespace_a0023ae3
	Checksum: 0x27E6D9F
	Offset: 0xA80
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function function_58ff5d0b(player)
{
	if(!self.var_784ea913)
	{
		return &"";
	}
	switch(self.var_5fd95ddf)
	{
		case 0:
		{
			return self.var_3647811a;
		}
		case 1:
		{
			return self.var_463d711d;
		}
		case default:
		{
			return &"";
		}
	}
}

/*
	Name: function_c9c18baa
	Namespace: namespace_a0023ae3
	Checksum: 0x8E2E5971
	Offset: 0xAF0
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function function_c9c18baa(player)
{
	if(isdefined(player.beastmode) && player.beastmode)
	{
		return 0;
	}
	if(isdefined(level.var_522a1f61) && level.var_522a1f61)
	{
		return 0;
	}
	if(self.var_784ea913)
	{
		switch(self.var_5fd95ddf)
		{
			case 0:
			case 1:
			{
				return 1;
			}
			case default:
			{
				break;
			}
		}
	}
	return 0;
}

/*
	Name: function_bccaba63
	Namespace: namespace_a0023ae3
	Checksum: 0xC818E23F
	Offset: 0xB90
	Size: 0xBF
	Parameters: 1
	Flags: None
*/
function function_bccaba63(player)
{
	var_36f3fe5b = function_c9c18baa(self.stub.var_501122d5);
	if(var_36f3fe5b)
	{
		str_msg = function_58ff5d0b(self.stub.var_501122d5);
		self setHintString(str_msg);
		thread function_4e035595(player);
	}
	else
	{
		self setHintString(&"");
	}
	return var_36f3fe5b;
}

/*
	Name: function_4e035595
	Namespace: namespace_a0023ae3
	Checksum: 0x391EFB7F
	Offset: 0xC58
	Size: 0xF3
	Parameters: 1
	Flags: None
*/
function function_4e035595(player)
{
	self endon("disconnect");
	if(isdefined(player.var_b999c630) && player.var_b999c630 || !level flag::get("ritual_in_progress"))
	{
		return;
	}
	player.var_b999c630 = 1;
	if(zm_utility::is_player_valid(player))
	{
		player thread namespace_8e578893::function_55f114f9("zmInventory.widget_quest_items", 3.5);
		player thread namespace_8e578893::show_infotext_for_duration("ZM_ZOD_UI_RITUAL_BUSY", 3.5);
	}
	wait(3.5);
	player.var_b999c630 = 0;
}

/*
	Name: function_f494e855
	Namespace: namespace_a0023ae3
	Checksum: 0x8F9FF512
	Offset: 0xD58
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function function_f494e855()
{
	if(isdefined(self.var_28f7dec3))
	{
		self.var_28f7dec3 zm_unitrigger::run_visibility_function_for_all_triggers();
	}
}

/*
	Name: function_86206edf
	Namespace: namespace_a0023ae3
	Checksum: 0x96CCCB54
	Offset: 0xD90
	Size: 0x15B
	Parameters: 0
	Flags: None
*/
function function_86206edf()
{
	self endon("hash_383cb307");
	while(1)
	{
		self.var_28f7dec3 waittill("trigger", e_triggerer);
		if(e_triggerer zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_triggerer, 1, 1))
		{
			continue;
		}
		if(self.var_5fd95ddf != 1)
		{
			continue;
		}
		if(isdefined(self.var_f68b577b) && [[self.var_f68b577b]](self.var_20a1be38) == 0)
		{
			continue;
		}
		self.var_5fd95ddf = 2;
		self.var_c8286d42 = e_triggerer;
		function_f494e855();
		[[self.var_542aaa76]](self.var_20a1be38, self.var_c8286d42);
		self thread function_76c664d9();
		self thread function_dab6014d();
		while(self.var_5fd95ddf != 1)
		{
			wait(1);
		}
	}
}

/*
	Name: function_76c664d9
	Namespace: namespace_a0023ae3
	Checksum: 0x4EB6C0E1
	Offset: 0xEF8
	Size: 0x403
	Parameters: 0
	Flags: None
*/
function function_76c664d9()
{
	/#
		println("Dev Block strings are not supported");
	#/
	self.var_b46f18d4 = 0;
	self.var_3218a534 = self.var_3895bf80;
	self.var_9e054a5d = [];
	var_db69778c = level.activePlayers.size;
	var_d416c150 = function_e58747ab();
	var_1062af15 = var_d416c150.size;
	self.var_89a7aad3 = function_d9a5609b(var_db69778c, var_1062af15);
	self.var_35a35f82 = 100 / self.var_89a7aad3 * 0.1;
	while(self.var_b46f18d4 < 100 && self.var_3218a534 > 0)
	{
		var_d416c150 = function_e58747ab();
		var_1062af15 = var_d416c150.size;
		foreach(player in level.activePlayers)
		{
			if(!zm_utility::is_player_valid(player, 1, 1))
			{
				continue;
			}
			if(function_1a94b9be(player))
			{
				if(!isdefined(player.var_84f1bc44))
				{
					player thread namespace_8e578893::function_6edf48d5(5);
					Array::add(self.var_9e054a5d, player, 0);
					player.var_84f1bc44 = 1;
				}
				if(!player.var_84f1bc44)
				{
					player thread namespace_8e578893::function_6edf48d5(5);
					player.var_84f1bc44 = 1;
					self function_19d7a318(player);
				}
				continue;
			}
			if(zm_utility::is_player_valid(player, 1, 1))
			{
				if(isdefined(player.var_84f1bc44) && player.var_84f1bc44)
				{
					player thread namespace_8e578893::function_6edf48d5(0);
					player.var_84f1bc44 = 0;
					self function_19d7a318(player);
					player.var_fed8a8e6 = player OpenLUIMenu(self.var_3dc82e65);
				}
			}
		}
		var_2e902fc4 = self.var_35a35f82;
		self.var_b46f18d4 = self.var_b46f18d4 + var_2e902fc4;
		if(var_1062af15 > 0)
		{
			self.var_b46f18d4 = math::clamp(self.var_b46f18d4, 0, 100);
			self.var_3218a534 = self.var_3895bf80;
		}
		else
		{
			self.var_3218a534 = self.var_3218a534 - 0.1;
		}
		wait(0.1);
	}
	if(self.var_b46f18d4 == 100)
	{
		function_49b4e0e3();
	}
	else
	{
		function_17690ec3();
	}
}

/*
	Name: function_d9a5609b
	Namespace: namespace_a0023ae3
	Checksum: 0x2D8C6303
	Offset: 0x1308
	Size: 0x15D
	Parameters: 2
	Flags: None
*/
function function_d9a5609b(n_players_total, var_1062af15)
{
	if(n_players_total == 1)
	{
		return 20;
	}
	if(n_players_total == 2 && var_1062af15 == 1)
	{
		return 30;
	}
	if(n_players_total == 2 && var_1062af15 == 2)
	{
		return 20;
	}
	if(n_players_total == 3 && var_1062af15 == 1)
	{
		return 40;
	}
	if(n_players_total == 3 && var_1062af15 == 2)
	{
		return 30;
	}
	if(n_players_total == 3 && var_1062af15 == 3)
	{
		return 20;
	}
	if(n_players_total == 4 && var_1062af15 == 1)
	{
		return 60;
	}
	if(n_players_total == 4 && var_1062af15 == 2)
	{
		return 40;
	}
	if(n_players_total == 4 && var_1062af15 == 3)
	{
		return 30;
	}
	if(n_players_total == 4 && var_1062af15 == 4)
	{
		return 20;
	}
	return 30;
}

/*
	Name: function_dab6014d
	Namespace: namespace_a0023ae3
	Checksum: 0x500FF50D
	Offset: 0x1470
	Size: 0x1A1
	Parameters: 0
	Flags: None
*/
function function_dab6014d()
{
	self.var_a64ccb9c = [];
	while(self.var_5fd95ddf == 2)
	{
		self.var_a64ccb9c = Array::remove_dead(self.var_a64ccb9c, 0);
		var_2021b6 = 4;
		if(level.round_number < 4)
		{
			var_2021b6 = 6;
		}
		else if(level.round_number < 6)
		{
			var_2021b6 = 5;
		}
		if(self.var_a64ccb9c.size < var_2021b6)
		{
			s_spawn_point = function_7e9f0faf();
			ai = zombie_utility::spawn_zombie(self.var_ce363bed[0], "defend_event_zombie", s_spawn_point);
			if(!isdefined(ai))
			{
				/#
					println("Dev Block strings are not supported");
				#/
				continue;
			}
			ai.var_81ac9e79 = 1;
			ai thread namespace_1f61c67f::function_2d0c5aa1(s_spawn_point);
			ai thread function_877a7365();
			Array::add(self.var_a64ccb9c, ai, 0);
		}
		wait(level.zombie_vars["zombie_spawn_delay"]);
	}
}

/*
	Name: function_df5ae14e
	Namespace: namespace_a0023ae3
	Checksum: 0xDC74743C
	Offset: 0x1620
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_df5ae14e(ai_zombie)
{
	ai_zombie waittill("death");
	ai_zombie clientfield::set("keeper_fx", 0);
}

/*
	Name: function_877a7365
	Namespace: namespace_a0023ae3
	Checksum: 0x726908E6
	Offset: 0x1668
	Size: 0x1DF
	Parameters: 0
	Flags: None
*/
function function_877a7365()
{
	self endon("death");
	while(1)
	{
		var_c7ca004c = [];
		foreach(player in level.activePlayers)
		{
			if(zm_utility::is_player_valid(player) && (isdefined(player.var_84f1bc44) && player.var_84f1bc44))
			{
				if(!isdefined(var_c7ca004c))
				{
					var_c7ca004c = [];
				}
				else if(!IsArray(var_c7ca004c))
				{
					var_c7ca004c = Array(var_c7ca004c);
				}
				var_c7ca004c[var_c7ca004c.size] = player;
			}
		}
		var_186e36e = Array::random(var_c7ca004c);
		while(isalive(var_186e36e) && (!isdefined(var_186e36e.beastmode) && var_186e36e.beastmode) && !var_186e36e laststand::player_is_in_laststand())
		{
			self SetGoal(var_186e36e);
			self waittill("goal");
		}
		wait(0.1);
	}
}

/*
	Name: function_7e9f0faf
	Namespace: namespace_a0023ae3
	Checksum: 0xA8776FA2
	Offset: 0x1850
	Size: 0x147
	Parameters: 0
	Flags: None
*/
function function_7e9f0faf()
{
	a_valid_spawn_points = [];
	b_all_points_used = 0;
	while(!a_valid_spawn_points.size)
	{
		foreach(s_spawn_point in self.var_c2c38644)
		{
			if(!isdefined(s_spawn_point.spawned_zombie) || b_all_points_used)
			{
				s_spawn_point.spawned_zombie = 0;
			}
			if(!s_spawn_point.spawned_zombie)
			{
				Array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if(!a_valid_spawn_points.size)
		{
			b_all_points_used = 1;
		}
	}
	s_spawn_point = Array::random(a_valid_spawn_points);
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}

/*
	Name: function_49b4e0e3
	Namespace: namespace_a0023ae3
	Checksum: 0x421A8147
	Offset: 0x19A0
	Size: 0x215
	Parameters: 0
	Flags: None
*/
function function_49b4e0e3()
{
	/#
		println("Dev Block strings are not supported");
	#/
	self.var_5fd95ddf = 3;
	function_c9ad9349();
	foreach(s_spawn_point in self.var_c2c38644)
	{
		s_spawn_point delete();
	}
	self.var_c2c38644 = [];
	self thread function_8d5cae10();
	zm_unitrigger::unregister_unitrigger(self.var_28f7dec3);
	self.var_28f7dec3 = undefined;
	foreach(player in self.var_9e054a5d)
	{
		if(!isdefined(player))
		{
			continue;
		}
		player thread namespace_8e578893::function_6edf48d5(6);
		player.var_84f1bc44 = undefined;
		self thread function_56842015(player);
		player zm_score::add_to_player_score(500);
	}
	[[self.var_46491092]](self.var_20a1be38, self.var_9e054a5d);
	self notify("hash_383cb307");
}

/*
	Name: function_17690ec3
	Namespace: namespace_a0023ae3
	Checksum: 0x1A3A4BD8
	Offset: 0x1BC0
	Size: 0x147
	Parameters: 0
	Flags: None
*/
function function_17690ec3()
{
	/#
		println("Dev Block strings are not supported");
	#/
	self.var_5fd95ddf = 1;
	function_f494e855();
	function_c9ad9349();
	self.var_c2c38644 = [];
	self thread function_7a82ab47();
	foreach(player in self.var_9e054a5d)
	{
		if(!isdefined(player))
		{
			continue;
		}
		player thread namespace_8e578893::function_6edf48d5(0);
		player.var_84f1bc44 = undefined;
		self thread function_d2445eb5(player);
	}
	[[self.var_146da93e]](self.var_20a1be38);
}

/*
	Name: function_c9ad9349
	Namespace: namespace_a0023ae3
	Checksum: 0xB6C9E505
	Offset: 0x1D10
	Size: 0xC9
	Parameters: 0
	Flags: None
*/
function function_c9ad9349()
{
	foreach(zombie in self.var_a64ccb9c)
	{
		if(isalive(zombie) && (isdefined(zombie.allowdeath) && zombie.allowdeath))
		{
			zombie kill();
		}
	}
}

/*
	Name: get_progress_rate
	Namespace: namespace_a0023ae3
	Checksum: 0x50673FE9
	Offset: 0x1DE8
	Size: 0x39
	Parameters: 2
	Flags: None
*/
function get_progress_rate(var_1062af15, n_players_total)
{
	var_47c092c2 = var_1062af15 / n_players_total * self.var_35a35f82;
	return var_47c092c2;
}

/*
	Name: get_state
	Namespace: namespace_a0023ae3
	Checksum: 0x14CBC257
	Offset: 0x1E30
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_state()
{
	return self.var_5fd95ddf;
}

/*
	Name: function_e58747ab
	Namespace: namespace_a0023ae3
	Checksum: 0x1A05B52F
	Offset: 0x1E48
	Size: 0xD5
	Parameters: 0
	Flags: None
*/
function function_e58747ab()
{
	var_d416c150 = [];
	foreach(player in level.activePlayers)
	{
		if(zm_utility::is_player_valid(player) && function_1a94b9be(player))
		{
			Array::add(var_d416c150, player);
		}
	}
	return var_d416c150;
}

/*
	Name: function_1a94b9be
	Namespace: namespace_a0023ae3
	Checksum: 0x6DED2910
	Offset: 0x1F28
	Size: 0x101
	Parameters: 1
	Flags: None
*/
function function_1a94b9be(player)
{
	if(isdefined(self.var_b8236eca))
	{
		if(zm_utility::is_player_valid(player, 1, 1) && player istouching(self.var_b8236eca))
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	if(zm_utility::is_player_valid(player, 1, 1) && Distance2DSquared(player.origin, self.var_cac6e7ae.origin) < self.var_d109e848 && player.origin[2] > self.var_cac6e7ae.origin[2] + -20)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

/*
	Name: function_4721f0d
	Namespace: namespace_a0023ae3
	Checksum: 0xC02B5ADB
	Offset: 0x2038
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function function_4721f0d()
{
	return self.var_b46f18d4 / 100;
}

/*
	Name: function_56842015
	Namespace: namespace_a0023ae3
	Checksum: 0x30A4562C
	Offset: 0x2050
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_56842015(player)
{
	self function_19d7a318(player);
	if(isdefined(player) && isdefined(player.sessionstate) && player.sessionstate == "spectator")
	{
		return;
	}
	wait(3);
	self function_19d7a318(player);
}

/*
	Name: function_d2445eb5
	Namespace: namespace_a0023ae3
	Checksum: 0x6908AEEB
	Offset: 0x20D8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_d2445eb5(player)
{
	self function_19d7a318(player);
	if(isdefined(player) && player.sessionstate === "spectator")
	{
		return;
	}
	wait(3);
	self function_19d7a318(player);
}

/*
	Name: function_19d7a318
	Namespace: namespace_a0023ae3
	Checksum: 0x835059C9
	Offset: 0x2150
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function function_19d7a318(player)
{
	if(isdefined(player) && player.sessionstate === "spectator")
	{
		return;
	}
	if(isdefined(player) && isdefined(player.var_fed8a8e6))
	{
		var_5def8893 = player GetLuiMenu(self.var_56b146ea);
		var_b5e415a4 = player GetLuiMenu(self.var_3dc82e65);
		if(isdefined(var_5def8893) || isdefined(var_b5e415a4))
		{
			player CloseLUIMenu(player.var_fed8a8e6);
			player.var_fed8a8e6 = undefined;
		}
	}
}

/*
	Name: function_8d5cae10
	Namespace: namespace_a0023ae3
	Checksum: 0x4378E3F1
	Offset: 0x2240
	Size: 0x379
	Parameters: 0
	Flags: None
*/
function function_8d5cae10()
{
	level LUI::screen_flash(0.2, 0.5, 1, 0.8, "white");
	wait(0.2);
	a_ai_zombies = function_a5e2032d();
	var_6b1085eb = [];
	foreach(ai_zombie in a_ai_zombies)
	{
		if(isdefined(ai_zombie.ignore_nuke) && ai_zombie.ignore_nuke)
		{
			continue;
		}
		if(isdefined(ai_zombie.marked_for_death) && ai_zombie.marked_for_death)
		{
			continue;
		}
		if(isdefined(ai_zombie.nuke_damage_func))
		{
			ai_zombie thread [[ai_zombie.nuke_damage_func]]();
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(ai_zombie))
		{
			continue;
		}
		ai_zombie.marked_for_death = 1;
		ai_zombie.nuked = 1;
		var_6b1085eb[var_6b1085eb.size] = ai_zombie;
	}
	foreach(var_f92b3d80 in var_6b1085eb)
	{
		if(!isdefined(var_f92b3d80))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80))
		{
			continue;
		}
		if(i < 5 && (!isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog))
		{
			var_f92b3d80 thread zombie_death::flame_death_fx();
		}
		if(!(isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog))
		{
			if(!(isdefined(var_f92b3d80.no_gib) && var_f92b3d80.no_gib))
			{
				var_f92b3d80 zombie_utility::zombie_head_gib();
			}
		}
		var_f92b3d80 DoDamage(var_f92b3d80.health, var_f92b3d80.origin);
		if(!level flag::get("special_round"))
		{
			if(var_f92b3d80.archetype == "margwa")
			{
				level.var_e0191376++;
				continue;
			}
			level.zombie_total++;
		}
	}
}

/*
	Name: function_a5e2032d
	Namespace: namespace_a0023ae3
	Checksum: 0xAFC1AB88
	Offset: 0x25C8
	Size: 0x35B
	Parameters: 0
	Flags: None
*/
function function_a5e2032d()
{
	var_7591ca03 = zm_zonemgr::get_zone_from_position(self.var_cac6e7ae.origin);
	if(IsSubStr(var_7591ca03, "burlesque"))
	{
		var_b42fba6b = "burlesque";
	}
	else if(IsSubStr(var_7591ca03, "gym"))
	{
		var_b42fba6b = "gym";
	}
	else if(IsSubStr(var_7591ca03, "brothel"))
	{
		var_b42fba6b = "brothel";
	}
	else if(IsSubStr(var_7591ca03, "magician"))
	{
		var_b42fba6b = "magician";
	}
	else
	{
		var_b42fba6b = "pap";
	}
	var_b5a606c0 = [];
	foreach(str_zone_name in level.active_zone_names)
	{
		if(IsSubStr(str_zone_name, var_b42fba6b))
		{
			if(!isdefined(var_b5a606c0))
			{
				var_b5a606c0 = [];
			}
			else if(!IsArray(var_b5a606c0))
			{
				var_b5a606c0 = Array(var_b5a606c0);
			}
			var_b5a606c0[var_b5a606c0.size] = str_zone_name;
		}
	}
	a_ai_zombies = GetAITeamArray(level.zombie_team);
	a_ai_zombies = ArraySort(a_ai_zombies, self.var_cac6e7ae.origin);
	i = 0;
	while(i < a_ai_zombies.size)
	{
		var_31a4faf3 = 0;
		foreach(var_7da234a9 in var_b5a606c0)
		{
			if(a_ai_zombies[i] zm_zonemgr::entity_in_zone(var_7da234a9))
			{
				var_31a4faf3 = 1;
				i++;
				break;
			}
		}
		if(!var_31a4faf3)
		{
			ArrayRemoveValue(a_ai_zombies, a_ai_zombies[i]);
		}
	}
	return a_ai_zombies;
}

/*
	Name: function_9b385ca5
	Namespace: namespace_a0023ae3
	Checksum: 0x99EC1590
	Offset: 0x2930
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
}

/*
	Name: function_5fba2032
	Namespace: namespace_a0023ae3
	Checksum: 0x99EC1590
	Offset: 0x2940
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

#namespace namespace_ec1f3b4;

/*
	Name: function_a0023ae3
	Namespace: namespace_ec1f3b4
	Checksum: 0xC823682
	Offset: 0x2950
	Size: 0x6E5
	Parameters: 0
	Flags: 6
*/
function private autoexec function_a0023ae3()
{
	classes.var_a0023ae3[0] = spawnstruct();
	classes.var_a0023ae3[0].__vtable[1606033458] = &namespace_a0023ae3::function_5fba2032;
	classes.var_a0023ae3[0].__vtable[-1690805083] = &namespace_a0023ae3::function_9b385ca5;
	classes.var_a0023ae3[0].__vtable[-1511914707] = &namespace_a0023ae3::function_a5e2032d;
	classes.var_a0023ae3[0].__vtable[-1923305968] = &namespace_a0023ae3::function_8d5cae10;
	classes.var_a0023ae3[0].__vtable[433562392] = &namespace_a0023ae3::function_19d7a318;
	classes.var_a0023ae3[0].__vtable[-767271243] = &namespace_a0023ae3::function_d2445eb5;
	classes.var_a0023ae3[0].__vtable[1451499541] = &namespace_a0023ae3::function_56842015;
	classes.var_a0023ae3[0].__vtable[74587917] = &namespace_a0023ae3::function_4721f0d;
	classes.var_a0023ae3[0].__vtable[445954494] = &namespace_a0023ae3::function_1a94b9be;
	classes.var_a0023ae3[0].__vtable[-444119125] = &namespace_a0023ae3::function_e58747ab;
	classes.var_a0023ae3[0].__vtable[1194857509] = &namespace_a0023ae3::get_state;
	classes.var_a0023ae3[0].__vtable[168524620] = &namespace_a0023ae3::get_progress_rate;
	classes.var_a0023ae3[0].__vtable[-911371447] = &namespace_a0023ae3::function_c9ad9349;
	classes.var_a0023ae3[0].__vtable[392761027] = &namespace_a0023ae3::function_17690ec3;
	classes.var_a0023ae3[0].__vtable[1236590819] = &namespace_a0023ae3::function_49b4e0e3;
	classes.var_a0023ae3[0].__vtable[2124353455] = &namespace_a0023ae3::function_7e9f0faf;
	classes.var_a0023ae3[0].__vtable[-2022018203] = &namespace_a0023ae3::function_877a7365;
	classes.var_a0023ae3[0].__vtable[-547692210] = &namespace_a0023ae3::function_df5ae14e;
	classes.var_a0023ae3[0].__vtable[-625606323] = &namespace_a0023ae3::function_dab6014d;
	classes.var_a0023ae3[0].__vtable[-643473253] = &namespace_a0023ae3::function_d9a5609b;
	classes.var_a0023ae3[0].__vtable[1992713433] = &namespace_a0023ae3::function_76c664d9;
	classes.var_a0023ae3[0].__vtable[-2044694817] = &namespace_a0023ae3::function_86206edf;
	classes.var_a0023ae3[0].__vtable[-191567787] = &namespace_a0023ae3::function_f494e855;
	classes.var_a0023ae3[0].__vtable[1308841365] = &namespace_a0023ae3::function_4e035595;
	classes.var_a0023ae3[0].__vtable[-1127564701] = &namespace_a0023ae3::function_bccaba63;
	classes.var_a0023ae3[0].__vtable[-910062678] = &namespace_a0023ae3::function_c9c18baa;
	classes.var_a0023ae3[0].__vtable[1493130507] = &namespace_a0023ae3::function_58ff5d0b;
	classes.var_a0023ae3[0].__vtable[-1476488829] = &namespace_a0023ae3::function_a7fe9183;
	classes.var_a0023ae3[0].__vtable[55554463] = &namespace_a0023ae3::start;
	classes.var_a0023ae3[0].__vtable[657603382] = &namespace_a0023ae3::function_27323b36;
	classes.var_a0023ae3[0].__vtable[-1176656885] = &namespace_a0023ae3::function_b9dda40b;
	classes.var_a0023ae3[0].__vtable[1535958020] = &namespace_a0023ae3::function_5b8cdc04;
	classes.var_a0023ae3[0].__vtable[1287716801] = &namespace_a0023ae3::function_4cc0ffc1;
	classes.var_a0023ae3[0].__vtable[-338368872] = &namespace_a0023ae3::function_ebd4e698;
	classes.var_a0023ae3[0].__vtable[2055383879] = &namespace_a0023ae3::function_7a82ab47;
	classes.var_a0023ae3[0].__vtable[-1017222485] = &namespace_a0023ae3::init;
}

