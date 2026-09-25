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
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_1d57720d;

/*
	Name: init
	Namespace: namespace_1d57720d
	Checksum: 0xB755A7DD
	Offset: 0x3F0
	Size: 0x63
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitZmBehaviorsAndASM();
	SetDvar("tu5_zmPathDistanceCheckTolarance", 20);
	SetDvar("scr_zm_use_code_enemy_selection", 0);
	level.move_valid_poi_to_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: InitZmBehaviorsAndASM
	Namespace: namespace_1d57720d
	Checksum: 0x19CC27F3
	Offset: 0x460
	Size: 0x83
	Parameters: 0
	Flags: Private
*/
function private InitZmBehaviorsAndASM()
{
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_traversal@zombie", &function_5683b5d5, undefined, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodShouldMove", &function_7f985cab);
	spawner::add_archetype_spawn_function("zombie", &function_9fb7c76f);
}

/*
	Name: function_5683b5d5
	Namespace: namespace_1d57720d
	Checksum: 0x9A389FBF
	Offset: 0x4F0
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
	Name: function_7f985cab
	Namespace: namespace_1d57720d
	Checksum: 0xDD9B5A6D
	Offset: 0x698
	Size: 0x189
	Parameters: 1
	Flags: None
*/
function function_7f985cab(entity)
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
	Name: function_9fb7c76f
	Namespace: namespace_1d57720d
	Checksum: 0x3E43F928
	Offset: 0x830
	Size: 0x1B
	Parameters: 0
	Flags: Private
*/
function private function_9fb7c76f()
{
	self.cant_move_cb = &function_f05a4eb4;
}

/*
	Name: function_f05a4eb4
	Namespace: namespace_1d57720d
	Checksum: 0xF7B55BAC
	Offset: 0x858
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private function_f05a4eb4()
{
	self PushActors(0);
	self.enablePushTime = GetTime() + 1000;
}

/*
	Name: function_9b05f3fc
	Namespace: namespace_1d57720d
	Checksum: 0x85EABAFE
	Offset: 0x890
	Size: 0xF9
	Parameters: 1
	Flags: Private
*/
function private function_9b05f3fc(players)
{
	if(isdefined(self.last_closest_player) && (isdefined(self.last_closest_player.am_i_valid) && self.last_closest_player.am_i_valid))
	{
		return;
	}
	self.need_closest_player = 1;
	foreach(player in players)
	{
		if(isdefined(player.am_i_valid) && player.am_i_valid)
		{
			self.last_closest_player = player;
			return;
		}
	}
	self.last_closest_player = undefined;
}

/*
	Name: function_3ff94b60
	Namespace: namespace_1d57720d
	Checksum: 0x699B5775
	Offset: 0x998
	Size: 0x279
	Parameters: 2
	Flags: None
*/
function function_3ff94b60(origin, players)
{
	if(players.size == 0)
	{
		return undefined;
	}
	if(isdefined(self.zombie_poi))
	{
		return undefined;
	}
	if(players.size == 1)
	{
		self.last_closest_player = players[0];
		return self.last_closest_player;
	}
	if(!isdefined(self.last_closest_player))
	{
		self.last_closest_player = players[0];
	}
	if(isdefined(self.v_zombie_custom_goal_pos))
	{
		return self.last_closest_player;
	}
	if(!isdefined(self.need_closest_player))
	{
		self.need_closest_player = 1;
	}
	if(isdefined(level.last_closest_time) && level.last_closest_time >= level.time)
	{
		self function_9b05f3fc(players);
		return self.last_closest_player;
	}
	if(isdefined(self.need_closest_player) && self.need_closest_player)
	{
		level.last_closest_time = level.time;
		self.need_closest_player = 0;
		closest = players[0];
		closest_dist = self zm_utility::approximate_path_dist(closest);
		if(!isdefined(closest_dist))
		{
			closest = undefined;
		}
		for(index = 1; index < players.size; index++)
		{
			dist = self zm_utility::approximate_path_dist(players[index]);
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
	self function_9b05f3fc(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: namespace_1d57720d
	Checksum: 0xF5414F61
	Offset: 0xC20
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function update_closest_player()
{
	level waittill("start_of_round");
	while(1)
	{
		reset_closest_player = 1;
		zombies = zombie_utility::get_round_enemy_array();
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

