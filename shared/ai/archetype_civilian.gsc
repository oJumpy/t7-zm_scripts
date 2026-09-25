#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\spawner_shared;

#namespace ARCHETYPE_CIVILIAN;

/*
	Name: main
	Namespace: ARCHETYPE_CIVILIAN
	Checksum: 0xC28BD094
	Offset: 0x2A8
	Size: 0x13
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	ArchetypeCivilian::RegisterBehaviorScriptFunctions();
}

#namespace ArchetypeCivilian;

/*
	Name: RegisterBehaviorScriptFunctions
	Namespace: ArchetypeCivilian
	Checksum: 0x9A35315C
	Offset: 0x2C8
	Size: 0x1A3
	Parameters: 0
	Flags: None
*/
function RegisterBehaviorScriptFunctions()
{
	spawner::add_archetype_spawn_function("civilian", &civilianBlackboardInit);
	spawner::add_archetype_spawn_function("civilian", &archetypeCivilianInit);
	ai::RegisterMatchedInterface("civilian", "sprint", 0, Array(1, 0));
	ai::RegisterMatchedInterface("civilian", "panic", 0, Array(1, 0));
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("civilianMoveAction", &civilianMoveActionInitialize, undefined, &civilianMoveActionFinalize);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("civilianCowerAction", &civilianCowerActionInitialize, undefined, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("civilianIsPanicked", &civilianIsPanicked);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("civilianPanic", &civilianPanic);
	BehaviorStateMachine::RegisterBSMScriptAPIInternal("civilianPanic", &civilianPanic);
}

/*
	Name: civilianBlackboardInit
	Namespace: ArchetypeCivilian
	Checksum: 0x625AB7AD
	Offset: 0x478
	Size: 0x13B
	Parameters: 0
	Flags: Private
*/
function private civilianBlackboardInit()
{
	blackboard::CreateBlackBoardForEntity(self);
	ai::CreateInterfaceForEntity(self);
	self AiUtility::RegisterUtilityBlackboardAttributes();
	blackboard::RegisterBlackBoardAttribute(self, "_panic", "calm", &BB_GetPanic);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	blackboard::RegisterBlackBoardAttribute(self, "_human_locomotion_variation", undefined, undefined);
	if(IsActor(self))
	{
		/#
			self function_d0db9f97("Dev Block strings are not supported");
		#/
	}
	self.___ArchetypeOnAnimscriptedCallback = &civilianOnAnimscriptedCallback;
	/#
		self function_89398c57();
	#/
}

/*
	Name: archetypeCivilianInit
	Namespace: ArchetypeCivilian
	Checksum: 0x357563BD
	Offset: 0x5C0
	Size: 0xBB
	Parameters: 0
	Flags: Private
*/
function private archetypeCivilianInit()
{
	entity = self;
	locomotionTypes = Array("alt1", "alt2", "alt3", "alt4");
	altIndex = entity GetEntityNumber() % locomotionTypes.size;
	blackboard::SetBlackBoardAttribute(entity, "_human_locomotion_variation", locomotionTypes[altIndex]);
	entity SetAvoidanceMask("avoid ai");
}

/*
	Name: BB_GetPanic
	Namespace: ArchetypeCivilian
	Checksum: 0x59AD0BC9
	Offset: 0x688
	Size: 0x35
	Parameters: 0
	Flags: Private
*/
function private BB_GetPanic()
{
	if(ai::GetAiAttribute(self, "panic"))
	{
		return "panic";
	}
	return "calm";
}

/*
	Name: civilianOnAnimscriptedCallback
	Namespace: ArchetypeCivilian
	Checksum: 0x81C13565
	Offset: 0x6C8
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private civilianOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity civilianBlackboardInit();
}

/*
	Name: civilianMoveActionInitialize
	Namespace: ArchetypeCivilian
	Checksum: 0xD7523D1D
	Offset: 0x708
	Size: 0x57
	Parameters: 2
	Flags: Private
*/
function private civilianMoveActionInitialize(entity, asmStateName)
{
	blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "stand");
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	return 5;
}

/*
	Name: civilianMoveActionFinalize
	Namespace: ArchetypeCivilian
	Checksum: 0x2DFDCED8
	Offset: 0x768
	Size: 0x67
	Parameters: 2
	Flags: Private
*/
function private civilianMoveActionFinalize(entity, asmStateName)
{
	if(blackboard::GetBlackBoardAttribute(entity, "_stance") != "stand")
	{
		blackboard::SetBlackBoardAttribute(entity, "_desired_stance", "stand");
	}
	return 4;
}

/*
	Name: civilianCowerActionInitialize
	Namespace: ArchetypeCivilian
	Checksum: 0xCFA539E
	Offset: 0x7D8
	Size: 0xC7
	Parameters: 2
	Flags: Private
*/
function private civilianCowerActionInitialize(entity, asmStateName)
{
	if(isdefined(entity.node))
	{
		highestStance = AiUtility::getHighestNodeStance(entity.node);
		if(highestStance == "crouch")
		{
			blackboard::SetBlackBoardAttribute(entity, "_stance", "crouch");
		}
		else
		{
			blackboard::SetBlackBoardAttribute(entity, "_stance", "stand");
		}
	}
	AnimationStateNetworkUtility::RequestState(entity, asmStateName);
	return 5;
}

/*
	Name: civilianIsPanicked
	Namespace: ArchetypeCivilian
	Checksum: 0xAE944285
	Offset: 0x8A8
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private civilianIsPanicked(entity)
{
	return blackboard::GetBlackBoardAttribute(entity, "_panic") == "panic";
}

/*
	Name: civilianPanic
	Namespace: ArchetypeCivilian
	Checksum: 0x58B3C3EE
	Offset: 0x8E8
	Size: 0x2F
	Parameters: 1
	Flags: Private
*/
function private civilianPanic(entity)
{
	entity ai::set_behavior_attribute("panic", 1);
	return 1;
}

