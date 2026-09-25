#using scripts\codescripts\struct;
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
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace CloneBehavior;

/*
	Name: init
	Namespace: CloneBehavior
	Checksum: 0xF339E233
	Offset: 0x430
	Size: 0x63
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	InitThrasherBehaviorsAndASM();
	spawner::add_archetype_spawn_function("human_clone", &ArchetypeCloneBlackboardInit);
	spawner::add_archetype_spawn_function("human_clone", &cloneSpawnSetup);
}

/*
	Name: InitThrasherBehaviorsAndASM
	Namespace: CloneBehavior
	Checksum: 0x99EC1590
	Offset: 0x4A0
	Size: 0x3
	Parameters: 0
	Flags: Private
*/
function private InitThrasherBehaviorsAndASM()
{
}

/*
	Name: ArchetypeCloneBlackboardInit
	Namespace: CloneBehavior
	Checksum: 0xE5AAEA65
	Offset: 0x4B0
	Size: 0x93
	Parameters: 0
	Flags: Private
*/
function private ArchetypeCloneBlackboardInit()
{
	entity = self;
	blackboard::CreateBlackBoardForEntity(entity);
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	ai::CreateInterfaceForEntity(entity);
	entity.___ArchetypeOnAnimscriptedCallback = &ArchetypeCloneOnAnimscriptedCallback;
	/#
		entity function_89398c57();
	#/
}

/*
	Name: ArchetypeCloneOnAnimscriptedCallback
	Namespace: CloneBehavior
	Checksum: 0xDF1C244
	Offset: 0x550
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private ArchetypeCloneOnAnimscriptedCallback(entity)
{
	entity.__blackboard = undefined;
	entity ArchetypeCloneBlackboardInit();
}

/*
	Name: perfectInfoThread
	Namespace: CloneBehavior
	Checksum: 0x825610F3
	Offset: 0x590
	Size: 0x6F
	Parameters: 0
	Flags: Private
*/
function private perfectInfoThread()
{
	entity = self;
	entity endon("death");
	while(1)
	{
		if(isdefined(entity.enemy))
		{
			entity GetPerfectInfo(entity.enemy, 1);
		}
		wait(0.05);
	}
}

/*
	Name: cloneSpawnSetup
	Namespace: CloneBehavior
	Checksum: 0xCF81C61D
	Offset: 0x608
	Size: 0xA3
	Parameters: 0
	Flags: Private
*/
function private cloneSpawnSetup()
{
	entity = self;
	entity.ignoreme = 1;
	entity.ignoreall = 1;
	entity setContents(8192);
	entity SetAvoidanceMask("avoid none");
	entity setclone();
	entity thread perfectInfoThread();
}

#namespace CloneServerUtils;

/*
	Name: clonePlayerLook
	Namespace: CloneServerUtils
	Checksum: 0x977DDCE7
	Offset: 0x6B8
	Size: 0x243
	Parameters: 3
	Flags: None
*/
function clonePlayerLook(clone, clonePlayer, targetPlayer)
{
	/#
		Assert(IsActor(clone));
	#/
	/#
		Assert(isPlayer(clonePlayer));
	#/
	/#
		Assert(isPlayer(targetPlayer));
	#/
	clone.owner = clonePlayer;
	clone SetEntityTarget(targetPlayer, 1);
	clone SetEntityOwner(clonePlayer);
	clone DetachAll();
	bodyModel = clonePlayer GetCharacterBodyModel();
	if(isdefined(bodyModel))
	{
		clone SetModel(bodyModel);
	}
	Headmodel = clonePlayer GetCharacterHeadModel();
	if(isdefined(Headmodel) && Headmodel != "tag_origin")
	{
		if(isdefined(clone.head))
		{
			clone Detach(clone.head);
		}
		clone Attach(Headmodel);
	}
	helmetModel = clonePlayer GetCharacterHelmetModel();
	if(isdefined(helmetModel) && Headmodel != "tag_origin")
	{
		clone Attach(helmetModel);
	}
}

