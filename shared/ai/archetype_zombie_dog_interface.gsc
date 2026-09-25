#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\systems\ai_interface;

#namespace ZombieDogInterface;

/*
	Name: RegisterZombieDogInterfaceAttributes
	Namespace: ZombieDogInterface
	Checksum: 0x26B16E52
	Offset: 0x110
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function RegisterZombieDogInterfaceAttributes()
{
	ai::RegisterMatchedInterface("zombie_dog", "gravity", "normal", Array("low", "normal"), &ZombieDogBehavior::zombieDogGravity);
	ai::RegisterMatchedInterface("zombie_dog", "min_run_dist", 500);
	ai::RegisterMatchedInterface("zombie_dog", "sprint", 0, Array(1, 0));
}

