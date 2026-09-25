#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_tomb_tank;

#namespace namespace_ba5e3d70;

/*
	Name: init
	Namespace: namespace_ba5e3d70
	Checksum: 0xF519961F
	Offset: 0x4C0
	Size: 0x5B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_b5da43f3();
	SetDvar("scr_zm_use_code_enemy_selection", 0);
	level thread update_closest_player();
	level.validate_on_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: function_b5da43f3
	Namespace: namespace_ba5e3d70
	Checksum: 0xA4FE2CFE
	Offset: 0x528
	Size: 0x233
	Parameters: 0
	Flags: Private
*/
function private function_b5da43f3()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasKilledByWaterStaff", &function_901a96ec);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasKilledByFireStaff", &function_7ae408dd);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasKilledByLightningStaff", &function_a8b7161f);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasKilledOnTank", &function_9449d80c);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasStunnedByFireStaff", &function_1beccbaf);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasStunnedByLightningStaff", &function_4638613d);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldWhirlwind", &function_dc92ad10);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStunFireActionEnd", &function_bcaa2d94);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStunLightningActionEnd", &function_5fe08728);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombSetFindFleshState", &function_92b303d1);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombClearFindFleshState", &function_7ccc282a);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("tombOnTankDeathActionStart", &function_4bf50754);
	spawner::add_archetype_spawn_function("zombie", &function_59f740e7);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("shatter", &function_e24c6a3f);
}

/*
	Name: function_59f740e7
	Namespace: namespace_ba5e3d70
	Checksum: 0xB56819E3
	Offset: 0x768
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_59f740e7()
{
	self.zombieMoveActionCallback = &function_92b303d1;
}

/*
	Name: function_e24c6a3f
	Namespace: namespace_ba5e3d70
	Checksum: 0xB84ED822
	Offset: 0x790
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function function_e24c6a3f(entity)
{
	entity clientfield::set("staff_shatter_fx", 1);
	entity clientfield::set("attach_bullet_model", 0);
	entity ghost();
}

/*
	Name: function_901a96ec
	Namespace: namespace_ba5e3d70
	Checksum: 0xD827ECDE
	Offset: 0x800
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_901a96ec(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.var_93022f09) && behaviorTreeEntity.var_93022f09)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_7ae408dd
	Namespace: namespace_ba5e3d70
	Checksum: 0x7EAF6D4C
	Offset: 0x848
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_7ae408dd(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.var_1339189a) && behaviorTreeEntity.var_1339189a)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_a8b7161f
	Namespace: namespace_ba5e3d70
	Checksum: 0x8BB749C9
	Offset: 0x890
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_a8b7161f(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.var_26747e92) && behaviorTreeEntity.var_26747e92)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_9449d80c
	Namespace: namespace_ba5e3d70
	Checksum: 0xDA16385
	Offset: 0x8D8
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_9449d80c(behaviorTreeEntity)
{
	return self zm_tomb_tank::entity_on_tank() || (isdefined(self.b_climbing_tank) && self.b_climbing_tank);
}

/*
	Name: function_1beccbaf
	Namespace: namespace_ba5e3d70
	Checksum: 0x77E38544
	Offset: 0x920
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_1beccbaf(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.var_262d5062) && behaviorTreeEntity.var_262d5062)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_4638613d
	Namespace: namespace_ba5e3d70
	Checksum: 0x80EBBCC8
	Offset: 0x968
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_4638613d(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity.var_b52ab77a) && behaviorTreeEntity.var_b52ab77a)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_dc92ad10
	Namespace: namespace_ba5e3d70
	Checksum: 0x5CFF1286
	Offset: 0x9B0
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_dc92ad10(behaviorTreeEntity)
{
	if(isdefined(behaviorTreeEntity._whirlwind_attract_anim) && behaviorTreeEntity._whirlwind_attract_anim)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_5fe08728
	Namespace: namespace_ba5e3d70
	Checksum: 0x9FFE38D3
	Offset: 0x9F8
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function function_5fe08728(behaviorTreeEntity)
{
	behaviorTreeEntity.var_b52ab77a = 0;
}

/*
	Name: function_bcaa2d94
	Namespace: namespace_ba5e3d70
	Checksum: 0x50C2BC42
	Offset: 0xA20
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function function_bcaa2d94(behaviorTreeEntity)
{
	behaviorTreeEntity.var_262d5062 = 0;
}

/*
	Name: function_4bf50754
	Namespace: namespace_ba5e3d70
	Checksum: 0x7D2B2D4E
	Offset: 0xA48
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_4bf50754(behaviorTreeEntity)
{
	behaviorTreeEntity thread function_fe0480d9();
	var_25c21be0 = spawnstruct();
	var_25c21be0 thread function_57039dd1();
	behaviorTreeEntity thread function_66e3edec(var_25c21be0);
}

/*
	Name: function_fe0480d9
	Namespace: namespace_ba5e3d70
	Checksum: 0x4F2A062A
	Offset: 0xAC0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_fe0480d9()
{
	wait(0.7);
	if(!isdefined(self))
	{
		return;
	}
	self zombie_utility::zombie_eye_glow_stop();
	self clientfield::set("zombie_instant_explode", 1);
	wait(0.05);
	if(!isdefined(self))
	{
		return;
	}
	self Hide();
}

/*
	Name: function_57039dd1
	Namespace: namespace_ba5e3d70
	Checksum: 0x80781915
	Offset: 0xB40
	Size: 0x15
	Parameters: 0
	Flags: None
*/
function function_57039dd1()
{
	wait(10);
	self notify("hash_57039dd1");
}

/*
	Name: function_66e3edec
	Namespace: namespace_ba5e3d70
	Checksum: 0xC7B6E9E
	Offset: 0xB60
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_66e3edec(var_25c21be0)
{
	var_25c21be0 endon("hash_57039dd1");
	self waittill("actor_corpse", e_corpse);
	e_corpse Hide();
}

/*
	Name: function_ce3464b9
	Namespace: namespace_ba5e3d70
	Checksum: 0x7BE2B94B
	Offset: 0xBB0
	Size: 0xF9
	Parameters: 1
	Flags: Private
*/
function private function_ce3464b9(players)
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
	Name: function_3394e22d
	Namespace: namespace_ba5e3d70
	Checksum: 0xF424BBA4
	Offset: 0xCB8
	Size: 0x261
	Parameters: 2
	Flags: Private
*/
function private function_3394e22d(origin, players)
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
		self function_ce3464b9(players);
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
	self function_ce3464b9(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: namespace_ba5e3d70
	Checksum: 0xC67E7AE9
	Offset: 0xF28
	Size: 0x1F7
	Parameters: 0
	Flags: Private
*/
function private update_closest_player()
{
	level waittill("start_of_round");
	while(1)
	{
		reset_closest_player = 1;
		zombies = zombie_utility::get_zombie_array();
		var_6aad1b23 = GetAIArchetypeArray("mechz", level.zombie_team);
		if(var_6aad1b23.size)
		{
			zombies = ArrayCombine(zombies, var_6aad1b23, 0, 0);
		}
		foreach(zombie in zombies)
		{
			if(isdefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area && !isdefined(zombie.var_13ed8adf))
			{
				reset_closest_player = 0;
				break;
			}
		}
		if(reset_closest_player)
		{
			foreach(zombie in zombies)
			{
				if(isdefined(zombie.var_13ed8adf))
				{
					zombie.var_13ed8adf = undefined;
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_92b303d1
	Namespace: namespace_ba5e3d70
	Checksum: 0xCBE841E9
	Offset: 0x1128
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_92b303d1(behaviorTreeEntity)
{
	behaviorTreeEntity.var_68ff8357 = behaviorTreeEntity.ai_state;
	behaviorTreeEntity.ai_state = "find_flesh";
}

/*
	Name: function_7ccc282a
	Namespace: namespace_ba5e3d70
	Checksum: 0x66F5BB4F
	Offset: 0x1170
	Size: 0x35
	Parameters: 1
	Flags: None
*/
function function_7ccc282a(behaviorTreeEntity)
{
	behaviorTreeEntity.ai_state = behaviorTreeEntity.var_68ff8357;
	behaviorTreeEntity.var_68ff8357 = undefined;
}

