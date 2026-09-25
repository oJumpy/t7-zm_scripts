#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_2cce1885;

/*
	Name: __init__sytem__
	Namespace: namespace_2cce1885
	Checksum: 0x34716B07
	Offset: 0x2C0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_robot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_2cce1885
	Checksum: 0xE94728A4
	Offset: 0x300
	Size: 0xBB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "robot_switch", 1, 1, "int", &function_16e00222, 0, 0);
	clientfield::register("world", "robot_lights", 1, 2, "int", &robot_lights, 0, 0);
	ai::add_archetype_spawn_function("zod_companion", &function_a0b7ccbf);
}

/*
	Name: function_a0b7ccbf
	Namespace: namespace_2cce1885
	Checksum: 0x25BA1C5C
	Offset: 0x3C8
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private function_a0b7ccbf(localClientNum)
{
	entity = self;
	entity SetDrawName(&"ZM_ZOD_ROBOT_NAME");
}

/*
	Name: function_16e00222
	Namespace: namespace_2cce1885
	Checksum: 0x82129AED
	Offset: 0x410
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_16e00222(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playFX(localClientNum, "zombie/fx_fuse_master_switch_on_zod_zmb", self.origin);
}

/*
	Name: robot_lights
	Namespace: namespace_2cce1885
	Checksum: 0xCC0E75EA
	Offset: 0x480
	Size: 0x1A5
	Parameters: 7
	Flags: None
*/
function robot_lights(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			exploder::exploder("lgt_robot_callbox_green");
			exploder::stop_exploder("lgt_robot_callbox_red");
			exploder::stop_exploder("lgt_robot_callbox_yellow");
			break;
		}
		case 2:
		{
			exploder::stop_exploder("lgt_robot_callbox_green");
			exploder::exploder("lgt_robot_callbox_red");
			exploder::stop_exploder("lgt_robot_callbox_yellow");
			break;
		}
		case 3:
		{
			exploder::stop_exploder("lgt_robot_callbox_green");
			exploder::stop_exploder("lgt_robot_callbox_red");
			exploder::exploder("lgt_robot_callbox_yellow");
			break;
		}
		case default:
		{
			exploder::stop_exploder("lgt_robot_callbox_green");
			exploder::stop_exploder("lgt_robot_callbox_red");
			exploder::stop_exploder("lgt_robot_callbox_yellow");
			break;
		}
	}
}

