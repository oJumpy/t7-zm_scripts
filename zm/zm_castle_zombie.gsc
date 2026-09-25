#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_e9d5a0ce;

/*
	Name: init
	Namespace: namespace_e9d5a0ce
	Checksum: 0x1DCA0DF4
	Offset: 0x470
	Size: 0x113
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_83f83141();
	level.var_4fb25bb9 = [];
	level.var_4fb25bb9["walk"] = 4;
	level.var_4fb25bb9["run"] = 4;
	level.var_4fb25bb9["sprint"] = 4;
	level.var_4fb25bb9["crawl"] = 3;
	SetDvar("tu5_zmPathDistanceCheckTolarance", 20);
	SetDvar("scr_zm_use_code_enemy_selection", 0);
	level.closest_player_override = &function_c4a8cdff;
	level thread update_closest_player();
	/#
		thread function_e250a9f();
	#/
	level.move_valid_poi_to_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: function_83f83141
	Namespace: namespace_e9d5a0ce
	Checksum: 0xE1C68A03
	Offset: 0x590
	Size: 0x83
	Parameters: 0
	Flags: Private
*/
function private function_83f83141()
{
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_traversal@zombie", &function_5683b5d5, undefined, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldMoveLowg", &shouldMoveLowg);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodShouldMove", &function_d0ef2cea);
}

/*
	Name: function_5683b5d5
	Namespace: namespace_e9d5a0ce
	Checksum: 0xD127E1E7
	Offset: 0x620
	Size: 0x19B
	Parameters: 5
	Flags: None
*/
function function_5683b5d5(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("normal");
	if(isdefined(entity.traverseEndNode))
	{
		/#
			print3d(entity.traverseStartNode.origin, "Dev Block strings are not supported", (1, 0, 0), 1, 1, 60);
			print3d(entity.traverseEndNode.origin, "Dev Block strings are not supported", (0, 1, 0), 1, 1, 60);
			line(entity.traverseStartNode.origin, entity.traverseEndNode.origin, (0, 1, 0), 1, 0, 60);
		#/
		entity ForceTeleport(entity.traverseEndNode.origin, entity.traverseEndNode.angles, 0);
	}
}

/*
	Name: function_d0ef2cea
	Namespace: namespace_e9d5a0ce
	Checksum: 0x957D1784
	Offset: 0x7C8
	Size: 0x189
	Parameters: 1
	Flags: None
*/
function function_d0ef2cea(entity)
{
	if(isdefined(entity.zombie_tesla_hit) && entity.zombie_tesla_hit && (!isdefined(entity.tesla_death) && entity.tesla_death))
	{
		return 0;
	}
	if(isdefined(entity.pushed) && entity.pushed)
	{
		return 0;
	}
	if(isdefined(entity.KNOCKDOWN) && entity.KNOCKDOWN)
	{
		return 0;
	}
	if(isdefined(entity.grapple_is_fatal) && entity.grapple_is_fatal)
	{
		return 0;
	}
	if(level.wait_and_revive)
	{
		if(!(isdefined(entity.var_1e3fb1c) && entity.var_1e3fb1c))
		{
			return 0;
		}
	}
	if(isdefined(entity.stumble))
	{
		return 0;
	}
	if(ZombieBehavior::zombieShouldMeleeCondition(entity))
	{
		return 0;
	}
	if(entity HasPath())
	{
		return 1;
	}
	if(isdefined(entity.keep_moving) && entity.keep_moving)
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldMoveLowg
	Namespace: namespace_e9d5a0ce
	Checksum: 0xCAFBEAE0
	Offset: 0x960
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function shouldMoveLowg(entity)
{
	return isdefined(entity.LOW_GRAVITY) && entity.LOW_GRAVITY;
}

/*
	Name: function_104ff02c
	Namespace: namespace_e9d5a0ce
	Checksum: 0xF4992EBB
	Offset: 0x998
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function function_104ff02c(gravity)
{
	if(gravity == "low")
	{
		self.LOW_GRAVITY = 1;
		if(isdefined(self.missingLegs) && self.missingLegs)
		{
			self.LOW_GRAVITY_VARIANT = RandomInt(level.var_4fb25bb9["crawl"]);
		}
		else
		{
			self.LOW_GRAVITY_VARIANT = RandomInt(level.var_4fb25bb9[self.zombie_move_speed]);
		}
	}
	else if(gravity == "normal")
	{
		self.LOW_GRAVITY = 0;
	}
}

/*
	Name: function_7b63bf24
	Namespace: namespace_e9d5a0ce
	Checksum: 0xB39CF8A6
	Offset: 0xA60
	Size: 0x34F
	Parameters: 1
	Flags: None
*/
function function_7b63bf24(player)
{
	var_b9ec9b33 = 0;
	var_ef36a2fe = 0;
	if(self.archetype == "mechz")
	{
		if(self zm_zonemgr::entity_in_zone("zone_undercroft"))
		{
			a_players = GetPlayers();
			var_2ace9ca5 = 0;
			var_949334ad = 0;
			foreach(target in a_players)
			{
				if(zombie_utility::is_player_valid(target, 1) && target zm_zonemgr::entity_in_zone("zone_undercroft"))
				{
					var_949334ad = var_949334ad + 1;
					if(target IsWallRunning() || !target IsOnGround())
					{
						var_2ace9ca5 = var_2ace9ca5 + 1;
					}
				}
			}
			if(var_2ace9ca5 < var_949334ad && (player IsWallRunning() || !player IsOnGround()))
			{
				return 0;
			}
		}
		return 1;
	}
	if(isdefined(self.zone_name))
	{
		if(self.zone_name == "zone_v10_pad" || self.zone_name == "zone_v10_pad_door" || self.zone_name == "zone_v10_pad_exterior")
		{
			var_b9ec9b33 = 1;
			if(!(isdefined(level.zones["zone_v10_pad_door"].is_spawning_allowed) && level.zones["zone_v10_pad_door"].is_spawning_allowed))
			{
				var_2d8a543 = GetEnt("zone_v10_pad", "targetname");
				if(!self istouching(var_2d8a543))
				{
					return 0;
				}
			}
		}
	}
	if(isdefined(player.zone_name))
	{
		if(player.zone_name == "zone_v10_pad" || player.zone_name == "zone_v10_pad_door" || player.zone_name == "zone_v10_pad_exterior")
		{
			var_ef36a2fe = 1;
		}
	}
	if(var_b9ec9b33 == var_ef36a2fe)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_3cc0a9c3
	Namespace: namespace_e9d5a0ce
	Checksum: 0x2520D9A7
	Offset: 0xDB8
	Size: 0xED
	Parameters: 1
	Flags: Private
*/
function private function_3cc0a9c3(players)
{
	if(isdefined(self.last_closest_player) && (isdefined(self.last_closest_player.am_i_valid) && self.last_closest_player.am_i_valid))
	{
		return;
	}
	self.need_closest_player = 1;
	foreach(player in players)
	{
		if(self function_7b63bf24(player))
		{
			self.last_closest_player = player;
			return;
		}
	}
	self.last_closest_player = undefined;
}

/*
	Name: function_ca4f6cd2
	Namespace: namespace_e9d5a0ce
	Checksum: 0x840BE87B
	Offset: 0xEB0
	Size: 0x93
	Parameters: 1
	Flags: Private
*/
function private function_ca4f6cd2(player)
{
	if(isdefined(player.zone_name))
	{
		if(player.zone_name == "zone_v10_pad")
		{
			dist = Distance(player.origin, self.origin);
			return dist;
		}
	}
	dist = self zm_utility::approximate_path_dist(player);
	return dist;
}

/*
	Name: function_c4a8cdff
	Namespace: namespace_e9d5a0ce
	Checksum: 0xA64767D2
	Offset: 0xF50
	Size: 0x389
	Parameters: 2
	Flags: Private
*/
function private function_c4a8cdff(origin, var_6c55ba74)
{
	AIProfile_BeginEntry("castle_closest_player");
	players = Array::filter(var_6c55ba74, 0, &function_4fee0339);
	if(players.size == 0)
	{
		AIProfile_EndEntry();
		return undefined;
	}
	if(isdefined(self.zombie_poi))
	{
		AIProfile_EndEntry();
		return undefined;
	}
	if(players.size == 1)
	{
		if(self function_7b63bf24(players[0]))
		{
			self.last_closest_player = players[0];
			AIProfile_EndEntry();
			return self.last_closest_player;
		}
		AIProfile_EndEntry();
		return undefined;
	}
	if(!isdefined(self.last_closest_player))
	{
		self.last_closest_player = players[0];
	}
	if(!isdefined(self.need_closest_player))
	{
		self.need_closest_player = 1;
	}
	if(isdefined(level.last_closest_time) && level.last_closest_time >= level.time)
	{
		self function_3cc0a9c3(players);
		AIProfile_EndEntry();
		return self.last_closest_player;
	}
	if(isdefined(self.need_closest_player) && self.need_closest_player)
	{
		level.last_closest_time = level.time;
		self.need_closest_player = 0;
		closest = players[0];
		closest_dist = undefined;
		if(self function_7b63bf24(players[0]))
		{
			closest_dist = self function_ca4f6cd2(closest);
		}
		if(!isdefined(closest_dist))
		{
			closest = undefined;
		}
		for(index = 1; index < players.size; index++)
		{
			dist = undefined;
			if(self function_7b63bf24(players[index]))
			{
				dist = self function_ca4f6cd2(players[index]);
			}
			if(isdefined(dist))
			{
				if(isdefined(closest_dist))
				{
					if(dist < closest_dist)
					{
						closest = players[index];
						closest_dist = dist;
					}
					continue;
				}
				closest = players[index];
				closest_dist = dist;
			}
		}
		self.last_closest_player = closest;
	}
	if(players.size > 1 && isdefined(closest))
	{
		self zm_utility::approximate_path_dist(closest);
	}
	self function_3cc0a9c3(players);
	AIProfile_EndEntry();
	return self.last_closest_player;
}

/*
	Name: function_4fee0339
	Namespace: namespace_e9d5a0ce
	Checksum: 0x1B27598E
	Offset: 0x12E8
	Size: 0xAD
	Parameters: 1
	Flags: Private
*/
function private function_4fee0339(player)
{
	if(!isdefined(player) || !isalive(player) || !isPlayer(player) || player.sessionstate == "spectator" || player.sessionstate == "intermission" || player laststand::player_is_in_laststand() || player.ignoreme)
	{
		return 0;
	}
	return 1;
}

/*
	Name: update_closest_player
	Namespace: namespace_e9d5a0ce
	Checksum: 0x7BFE8DB3
	Offset: 0x13A0
	Size: 0x1EB
	Parameters: 0
	Flags: Private
*/
function private update_closest_player()
{
	level waittill("start_of_round");
	while(1)
	{
		reset_closest_player = 1;
		zombies = zombie_utility::get_round_enemy_array();
		var_6aad1b23 = GetAIArchetypeArray("mechz", level.zombie_team);
		if(var_6aad1b23.size)
		{
			zombies = ArrayCombine(zombies, var_6aad1b23, 0, 0);
		}
		foreach(zombie in zombies)
		{
			if(isdefined(zombie.need_closest_player) && zombie.need_closest_player)
			{
				reset_closest_player = 0;
				break;
			}
		}
		if(reset_closest_player)
		{
			foreach(zombie in zombies)
			{
				if(isdefined(zombie.need_closest_player))
				{
					zombie.need_closest_player = 1;
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_e250a9f
	Namespace: namespace_e9d5a0ce
	Checksum: 0xF9CF446A
	Offset: 0x1598
	Size: 0x5B
	Parameters: 0
	Flags: Private
*/
function private function_e250a9f()
{
	/#
		level flagsys::wait_till("Dev Block strings are not supported");
		zm_devgui::function_4acecab5(&function_e48879e3);
		AddDebugCommand("Dev Block strings are not supported");
	#/
}

/*
	Name: function_e48879e3
	Namespace: namespace_e9d5a0ce
	Checksum: 0xB791EA9D
	Offset: 0x1600
	Size: 0x1DD
	Parameters: 1
	Flags: Private
*/
function private function_e48879e3(cmd)
{
	/#
		switch(cmd)
		{
			case "Dev Block strings are not supported":
			{
				if(!isdefined(level.var_c43a1504))
				{
					level.var_c43a1504 = 1;
				}
				else
				{
					level.var_c43a1504 = !level.var_c43a1504;
				}
				zombies = GetAISpeciesArray(level.zombie_team, "Dev Block strings are not supported");
				foreach(zombie in zombies)
				{
					if(isdefined(level.var_c43a1504) && level.var_c43a1504)
					{
						zombie function_104ff02c("Dev Block strings are not supported");
						if(zombie ai::has_behavior_attribute("Dev Block strings are not supported"))
						{
							zombie ai::set_behavior_attribute("Dev Block strings are not supported", "Dev Block strings are not supported");
						}
						continue;
					}
					zombie function_104ff02c("Dev Block strings are not supported");
					if(zombie ai::has_behavior_attribute("Dev Block strings are not supported"))
					{
						zombie ai::set_behavior_attribute("Dev Block strings are not supported", "Dev Block strings are not supported");
					}
				}
				break;
			}
		}
	#/
}

