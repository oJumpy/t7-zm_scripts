#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_zod;
#using scripts\zm\zm_zod_portals;
#using scripts\zm\zm_zod_vo;

#namespace namespace_99cd1d55;

/*
	Name: init
	Namespace: namespace_99cd1d55
	Checksum: 0x706B7615
	Offset: 0x358
	Size: 0xAB
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_3606a81c();
	level.zombie_init_done = &function_e4da8c4d;
	SetDvar("scr_zm_use_code_enemy_selection", 0);
	SetDvar("tu5_zmPathDistanceCheckTolarance", 20);
	level.closest_player_override = &function_e33b6e60;
	level thread update_closest_player();
	level.move_valid_poi_to_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: function_3606a81c
	Namespace: namespace_99cd1d55
	Checksum: 0xA71748A2
	Offset: 0x410
	Size: 0x5B
	Parameters: 0
	Flags: Private
*/
function private function_3606a81c()
{
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_traversal@zombie", &function_5683b5d5, undefined, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodShouldMove", &function_d0ef2cea);
}

/*
	Name: function_5683b5d5
	Namespace: namespace_99cd1d55
	Checksum: 0x40247A63
	Offset: 0x478
	Size: 0x103
	Parameters: 5
	Flags: None
*/
function function_5683b5d5(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	entity.is_teleporting = 1;
	entity OrientMode("face angle", entity.angles[1]);
	entity animMode("normal");
	if(isdefined(entity.traverseStartNode))
	{
		portal_trig = entity.traverseStartNode.portal_trig;
		level clientfield::increment("pulse_" + portal_trig.script_noteworthy);
		portal_trig thread namespace_8e2647d0::function_eb1242c8(entity);
	}
}

/*
	Name: function_d0ef2cea
	Namespace: namespace_99cd1d55
	Checksum: 0xC0A8F5B0
	Offset: 0x588
	Size: 0x191
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
		return 0;
	}
	if(isdefined(entity.stumble))
	{
		return 0;
	}
	if(ZombieBehavior::zombieShouldMeleeCondition(entity))
	{
		return 0;
	}
	if(isdefined(entity.interdimensional_gun_kill) && !isdefined(entity.killby_interdimensional_gun_hole))
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
	Name: function_e4da8c4d
	Namespace: namespace_99cd1d55
	Checksum: 0xCFAB10C5
	Offset: 0x728
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_e4da8c4d()
{
	self PushActors(0);
}

/*
	Name: function_8e555efc
	Namespace: namespace_99cd1d55
	Checksum: 0x47AB5626
	Offset: 0x750
	Size: 0xF9
	Parameters: 1
	Flags: Private
*/
function private function_8e555efc(players)
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
	Name: function_e33b6e60
	Namespace: namespace_99cd1d55
	Checksum: 0x8502ECF4
	Offset: 0x858
	Size: 0x281
	Parameters: 2
	Flags: Private
*/
function private function_e33b6e60(origin, players)
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
		self function_8e555efc(players);
		return self.last_closest_player;
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
		self function_8e555efc(players);
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
	self function_8e555efc(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: namespace_99cd1d55
	Checksum: 0x47F0106F
	Offset: 0xAE8
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
		margwa = GetAIArchetypeArray("margwa", level.zombie_team);
		if(margwa.size)
		{
			zombies = ArrayCombine(zombies, margwa, 0, 0);
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

