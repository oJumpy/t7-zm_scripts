#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\zombie;

#namespace ZombieInterface;

/*
	Name: RegisterZombieInterfaceAttributes
	Namespace: ZombieInterface
	Checksum: 0x2EA92298
	Offset: 0x110
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function RegisterZombieInterfaceAttributes()
{
	ai::RegisterMatchedInterface("zombie", "can_juke", 0, Array(1, 0));
	ai::RegisterMatchedInterface("zombie", "suicidal_behavior", 0, Array(1, 0));
	ai::RegisterMatchedInterface("zombie", "spark_behavior", 0, Array(1, 0));
	ai::RegisterMatchedInterface("zombie", "use_attackable", 0, Array(1, 0));
}

