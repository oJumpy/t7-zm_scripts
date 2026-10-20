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
#using scripts\zm\_zm_zonemgr;

#namespace namespace_e1bd9dd;

/*
	Name: init
	Namespace: namespace_e1bd9dd
	Checksum: 0x4788ECA5
	Offset: 0x3E8
	Size: 0x63
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmasylumbehaviorsandasm();
	SetDvar("tu5_zmPathDistanceCheckTolarance", 20);
	SetDvar("scr_zm_use_code_enemy_selection", 0);
	level.move_valid_poi_to_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: initzmasylumbehaviorsandasm
	Namespace: namespace_e1bd9dd
	Checksum: 0x442110AD
	Offset: 0x458
	Size: 0x83
	Parameters: 0
	Flags: Private
*/
function private initzmasylumbehaviorsandasm()
{
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_traversal@zombie", &teleporttraversalmocompstart, undefined, undefined);
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodShouldMove", &zodshouldmove);
	spawner::add_archetype_spawn_function("zombie", &sumpf_zombie_spawned);
}

/*
	Name: teleporttraversalmocompstart
	Namespace: namespace_e1bd9dd
	Checksum: 0xA12EF3A8
	Offset: 0x4E8
	Size: 0x19B
	Parameters: 5
	Flags: None
*/
function teleporttraversalmocompstart(entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration)
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
	Name: zodshouldmove
	Namespace: namespace_e1bd9dd
	Checksum: 0x98BDD08B
	Offset: 0x690
	Size: 0x189
	Parameters: 1
	Flags: None
*/
function zodshouldmove(entity)
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
	Name: sumpf_zombie_spawned
	Namespace: namespace_e1bd9dd
	Checksum: 0x98553D4C
	Offset: 0x828
	Size: 0x1B
	Parameters: 0
	Flags: Private
*/
function private sumpf_zombie_spawned()
{
	self.cant_move_cb = &sumpf_cant_move_cb;
}

/*
	Name: sumpf_cant_move_cb
	Namespace: namespace_e1bd9dd
	Checksum: 0x57FAB375
	Offset: 0x850
	Size: 0x2B
	Parameters: 0
	Flags: Private
*/
function private sumpf_cant_move_cb()
{
	self PushActors(0);
	self.enablePushTime = GetTime() + 1000;
}

