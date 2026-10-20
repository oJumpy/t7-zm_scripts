#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\zm\_util;

#namespace controllable_spider;

/*
	Name: __init__sytem__
	Namespace: controllable_spider
	Checksum: 0x20685F1F
	Offset: 0x1C0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("controllable_spider", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: controllable_spider
	Checksum: 0x7D540EFD
	Offset: 0x200
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function __init__(localClientNum)
{
	clientfield::register("scriptmover", "player_cocooned_fx", 9000, 1, "int", &player_cocooned_fx, 0, 0);
	clientfield::register("allplayers", "player_cocooned_fx", 9000, 1, "int", &player_cocooned_fx, 0, 0);
}

/*
	Name: player_cocooned_fx
	Namespace: controllable_spider
	Checksum: 0xFCB6C022
	Offset: 0x2A8
	Size: 0xA1
	Parameters: 7
	Flags: None
*/
function player_cocooned_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(!isdefined(self.var_e3645e32))
		{
			self.var_e3645e32 = [];
		}
		self.var_e3645e32[localClientNum] = PlayFXOnTag(localClientNum, level._effect["cocooned_fx"], self, "tag_origin");
	}
}

