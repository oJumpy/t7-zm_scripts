#using scripts\shared\ai\archetype_thrasher;
#using scripts\shared\ai\systems\ai_interface;

#namespace ThrasherInterface;

/*
	Name: RegisterThrasherInterfaceAttributes
	Namespace: ThrasherInterface
	Checksum: 0xFAE534BD
	Offset: 0x118
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function RegisterThrasherInterfaceAttributes()
{
	ai::RegisterMatchedInterface("thrasher", "stunned", 0, Array(1, 0));
	ai::RegisterMatchedInterface("thrasher", "move_mode", "normal", Array("normal", "friendly"), &ThrasherServerUtils::thrasherMoveModeAttributeCallback);
	ai::RegisterMatchedInterface("thrasher", "use_attackable", 0, Array(1, 0));
}

