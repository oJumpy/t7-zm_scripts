#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_spawner;

#namespace zm_behavior_utility;

/*
	Name: setupAttackProperties
	Namespace: zm_behavior_utility
	Checksum: 0x772E4EBB
	Offset: 0x218
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function setupAttackProperties()
{
	self.ignoreall = 0;
	self.meleeAttackDist = 64;
}

/*
	Name: enteredPlayableArea
	Namespace: zm_behavior_utility
	Checksum: 0x308197B7
	Offset: 0x240
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function enteredPlayableArea()
{
	self zm_spawner::zombie_complete_emerging_into_playable_area();
	self.pushable = 1;
	self setupAttackProperties();
}

