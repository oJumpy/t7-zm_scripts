#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_portals;

#namespace zm_genesis_keeper;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_keeper
	Checksum: 0xBF3BCC08
	Offset: 0x8A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_keeper", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_keeper
	Checksum: 0x8D712BE5
	Offset: 0x8E8
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	function_cf48298e();
	if(ai::shouldRegisterClientFieldForArchetype("keeper"))
	{
		clientfield::register("actor", "keeper_death", 15000, 2, "int");
	}
	/#
		AddDebugCommand("Dev Block strings are not supported");
		thread function_85d4833b();
	#/
}

/*
	Name: function_cf48298e
	Namespace: zm_genesis_keeper
	Checksum: 0x7577D640
	Offset: 0x980
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private function_cf48298e()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("genesisKeeperDeathStart", &function_9d655978);
}

/*
	Name: function_9d655978
	Namespace: zm_genesis_keeper
	Checksum: 0x90C9DAC
	Offset: 0x9B8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function function_9d655978(entity)
{
	if(entity.model == "c_zom_dlc4_keeper_hooded_body")
	{
		entity SetModel("c_zom_dlc4_keeper_hooded_dissolve");
	}
	else
	{
		entity SetModel("c_zom_dlc4_keeper_dissolve");
	}
	entity clientfield::set("keeper_death", 2);
	entity notsolid();
}

/*
	Name: function_f8c7a969
	Namespace: zm_genesis_keeper
	Checksum: 0x342DFC2A
	Offset: 0xA60
	Size: 0x7F
	Parameters: 8
	Flags: None
*/
function function_f8c7a969(inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTimes)
{
	self clientfield::set("keeper_death", 1);
	self notsolid();
	return damage;
}

/*
	Name: function_51dd865c
	Namespace: zm_genesis_keeper
	Checksum: 0x1675D5D9
	Offset: 0xAE8
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_51dd865c()
{
	spawner::add_archetype_spawn_function("keeper", &function_cb6b3469);
	spawner::add_archetype_spawn_function("keeper", &function_6ded398b);
	spawner::add_archetype_spawn_function("keeper", &function_e5e94978);
	spawner::add_archetype_spawn_function("keeper", &function_1dcdd145);
	level thread AAT::register_immunity("zm_aat_turned", "keeper", 1, 1, 1);
}

/*
	Name: function_85d4833b
	Namespace: zm_genesis_keeper
	Checksum: 0x4CD6703D
	Offset: 0xBC8
	Size: 0x43
	Parameters: 0
	Flags: Private
*/
function private function_85d4833b()
{
	level flagsys::wait_till("start_zombie_round_logic");
	zm_devgui::add_custom_devgui_callback(&function_e361808);
}

/*
	Name: function_24dd2f20
	Namespace: zm_genesis_keeper
	Checksum: 0x7FCC54C6
	Offset: 0xC18
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_24dd2f20()
{
	self waittill("death", e_attacker);
	if(isdefined(e_attacker) && isdefined(e_attacker.var_4d307aef))
	{
		e_attacker.var_4d307aef++;
	}
	if(isdefined(e_attacker) && isdefined(e_attacker.var_8b5008fe))
	{
		e_attacker.var_8b5008fe++;
	}
}

/*
	Name: function_e361808
	Namespace: zm_genesis_keeper
	Checksum: 0x8DE5A6CE
	Offset: 0xC98
	Size: 0x145
	Parameters: 1
	Flags: Private
*/
function private function_e361808(cmd)
{
	switch(cmd)
	{
		case "genesis_keeper_spawn":
		{
			queryResult = PositionQuery_Source_Navigation(level.players[0].origin, 128, 256, 128, 20);
			if(isdefined(queryResult) && queryResult.data.size > 0)
			{
				origin = queryResult.data[0].origin;
				angles = level.players[0].angles;
				entity = SpawnActor("spawner_zm_genesis_keeper", origin, level.players[0].angles, undefined, 1, 1);
				if(isdefined(entity))
				{
					entity thread function_dfdf3fc1();
				}
			}
			break;
		}
	}
}

/*
	Name: function_dfdf3fc1
	Namespace: zm_genesis_keeper
	Checksum: 0x57EDFA8F
	Offset: 0xDE8
	Size: 0xAF
	Parameters: 0
	Flags: Private
*/
function private function_dfdf3fc1()
{
	self endon("death");
	self.spawn_time = GetTime();
	self thread function_24dd2f20();
	self.heroweapon_kill_power = 2;
	self.voicePrefix = "keeper";
	self.animName = "keeper";
	self thread zm_spawner::play_ambient_zombie_vocals();
	self thread zm_audio::zmbAIVox_NotifyConvert();
	self PushActors(1);
	wait(1);
	self.zombie_think_done = 1;
}

/*
	Name: function_6ded398b
	Namespace: zm_genesis_keeper
	Checksum: 0x78076D56
	Offset: 0xEA0
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function function_6ded398b()
{
	AiUtility::AddAIOverrideDamageCallback(self, &damage_callback);
	self thread zm::update_zone_name();
	self AAT::aat_cooldown_init();
	self thread zm_spawner::enemy_death_detection();
	self.completed_emerging_into_playable_area = 1;
	self.is_zombie = 1;
}

/*
	Name: function_e5e94978
	Namespace: zm_genesis_keeper
	Checksum: 0x8D5604B9
	Offset: 0xF30
	Size: 0x157
	Parameters: 0
	Flags: None
*/
function function_e5e94978()
{
	self endon("death");
	while(isalive(self))
	{
		self waittill("damage");
		if(isPlayer(self.attacker))
		{
			if(zm_spawner::player_using_hi_score_weapon(self.attacker))
			{
				str_notify = "damage";
			}
			else
			{
				str_notify = "damage_light";
			}
			if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
			{
				self.attacker zm_score::player_add_points(str_notify, self.damageMod, self.damagelocation, undefined, self.team, self.damageWeapon);
			}
			if(isdefined(level.hero_power_update))
			{
				[[level.hero_power_update]](self.attacker, self);
			}
			self.attacker.use_weapon_type = self.damageMod;
			self thread zm_powerups::check_for_instakill(self.attacker, self.damageMod, self.damagelocation);
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_1dcdd145
	Namespace: zm_genesis_keeper
	Checksum: 0x7E1AEA6C
	Offset: 0x1090
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function function_1dcdd145()
{
	self waittill("death");
	self zm_spawner::check_zombie_death_event_callbacks(self.attacker);
	if(isPlayer(self.attacker))
	{
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			self.attacker zm_score::player_add_points("death", self.damageMod, self.damagelocation, undefined, self.team, self.damageWeapon);
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](self.attacker, self);
		}
	}
}

/*
	Name: damage_callback
	Namespace: zm_genesis_keeper
	Checksum: 0xCAD2AEB6
	Offset: 0x1158
	Size: 0x12B
	Parameters: 12
	Flags: None
*/
function damage_callback(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex)
{
	if(isPlayer(eAttacker) && (isdefined(eAttacker.var_74fe492b) && eAttacker.var_74fe492b))
	{
		iDamage = Int(iDamage * 1.33);
	}
	if(isPlayer(eAttacker) && (isdefined(eAttacker.var_e8e8daad) && eAttacker.var_e8e8daad))
	{
		iDamage = Int(iDamage * 1.5);
	}
	return iDamage;
}

/*
	Name: BB_GetArmsPosition
	Namespace: zm_genesis_keeper
	Checksum: 0x88565184
	Offset: 0x1290
	Size: 0x39
	Parameters: 0
	Flags: None
*/
function BB_GetArmsPosition()
{
	if(isdefined(self.zombie_arms_position))
	{
		if(self.zombie_arms_position == "up")
		{
			return "arms_up";
		}
		return "arms_down";
	}
	return "arms_up";
}

/*
	Name: BB_GetLocomotionSpeedType
	Namespace: zm_genesis_keeper
	Checksum: 0x337810F0
	Offset: 0x12D8
	Size: 0x91
	Parameters: 0
	Flags: None
*/
function BB_GetLocomotionSpeedType()
{
	if(isdefined(self.zombie_move_speed))
	{
		if(self.zombie_move_speed == "walk")
		{
			return "locomotion_speed_walk";
		}
		else if(self.zombie_move_speed == "run")
		{
			return "locomotion_speed_run";
		}
		else if(self.zombie_move_speed == "sprint")
		{
			return "locomotion_speed_sprint";
		}
		else if(self.zombie_move_speed == "super_sprint")
		{
			return "locomotion_speed_super_sprint";
		}
	}
	return "locomotion_speed_walk";
}

/*
	Name: BB_GetVariantType
	Namespace: zm_genesis_keeper
	Checksum: 0xF8A28D87
	Offset: 0x1378
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function BB_GetVariantType()
{
	if(isdefined(self.variant_type))
	{
		return self.variant_type;
	}
	return 0;
}

/*
	Name: BB_GetHasLegsStatus
	Namespace: zm_genesis_keeper
	Checksum: 0x20FC1030
	Offset: 0x13A0
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function BB_GetHasLegsStatus()
{
	if(self.missingLegs)
	{
		return "has_legs_no";
	}
	return "has_legs_yes";
}

/*
	Name: BB_GetShouldTurn
	Namespace: zm_genesis_keeper
	Checksum: 0xCB6073E9
	Offset: 0x13C8
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function BB_GetShouldTurn()
{
	if(isdefined(self.should_turn) && self.should_turn)
	{
		return "should_turn";
	}
	return "should_not_turn";
}

/*
	Name: BB_IDGunGetDamageDirection
	Namespace: zm_genesis_keeper
	Checksum: 0x358A8727
	Offset: 0x1400
	Size: 0x29
	Parameters: 0
	Flags: None
*/
function BB_IDGunGetDamageDirection()
{
	if(isdefined(self.damage_direction))
	{
		return self.damage_direction;
	}
	return self AiUtility::BB_GetDamageDirection();
}

/*
	Name: BB_GetLowGravityVariant
	Namespace: zm_genesis_keeper
	Checksum: 0x8EED25C3
	Offset: 0x1438
	Size: 0x19
	Parameters: 0
	Flags: None
*/
function BB_GetLowGravityVariant()
{
	if(isdefined(self.LOW_GRAVITY_VARIANT))
	{
		return self.LOW_GRAVITY_VARIANT;
	}
	return 0;
}

/*
	Name: function_cb6b3469
	Namespace: zm_genesis_keeper
	Checksum: 0x87A071F2
	Offset: 0x1460
	Size: 0x4FB
	Parameters: 0
	Flags: None
*/
function function_cb6b3469()
{
	blackboard::CreateBlackBoardForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	ai::CreateInterfaceForEntity(self);
	blackboard::RegisterBlackBoardAttribute(self, "_arms_position", "arms_up", &BB_GetArmsPosition);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_walk", &BB_GetLocomotionSpeedType);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_has_legs", "has_legs_yes", &BB_GetHasLegsStatus);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_variant_type", 0, &BB_GetVariantType);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_which_board_pull", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_board_attack_spot", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_grapple_direction", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_locomotion_should_turn", "should_not_turn", &BB_GetShouldTurn);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_idgun_damage_direction", "back", &BB_IDGunGetDamageDirection);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_low_gravity_variant", 0, &BB_GetLowGravityVariant);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_knockdown_direction", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_knockdown_type", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self trackblackboardattribute("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeZombieOnAnimscriptedCallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: ArchetypeZombieOnAnimscriptedCallback
	Namespace: zm_genesis_keeper
	Checksum: 0xC2B3157C
	Offset: 0x1968
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeZombieOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity function_cb6b3469();
}

