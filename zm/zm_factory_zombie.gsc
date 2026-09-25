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

#namespace namespace_27d8454e;

/*
	Name: init
	Namespace: namespace_27d8454e
	Checksum: 0x7E13F35D
	Offset: 0x300
	Size: 0x8B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitZmFactoryBehaviorsAndASM();
	level.zombie_init_done = &function_f06eec12;
	SetDvar("scr_zm_use_code_enemy_selection", 0);
	level.closest_player_override = &factory_closest_player;
	level thread update_closest_player();
	level.move_valid_poi_to_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: InitZmFactoryBehaviorsAndASM
	Namespace: namespace_27d8454e
	Checksum: 0x7BFDEC8C
	Offset: 0x398
	Size: 0x63
	Parameters: 0
	Flags: Private
*/
function private InitZmFactoryBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("ZmFactoryTraversalService", &ZmFactoryTraversalService);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_idle_special_factory", &mocompIdleSpecialFactoryStart, undefined, &mocompIdleSpecialFactoryTerminate);
}

/*
	Name: ZmFactoryTraversalService
	Namespace: namespace_27d8454e
	Checksum: 0xA49E322C
	Offset: 0x408
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function ZmFactoryTraversalService(entity)
{
	if(isdefined(entity.traverseStartNode))
	{
		entity PushActors(0);
		return 1;
	}
	return 0;
}

/*
	Name: mocompIdleSpecialFactoryStart
	Namespace: namespace_27d8454e
	Checksum: 0x31DE441A
	Offset: 0x458
	Size: 0x103
	Parameters: 5
	Flags: Private
*/
function private mocompIdleSpecialFactoryStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		entity OrientMode("face direction", entity.enemyoverride[1].origin - entity.origin);
		entity animMode("zonly_physics", 0);
	}
	else
	{
		entity OrientMode("face current");
		entity animMode("zonly_physics", 0);
	}
}

/*
	Name: mocompIdleSpecialFactoryTerminate
	Namespace: namespace_27d8454e
	Checksum: 0x1FD3E9E8
	Offset: 0x568
	Size: 0x2B
	Parameters: 5
	Flags: Private
*/
function private mocompIdleSpecialFactoryTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
}

/*
	Name: function_f06eec12
	Namespace: namespace_27d8454e
	Checksum: 0x6C30432E
	Offset: 0x5A0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_f06eec12()
{
	self PushActors(0);
}

/*
	Name: factory_validate_last_closest_player
	Namespace: namespace_27d8454e
	Checksum: 0xC6405D0A
	Offset: 0x5C8
	Size: 0xF9
	Parameters: 1
	Flags: Private
*/
function private factory_validate_last_closest_player(players)
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
	Name: factory_closest_player
	Namespace: namespace_27d8454e
	Checksum: 0xE248CEEF
	Offset: 0x6D0
	Size: 0x261
	Parameters: 2
	Flags: Private
*/
function private factory_closest_player(origin, players)
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
	if(!isdefined(self.need_closest_player))
	{
		self.need_closest_player = 1;
	}
	if(isdefined(level.last_closest_time) && level.last_closest_time >= level.time)
	{
		self factory_validate_last_closest_player(players);
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
	self factory_validate_last_closest_player(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: namespace_27d8454e
	Checksum: 0xD4E0AD5C
	Offset: 0x940
	Size: 0x18B
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

