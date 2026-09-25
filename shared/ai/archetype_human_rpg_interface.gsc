#using scripts\shared\ai\archetype_human_rpg;
#using scripts\shared\ai\systems\ai_interface;

#namespace HumanRpgInterface;

/*
	Name: RegisterHumanRpgInterfaceAttributes
	Namespace: HumanRpgInterface
	Checksum: 0x262765A2
	Offset: 0x118
	Size: 0x11B
	Parameters: 0
	Flags: None
*/
function RegisterHumanRpgInterfaceAttributes()
{
	ai::RegisterMatchedInterface("human_rpg", "can_be_meleed", 1, Array(1, 0));
	ai::RegisterMatchedInterface("human_rpg", "can_melee", 1, Array(1, 0));
	ai::RegisterMatchedInterface("human_rpg", "coverIdleOnly", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human_rpg", "sprint", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human_rpg", "patrol", 0, Array(1, 0));
}

