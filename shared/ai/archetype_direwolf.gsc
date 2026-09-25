#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace ArchetypeDirewolf;

/*
	Name: __init__sytem__
	Namespace: ArchetypeDirewolf
	Checksum: 0xEC7CA82E
	Offset: 0x220
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("direwolf", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ArchetypeDirewolf
	Checksum: 0xF11774C0
	Offset: 0x260
	Size: 0x1CB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	spawner::add_archetype_spawn_function("direwolf", &ZombieDogBehavior::ArchetypeZombieDogBlackboardInit);
	spawner::add_archetype_spawn_function("direwolf", &direwolfSpawnSetup);
	ai::RegisterMatchedInterface("direwolf", "sprint", 0, Array(1, 0));
	ai::RegisterMatchedInterface("direwolf", "howl_chance", 0.3);
	ai::RegisterMatchedInterface("direwolf", "can_initiateaivsaimelee", 1, Array(1, 0));
	ai::RegisterMatchedInterface("direwolf", "spacing_near_dist", 120);
	ai::RegisterMatchedInterface("direwolf", "spacing_far_dist", 480);
	ai::RegisterMatchedInterface("direwolf", "spacing_horz_dist", 144);
	ai::RegisterMatchedInterface("direwolf", "spacing_value", 0);
	if(ai::shouldRegisterClientFieldForArchetype("direwolf"))
	{
		clientfield::register("actor", "direwolf_eye_glow_fx", 1, 1, "int");
	}
}

/*
	Name: direwolfSpawnSetup
	Namespace: ArchetypeDirewolf
	Checksum: 0x61639958
	Offset: 0x438
	Size: 0xE3
	Parameters: 0
	Flags: Private
*/
function private direwolfSpawnSetup()
{
	self SetTeam("team3");
	self AllowPitchAngle(1);
	self SetPitchOrient();
	self SetAvoidanceMask("avoid all");
	self PushActors(1);
	self ai::set_behavior_attribute("spacing_value", RandomFloatRange(-1, 1));
	self clientfield::set("direwolf_eye_glow_fx", 1);
}

