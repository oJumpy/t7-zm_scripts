#using scripts\shared\ai\archetype_human;
#using scripts\shared\ai\systems\ai_interface;

#namespace HumanInterface;

/*
	Name: RegisterHumanInterfaceAttributes
	Namespace: HumanInterface
	Checksum: 0x5707D523
	Offset: 0x1B8
	Size: 0x3C3
	Parameters: 0
	Flags: None
*/
function RegisterHumanInterfaceAttributes()
{
	ai::RegisterMatchedInterface("human", "can_be_meleed", 1, Array(1, 0));
	ai::RegisterMatchedInterface("human", "can_melee", 1, Array(1, 0));
	ai::RegisterMatchedInterface("human", "can_initiateaivsaimelee", 1, Array(1, 0));
	ai::RegisterMatchedInterface("human", "coverIdleOnly", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human", "cqb", 0, Array(1, 0), &HumanSoldierServerUtils::cqbAttributeCallback);
	ai::RegisterMatchedInterface("human", "forceTacticalWalk", 0, Array(1, 0), &HumanSoldierServerUtils::forceTacticalWalkCallback);
	ai::RegisterMatchedInterface("human", "move_mode", "normal", Array("normal", "rambo"), &HumanSoldierServerUtils::moveModeAttributeCallback);
	ai::RegisterMatchedInterface("human", "useAnimationOverride", 0, Array(1, 0), &HumanSoldierServerUtils::UseAnimationOverrideCallback);
	ai::RegisterMatchedInterface("human", "sprint", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human", "patrol", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human", "disablearrivals", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human", "disablesprint", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human", "stealth", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human", "vignette_mode", "off", Array("off", "slow", "fast"), &HumanSoldierServerUtils::VignetteModeCallback);
	ai::RegisterMatchedInterface("human", "useGrenades", 1, Array(1, 0));
}

