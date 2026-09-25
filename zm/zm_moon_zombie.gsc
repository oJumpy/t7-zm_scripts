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
#using scripts\zm\_zm_weap_black_hole_bomb;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_remaster_zombie;

#namespace namespace_3bf51f67;

/*
	Name: init
	Namespace: namespace_3bf51f67
	Checksum: 0x75E6897A
	Offset: 0x420
	Size: 0x43
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitZmBehaviorsAndASM();
	level thread namespace_1d57720d::update_closest_player();
	level.last_valid_position_override = &function_2df3c740;
}

/*
	Name: InitZmBehaviorsAndASM
	Namespace: namespace_3bf51f67
	Checksum: 0x5EB80163
	Offset: 0x470
	Size: 0xA3
	Parameters: 0
	Flags: Private
*/
function private InitZmBehaviorsAndASM()
{
	spawner::add_archetype_spawn_function("zombie", &function_7a726580);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("moonZombieKilledByMicrowaveGunDw", &function_3679b8f9);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("moonZombieKilledByMicrowaveGun", &function_8defac52);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("moonShouldMoveLowg", &function_78b1e165);
}

/*
	Name: function_5683b5d5
	Namespace: namespace_3bf51f67
	Checksum: 0xFCA9F6F4
	Offset: 0x520
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
	Namespace: namespace_3bf51f67
	Checksum: 0x16A304C0
	Offset: 0x6C8
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
	Name: function_7a726580
	Namespace: namespace_3bf51f67
	Checksum: 0xFC1EA588
	Offset: 0x860
	Size: 0x33
	Parameters: 0
	Flags: Private
*/
function private function_7a726580()
{
	self.cant_move_cb = &function_2a29252b;
	self.closest_player_override = &namespace_1d57720d::function_3ff94b60;
}

/*
	Name: function_2a29252b
	Namespace: namespace_3bf51f67
	Checksum: 0x437A67E1
	Offset: 0x8A0
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private function_2a29252b()
{
	self PushActors(0);
	self.enablePushTime = GetTime() + 1000;
}

/*
	Name: function_3679b8f9
	Namespace: namespace_3bf51f67
	Checksum: 0xB0447E76
	Offset: 0x8D8
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function function_3679b8f9(entity)
{
	return isdefined(entity.microwavegun_dw_death) && entity.microwavegun_dw_death;
}

/*
	Name: function_8defac52
	Namespace: namespace_3bf51f67
	Checksum: 0x35DF044E
	Offset: 0x910
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function function_8defac52(entity)
{
	return isdefined(entity.microwavegun_death) && entity.microwavegun_death;
}

/*
	Name: function_78b1e165
	Namespace: namespace_3bf51f67
	Checksum: 0x58C9938F
	Offset: 0x948
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function function_78b1e165(entity)
{
	return isdefined(entity.in_low_gravity) && entity.in_low_gravity;
}

/*
	Name: function_2df3c740
	Namespace: namespace_3bf51f67
	Checksum: 0x486B431E
	Offset: 0x980
	Size: 0xD3
	Parameters: 0
	Flags: None
*/
function function_2df3c740()
{
	if(isdefined(self.in_low_gravity) && self.in_low_gravity)
	{
		if(self IsOnGround())
		{
			return 0;
		}
		trace = GroundTrace(self.origin + VectorScale((0, 0, 1), 15), self.origin + VectorScale((0, 0, -1), 1000), 0, undefined);
		ground_pos = trace["position"];
		if(isdefined(ground_pos))
		{
			if(IsPointOnNavMesh(ground_pos, self))
			{
				self.last_valid_position = ground_pos;
				return 1;
			}
		}
	}
	return 0;
}

