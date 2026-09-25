#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_human_rpg_interface;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;

#namespace ARCHETYPE_HUMAN_RPG;

/*
	Name: main
	Namespace: ARCHETYPE_HUMAN_RPG
	Checksum: 0xACB3173C
	Offset: 0x388
	Size: 0x4B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	spawner::add_archetype_spawn_function("human_rpg", &HumanRpgBehavior::ArchetypeHumanRpgBlackboardInit);
	HumanRpgBehavior::RegisterBehaviorScriptFunctions();
	HumanRpgInterface::RegisterHumanRpgInterfaceAttributes();
}

#namespace HumanRpgBehavior;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: HumanRpgBehavior
	Checksum: 0x99EC1590
	Offset: 0x3E0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function RegisterBehaviorScriptFunctions()
{
}

/*
	Name: ArchetypeHumanRpgBlackboardInit
	Namespace: HumanRpgBehavior
	Checksum: 0x71E239A7
	Offset: 0x3F0
	Size: 0xA3
	Parameters: 0
	Flags: Private
*/
function private ArchetypeHumanRpgBlackboardInit()
{
	entity = self;
	blackboard::CreateBlackBoardForEntity(entity);
	ai::CreateInterfaceForEntity(entity);
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeHumanRpgOnAnimscriptedCallback;
	/#
		entity function_89398c57();
	#/
	entity AsmChangeAnimMappingTable(1);
}

/*
	Name: ArchetypeHumanRpgOnAnimscriptedCallback
	Namespace: HumanRpgBehavior
	Checksum: 0x90E3A80C
	Offset: 0x4A0
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeHumanRpgOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeHumanRpgBlackboardInit();
}

