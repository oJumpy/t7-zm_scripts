#using scripts\codescripts\struct;
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#namespace zm_usermap_ai;

/*
	Name: init
	Namespace: zm_usermap_ai
	Checksum: 0x9BA6D5D1
	Offset: 0x7B0
	Size: 0x7F
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	if(!isdefined(level.pathdist_type))
	{
		level.pathdist_type = 2;
	}
	InitZmFactoryBehaviorsAndASM();
	SetDvar("scr_zm_use_code_enemy_selection", 0);
	level.closest_player_override = &factory_closest_player;
	level thread update_closest_player();
	level.move_valid_poi_to_navmesh = 1;
}

/*
	Name: InitZmFactoryBehaviorsAndASM
	Namespace: zm_usermap_ai
	Checksum: 0xA9D7CC32
	Offset: 0x838
	Size: 0x8B
	Parameters: 0
	Flags: Private
*/
function private InitZmFactoryBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("ZmFactoryTraversalService", &ZmFactoryTraversalService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldMoveLowg", &shouldMoveLowg);
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_idle_special_factory", &mocompIdleSpecialFactoryStart, undefined, &mocompIdleSpecialFactoryTerminate);
}

/*
	Name: ZmFactoryTraversalService
	Namespace: zm_usermap_ai
	Checksum: 0xCD92F5B0
	Offset: 0x8D0
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
	Namespace: zm_usermap_ai
	Checksum: 0x1E3F3503
	Offset: 0x920
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
	Namespace: zm_usermap_ai
	Checksum: 0x929FFA60
	Offset: 0xA30
	Size: 0x2B
	Parameters: 5
	Flags: Private
*/
function private mocompIdleSpecialFactoryTerminate(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
{
}

/*
	Name: shouldMoveLowg
	Namespace: zm_usermap_ai
	Checksum: 0xD3DDCA04
	Offset: 0xA68
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function shouldMoveLowg(entity)
{
	return isdefined(entity.LOW_GRAVITY) && entity.LOW_GRAVITY;
}

/*
	Name: factory_validate_last_closest_player
	Namespace: zm_usermap_ai
	Checksum: 0xEF904743
	Offset: 0xAA0
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
	Namespace: zm_usermap_ai
	Checksum: 0xDBEA9A1E
	Offset: 0xBA8
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
	Namespace: zm_usermap_ai
	Checksum: 0xFEC229C1
	Offset: 0xE18
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

