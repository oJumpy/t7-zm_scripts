#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\zombie;

#namespace MannequinInterface;

/*
	Name: RegisterMannequinInterfaceAttributes
	Namespace: MannequinInterface
	Checksum: 0xE164E6D
	Offset: 0x100
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function RegisterMannequinInterfaceAttributes()
{
	ai::RegisterMatchedInterface("mannequin", "can_juke", 0, Array(1, 0));
	ai::RegisterMatchedInterface("mannequin", "suicidal_behavior", 0, Array(1, 0));
	ai::RegisterMatchedInterface("mannequin", "spark_behavior", 0, Array(1, 0));
}

