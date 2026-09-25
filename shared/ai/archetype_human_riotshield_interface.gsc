#using scripts\shared\ai\archetype_human_riotshield;
#using scripts\shared\ai\systems\ai_interface;

#namespace HumanRiotshieldInterface;

/*
	Name: RegisterHumanRiotshieldInterfaceAttributes
	Namespace: HumanRiotshieldInterface
	Checksum: 0xB3ADAABA
	Offset: 0x188
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function RegisterHumanRiotshieldInterfaceAttributes()
{
	ai::RegisterMatchedInterface("human_riotshield", "can_be_meleed", 1, Array(1, 0));
	ai::RegisterMatchedInterface("human_riotshield", "can_melee", 1, Array(1, 0));
	ai::RegisterMatchedInterface("human_riotshield", "can_initiateaivsaimelee", 1, Array(1, 0));
	ai::RegisterMatchedInterface("human_riotshield", "coverIdleOnly", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human_riotshield", "phalanx", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human_riotshield", "phalanx_force_stance", "normal", Array("normal", "stand", "crouch"));
	ai::RegisterMatchedInterface("human_riotshield", "sprint", 0, Array(1, 0));
	ai::RegisterMatchedInterface("human_riotshield", "attack_mode", "normal", Array("normal", "unarmed"));
}

