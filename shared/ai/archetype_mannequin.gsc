#using scripts\shared\ai\archetype_mannequin_interface;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\spawner_shared;

#namespace MannequinBehavior;

/*
	Name: init
	Namespace: MannequinBehavior
	Checksum: 0x41C61ABB
	Offset: 0x1C8
	Size: 0x213
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	level.zm_variant_type_max = [];
	level.zm_variant_type_max["walk"] = [];
	level.zm_variant_type_max["run"] = [];
	level.zm_variant_type_max["sprint"] = [];
	level.zm_variant_type_max["walk"]["down"] = 14;
	level.zm_variant_type_max["walk"]["up"] = 16;
	level.zm_variant_type_max["run"]["down"] = 13;
	level.zm_variant_type_max["run"]["up"] = 12;
	level.zm_variant_type_max["sprint"]["down"] = 7;
	level.zm_variant_type_max["sprint"]["up"] = 6;
	spawner::add_archetype_spawn_function("mannequin", &ZombieBehavior::ArchetypeZombieBlackboardInit);
	spawner::add_archetype_spawn_function("mannequin", &ZombieBehavior::ArchetypeZombieDeathOverrideInit);
	spawner::add_archetype_spawn_function("mannequin", &zombie_utility::zombieSpawnSetup);
	spawner::add_archetype_spawn_function("mannequin", &mannequinSpawnSetup);
	MannequinInterface::RegisterMannequinInterfaceAttributes();
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mannequinCollisionService", &mannequinCollisionService);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("mannequinShouldMelee", &mannequinShouldMelee);
}

/*
	Name: mannequinCollisionService
	Namespace: MannequinBehavior
	Checksum: 0xC9C59DC4
	Offset: 0x3E8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function mannequinCollisionService(entity)
{
	if(isdefined(entity.enemy) && DistanceSquared(entity.origin, entity.enemy.origin) > 300 * 300)
	{
		entity PushActors(0);
	}
	else
	{
		entity PushActors(1);
	}
}

/*
	Name: mannequinSpawnSetup
	Namespace: MannequinBehavior
	Checksum: 0xEDD38CBA
	Offset: 0x490
	Size: 0xB
	Parameters: 1
	Flags: None
*/
function mannequinSpawnSetup(entity)
{
}

/*
	Name: mannequinShouldMelee
	Namespace: MannequinBehavior
	Checksum: 0xEB636FA1
	Offset: 0x4A8
	Size: 0x18B
	Parameters: 1
	Flags: Private
*/
function private mannequinShouldMelee(entity)
{
	if(!isdefined(entity.enemy))
	{
		return 0;
	}
	if(isdefined(entity.marked_for_death))
	{
		return 0;
	}
	if(isdefined(entity.ignoreMelee) && entity.ignoreMelee)
	{
		return 0;
	}
	if(Distance2DSquared(entity.origin, entity.enemy.origin) > 64 * 64)
	{
		return 0;
	}
	if(Abs(entity.origin[2] - entity.enemy.origin[2]) > 72)
	{
		return 0;
	}
	yawToEnemy = AngleClamp180(entity.angles[1] - VectorToAngles(entity.enemy.origin - entity.origin)[1]);
	if(Abs(yawToEnemy) > 45)
	{
		return 0;
	}
	return 1;
}

