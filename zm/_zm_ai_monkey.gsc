#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace namespace_8fb880d9;

/*
	Name: init
	Namespace: namespace_8fb880d9
	Checksum: 0xFFE93ED0
	Offset: 0x12F0
	Size: 0x253
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_1444ad65();
	spawner::add_archetype_spawn_function("monkey", &function_23a486c);
	spawner::add_archetype_spawn_function("monkey", &function_31560902);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("monkey_melee", &function_57e144e9);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("monkey_groundpound", &function_f7725aa8);
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("grenade_pickup", &function_fcdc0829);
	level thread AAT::register_immunity("zm_aat_blast_furnace", "monkey", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_dead_wire", "monkey", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_fire_works", "monkey", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_thunder_wall", "monkey", 1, 1, 1);
	level thread AAT::register_immunity("zm_aat_turned", "monkey", 1, 1, 1);
	clientfield::register("actor", "monkey_eye_glow", 21000, 1, "int");
	level.var_45abf882 = [];
	for(i = 0; i < 4; i++)
	{
		level.var_45abf882[i] = "rtrg_ai_zm_dlc5_monkey_thundergun_roll_0" + i + 1;
	}
}

/*
	Name: function_57e144e9
	Namespace: namespace_8fb880d9
	Checksum: 0x23A77594
	Offset: 0x1550
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function function_57e144e9(entity)
{
	entity melee();
	/#
		Record3DText("Dev Block strings are not supported", self.origin, (1, 0, 0), "Dev Block strings are not supported", entity);
	#/
}

/*
	Name: function_f7725aa8
	Namespace: namespace_8fb880d9
	Checksum: 0x5F813DDA
	Offset: 0x15B8
	Size: 0x4D5
	Parameters: 1
	Flags: None
*/
function function_f7725aa8(entity)
{
	PlayFXOnTag(level._effect["monkey_groundhit"], entity, "tag_origin");
	entity playsound("zmb_monkey_groundpound");
	origin = entity.origin + VectorScale((0, 0, 1), 40);
	zombies = Array::get_all_closest(origin, GetAISpeciesArray(level.zombie_team, "all"), undefined, undefined, level.var_9151fd0b);
	if(isdefined(zombies))
	{
		for(i = 0; i < zombies.size; i++)
		{
			if(!isdefined(zombies[i]))
			{
				continue;
			}
			if(zm_utility::is_magic_bullet_shield_enabled(zombies[i]))
			{
				continue;
			}
			test_origin = zombies[i] GetEye();
			if(!BulletTracePassed(origin, test_origin, 0, undefined))
			{
				continue;
			}
			if(zombies[i] == entity)
			{
				continue;
			}
			if(zombies[i].animName == "monkey_zombie")
			{
				continue;
			}
			zombies[i] zombie_utility::gib_random_parts();
			GibServerUtils::Annihilate(zombies[i]);
			zombies[i] DoDamage(zombies[i].health * 10, entity.origin, entity);
		}
	}
	players = GetPlayers();
	affected_players = [];
	for(i = 0; i < players.size; i++)
	{
		if(!zombie_utility::is_player_valid(players[i]))
		{
			continue;
		}
		test_origin = players[i] GetEye();
		if(DistanceSquared(origin, test_origin) > level.var_9151fd0b * level.var_9151fd0b)
		{
			continue;
		}
		if(!BulletTracePassed(origin, test_origin, 0, undefined))
		{
			continue;
		}
		if(!isdefined(affected_players))
		{
			affected_players = [];
		}
		else if(!IsArray(affected_players))
		{
			affected_players = Array(affected_players);
		}
		affected_players[affected_players.size] = players[i];
	}
	entity.chest_beat = 0;
	for(i = 0; i < affected_players.size; i++)
	{
		entity.chest_beat = 1;
		player = affected_players[i];
		if(player IsOnGround())
		{
			damage = player.maxhealth * 0.5;
			player DoDamage(damage, entity.origin, entity);
		}
	}
	if(isdefined(entity.var_2da34b1))
	{
		for(i = 0; i < entity.var_2da34b1.size; i++)
		{
			if(isdefined(entity.var_2da34b1[i]))
			{
				entity.var_2da34b1[i] detonate(undefined);
			}
		}
	}
}

/*
	Name: function_fcdc0829
	Namespace: namespace_8fb880d9
	Checksum: 0x91E143EC
	Offset: 0x1A98
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function function_fcdc0829(entity)
{
	target = self.monkey_thrower;
	throw_angle = randomIntRange(20, 30);
	dir = VectorToAngles(target.origin - entity.origin);
	dir = (dir[0] - throw_angle, dir[1], dir[2]);
	dir = AnglesToForward(dir);
	velocity = dir * 550;
	fuse = RandomFloatRange(1, 2);
	hand_pos = entity GetTagOrigin("J_Thumb_RI_1");
	if(!isdefined(hand_pos))
	{
		hand_pos = entity.origin;
	}
	grenade_type = target zm_utility::get_player_lethal_grenade();
	entity MagicGrenadeType(grenade_type, hand_pos, velocity, fuse);
}

/*
	Name: function_23a486c
	Namespace: namespace_8fb880d9
	Checksum: 0x7269284D
	Offset: 0x1C38
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_23a486c()
{
	blackboard::CreateBlackBoardForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	ai::CreateInterfaceForEntity(self);
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_walk", &ZombieBehavior::BB_GetLocomotionSpeedType);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &function_fbae5ec2;
	/#
		self function_89398c57();
	#/
}

/*
	Name: function_31560902
	Namespace: namespace_8fb880d9
	Checksum: 0xD9C89BAF
	Offset: 0x1D28
	Size: 0x33
	Parameters: 0
	Flags: Private
*/
function private function_31560902()
{
	self SetPitchOrient();
	self monkey_prespawn();
}

/*
	Name: function_fbae5ec2
	Namespace: namespace_8fb880d9
	Checksum: 0x51C3C39C
	Offset: 0x1D68
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private function_fbae5ec2(entity)
{
	entity.__blackboard = undefined;
	entity function_23a486c();
}

/*
	Name: function_1444ad65
	Namespace: namespace_8fb880d9
	Checksum: 0xCEEB5186
	Offset: 0x1DA8
	Size: 0x143
	Parameters: 0
	Flags: Private
*/
function private function_1444ad65()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("monkeyTargetService", &function_f6d7dbae);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("monkeyShouldGroundHit", &function_5403fe31);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("monkeyShouldThrowBackRun", &function_38a521eb);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("monkeyShouldThrowBackStill", &function_25709832);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("monkeyGroundHitStart", &function_6612416a);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("monkeyGroundHitTerminate", &function_2f7de18b);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("monkeyThrowBackTerminate", &function_a03001bc);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("monkeyGrenadeTauntTerminate", &function_1519af55);
}

/*
	Name: function_f6d7dbae
	Namespace: namespace_8fb880d9
	Checksum: 0x61AC7B66
	Offset: 0x1EF8
	Size: 0x32F
	Parameters: 1
	Flags: None
*/
function function_f6d7dbae(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return 0;
	}
	if(!(isdefined(entity.following_player) && entity.following_player))
	{
		return 0;
	}
	if(isdefined(entity.destroy_octobomb))
	{
		return 0;
	}
	player = zm_utility::get_closest_valid_player(self.origin, self.ignore_player);
	entity.favoriteenemy = player;
	if(isdefined(entity.pack) && isdefined(entity.pack.enemy))
	{
		if(!isdefined(entity.favoriteenemy) || entity.favoriteenemy != entity.pack.enemy)
		{
			entity.favoriteenemy = entity.pack.enemy;
		}
	}
	if(!isdefined(player) || player IsNoTarget())
	{
		if(isdefined(entity.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			entity.ignore_player = [];
		}
		if(isdefined(level.no_target_override))
		{
			[[level.no_target_override]](entity);
		}
		else
		{
			entity SetGoal(entity.origin);
		}
		return 0;
	}
	else if(isdefined(level.enemy_location_override_func))
	{
		enemy_ground_pos = [[level.enemy_location_override_func]](entity, player);
		if(isdefined(enemy_ground_pos))
		{
			entity SetGoal(enemy_ground_pos);
			return 1;
		}
	}
	targetPos = GetClosestPointOnNavMesh(entity.favoriteenemy.origin, 15, 15);
	if(isdefined(targetPos))
	{
		entity SetGoal(targetPos);
		return 1;
	}
	if(isdefined(entity.favoriteenemy.last_valid_position))
	{
		entity SetGoal(entity.favoriteenemy.last_valid_position);
		return 1;
	}
	else
	{
		entity SetGoal(entity.origin);
		return 0;
	}
}

/*
	Name: function_5403fe31
	Namespace: namespace_8fb880d9
	Checksum: 0x485999D9
	Offset: 0x2230
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_5403fe31(entity)
{
	if(isdefined(entity.var_aa9937) && entity.var_aa9937)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_6612416a
	Namespace: namespace_8fb880d9
	Checksum: 0xFF67A29E
	Offset: 0x2278
	Size: 0x37
	Parameters: 1
	Flags: None
*/
function function_6612416a(entity)
{
	self function_d9b855a8("ground_pound");
	self.ground_hit = 1;
}

/*
	Name: function_2f7de18b
	Namespace: namespace_8fb880d9
	Checksum: 0x5BCA1090
	Offset: 0x22B8
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function function_2f7de18b(entity)
{
	self.ground_hit = 0;
	self function_d9b855a8("ground_pound_done");
	self.nextGroundHit = GetTime() + level.var_6916b2bf;
	self.var_aa9937 = 0;
}

/*
	Name: function_38a521eb
	Namespace: namespace_8fb880d9
	Checksum: 0x70BBDEF5
	Offset: 0x2318
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_38a521eb(entity)
{
	if(isdefined(entity.var_cf51d24) && entity.var_cf51d24)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_25709832
	Namespace: namespace_8fb880d9
	Checksum: 0x6E00DEDA
	Offset: 0x2360
	Size: 0x39
	Parameters: 1
	Flags: None
*/
function function_25709832(entity)
{
	if(isdefined(entity.var_6602f0c5) && entity.var_6602f0c5)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_a03001bc
	Namespace: namespace_8fb880d9
	Checksum: 0xC040E525
	Offset: 0x23A8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_a03001bc(entity)
{
	entity.var_cf51d24 = 0;
	entity.var_6602f0c5 = 0;
}

/*
	Name: function_1519af55
	Namespace: namespace_8fb880d9
	Checksum: 0xAA512407
	Offset: 0x23E0
	Size: 0x1B
	Parameters: 1
	Flags: None
*/
function function_1519af55(entity)
{
	entity notify("throw_done");
}

/*
	Name: function_4c8046f8
	Namespace: namespace_8fb880d9
	Checksum: 0x494D7AB7
	Offset: 0x2408
	Size: 0x37B
	Parameters: 0
	Flags: None
*/
function function_4c8046f8()
{
	function_dd79f3a8();
	level._effect["monkey_groundhit"] = "dlc5/zmhd/fx_zmb_monkey_ground_hit";
	level._effect["monkey_death"] = "dlc5/cosmo/fx_zmb_monkey_death";
	level._effect["monkey_spawn"] = "dlc5/cosmo/fx_zombie_ape_spawn_dust";
	if(!isdefined(level.var_1643e9c6))
	{
		level.var_1643e9c6 = &function_bed58958;
	}
	if(!isdefined(level.monkey_zombie_enter_level))
	{
		level.monkey_zombie_enter_level = &monkey_zombie_default_enter_level;
	}
	level.var_3d1f9aed = 0;
	level.monkey_zombie_spawners = GetEntArray("monkey_zombie_spawner", "targetname");
	if(!isdefined(level.var_114d8513))
	{
		level.var_114d8513 = 1;
	}
	if(!isdefined(level.var_27c3e797))
	{
		level.var_27c3e797 = 150;
	}
	if(!isdefined(level.var_281c5d62))
	{
		level.var_281c5d62 = 100;
	}
	if(!isdefined(level.var_16b3fbc0))
	{
		level.var_16b3fbc0 = 96;
	}
	if(!isdefined(level.var_9151fd0b))
	{
		level.var_9151fd0b = 280;
	}
	if(!isdefined(level.var_6916b2bf))
	{
		level.var_6916b2bf = 5000;
	}
	if(!isdefined(level.var_9e310f9b))
	{
		level.var_9e310f9b = 3;
	}
	if(!isdefined(level.var_3bf8b909))
	{
		level.var_3bf8b909 = 1;
	}
	if(!isdefined(level.var_ecb65a32))
	{
		level.var_ecb65a32 = [];
	}
	if(!isdefined(level.var_6b0bbc7e))
	{
		level.var_6b0bbc7e = 100;
	}
	if(!isdefined(level.var_b745bb11))
	{
		level.var_b745bb11 = 1;
	}
	if(!isdefined(level.var_2243306f))
	{
		level.var_2243306f = 8;
	}
	if(!isdefined(level.var_7c4a5d82))
	{
		level.var_7c4a5d82 = RandomFloatRange(4.5, 6.5) * 1000;
	}
	level.monkey_death = 0;
	level.monkey_death_total = 0;
	level.var_e810cac3 = 0;
	level.var_b63dbbcb = 1;
	level.var_b20b6949 = 0;
	level flag::init("monkey_round");
	level flag::init("last_monkey_down");
	level flag::init("monkey_pack_down");
	level flag::init("perk_bought");
	level flag::init("monkey_free_perk");
	level thread function_ef9c7c76();
	level.perk_lost_func = &function_85994fd6;
	level.perk_bought_func = &function_57ee756d;
	level.revive_solo_fx_func = &function_67695f31;
}

/*
	Name: monkey_prespawn
	Namespace: namespace_8fb880d9
	Checksum: 0x46D0F081
	Offset: 0x2790
	Size: 0x2DD
	Parameters: 0
	Flags: None
*/
function monkey_prespawn()
{
	self.animName = "monkey_zombie";
	self PushActors(1);
	self.b_ignore_cleanup = 1;
	self.ignorelocationaldamage = 1;
	self.ignoreall = 1;
	self.allowdeath = 1;
	self.is_zombie = 1;
	self.missingLegs = 0;
	self AllowedStances("stand");
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.no_widows_wine = 1;
	self.disableArrivals = 1;
	self.disableExits = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoreSuppression = 1;
	self.suppressionThreshold = 1;
	self.noDodgeMove = 1;
	self.dontShootWhileMoving = 1;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatInitialized = 0;
	self.a.disablePain = 1;
	self zm_utility::disable_react();
	self.freezegun_damage = 0;
	self thread zm_spawner::zombie_damage_failsafe();
	self.flame_damage_time = 0;
	self.meleeDamage = 40;
	self.no_powerups = 1;
	self.no_gib = 1;
	self.custom_damage_func = &function_f501d50;
	self.chest_beat = 0;
	self.var_61aabb9c = level.var_b745bb11;
	self.dropped = 1;
	self AllowPitchAngle(1);
	self.thundergun_fling_func = &function_1d77501d;
	self function_d9b855a8("default");
	self.noChangeDuringMelee = 1;
	if(isdefined(level.monkey_prespawn))
	{
		self [[level.monkey_prespawn]]();
	}
	self.zombie_move_speed = "walk";
	self zombie_utility::set_zombie_run_cycle();
	self thread zm_spawner::play_ambient_zombie_vocals();
	self thread zm_audio::zmbAIVox_NotifyConvert();
	self.var_ef2f46e2 = GetTime();
	self notify("zombie_init_done");
}

/*
	Name: function_dd79f3a8
	Namespace: namespace_8fb880d9
	Checksum: 0xEBCFC4A8
	Offset: 0x2A78
	Size: 0x4AF
	Parameters: 0
	Flags: None
*/
function function_dd79f3a8()
{
	level.var_99568ae3[0] = "rtrg_ai_zm_dlc5_monkey_attack_perks_front";
	level.var_99568ae3[1] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left";
	level.var_99568ae3[2] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_top";
	level.var_99568ae3[3] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right";
	level.var_99568ae3[4] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_top";
	level.var_99568ae3["specialty_armorvest"]["front"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_front_jugg";
	level.var_99568ae3["specialty_armorvest"]["left"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_jugg";
	level.var_99568ae3["specialty_armorvest"]["left_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_top_jugg";
	level.var_99568ae3["specialty_armorvest"]["right"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_jugg";
	level.var_99568ae3["specialty_armorvest"]["right_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_top_jugg";
	level.var_99568ae3["specialty_staminup"]["front"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_front_marathon";
	level.var_99568ae3["specialty_staminup"]["left"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_marathon";
	level.var_99568ae3["specialty_staminup"]["left_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_top_marathon";
	level.var_99568ae3["specialty_staminup"]["right"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_marathon";
	level.var_99568ae3["specialty_staminup"]["right_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_top_marathon";
	level.var_99568ae3["specialty_quickrevive"]["front"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_front_revive";
	level.var_99568ae3["specialty_quickrevive"]["left"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_revive";
	level.var_99568ae3["specialty_quickrevive"]["left_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_top_revive";
	level.var_99568ae3["specialty_quickrevive"]["right"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_revive";
	level.var_99568ae3["specialty_quickrevive"]["right_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_top_revive";
	level.var_99568ae3["specialty_fastreload"]["front"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_front_speed";
	level.var_99568ae3["specialty_fastreload"]["left"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_speed";
	level.var_99568ae3["specialty_fastreload"]["left_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_top_speed";
	level.var_99568ae3["specialty_fastreload"]["right"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_speed";
	level.var_99568ae3["specialty_fastreload"]["right_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_top_speed";
	level.var_99568ae3["specialty_additionalprimaryweapon"]["front"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_front_mulekick";
	level.var_99568ae3["specialty_additionalprimaryweapon"]["left"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_mulekick";
	level.var_99568ae3["specialty_additionalprimaryweapon"]["left_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_top_mulekick";
	level.var_99568ae3["specialty_additionalprimaryweapon"]["right"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_mulekick";
	level.var_99568ae3["specialty_additionalprimaryweapon"]["right_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_top_mulekick";
	level.var_99568ae3["specialty_widowswine"]["front"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_front_widows_vine";
	level.var_99568ae3["specialty_widowswine"]["left"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_widows_vine";
	level.var_99568ae3["specialty_widowswine"]["left_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_left_top_widows_vine";
	level.var_99568ae3["specialty_widowswine"]["right"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_widows_vine";
	level.var_99568ae3["specialty_widowswine"]["right_top"] = "rtrg_ai_zm_dlc5_monkey_attack_perks_right_top_widows_vine";
}

/*
	Name: function_d42b656b
	Namespace: namespace_8fb880d9
	Checksum: 0x6973F149
	Offset: 0x2F30
	Size: 0x1E7
	Parameters: 1
	Flags: None
*/
function function_d42b656b(pack)
{
	self.script_moveoverride = 1;
	if(!isdefined(level.var_3d1f9aed))
	{
		level.var_3d1f9aed = 0;
	}
	level.var_3d1f9aed++;
	var_8e9070eb = zombie_utility::spawn_zombie(self);
	self.count = 666;
	self.last_spawn_time = GetTime();
	if(isdefined(var_8e9070eb))
	{
		var_8e9070eb.script_noteworthy = self.script_noteworthy;
		var_8e9070eb.targetname = self.targetname;
		var_8e9070eb.target = self.target;
		var_8e9070eb.deathFunction = &function_d355c044;
		var_8e9070eb.animName = "monkey_zombie";
		var_8e9070eb.pack = pack;
		var_8e9070eb.perk = pack.perk;
		var_8e9070eb.var_ef2f46e2 = pack.var_ef2f46e2;
		var_8e9070eb.spawn_origin = self.origin;
		var_8e9070eb.spawn_angles = self.angles;
		var_8e9070eb clientfield::set("monkey_eye_glow", 1);
		var_8e9070eb thread watch_for_death();
		var_8e9070eb thread function_b2a7147a();
		var_8e9070eb.zombie_think_done = 1;
	}
	else
	{
		level.var_3d1f9aed--;
	}
	var_8e9070eb thread wait_for_damage();
	return var_8e9070eb;
}

/*
	Name: wait_for_damage
	Namespace: namespace_8fb880d9
	Checksum: 0xE7A9D29D
	Offset: 0x3120
	Size: 0xCF
	Parameters: 0
	Flags: None
*/
function wait_for_damage()
{
	self endon("death");
	while(1)
	{
		self waittill("damage", n_amount, e_attacker, v_direction, v_point, str_type);
		if(e_attacker zm_utility::is_player())
		{
			e_attacker zm_score::player_add_points("damage");
			e_attacker.use_weapon_type = str_type;
			self thread zm_powerups::check_for_instakill(e_attacker, str_type, v_point);
		}
	}
}

/*
	Name: watch_for_death
	Namespace: namespace_8fb880d9
	Checksum: 0x99EC1590
	Offset: 0x31F8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function watch_for_death()
{
}

/*
	Name: function_9a0a813d
	Namespace: namespace_8fb880d9
	Checksum: 0x2777958D
	Offset: 0x3208
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function function_9a0a813d()
{
	level endon("intermission");
	level endon("end_of_round");
	level endon("restart_round");
	/#
		level endon("kill_round");
		if(GetDvarInt("Dev Block strings are not supported") == 2 || GetDvarInt("Dev Block strings are not supported") >= 4)
		{
			return;
		}
	#/
	if(level.intermission)
	{
		return;
	}
	level.var_b20b6949 = 1;
	level thread function_3200962a();
	var_76cce6ca = 0;
	while(1)
	{
		level function_b589f39a();
		var_76cce6ca++;
		if(var_76cce6ca >= level.var_3bf8b909)
		{
			break;
		}
		time = RandomFloatRange(3.2, 4.4);
		wait(time);
		util::wait_network_frame();
	}
}

/*
	Name: function_f690ea5f
	Namespace: namespace_8fb880d9
	Checksum: 0xDF53AB55
	Offset: 0x3350
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function function_f690ea5f()
{
	level.var_e810cac3 = 0;
	players = GetPlayers();
	if(players.size > level.var_b63dbbcb)
	{
		level.var_3bf8b909 = players.size + level.var_b63dbbcb;
	}
	else
	{
		level.var_3bf8b909 = players.size * 2;
	}
	level.var_b63dbbcb++;
}

/*
	Name: function_92f9a6d1
	Namespace: namespace_8fb880d9
	Checksum: 0xBF365597
	Offset: 0x33D8
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_92f9a6d1()
{
	switch(level.var_b63dbbcb)
	{
		case 1:
		{
			level.monkey_zombie_health = level.zombie_health * 0.25;
			break;
		}
		case 2:
		{
			level.monkey_zombie_health = level.zombie_health * 0.5;
			break;
		}
		case 3:
		{
			level.monkey_zombie_health = level.zombie_health * 0.75;
			break;
		}
		case default:
		{
			level.monkey_zombie_health = level.zombie_health;
			break;
		}
	}
	if(level.zombie_health > 1600)
	{
		level.zombie_health = 1600;
	}
	function_aae19d1e("monkey health = " + level.monkey_zombie_health);
}

/*
	Name: function_b8287220
	Namespace: namespace_8fb880d9
	Checksum: 0x485540D
	Offset: 0x34C8
	Size: 0xB7
	Parameters: 0
	Flags: None
*/
function function_b8287220()
{
	level.var_5d7bed84 = [];
	for(i = 0; i < level.monkey_zombie_spawners.size; i++)
	{
		if(level.zones[level.monkey_zombie_spawners[i].script_noteworthy].is_enabled)
		{
			level.var_5d7bed84[level.var_5d7bed84.size] = level.monkey_zombie_spawners[i];
		}
	}
	level.var_5d7bed84 = randomize_array(level.var_5d7bed84);
	level.var_5d91ccf = 0;
}

/*
	Name: randomize_array
	Namespace: namespace_8fb880d9
	Checksum: 0xBDCA7198
	Offset: 0x3588
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function randomize_array(Array)
{
	for(i = 0; i < Array.size; i++)
	{
		j = RandomInt(Array.size);
		temp = Array[i];
		Array[i] = Array[j];
		Array[j] = temp;
	}
	return Array;
}

/*
	Name: function_a68db908
	Namespace: namespace_8fb880d9
	Checksum: 0x14AB92F0
	Offset: 0x3630
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function function_a68db908()
{
	spawner = level.var_5d7bed84[level.var_5d91ccf];
	if(isdefined(spawner))
	{
		level.var_5d91ccf++;
		if(level.var_5d91ccf == level.var_5d7bed84.size)
		{
			level function_b8287220();
		}
	}
	return spawner;
}

/*
	Name: function_f61ce2c5
	Namespace: namespace_8fb880d9
	Checksum: 0x23E9F9E5
	Offset: 0x3698
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function function_f61ce2c5()
{
	spawners = [];
	for(i = 0; i < level.monkey_zombie_spawners.size; i++)
	{
		if(level.zones[level.monkey_zombie_spawners[i].script_noteworthy].is_enabled)
		{
			spawners[spawners.size] = level.monkey_zombie_spawners[i];
		}
	}
	spawners = Array::randomize(spawners);
	return spawners;
}

/*
	Name: function_78426a43
	Namespace: namespace_8fb880d9
	Checksum: 0xC4EE089C
	Offset: 0x3750
	Size: 0x1E7
	Parameters: 0
	Flags: None
*/
function function_78426a43()
{
	level.var_4a8855e0 = [];
	vending_triggers = function_5b9c3e11();
	for(i = 0; i < vending_triggers.size; i++)
	{
		if(vending_triggers[i].targeted)
		{
			break;
		}
		players = GetPlayers();
		for(j = 0; j < players.size; j++)
		{
			perk = vending_triggers[i].script_noteworthy;
			org = vending_triggers[i].origin;
			if(isdefined(vending_triggers[i].realorigin))
			{
				org = vending_triggers[i].realorigin;
			}
			zone_enabled = zm_zonemgr::get_zone_from_position(org, 0);
			if(players[j] hasPerk(perk) && isdefined(zone_enabled))
			{
				level.var_4a8855e0[level.var_4a8855e0.size] = vending_triggers[i];
				break;
			}
		}
	}
	if(level.var_4a8855e0.size > 1)
	{
		level.var_4a8855e0 = Array::randomize(level.var_4a8855e0);
	}
	level.var_b4e003b9 = 0;
}

/*
	Name: function_5b9c3e11
	Namespace: namespace_8fb880d9
	Checksum: 0x6A96BEF6
	Offset: 0x3940
	Size: 0xED
	Parameters: 0
	Flags: None
*/
function function_5b9c3e11()
{
	vending_machines = [];
	var_560b7d8d = GetEntArray("zombie_vending", "targetname");
	for(i = 0; i < var_560b7d8d.size; i++)
	{
		if(var_560b7d8d[i].script_noteworthy != "specialty_weapupgrade")
		{
			if(!isdefined(vending_machines))
			{
				vending_machines = [];
			}
			else if(!IsArray(vending_machines))
			{
				vending_machines = Array(vending_machines);
			}
			vending_machines[vending_machines.size] = var_560b7d8d[i];
		}
	}
	return vending_machines;
}

/*
	Name: function_c0fc1751
	Namespace: namespace_8fb880d9
	Checksum: 0xFFAE2559
	Offset: 0x3A38
	Size: 0x8F
	Parameters: 0
	Flags: None
*/
function function_c0fc1751()
{
	if(level.var_4a8855e0.size == 0)
	{
		self.perk = undefined;
		return;
	}
	perk = level.var_4a8855e0[level.var_b4e003b9];
	perk.targeted = 1;
	level.var_b4e003b9++;
	if(level.var_b4e003b9 == level.var_4a8855e0.size)
	{
		level function_78426a43();
	}
	self.perk = perk;
}

/*
	Name: function_b589f39a
	Namespace: namespace_8fb880d9
	Checksum: 0x69CDA6AA
	Offset: 0x3AD0
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_b589f39a()
{
	function_aae19d1e("spawning pack");
	pack = spawnstruct();
	pack.monkeys = [];
	pack.attack = [];
	pack.target = undefined;
	level.var_ecb65a32[level.var_ecb65a32.size] = pack;
	pack thread function_c03b15f7();
}

/*
	Name: function_c03b15f7
	Namespace: namespace_8fb880d9
	Checksum: 0x4BDA35BD
	Offset: 0x3B70
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function function_c03b15f7()
{
	self.var_ef2f46e2 = GetTime();
	self function_c0fc1751();
	self function_ac8bf991();
	self function_847ba2ab();
	self.var_9d1c9c35 = 0;
	for(i = 0; i < level.var_9e310f9b; i++)
	{
		spawner = function_a68db908();
		if(isdefined(spawner))
		{
			monkey = spawner function_d42b656b(self);
			self.monkeys[self.monkeys.size] = monkey;
		}
		if(i < level.var_9e310f9b - 1)
		{
			time = RandomFloatRange(2.2, 4.4);
			wait(time);
		}
	}
	self.var_9d1c9c35 = 1;
	self thread function_7f749e47();
	self thread function_f932e98d();
}

/*
	Name: function_f932e98d
	Namespace: namespace_8fb880d9
	Checksum: 0xEF8C5C41
	Offset: 0x3CF0
	Size: 0x167
	Parameters: 0
	Flags: None
*/
function function_f932e98d()
{
	while(1)
	{
		if(!isdefined(self.perk))
		{
			break;
		}
		if(self.machine.var_e91fc987 == 0)
		{
			function_aae19d1e("pack destroyed " + self.machine.targetname);
			self function_e0d1a467();
			util::wait_network_frame();
			self function_d1c1e2a0();
			self function_c0fc1751();
			self function_ac8bf991();
			for(i = 0; i < self.monkeys.size; i++)
			{
				if(!self.monkeys[i].var_87a956ff)
				{
					self.monkeys[i].perk = self.perk;
					self.monkeys[i] notify("hash_b8e59c03");
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_fe2acc25
	Namespace: namespace_8fb880d9
	Checksum: 0x816EAF7A
	Offset: 0x3E60
	Size: 0x137
	Parameters: 0
	Flags: None
*/
function function_fe2acc25()
{
	perk = undefined;
	var_4963175d = -1;
	num_perks = 0;
	keys = getArrayKeys(level.var_4a8855e0);
	for(i = 0; i < keys.size; i++)
	{
		if(level.var_4a8855e0[keys[i]] > num_perks)
		{
			num_perks = level.var_4a8855e0[keys[i]];
			var_4963175d = i;
		}
	}
	if(var_4963175d >= 0)
	{
		perk = keys[var_4963175d];
	}
	if(isdefined(perk))
	{
		function_aae19d1e("perk is " + perk);
	}
	else
	{
		function_aae19d1e("no more perks");
	}
	self.perk = perk;
}

/*
	Name: function_ac8bf991
	Namespace: namespace_8fb880d9
	Checksum: 0x1C1CBB98
	Offset: 0x3FA0
	Size: 0xAD
	Parameters: 0
	Flags: None
*/
function function_ac8bf991()
{
	self.machine = undefined;
	if(!isdefined(self.perk))
	{
		return;
	}
	targets = GetEntArray(self.perk.target, "targetname");
	for(j = 0; j < targets.size; j++)
	{
		if(targets[j].classname == "script_model")
		{
			self.machine = targets[j];
		}
	}
}

/*
	Name: function_847ba2ab
	Namespace: namespace_8fb880d9
	Checksum: 0xC80D82C1
	Offset: 0x4058
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_847ba2ab()
{
	var_5fa1bd33 = [];
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!zombie_utility::is_player_valid(players[i]))
		{
			continue;
		}
		var_5fa1bd33[var_5fa1bd33.size] = players[i];
	}
	var_5fa1bd33 = Array::randomize(var_5fa1bd33);
	if(var_5fa1bd33.size > 0)
	{
		self.enemy = var_5fa1bd33[0];
	}
	else
	{
		self.enemy = players[0];
	}
}

/*
	Name: function_7f749e47
	Namespace: namespace_8fb880d9
	Checksum: 0xEDD6F5B
	Offset: 0x4148
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function function_7f749e47()
{
	while(self.monkeys.size > 0)
	{
		players = GetPlayers();
		total_dist = 1000000;
		player_idx = 0;
		for(i = 0; i < players.size; i++)
		{
			if(!zombie_utility::is_player_valid(players[i]))
			{
				continue;
			}
			dist = 0;
			for(j = 0; j < self.monkeys.size; j++)
			{
				if(!isdefined(self.monkeys[j]))
				{
					continue;
				}
				dist = dist + Distance(players[i].origin, self.monkeys[j].origin);
			}
			if(dist < total_dist)
			{
				total_dist = dist;
				player_idx = i;
			}
			if(isdefined(players[i].b_is_designated_target) && players[i].b_is_designated_target)
			{
				player_idx = i;
			}
		}
		if(isdefined(players))
		{
			if(isdefined(self.enemy))
			{
				if(self.enemy != players[player_idx])
				{
					function_aae19d1e("pack enemy is " + self.enemy.name);
				}
			}
			else
			{
				function_aae19d1e("pack enemy is " + players[player_idx].name);
			}
			self.enemy = players[player_idx];
		}
		wait(0.2);
	}
}

/*
	Name: function_2a8f005e
	Namespace: namespace_8fb880d9
	Checksum: 0x3A35ED50
	Offset: 0x43A0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_2a8f005e()
{
	if(GetTime() >= self.var_ef2f46e2)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_d2f3f336
	Namespace: namespace_8fb880d9
	Checksum: 0x5478D2FE
	Offset: 0x43C8
	Size: 0x22B
	Parameters: 1
	Flags: None
*/
function function_d2f3f336(var_52c54b81)
{
	self.var_ef2f46e2 = GetTime() + level.var_7c4a5d82;
	level.var_7c4a5d82 = RandomFloatRange(4.5, 6.5) * 1000;
	for(i = 0; i < self.monkeys.size; i++)
	{
		if(isdefined(self.monkeys[i]))
		{
			self.monkeys[i].var_ef2f46e2 = self.var_ef2f46e2;
		}
	}
	var_d5bdd692 = level.var_16b3fbc0 * 2;
	var_9e4d7e51 = var_d5bdd692 * var_d5bdd692;
	for(i = 0; i < level.var_ecb65a32.size; i++)
	{
		pack = level.var_ecb65a32[i];
		if(self == pack)
		{
			break;
		}
		for(j = 0; j < pack.monkeys.size; j++)
		{
			monkey = pack.monkeys[j];
			if(!isdefined(monkey))
			{
				continue;
			}
			if(var_52c54b81 == monkey)
			{
				continue;
			}
			dist_sq = DistanceSquared(var_52c54b81.origin, monkey.origin);
			if(dist_sq <= var_9e4d7e51)
			{
				monkey.var_ef2f46e2 = self.var_ef2f46e2;
			}
		}
	}
	function_aae19d1e("next ground hit in " + level.var_7c4a5d82);
}

/*
	Name: function_bf9c5bbd
	Namespace: namespace_8fb880d9
	Checksum: 0x62BC8F7D
	Offset: 0x4600
	Size: 0x9B
	Parameters: 0
	Flags: None
*/
function function_bf9c5bbd()
{
	/#
		if(GetDvarInt("Dev Block strings are not supported") == 2 || GetDvarInt("Dev Block strings are not supported") >= 4)
		{
			level waittill("forever");
		}
	#/
	wait(1);
	if(level flag::get("monkey_round"))
	{
		wait(7);
		while(level.var_b20b6949)
		{
			wait(0.5);
		}
	}
}

/*
	Name: function_3200962a
	Namespace: namespace_8fb880d9
	Checksum: 0xF3B2023C
	Offset: 0x46A8
	Size: 0x7F
	Parameters: 0
	Flags: None
*/
function function_3200962a()
{
	level flag::wait_till("last_monkey_down");
	level thread zm_audio::sndMusicSystem_PlayState("monkey_round_end");
	level.round_spawn_func = level.var_8f91730b;
	level.round_wait_func = level.var_dffdc35f;
	wait(6);
	level.sndMusicSpecialRound = 0;
	level.var_b20b6949 = 0;
}

/*
	Name: function_ef9c7c76
	Namespace: namespace_8fb880d9
	Checksum: 0x47E145E5
	Offset: 0x4730
	Size: 0x22F
	Parameters: 0
	Flags: None
*/
function function_ef9c7c76()
{
	level flag::wait_till("power_on");
	level flag::wait_till("perk_bought");
	level.var_8f91730b = level.round_spawn_func;
	level.var_dffdc35f = level.round_wait_func;
	level.next_monkey_round = level.round_number + randomIntRange(1, 4);
	level.var_626bf0e3 = level.next_monkey_round;
	while(1)
	{
		level waittill("between_round_over");
		if(level.round_number == level.next_monkey_round)
		{
			if(!function_8fa57ade())
			{
				level.next_monkey_round++;
				function_aae19d1e("next monkey round at " + level.next_monkey_round);
				continue;
			}
			level.sndMusicSpecialRound = 1;
			level.var_8f91730b = level.round_spawn_func;
			level.var_dffdc35f = level.round_wait_func;
			level thread zm_audio::sndMusicSystem_PlayState("monkey_round_start");
			monkey_round_start();
			level.round_spawn_func = &function_9a0a813d;
			level.round_wait_func = &function_bf9c5bbd;
			level.var_626bf0e3 = level.next_monkey_round;
			level.next_monkey_round = level.round_number + randomIntRange(4, 6);
			function_aae19d1e("next monkey round at " + level.next_monkey_round);
		}
		else if(level flag::get("monkey_round"))
		{
			function_724fe496();
		}
	}
}

/*
	Name: monkey_round_start
	Namespace: namespace_8fb880d9
	Checksum: 0xF55A47A9
	Offset: 0x4968
	Size: 0x13B
	Parameters: 0
	Flags: None
*/
function monkey_round_start()
{
	level flag::set("monkey_round");
	level flag::set("monkey_free_perk");
	if(isdefined(level.monkey_round_start))
	{
		level thread [[level.monkey_round_start]]();
	}
	level thread function_d8ac7d7f();
	level function_92f9a6d1();
	level function_b8287220();
	level function_f690ea5f();
	level function_78426a43();
	level thread monkey_grenade_watcher();
	util::clientNotify("monkey_start");
	playsoundatposition("zmb_ape_intro_sonicboom_fnt", (0, 0, 0));
	level thread function_5e2e012a();
}

/*
	Name: function_5e2e012a
	Namespace: namespace_8fb880d9
	Checksum: 0x5CDBFF9
	Offset: 0x4AB0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_5e2e012a()
{
	wait(8);
	players = GetPlayers();
	players[randomIntRange(0, players.size)] zm_audio::create_and_play_dialog("general", "monkey_spawn");
}

/*
	Name: function_724fe496
	Namespace: namespace_8fb880d9
	Checksum: 0xF867B9F3
	Offset: 0x4B28
	Size: 0x11F
	Parameters: 0
	Flags: None
*/
function function_724fe496()
{
	level flag::clear("monkey_round");
	level flag::clear("last_monkey_down");
	if(isdefined(level.var_724fe496))
	{
		level thread [[level.var_724fe496]]();
	}
	util::clientNotify("monkey_stop");
	level notify("hash_6a70071f");
	players = GetPlayers();
	foreach(player in players)
	{
		self.perk_hud_flash = undefined;
	}
}

/*
	Name: function_8fa57ade
	Namespace: namespace_8fb880d9
	Checksum: 0x15DAB1E4
	Offset: 0x4C50
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function function_8fa57ade()
{
	vending_triggers = function_5b9c3e11();
	for(i = 0; i < vending_triggers.size; i++)
	{
		players = GetPlayers();
		for(j = 0; j < players.size; j++)
		{
			perk = vending_triggers[i].script_noteworthy;
			org = vending_triggers[i].origin;
			if(isdefined(vending_triggers[i].realorigin))
			{
				org = vending_triggers[i].realorigin;
			}
			zone_enabled = zm_zonemgr::get_zone_from_position(org, 0);
			if(players[j] hasPerk(perk) && isdefined(zone_enabled))
			{
				return 1;
			}
		}
	}
	return 0;
}

/*
	Name: function_e2b3b2bb
	Namespace: namespace_8fb880d9
	Checksum: 0x908FD001
	Offset: 0x4DC0
	Size: 0x77
	Parameters: 0
	Flags: None
*/
function function_e2b3b2bb()
{
	while(1)
	{
		while(level.var_3d1f9aed < level.var_114d8513)
		{
			spawner = function_84a33c9f();
			if(isdefined(spawner))
			{
				spawner function_d42b656b();
			}
			wait(10);
		}
		wait(10);
	}
}

/*
	Name: function_84a33c9f
	Namespace: namespace_8fb880d9
	Checksum: 0x94BFEBE1
	Offset: 0x4E40
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function function_84a33c9f()
{
	best_spawner = undefined;
	best_score = -1;
	for(i = 0; i < level.monkey_zombie_spawners.size; i++)
	{
		score = [[level.var_1643e9c6]](level.monkey_zombie_spawners[i]);
		if(score > best_score)
		{
			best_spawner = level.monkey_zombie_spawners[i];
			best_score = score;
		}
	}
	return best_spawner;
}

/*
	Name: function_602b3d53
	Namespace: namespace_8fb880d9
	Checksum: 0x368B3A02
	Offset: 0x4EF8
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function function_602b3d53()
{
	self endon("death");
	self.zombie_move_speed = "run";
	self waittill("speed_up");
	self.zombie_move_speed = "sprint";
}

/*
	Name: function_b2a7147a
	Namespace: namespace_8fb880d9
	Checksum: 0xF8135EC
	Offset: 0x4F40
	Size: 0x1EF
	Parameters: 0
	Flags: None
*/
function function_b2a7147a()
{
	self endon("death");
	self thread play_random_monkey_vox();
	self.goalRadius = 32;
	self.meleeAttackDist = 64;
	self.var_87a956ff = 0;
	level.var_27c3e797 = Int(level.monkey_zombie_health);
	if(!isdefined(self.maxhealth) || self.maxhealth < level.var_27c3e797)
	{
		self.maxhealth = level.var_27c3e797;
		self.health = level.var_27c3e797;
	}
	if(isdefined(level.var_83c53db8))
	{
		self.maxhealth = 1;
		self.health = 1;
	}
	self thread function_602b3d53();
	self.maxsightdistsqrd = 9216;
	self [[level.monkey_zombie_enter_level]]();
	if(isdefined(level.var_8995237a))
	{
		self thread [[level.var_8995237a]]();
	}
	self.ignoreall = 0;
	self thread function_5ea57e90();
	self thread function_5b3f15dd();
	self thread function_5cbf8fcf();
	self thread function_e8496e8a();
	self thread function_44d16f7d();
	self thread function_bf09b321();
	self thread function_f0891021();
	if(isdefined(level.monkey_zombie_failsafe))
	{
		self thread [[level.monkey_zombie_failsafe]]();
	}
}

/*
	Name: function_ac26e17f
	Namespace: namespace_8fb880d9
	Checksum: 0xC14C7294
	Offset: 0x5138
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function function_ac26e17f()
{
	self endon("death");
	while(1)
	{
		FORWARD = VectorNormalize(AnglesToForward(self.angles));
		end_pos = self.origin - VectorScale(FORWARD, 120);
		util::wait_network_frame();
	}
}

/*
	Name: function_bf09b321
	Namespace: namespace_8fb880d9
	Checksum: 0xD52B527
	Offset: 0x51C8
	Size: 0x185
	Parameters: 0
	Flags: None
*/
function function_bf09b321()
{
	self endon("death");
	self endon("hash_68892e65");
	self animMode("none");
	while(1)
	{
		if(isdefined(self.custom_think) && self.custom_think)
		{
			util::wait_network_frame();
			continue;
		}
		else if(isdefined(self.State) && (self.State == "bhb_response" || self.State == "grenade_response"))
		{
			util::wait_network_frame();
			continue;
		}
		else if(isdefined(self.perk))
		{
			self thread function_4305214b();
			self waittill("hash_b8e59c03");
			util::wait_network_frame();
			continue;
		}
		else if(isdefined(self.ground_hit) && self.ground_hit)
		{
			util::wait_network_frame();
			continue;
		}
		else if(!isdefined(self.following_player) || !self.following_player)
		{
			self.following_player = 1;
			self function_d9b855a8("charge_player");
		}
		wait(1);
	}
}

/*
	Name: function_f0891021
	Namespace: namespace_8fb880d9
	Checksum: 0x8FEE4977
	Offset: 0x5358
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function function_f0891021()
{
	self endon("death");
	while(1)
	{
		dist_sq = 0;
		start_pos = self.origin;
		wait(1);
		dist_sq = DistanceSquared(start_pos, self.origin);
		start_pos = self.origin;
		wait(1);
		dist_sq = dist_sq + DistanceSquared(start_pos, self.origin);
		start_pos = self.origin;
		wait(1);
		dist_sq = dist_sq + DistanceSquared(start_pos, self.origin);
		if(dist_sq < 144)
		{
			self.following_player = 1;
			self function_d9b855a8("charge_player");
		}
		wait(3);
	}
}

/*
	Name: function_96c9d732
	Namespace: namespace_8fb880d9
	Checksum: 0x97F2D3C7
	Offset: 0x5478
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function function_96c9d732()
{
	a_s_points = struct::get_array(self.pack.machine.target, "targetname");
	for(i = 0; i < a_s_points.size; i++)
	{
		if(a_s_points[i].script_noteworthy !== "attack_spot")
		{
			continue;
		}
		if(isdefined(self.pack.attack[i]))
		{
			continue;
		}
		self.pack.attack[i] = self;
		self.attack = a_s_points[i];
		break;
	}
}

/*
	Name: function_d1c1e2a0
	Namespace: namespace_8fb880d9
	Checksum: 0x4172D43E
	Offset: 0x5560
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function function_d1c1e2a0()
{
	self.attack = [];
}

/*
	Name: function_f9b5859d
	Namespace: namespace_8fb880d9
	Checksum: 0x45B505A4
	Offset: 0x5578
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function function_f9b5859d()
{
	self endon("death");
	var_61150253 = self.health * 0.75;
	while(1)
	{
		if(self.health <= var_61150253)
		{
			self StopAnimScripted();
			util::wait_network_frame();
			self notify("hash_b8e59c03");
			self function_d9b855a8("charge_player");
			self.var_87a956ff = 1;
			self.perk = undefined;
			break;
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_44d16f7d
	Namespace: namespace_8fb880d9
	Checksum: 0x6EDC99A4
	Offset: 0x5648
	Size: 0x6F
	Parameters: 0
	Flags: None
*/
function function_44d16f7d()
{
	self endon("death");
	var_d0ad1853 = level.monkey_zombie_health * 0.5;
	while(1)
	{
		if(self.health <= var_d0ad1853)
		{
			self.thundergun_fling_func = undefined;
			break;
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_e8496e8a
	Namespace: namespace_8fb880d9
	Checksum: 0x1E70152D
	Offset: 0x56C0
	Size: 0x55
	Parameters: 0
	Flags: None
*/
function function_e8496e8a()
{
	self endon("death");
	while(1)
	{
		if(self.health < self.maxhealth)
		{
			break;
		}
		util::wait_network_frame();
	}
	self notify("speed_up");
}

/*
	Name: monkey_grenade_watcher
	Namespace: namespace_8fb880d9
	Checksum: 0x1C631CBC
	Offset: 0x5720
	Size: 0x85
	Parameters: 0
	Flags: None
*/
function monkey_grenade_watcher()
{
	self endon("death");
	level.monkey_grenades = [];
	level.var_35b3c712 = [];
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread function_ed0e3d5d();
	}
}

/*
	Name: function_ed0e3d5d
	Namespace: namespace_8fb880d9
	Checksum: 0x590A694
	Offset: 0x57B0
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function function_ed0e3d5d()
{
	self endon("death");
	level endon("hash_6a70071f");
	while(1)
	{
		self waittill("grenade_fire", grenade, weapon);
		if(zm_utility::is_lethal_grenade(weapon))
		{
			grenade thread function_cc5f3e87();
			grenade.thrower = self;
			level.monkey_grenades[level.monkey_grenades.size] = grenade;
		}
		if(weapon === level.var_453e74a0)
		{
			grenade thread function_9014347d();
			level.var_35b3c712[level.var_35b3c712.size] = grenade;
		}
		function_aae19d1e("thrown from " + weapon.name);
	}
}

/*
	Name: function_cc5f3e87
	Namespace: namespace_8fb880d9
	Checksum: 0xC692BF9
	Offset: 0x58C0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_cc5f3e87()
{
	self waittill("death");
	ArrayRemoveValue(level.monkey_grenades, self);
	function_aae19d1e("remove grenade from level");
}

/*
	Name: function_9014347d
	Namespace: namespace_8fb880d9
	Checksum: 0x79DBC387
	Offset: 0x5910
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function function_9014347d()
{
	self waittill("death");
	ArrayRemoveValue(level.var_35b3c712, self);
	function_aae19d1e("remove bhb from level");
}

/*
	Name: monkey_zombie_grenade_throw_watcher
	Namespace: namespace_8fb880d9
	Checksum: 0x3A27B53E
	Offset: 0x5960
	Size: 0x183
	Parameters: 2
	Flags: None
*/
function monkey_zombie_grenade_throw_watcher(target, animName)
{
	self endon("death");
	self waittillmatch(animName);
	throw_angle = randomIntRange(20, 30);
	dir = VectorToAngles(target.origin - self.origin);
	dir = (dir[0] - throw_angle, dir[1], dir[2]);
	dir = AnglesToForward(dir);
	velocity = dir * 550;
	fuse = RandomFloatRange(1, 2);
	hand_pos = self GetTagOrigin("TAG_WEAPON_RIGHT");
	grenade_type = target zm_utility::get_player_lethal_grenade();
	self MagicGrenadeType(grenade_type, hand_pos, velocity, fuse);
}

/*
	Name: monkey_zombie_grenade_throw
	Namespace: namespace_8fb880d9
	Checksum: 0xA1826AB6
	Offset: 0x5AF0
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function monkey_zombie_grenade_throw(target)
{
	self endon("death");
	FORWARD = VectorNormalize(AnglesToForward(self.angles));
	end_pos = self.origin + vector_scale(FORWARD, 96);
	if(BulletTracePassed(self.origin, end_pos, 0, undefined))
	{
		self.var_cf51d24 = 1;
	}
	else
	{
		self.var_6602f0c5 = 1;
	}
}

/*
	Name: vector_scale
	Namespace: namespace_8fb880d9
	Checksum: 0x3312341E
	Offset: 0x5BC0
	Size: 0x4D
	Parameters: 2
	Flags: None
*/
function vector_scale(vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

/*
	Name: function_34504f07
	Namespace: namespace_8fb880d9
	Checksum: 0x41B2B5E0
	Offset: 0x5C18
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function function_34504f07()
{
	self endon("death");
	self endon("hash_b8e59c03");
	self endon("hash_ca94520f");
	var_9a27be81 = self.health;
	while(1)
	{
		var_7c7a2243 = self function_c23c2dd0();
		if(isdefined(var_7c7a2243))
		{
			if(var_7c7a2243.is_occupied || self.health < var_9a27be81)
			{
				function_aae19d1e("player is here, go crazy");
				self.var_61aabb9c = level.var_2243306f;
				break;
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_d9b855a8
	Namespace: namespace_8fb880d9
	Checksum: 0x2BC0A51F
	Offset: 0x5CF8
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function function_d9b855a8(State)
{
	self.State = State;
	function_aae19d1e("set state to " + State);
	/#
		if(!isdefined(self.var_ee277195))
		{
			self.var_ee277195 = [];
		}
		if(!isdefined(self.var_d82deb25))
		{
			self.var_d82deb25 = 0;
		}
		self.var_ee277195[self.var_d82deb25] = State;
		self.var_d82deb25++;
		if(self.var_d82deb25 > 100)
		{
			self.var_d82deb25 = 0;
		}
	#/
}

/*
	Name: function_aa171d7c
	Namespace: namespace_8fb880d9
	Checksum: 0xC696F719
	Offset: 0x5DB0
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function function_aa171d7c()
{
	if(isdefined(self.State))
	{
		return self.State;
	}
	return undefined;
}

/*
	Name: function_4afc4cb1
	Namespace: namespace_8fb880d9
	Checksum: 0xBB94FBC4
	Offset: 0x5DD8
	Size: 0x4B3
	Parameters: 0
	Flags: None
*/
function function_4afc4cb1()
{
	self endon("death");
	self endon("hash_b8e59c03");
	self endon("hash_cce726d1");
	if(!isdefined(self.perk))
	{
		return;
	}
	level flag::clear("monkey_free_perk");
	self.following_player = 0;
	self thread function_f9b5859d();
	self function_d9b855a8("attack_perk");
	level thread function_e1503bfc(self.perk.script_noteworthy, self);
	spot = self.attack.script_int;
	self teleport(self.attack.origin, self.attack.angles);
	function_aae19d1e("attack " + self.perk.script_noteworthy + " from " + spot);
	choose = 0;
	if(spot == 1)
	{
		choose = randomIntRange(1, 3);
	}
	else if(spot == 3)
	{
		choose = randomIntRange(3, 5);
	}
	perk_attack_anim = undefined;
	if(choose == 0)
	{
		if(isdefined(level.var_99568ae3[self.perk.script_noteworthy]))
		{
			perk_attack_anim = level.var_99568ae3[self.perk.script_noteworthy]["front"];
		}
	}
	else if(choose == 1)
	{
		if(isdefined(level.var_99568ae3[self.perk.script_noteworthy]))
		{
			perk_attack_anim = level.var_99568ae3[self.perk.script_noteworthy]["left"];
		}
	}
	else if(choose == 2)
	{
		if(isdefined(level.var_99568ae3[self.perk.script_noteworthy]))
		{
			perk_attack_anim = level.var_99568ae3[self.perk.script_noteworthy]["left_top"];
		}
	}
	else if(choose == 3)
	{
		if(isdefined(level.var_99568ae3[self.perk.script_noteworthy]))
		{
			perk_attack_anim = level.var_99568ae3[self.perk.script_noteworthy]["right"];
		}
	}
	else if(choose == 4)
	{
		if(isdefined(level.var_99568ae3[self.perk.script_noteworthy]))
		{
			perk_attack_anim = level.var_99568ae3[self.perk.script_noteworthy]["right_top"];
		}
	}
	if(!isdefined(perk_attack_anim))
	{
		perk_attack_anim = level.var_99568ae3[choose];
	}
	self thread function_c776714a();
	time = getanimlength(perk_attack_anim);
	while(1)
	{
		function_b1050070(self.perk.script_noteworthy);
		self thread play_attack_impacts(time);
		self AnimScripted("attack_perk_anim", self.attack.origin, self.attack.angles, perk_attack_anim);
		if(self function_a66da986(self.var_61aabb9c))
		{
			break;
		}
		wait(time);
	}
	self notify("hash_ca94520f");
	self function_d9b855a8("attack_perk_done");
}

/*
	Name: function_c776714a
	Namespace: namespace_8fb880d9
	Checksum: 0x267F1CFF
	Offset: 0x6298
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_c776714a()
{
	self endon("death");
	wait(0.2);
	self.dropped = 0;
	self.var_f4c4ea1 = self.attack.origin;
	while(1)
	{
		diff = Abs(self.var_f4c4ea1[2] - self.origin[2]);
		if(diff < 8)
		{
			break;
		}
		util::wait_network_frame();
	}
	self.dropped = 1;
	function_aae19d1e("close to ground");
}

/*
	Name: function_e1503bfc
	Namespace: namespace_8fb880d9
	Checksum: 0xB84E8877
	Offset: 0x6370
	Size: 0x219
	Parameters: 2
	Flags: None
*/
function function_e1503bfc(perk, monkey)
{
	var_ea5385f8 = 0;
	if(!isdefined(level.var_63ce4aa9))
	{
		level.var_63ce4aa9 = [];
	}
	if(!isdefined(level.var_63ce4aa9[perk]))
	{
		level.var_63ce4aa9[perk] = 0;
	}
	if(level.var_63ce4aa9[perk])
	{
		return;
	}
	level.var_63ce4aa9[perk] = 1;
	while(1)
	{
		player = GetPlayers();
		rand = randomIntRange(0, player.size);
		if(monkey function_a66da986(monkey.var_61aabb9c))
		{
			level.var_63ce4aa9[perk] = 0;
			return;
		}
		if(isalive(player[rand]) && !player[rand] laststand::player_is_in_laststand() && player[rand] hasPerk(perk))
		{
			player[rand] zm_audio::create_and_play_dialog("perk", "steal_" + perk);
			break;
		}
		else if(var_ea5385f8 >= 6)
		{
			break;
		}
		var_ea5385f8++;
		wait(0.05);
	}
	while(isdefined(monkey) && !monkey function_a66da986(monkey.var_61aabb9c))
	{
		wait(1);
	}
	level.var_63ce4aa9[perk] = 0;
}

/*
	Name: play_attack_impacts
	Namespace: namespace_8fb880d9
	Checksum: 0xFC3E248B
	Offset: 0x6598
	Size: 0x9D
	Parameters: 1
	Flags: None
*/
function play_attack_impacts(time)
{
	self endon("death");
	for(i = 0; i < time; i++)
	{
		if(randomIntRange(0, 100) >= 41)
		{
			self playsound("zmb_monkey_attack_machine");
		}
		wait(RandomFloatRange(0.7, 1.1));
	}
}

/*
	Name: function_4305214b
	Namespace: namespace_8fb880d9
	Checksum: 0x20C94A97
	Offset: 0x6640
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function function_4305214b()
{
	self endon("death");
	self endon("hash_b8e59c03");
	if(isdefined(self.perk))
	{
		self function_d9b855a8("destroy_perk");
		function_aae19d1e("goto " + self.perk.script_noteworthy);
		self function_96c9d732();
		if(isdefined(self.attack))
		{
			self setgoalpos(self.attack.origin);
			self waittill("goal");
			self setgoalpos(self.origin);
			self thread function_34504f07();
			self thread function_4afc4cb1();
		}
	}
}

/*
	Name: function_bed58958
	Namespace: namespace_8fb880d9
	Checksum: 0xD43CF33D
	Offset: 0x6760
	Size: 0x125
	Parameters: 1
	Flags: None
*/
function function_bed58958(spawner)
{
	if(!isdefined(spawner.script_noteworthy))
	{
		return -1;
	}
	if(!isdefined(level.zones) || !isdefined(level.zones[spawner.script_noteworthy]) || !level.zones[spawner.script_noteworthy].is_enabled)
	{
		return -1;
	}
	score = 0;
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		score = Int(DistanceSquared(spawner.origin, players[i].origin));
	}
	return score;
}

/*
	Name: function_d925dbf5
	Namespace: namespace_8fb880d9
	Checksum: 0xB203519F
	Offset: 0x6890
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function function_d925dbf5()
{
	self endon("death");
	if(self.ground_hit)
	{
		return;
	}
	self function_d9b855a8("ground_pound");
	self.ground_hit = 1;
	self thread groundhit_watcher("ground_pound");
	self zombie_shared::DoNoteTracks("ground_pound");
	self.ground_hit = 0;
	self function_d9b855a8("ground_pound_done");
	self.nextGroundHit = GetTime() + level.var_6916b2bf;
	if(self.chest_beat)
	{
		self zombie_shared::DoNoteTracks("board_taunt");
		self.chest_beat = 0;
	}
}

/*
	Name: function_db9ebbd9
	Namespace: namespace_8fb880d9
	Checksum: 0x1D7DE5FC
	Offset: 0x6988
	Size: 0xC5
	Parameters: 1
	Flags: None
*/
function function_db9ebbd9(claymore)
{
	for(i = 0; i < self.monkeys.size; i++)
	{
		if(self.monkeys[i] == self)
		{
			break;
		}
		ready = self.monkeys[i].var_2da34b1;
		if(isdefined(ready))
		{
			for(j = 0; j < ready.size; j++)
			{
				if(claymore == ready[j])
				{
					return 1;
				}
			}
		}
	}
	return 0;
}

/*
	Name: function_1034cff6
	Namespace: namespace_8fb880d9
	Checksum: 0xF4796CDF
	Offset: 0x6A58
	Size: 0x14F
	Parameters: 0
	Flags: None
*/
function function_1034cff6()
{
	if(!isdefined(level.claymores))
	{
		return 0;
	}
	var_36adf538 = 46656;
	var_2b515873 = 12;
	self.var_2da34b1 = [];
	for(i = 0; i < level.claymores.size; i++)
	{
		if(self.pack function_db9ebbd9(level.claymores[i]))
		{
			continue;
		}
		height_diff = Abs(self.origin[2] - level.claymores[i].origin[2]);
		if(height_diff < var_2b515873)
		{
			if(DistanceSquared(self.origin, level.claymores[i].origin) < var_36adf538)
			{
				self.var_2da34b1[self.var_2da34b1.size] = level.claymores[i];
			}
		}
	}
	return self.var_2da34b1.size > 0;
}

/*
	Name: function_5ea57e90
	Namespace: namespace_8fb880d9
	Checksum: 0x2E5F529D
	Offset: 0x6BB0
	Size: 0x27F
	Parameters: 0
	Flags: None
*/
function function_5ea57e90()
{
	self endon("death");
	self.ground_hit = 0;
	self.nextGroundHit = GetTime() + level.var_6916b2bf;
	while(1)
	{
		if(isdefined(self.State) && self.State == "attack_perk")
		{
			util::wait_network_frame();
			continue;
		}
		if(isdefined(self.dropped) && !self.dropped)
		{
			wait(1);
			continue;
		}
		if(!self.ground_hit && self function_1034cff6())
		{
			self.pack function_d2f3f336(self);
			self.var_aa9937 = 1;
		}
		else if(!self.ground_hit && self function_2a8f005e())
		{
			players = GetPlayers();
			closeEnough = 0;
			origin = self GetEye();
			for(i = 0; i < players.size; i++)
			{
				if(players[i] laststand::player_is_in_laststand())
				{
					continue;
				}
				test_origin = players[i] GetEye();
				d = DistanceSquared(origin, test_origin);
				if(d > level.var_16b3fbc0 * level.var_16b3fbc0)
				{
					continue;
				}
				if(!BulletTracePassed(origin, test_origin, 0, undefined))
				{
					continue;
				}
				closeEnough = 1;
				break;
			}
			if(closeEnough)
			{
				self.pack function_d2f3f336(self);
				self.var_aa9937 = 1;
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: groundhit_watcher
	Namespace: namespace_8fb880d9
	Checksum: 0xB1382494
	Offset: 0x6E38
	Size: 0x4AD
	Parameters: 1
	Flags: None
*/
function groundhit_watcher(animName)
{
	self endon("death");
	self waittillmatch(animName);
	PlayFXOnTag(level._effect["monkey_groundhit"], self, "tag_origin");
	self playsound("zmb_monkey_groundpound");
	origin = self.origin + VectorScale((0, 0, 1), 40);
	zombies = Array::get_all_closest(origin, GetAISpeciesArray(level.zombie_team, "all"), undefined, undefined, level.var_9151fd0b);
	if(isdefined(zombies))
	{
		for(i = 0; i < zombies.size; i++)
		{
			if(!isdefined(zombies[i]))
			{
				continue;
			}
			if(zm_utility::is_magic_bullet_shield_enabled(zombies[i]))
			{
				continue;
			}
			test_origin = zombies[i] GetEye();
			if(!BulletTracePassed(origin, test_origin, 0, undefined))
			{
				continue;
			}
			if(zombies[i] == self)
			{
				continue;
			}
			if(zombies[i].animName == "monkey_zombie")
			{
				continue;
			}
			zombies[i] zombie_utility::gib_random_parts();
			GibServerUtils::Annihilate(zombies[i]);
			zombies[i] DoDamage(zombies[i].health * 10, self.origin, self);
		}
	}
	players = GetPlayers();
	affected_players = [];
	for(i = 0; i < players.size; i++)
	{
		if(!zombie_utility::is_player_valid(players[i]))
		{
			continue;
		}
		test_origin = players[i] GetEye();
		if(DistanceSquared(origin, test_origin) > level.var_9151fd0b * level.var_9151fd0b)
		{
			continue;
		}
		if(!BulletTracePassed(origin, test_origin, 0, undefined))
		{
			continue;
		}
		if(!isdefined(affected_players))
		{
			affected_players = [];
		}
		else if(!IsArray(affected_players))
		{
			affected_players = Array(affected_players);
		}
		affected_players[affected_players.size] = players[i];
	}
	self.chest_beat = 0;
	for(i = 0; i < affected_players.size; i++)
	{
		self.chest_beat = 1;
		player = affected_players[i];
		if(player IsOnGround())
		{
			damage = player.maxhealth * 0.5;
			player DoDamage(damage, self.origin, self);
		}
	}
	if(isdefined(self.var_2da34b1))
	{
		for(i = 0; i < self.var_2da34b1.size; i++)
		{
			if(isdefined(self.var_2da34b1[i]))
			{
				self.var_2da34b1[i] detonate(undefined);
			}
		}
	}
}

/*
	Name: monkey_zombie_grenade_pickup
	Namespace: namespace_8fb880d9
	Checksum: 0x69AFA50B
	Offset: 0x72F0
	Size: 0x23F
	Parameters: 0
	Flags: None
*/
function monkey_zombie_grenade_pickup()
{
	self endon("death");
	pickup_dist_sq = 1024;
	picked_up = 0;
	while(isdefined(self.monkey_grenade))
	{
		self setgoalpos(self.monkey_grenade.origin);
		grenade_dist_sq = DistanceSquared(self.origin, self.monkey_grenade.origin);
		if(grenade_dist_sq <= pickup_dist_sq)
		{
			self.monkey_thrower = self.monkey_grenade.thrower;
			self.monkey_grenade delete();
			self.monkey_grenade = undefined;
			picked_up = 1;
			function_aae19d1e("deleting grenade");
		}
		util::wait_network_frame();
	}
	if(picked_up)
	{
		while(1)
		{
			self setgoalpos(self.monkey_thrower.origin);
			target_dir = self.monkey_thrower.origin - self.origin;
			monkey_dir = AnglesToForward(self.angles);
			dot = VectorDot(VectorNormalize(target_dir), VectorNormalize(monkey_dir));
			if(dot >= 0.5)
			{
				break;
			}
			util::wait_network_frame();
		}
		self thread monkey_zombie_grenade_throw(self.monkey_thrower);
		self waittill("throw_done");
	}
}

/*
	Name: monkey_zombie_grenade_response
	Namespace: namespace_8fb880d9
	Checksum: 0xEAF0CDD7
	Offset: 0x7538
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function monkey_zombie_grenade_response()
{
	self endon("death");
	function_aae19d1e("go for grenade");
	self notify("stop_find_flesh");
	self notify("hash_68892e65");
	self notify("hash_b8e59c03");
	self.following_player = 0;
	self function_d9b855a8("grenade_response");
	self function_b486d16b();
	self monkey_zombie_grenade_pickup();
	self thread function_bf09b321();
	self function_d9b855a8("grenade_response_done");
}

/*
	Name: function_5b3f15dd
	Namespace: namespace_8fb880d9
	Checksum: 0x1D822F37
	Offset: 0x7620
	Size: 0x1C7
	Parameters: 0
	Flags: None
*/
function function_5b3f15dd()
{
	self endon("death");
	grenade_respond_dist_sq = 14400;
	while(1)
	{
		if(self.State == "default")
		{
			util::wait_network_frame();
			continue;
		}
		if(isdefined(self.ground_hit) && self.ground_hit)
		{
			util::wait_network_frame();
			continue;
		}
		if(isdefined(self.monkey_grenade) && self.monkey_grenade)
		{
			util::wait_network_frame();
			continue;
		}
		if(level.monkey_grenades.size > 0)
		{
			for(i = 0; i < level.monkey_grenades.size; i++)
			{
				grenade = level.monkey_grenades[i];
				if(!isdefined(grenade) || isdefined(grenade.monkey))
				{
					util::wait_network_frame();
					continue;
				}
				grenade_dist_sq = DistanceSquared(self.origin, grenade.origin);
				if(grenade_dist_sq <= grenade_respond_dist_sq)
				{
					grenade.monkey = self;
					self.monkey_grenade = grenade;
					self monkey_zombie_grenade_response();
					break;
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_7c76fa54
	Namespace: namespace_8fb880d9
	Checksum: 0x7E5749EC
	Offset: 0x77F0
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function function_7c76fa54()
{
	self endon("death");
	function_aae19d1e("bhb teleport");
	black_hole_teleport = struct::get_array("struct_black_hole_teleport", "targetname");
	zone_name = self zm_utility::get_current_zone();
	locations = [];
	for(i = 0; i < black_hole_teleport.size; i++)
	{
		var_43372222 = black_hole_teleport[i].script_string;
		if(!isdefined(var_43372222) || !isdefined(zone_name))
		{
			continue;
		}
		if(var_43372222 == zone_name)
		{
			continue;
		}
		if(!level.zones[var_43372222].is_enabled)
		{
			continue;
		}
		locations[locations.size] = black_hole_teleport[i];
	}
	self StopAnimScripted();
	util::wait_network_frame();
	so = spawn("script_origin", self.origin);
	so.angles = self.angles;
	self LinkTo(so);
	if(locations.size > 0)
	{
		locations = Array::randomize(locations);
		so.origin = locations[0].origin;
		so.angles = locations[0].angles;
	}
	else
	{
		so.origin = self.spawn_origin;
		so.angles = self.spawn_angles;
	}
	util::wait_network_frame();
	self Unlink();
	so delete();
}

/*
	Name: function_ed69ccce
	Namespace: namespace_8fb880d9
	Checksum: 0xA7C2F25E
	Offset: 0x7A80
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_ed69ccce()
{
	self endon("death");
	self endon("hash_64ba5cff");
	prev_origin = self.origin;
	var_93f1e3f9 = 256;
	while(1)
	{
		wait(1);
		dist = DistanceSquared(prev_origin, self.origin);
		if(dist < var_93f1e3f9)
		{
			break;
		}
		prev_origin = self.origin;
	}
	if(self.State == "ground_pound")
	{
		return;
	}
	self.safeToChangeScript = 1;
	self animMode("none");
}

/*
	Name: function_726cf50c
	Namespace: namespace_8fb880d9
	Checksum: 0x734A7129
	Offset: 0x7B68
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function function_726cf50c()
{
	self endon("death");
	var_37636677 = 4096;
	jump = 0;
	util::wait_network_frame();
	if(!isdefined(self.var_3cb23523) || !isdefined(self.var_3cb23523.origin))
	{
		return;
	}
	self.safeToChangeScript = 0;
	self setgoalpos(self.var_3cb23523.origin);
	while(isdefined(self.var_3cb23523))
	{
		var_2c3a2d7d = DistanceSquared(self.origin, self.var_3cb23523.origin);
		if(var_2c3a2d7d <= var_37636677)
		{
			jump = 1;
			break;
		}
		util::wait_network_frame();
	}
	if(jump)
	{
		self function_7c76fa54();
	}
	util::wait_network_frame();
	self.safeToChangeScript = 1;
	self setgoalpos(self.origin);
	self util::waittill_notify_or_timeout("goal", 0.5);
	self notify("hash_64ba5cff");
	util::wait_network_frame();
	self thread function_ed69ccce();
}

/*
	Name: function_b486d16b
	Namespace: namespace_8fb880d9
	Checksum: 0x34F47F59
	Offset: 0x7D38
	Size: 0xA1
	Parameters: 0
	Flags: None
*/
function function_b486d16b()
{
	if(isdefined(self.attack))
	{
		if(isdefined(self.pack.attack))
		{
			for(i = 0; i < self.pack.attack.size; i++)
			{
				if(self == self.pack.attack[i])
				{
					ArrayRemoveValue(self.pack.attack, self);
					self.attack = undefined;
					return;
				}
			}
		}
	}
}

/*
	Name: function_764d3d90
	Namespace: namespace_8fb880d9
	Checksum: 0xD37F4E19
	Offset: 0x7DE8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function function_764d3d90()
{
	self endon("death");
	function_aae19d1e("bhb response");
	self notify("stop_find_flesh");
	self notify("hash_68892e65");
	self notify("hash_b8e59c03");
	self.following_player = 0;
	self function_d9b855a8("bhb_response");
	self function_b486d16b();
	self function_726cf50c();
	self thread function_bf09b321();
	self function_d9b855a8("bhb_response_done");
}

/*
	Name: function_5cbf8fcf
	Namespace: namespace_8fb880d9
	Checksum: 0x354F630B
	Offset: 0x7ED0
	Size: 0x1FF
	Parameters: 0
	Flags: None
*/
function function_5cbf8fcf()
{
	self endon("death");
	var_49535fb3 = 262144;
	while(1)
	{
		if(self.State == "default" || self.State == "ground_pound" || self.State == "ground_pound_taunt" || self.State == "grenade_reponse" || self.State == "bhb_response" || self.State == "attack_perk" || (!isdefined(self.dropped) && self.dropped))
		{
			util::wait_network_frame();
			continue;
		}
		if(level.var_35b3c712.size > 0)
		{
			for(i = 0; i < level.var_35b3c712.size; i++)
			{
				bhb = level.var_35b3c712[i];
				if(isdefined(bhb.is_valid) && bhb.is_valid)
				{
					if(!isdefined(bhb) || !isdefined(bhb.origin) || !isdefined(self.origin))
					{
						continue;
					}
					var_2c3a2d7d = DistanceSquared(self.origin, bhb.origin);
					if(var_2c3a2d7d <= var_49535fb3)
					{
						self.var_3cb23523 = bhb;
						self function_764d3d90();
					}
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: monkey_remove_from_pack
	Namespace: namespace_8fb880d9
	Checksum: 0xBD54D08F
	Offset: 0x80D8
	Size: 0x283
	Parameters: 0
	Flags: None
*/
function monkey_remove_from_pack()
{
	for(i = 0; i < level.var_ecb65a32.size; i++)
	{
		pack = level.var_ecb65a32[i];
		for(j = 0; j < pack.monkeys.size; j++)
		{
			if(self == pack.monkeys[j])
			{
				ArrayRemoveValue(pack.monkeys, self);
				if(pack.monkeys.size == 0 && pack.var_9d1c9c35)
				{
					if(isdefined(pack.perk))
					{
						pack.perk.targeted = 0;
					}
					level.var_e810cac3++;
					level flag::set("monkey_pack_down");
					ArrayRemoveValue(level.var_ecb65a32, pack);
				}
			}
		}
	}
	if(level.var_e810cac3 >= level.var_3bf8b909)
	{
		level flag::set("last_monkey_down");
		if(self function_5d83da34())
		{
			FORWARD = VectorNormalize(AnglesToForward(self.angles));
			end_pos = self.origin - VectorScale(FORWARD, 32);
			level thread zm_powerups::specific_powerup_drop("free_perk", end_pos);
		}
		drop_pos = self.origin;
		if(self.State == "attack_perk" || !self.dropped)
		{
			drop_pos = self.attack.origin;
		}
		level thread zm_powerups::specific_powerup_drop("full_ammo", drop_pos);
	}
}

/*
	Name: function_5d83da34
	Namespace: namespace_8fb880d9
	Checksum: 0xFC516522
	Offset: 0x8368
	Size: 0x1F5
	Parameters: 0
	Flags: None
*/
function function_5d83da34()
{
	if(!level flag::get("monkey_free_perk"))
	{
		return 0;
	}
	max_perks = 0;
	if(!isdefined(level.max_perks))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		max_perks = 4;
	}
	else
	{
		max_perks = level.max_perks;
	}
	if(level flag::get("solo_game"))
	{
		if(level.solo_lives_given >= level.max_solo_lives)
		{
			players = GetPlayers();
			if(!players[0] hasPerk("specialty_quickrevive"))
			{
				max_perks--;
			}
		}
	}
	players = GetPlayers();
	vending_triggers = function_5b9c3e11();
	for(i = 0; i < players.size; i++)
	{
		num_perks = 0;
		for(j = 0; j < vending_triggers.size; j++)
		{
			perk = vending_triggers[j].script_noteworthy;
			if(players[i] hasPerk(perk))
			{
				num_perks++;
			}
		}
		if(num_perks < max_perks)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: function_d355c044
	Namespace: namespace_8fb880d9
	Checksum: 0x7AE6BCC6
	Offset: 0x8568
	Size: 0x1E5
	Parameters: 8
	Flags: None
*/
function function_d355c044(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	self zombie_utility::reset_attack_spot();
	self clientfield::set("monkey_eye_glow", 0);
	self.grenadeAmmo = 0;
	playFX(level._effect["monkey_death"], self.origin);
	playsoundatposition("zmb_monkey_explode", self.origin);
	level zm_spawner::zombie_death_points(self.origin, self.damageMod, self.damagelocation, self.attacker, self);
	if(randomIntRange(0, 100) >= 75)
	{
		if(isdefined(self.attacker) && isPlayer(self.attacker))
		{
			self.attacker zm_audio::create_and_play_dialog("kill", "space_monkey");
		}
	}
	if(self.damageMod == "MOD_BURNED")
	{
		self thread zombie_death::flame_death_fx();
	}
	level.monkey_death++;
	level.monkey_death_total++;
	self monkey_remove_from_pack();
	self bgb::actor_death_override(attacker);
	return 0;
}

/*
	Name: function_f501d50
	Namespace: namespace_8fb880d9
	Checksum: 0x3BCAA02D
	Offset: 0x8758
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function function_f501d50(player)
{
	self endon("death");
	damage = self.meleeDamage;
	if(isdefined(self.ground_hit) && self.ground_hit)
	{
		damage = Int(player.maxhealth * 0.25);
	}
	return damage;
}

/*
	Name: monkey_zombie_default_enter_level
	Namespace: namespace_8fb880d9
	Checksum: 0xBCE782CF
	Offset: 0x87D8
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function monkey_zombie_default_enter_level()
{
	playFX(level._effect["monkey_spawn"], self.origin);
	playsoundatposition("zmb_ape_intro_land", self.origin);
}

/*
	Name: monkey_pathing
	Namespace: namespace_8fb880d9
	Checksum: 0xDEB7447F
	Offset: 0x8838
	Size: 0x87
	Parameters: 0
	Flags: None
*/
function monkey_pathing()
{
	self endon("death");
	while(1)
	{
		if(isdefined(self.favoriteenemy))
		{
			self.ignoreall = 0;
			self OrientMode("face default");
			self setgoalpos(self.favoriteenemy.origin);
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_8ef4eaf7
	Namespace: namespace_8fb880d9
	Checksum: 0xEA435C5B
	Offset: 0x88C8
	Size: 0x1AF
	Parameters: 0
	Flags: None
*/
function function_8ef4eaf7()
{
	self endon("death");
	level endon("intermission");
	self endon("stop_find_flesh");
	if(level.intermission)
	{
		return;
	}
	self zm_spawner::zombie_history("monkey find flesh -> start");
	self.goalRadius = 48;
	players = GetPlayers();
	self.ignore_player = [];
	player = zm_utility::get_closest_valid_player(self.origin, self.ignore_player);
	if(!isdefined(player))
	{
		self zm_spawner::zombie_history("monkey find flesh -> can't find player, continue");
	}
	self.favoriteenemy = player;
	while(1)
	{
		if(isdefined(self.pack) && isdefined(self.pack.enemy))
		{
			if(!isdefined(self.favoriteenemy) || self.favoriteenemy != self.pack.enemy)
			{
				self.favoriteenemy = self.pack.enemy;
			}
		}
		if(isdefined(level.var_66fdee6d))
		{
			self thread monkey_pathing();
		}
		else
		{
			self.ignoreall = 0;
			self OrientMode("face default");
		}
		wait(0.1);
	}
}

/*
	Name: function_d8ac7d7f
	Namespace: namespace_8fb880d9
	Checksum: 0x3EC90D76
	Offset: 0x8A80
	Size: 0x65
	Parameters: 0
	Flags: None
*/
function function_d8ac7d7f()
{
	vending_triggers = function_5b9c3e11();
	for(i = 0; i < vending_triggers.size; i++)
	{
		vending_triggers[i] function_dbcd70d7();
	}
}

/*
	Name: function_dbcd70d7
	Namespace: namespace_8fb880d9
	Checksum: 0x765FE1C5
	Offset: 0x8AF0
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function function_dbcd70d7()
{
	self.targeted = 0;
	machine = undefined;
	targets = GetEntArray(self.target, "targetname");
	for(i = 0; i < targets.size; i++)
	{
		if(targets[i].classname == "script_model")
		{
			machine = targets[i];
			break;
		}
	}
	if(isdefined(machine))
	{
		machine.var_e91fc987 = 100;
	}
}

/*
	Name: function_a66da986
	Namespace: namespace_8fb880d9
	Checksum: 0xC385BA4B
	Offset: 0x8BC8
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function function_a66da986(amount)
{
	if(!isdefined(self.perk))
	{
		return 1;
	}
	machine = self.pack.machine;
	machine.var_e91fc987 = machine.var_e91fc987 - amount;
	if(machine.var_e91fc987 < 0)
	{
		machine.var_e91fc987 = 0;
	}
	return machine.var_e91fc987 == 0;
}

/*
	Name: function_e0d1a467
	Namespace: namespace_8fb880d9
	Checksum: 0x8157CC0E
	Offset: 0x8C70
	Size: 0x115
	Parameters: 0
	Flags: None
*/
function function_e0d1a467()
{
	players = GetPlayers();
	self.perk.targeted = 0;
	perk = self.perk.script_noteworthy;
	for(i = 0; i < players.size; i++)
	{
		if(players[i] hasPerk(perk))
		{
			perk_str = perk + "_stop";
			players[i] notify(perk_str);
			if(level flag::get("solo_game") && perk == "specialty_quickrevive")
			{
				players[i].lives--;
			}
		}
	}
}

/*
	Name: function_85994fd6
	Namespace: namespace_8fb880d9
	Checksum: 0x32F7BB71
	Offset: 0x8D90
	Size: 0x3F
	Parameters: 1
	Flags: None
*/
function function_85994fd6(perk)
{
	if(perk == "specialty_armorvest")
	{
		if(self.health > self.maxhealth)
		{
			self.health = self.maxhealth;
		}
	}
}

/*
	Name: function_57ee756d
	Namespace: namespace_8fb880d9
	Checksum: 0xEE4A1DF1
	Offset: 0x8DD8
	Size: 0x35
	Parameters: 1
	Flags: None
*/
function function_57ee756d(perk)
{
	level flag::set("perk_bought");
	level.perk_bought_func = undefined;
}

/*
	Name: function_b1050070
	Namespace: namespace_8fb880d9
	Checksum: 0x9D28A0F2
	Offset: 0x8E18
	Size: 0xA5
	Parameters: 1
	Flags: None
*/
function function_b1050070(perk)
{
	if(!isdefined(perk))
	{
		return;
	}
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] hasPerk(perk))
		{
			players[i] thread function_7acaa6b4(perk);
		}
	}
}

/*
	Name: function_7acaa6b4
	Namespace: namespace_8fb880d9
	Checksum: 0xB92B76EC
	Offset: 0x8EC8
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function function_7acaa6b4(perk)
{
	self endon("disconnect");
	if(!isdefined(self.perk_hud_flash) || self.perk_hud_flash != perk)
	{
		self.perk_hud_flash = perk;
		self zm_perks::set_perk_clientfield(perk, 2);
		wait(0.3);
		if(self hasPerk(perk))
		{
			self zm_perks::set_perk_clientfield(perk, 1);
		}
		self.perk_hud_flash = "none";
	}
}

/*
	Name: function_9a616a62
	Namespace: namespace_8fb880d9
	Checksum: 0xF458E4A4
	Offset: 0x8F88
	Size: 0x59
	Parameters: 2
	Flags: None
*/
function function_9a616a62(perk, taken)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
	}
}

/*
	Name: function_c23c2dd0
	Namespace: namespace_8fb880d9
	Checksum: 0x34FF64E3
	Offset: 0x8FF0
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function function_c23c2dd0()
{
	zone = undefined;
	keys = getArrayKeys(level.zones);
	for(i = 0; i < keys.size; i++)
	{
		zone = level.zones[keys[i]];
		for(j = 0; j < zone.Volumes.size; j++)
		{
			if(self istouching(zone.Volumes[j]))
			{
				return zone;
			}
		}
	}
	return zone;
}

/*
	Name: function_1d77501d
	Namespace: namespace_8fb880d9
	Checksum: 0xA35DB57
	Offset: 0x90E0
	Size: 0x1E9
	Parameters: 1
	Flags: None
*/
function function_1d77501d(player)
{
	function_aae19d1e("fling monkey damage");
	damage = Int(level.monkey_zombie_health * 0.5);
	self DoDamage(damage, self.origin, self);
	FORWARD = VectorNormalize(AnglesToForward(self.angles));
	var_4d497f8d = VectorNormalize(self.origin - player.origin);
	dot = VectorDot(var_4d497f8d, FORWARD);
	if(dot < 0)
	{
		end_pos = self.origin - VectorScale(FORWARD, 120);
		if(SightTracePassed(self.origin, end_pos, 0, self))
		{
			flings = Array::randomize(level.var_45abf882);
			length = getanimlength(flings[0]);
			self AnimScripted("fling_anim", self.origin, self.angles, flings[0]);
			wait(length);
		}
	}
	self.thundergun_fling_func = undefined;
}

/*
	Name: function_67695f31
	Namespace: namespace_8fb880d9
	Checksum: 0x2BB34DC
	Offset: 0x92D8
	Size: 0x99
	Parameters: 0
	Flags: None
*/
function function_67695f31()
{
	vending_triggers = GetEntArray("zombie_vending", "targetname");
	for(i = 0; i < vending_triggers.size; i++)
	{
		if(vending_triggers[i].script_noteworthy == "specialty_quickrevive")
		{
			vending_triggers[i] delete();
			break;
		}
	}
}

/*
	Name: function_aae19d1e
	Namespace: namespace_8fb880d9
	Checksum: 0xBD32F045
	Offset: 0x9380
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function function_aae19d1e(STR)
{
	/#
		if(isdefined(level.var_ce37864e) && level.var_ce37864e)
		{
			iprintln(STR + "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: play_random_monkey_vox
	Namespace: namespace_8fb880d9
	Checksum: 0x706E2277
	Offset: 0x93D0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function play_random_monkey_vox()
{
	self endon("death");
	while(1)
	{
		wait(RandomFloatRange(1.25, 3));
	}
}

