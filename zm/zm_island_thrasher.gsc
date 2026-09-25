#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_utility;

#namespace namespace_105f13a2;

/*
	Name: init
	Namespace: namespace_105f13a2
	Checksum: 0x9963C57D
	Offset: 0x2F8
	Size: 0x2B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	spawner::add_archetype_spawn_function("thrasher", &function_f8333089);
}

/*
	Name: function_f8333089
	Namespace: namespace_105f13a2
	Checksum: 0xC2819EFF
	Offset: 0x330
	Size: 0x1B
	Parameters: 0
	Flags: Private
*/
function private function_f8333089()
{
	self thread function_9b57ea16();
}

/*
	Name: function_9b57ea16
	Namespace: namespace_105f13a2
	Checksum: 0xBCCB2B13
	Offset: 0x358
	Size: 0x33
	Parameters: 0
	Flags: Private
*/
function private function_9b57ea16()
{
	self endon("death");
	wait(1);
	self ai::set_behavior_attribute("use_attackable", 1);
}

