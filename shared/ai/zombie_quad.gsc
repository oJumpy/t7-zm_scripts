#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
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
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#namespace ZombieQuad;

/*
	Name: init
	Namespace: ZombieQuad
	Checksum: 0xF8CA25E9
	Offset: 0x500
	Size: 0x63
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitZombieBehaviorsAndASM();
	spawner::add_archetype_spawn_function("zombie_quad", &ArchetypeQuadBlackboardInit);
	spawner::add_archetype_spawn_function("zombie_quad", &quadSpawnSetup);
}

/*
	Name: ArchetypeQuadBlackboardInit
	Namespace: ZombieQuad
	Checksum: 0xEA8AE66B
	Offset: 0x570
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function ArchetypeQuadBlackboardInit()
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
	blackboard::RegisterBlackBoardAttribute(self, "_quad_wall_crawl", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_quad_phase_direction", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_quad_phase_distance", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeQuadOnAnimscriptedCallback;
	/#
		self function_89398c57();
	#/
}

/*
	Name: ArchetypeQuadOnAnimscriptedCallback
	Namespace: ZombieQuad
	Checksum: 0x9BA23D08
	Offset: 0x768
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeQuadOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeQuadBlackboardInit();
}

/*
	Name: InitZombieBehaviorsAndASM
	Namespace: ZombieQuad
	Checksum: 0x3FDCD04F
	Offset: 0x7A8
	Size: 0x33
	Parameters: 0
	Flags: Private
*/
function private InitZombieBehaviorsAndASM()
{
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_traversal@zombie_quad", &quadTeleportTraversalMocompStart, undefined, undefined);
}

/*
	Name: quadSpawnSetup
	Namespace: ZombieQuad
	Checksum: 0x53578EC6
	Offset: 0x7E8
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function quadSpawnSetup()
{
	self SetPitchOrient();
}

/*
	Name: quadTeleportTraversalMocompStart
	Namespace: ZombieQuad
	Checksum: 0x9E0E2C39
	Offset: 0x810
	Size: 0x19B
	Parameters: 5
	Flags: None
*/
function quadTeleportTraversalMocompStart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
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

