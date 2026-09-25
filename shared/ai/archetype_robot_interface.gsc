#using scripts\shared\ai\archetype_robot;
#using scripts\shared\ai\systems\ai_interface;

#namespace RobotInterface;

/*
	Name: RegisterRobotInterfaceAttributes
	Namespace: RobotInterface
	Checksum: 0x90F18DA3
	Offset: 0x318
	Size: 0x69B
	Parameters: 0
	Flags: None
*/
function RegisterRobotInterfaceAttributes()
{
	ai::RegisterMatchedInterface("robot", "can_be_meleed", 1, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "can_become_crawler", 1, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "can_become_rusher", 1, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "can_gib", 1, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "can_melee", 1, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "can_initiateaivsaimelee", 1, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "disablesprint", 0, Array(1, 0));
	ai::RegisterVectorInterface("robot", "escort_position");
	ai::RegisterMatchedInterface("robot", "force_cover", 0, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "force_crawler", "normal", Array("normal", "gib_legs", "remove_legs"), &RobotSoldierServerUtils::robotForceCrawler);
	ai::RegisterMatchedInterface("robot", "move_mode", "normal", Array("escort", "guard", "normal", "marching", "rambo", "rusher", "squadmember"), &RobotSoldierServerUtils::robotMoveModeAttributeCallback);
	ai::RegisterMatchedInterface("robot", "phalanx", 0, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "phalanx_force_stance", "normal", Array("normal", "stand", "crouch"));
	ai::RegisterMatchedInterface("robot", "robot_lights", 0, Array(0, 1, 2, 3, 4), &RobotSoldierServerUtils::robotLights);
	ai::RegisterMatchedInterface("robot", "robot_mini_raps", 0, Array(1, 0), &RobotSoldierServerUtils::robotEquipMiniRaps);
	ai::RegisterMatchedInterface("robot", "rogue_allow_predestruct", 1, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "rogue_allow_pregib", 1, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "rogue_control", "level_0", Array("level_0", "level_1", "forced_level_1", "level_2", "forced_level_2", "level_3", "forced_level_3"), &RobotSoldierServerUtils::rogueControlAttributeCallback);
	ai::RegisterVectorInterface("robot", "rogue_control_force_goal", undefined, &RobotSoldierServerUtils::rogueControlForceGoalAttributeCallback);
	ai::RegisterMatchedInterface("robot", "rogue_control_speed", "sprint", Array("walk", "run", "sprint"), &RobotSoldierServerUtils::rogueControlSpeedAttributeCallback);
	ai::RegisterMatchedInterface("robot", "rogue_force_explosion", 0, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "shutdown", 0, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "sprint", 0, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "supports_super_sprint", 0, Array(1, 0));
	ai::RegisterMatchedInterface("robot", "traversals", "normal", Array("normal", "procedural"), &RobotSoldierServerUtils::robotTraversalAttributeCallback);
}

