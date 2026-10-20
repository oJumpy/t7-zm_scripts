#using scripts\shared\ai\archetype_apothicon_fury;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\util_shared;

#namespace ApothiconFuryInterface;

/*
	Name: RegisterApothiconFuryInterfaceAttributes
	Namespace: ApothiconFuryInterface
	Checksum: 0xAEA2FCA8
	Offset: 0x210
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function RegisterApothiconFuryInterfaceAttributes()
{
	ai::RegisterMatchedInterface("apothicon_fury", "can_juke", 1, Array(1, 0));
	ai::RegisterMatchedInterface("apothicon_fury", "can_bamf", 1, Array(1, 0));
	ai::RegisterMatchedInterface("apothicon_fury", "can_be_furious", 1, Array(1, 0));
	ai::RegisterMatchedInterface("apothicon_fury", "move_speed", "walk", Array("walk", "run", "sprint", "super_sprint"), &ApothiconFuryBehaviorInterface::moveSpeedAttributeCallback);
}

