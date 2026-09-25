#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace archetype_robot;

/*
	Name: __init__sytem__
	Namespace: archetype_robot
	Checksum: 0xE5EDBCD0
	Offset: 0x2B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("robot", &__init__, undefined, undefined);
}

/*
	Name: Precache
	Namespace: archetype_robot
	Checksum: 0xBF78174C
	Offset: 0x2F0
	Size: 0x39
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
	level._effect["fx_ability_elec_surge_short_robot"] = "electric/fx_ability_elec_surge_short_robot";
	level._effect["fx_exp_robot_stage3_evb"] = "explosions/fx_exp_robot_stage3_evb";
}

/*
	Name: __init__
	Namespace: archetype_robot
	Checksum: 0x5BA98427
	Offset: 0x338
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(ai::shouldRegisterClientFieldForArchetype("robot"))
	{
		clientfield::register("actor", "robot_mind_control", 1, 2, "int", &RobotClientUtils::robotMindControlHandler, 0, 1);
		clientfield::register("actor", "robot_mind_control_explosion", 1, 1, "int", &RobotClientUtils::robotMindControlExplosionHandler, 0, 0);
		clientfield::register("actor", "robot_lights", 1, 3, "int", &RobotClientUtils::robotLightsHandler, 0, 0);
		clientfield::register("actor", "robot_EMP", 1, 1, "int", &RobotClientUtils::robotEmpHandler, 0, 0);
	}
	ai::add_archetype_spawn_function("robot", &RobotClientUtils::robotSoldierSpawnSetup);
}

#namespace RobotClientUtils;

/*
	Name: robotSoldierSpawnSetup
	Namespace: RobotClientUtils
	Checksum: 0x49E782E8
	Offset: 0x4A8
	Size: 0x1B
	Parameters: 1
	Flags: Private
*/
function private robotSoldierSpawnSetup(localClientNum)
{
	entity = self;
}

/*
	Name: robotLighting
	Namespace: RobotClientUtils
	Checksum: 0xCAD85F8B
	Offset: 0x4D0
	Size: 0x345
	Parameters: 4
	Flags: Private
*/
function private robotLighting(localClientNum, entity, flicker, mindControlState)
{
	switch(mindControlState)
	{
		case 0:
		{
			entity TmodeClearFlag(0);
			if(flicker)
			{
				FxClientUtils::PlayFxBundle(localClientNum, entity, entity.altfxdef3);
			}
			else
			{
				FxClientUtils::PlayFxBundle(localClientNum, entity, entity.fxdef);
			}
			break;
		}
		case 1:
		{
			entity TmodeClearFlag(0);
			FxClientUtils::StopAllFXBundles(localClientNum, entity);
			if(flicker)
			{
				FxClientUtils::PlayFxBundle(localClientNum, entity, entity.altfxdef4);
			}
			else
			{
				FxClientUtils::PlayFxBundle(localClientNum, entity, entity.altfxdef1);
			}
			if(!GibClientUtils::IsGibbed(localClientNum, entity, 8))
			{
				entity playsound(localClientNum, "fly_bot_ctrl_lvl_01_start", entity.origin);
			}
			break;
		}
		case 2:
		{
			entity TmodeSetFlag(0);
			FxClientUtils::StopAllFXBundles(localClientNum, entity);
			if(flicker)
			{
				FxClientUtils::PlayFxBundle(localClientNum, entity, entity.altfxdef4);
			}
			else
			{
				FxClientUtils::PlayFxBundle(localClientNum, entity, entity.altfxdef1);
			}
			if(!GibClientUtils::IsGibbed(localClientNum, entity, 8))
			{
				entity playsound(localClientNum, "fly_bot_ctrl_lvl_02_start", entity.origin);
			}
			break;
		}
		case 3:
		{
			entity TmodeSetFlag(0);
			FxClientUtils::StopAllFXBundles(localClientNum, entity);
			if(flicker)
			{
				FxClientUtils::PlayFxBundle(localClientNum, entity, entity.altfxdef5);
			}
			else
			{
				FxClientUtils::PlayFxBundle(localClientNum, entity, entity.altfxdef2);
			}
			entity playsound(localClientNum, "fly_bot_ctrl_lvl_03_start", entity.origin);
			break;
		}
	}
}

/*
	Name: robotLightsHandler
	Namespace: RobotClientUtils
	Checksum: 0xE77A3CFE
	Offset: 0x820
	Size: 0x163
	Parameters: 7
	Flags: Private
*/
function private robotLightsHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(!isdefined(entity) || !entity isai() || (isdefined(entity.archetype) && entity.archetype != "robot"))
	{
		return;
	}
	FxClientUtils::StopAllFXBundles(localClientNum, entity);
	flicker = newValue == 1;
	if(newValue == 0 || newValue == 3 || flicker)
	{
		robotLighting(localClientNum, entity, flicker, clientfield::get("robot_mind_control"));
	}
	else if(newValue == 4)
	{
		FxClientUtils::PlayFxBundle(localClientNum, entity, entity.deathfxdef);
	}
}

/*
	Name: robotEmpHandler
	Namespace: RobotClientUtils
	Checksum: 0xEBB2D757
	Offset: 0x990
	Size: 0x139
	Parameters: 7
	Flags: Private
*/
function private robotEmpHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(!isdefined(entity) || !entity isai() || (isdefined(entity.archetype) && entity.archetype != "robot"))
	{
		return;
	}
	if(isdefined(entity.empFX))
	{
		stopfx(localClientNum, entity.empFX);
	}
	switch(newValue)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			entity.empFX = PlayFXOnTag(localClientNum, level._effect["fx_ability_elec_surge_short_robot"], entity, "j_spine4");
			break;
		}
	}
}

/*
	Name: robotMindControlHandler
	Namespace: RobotClientUtils
	Checksum: 0xBBB3210F
	Offset: 0xAD8
	Size: 0x113
	Parameters: 7
	Flags: Private
*/
function private robotMindControlHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(!isdefined(entity) || !entity isai() || (isdefined(entity.archetype) && entity.archetype != "robot"))
	{
		return;
	}
	lights = clientfield::get("robot_lights");
	flicker = lights == 1;
	if(lights == 0 || flicker)
	{
		robotLighting(localClientNum, entity, flicker, newValue);
	}
}

/*
	Name: robotMindControlExplosionHandler
	Namespace: RobotClientUtils
	Checksum: 0x334D8647
	Offset: 0xBF8
	Size: 0x101
	Parameters: 7
	Flags: None
*/
function robotMindControlExplosionHandler(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(!isdefined(entity) || !entity isai() || (isdefined(entity.archetype) && entity.archetype != "robot"))
	{
		return;
	}
	switch(newValue)
	{
		case 1:
		{
			entity.explosionFx = PlayFXOnTag(localClientNum, level._effect["fx_exp_robot_stage3_evb"], entity, "j_spineupper");
			break;
		}
	}
}

