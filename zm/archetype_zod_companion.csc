#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zodcompanionclientutils;

/*
	Name: __init__sytem__
	Namespace: zodcompanionclientutils
	Checksum: 0x10CC164
	Offset: 0x290
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_companion", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zodcompanionclientutils
	Checksum: 0xF4B4988D
	Offset: 0x2D0
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "being_robot_revived", 1, 1, "int", &play_revival_fx, 0, 0);
	ai::add_archetype_spawn_function("zod_companion", &zodcompanionspawnsetup);
	level._effect["fx_dest_robot_head_sparks"] = "destruct/fx_dest_robot_head_sparks";
	level._effect["fx_dest_robot_body_sparks"] = "destruct/fx_dest_robot_body_sparks";
	level._effect["companion_revive_effect"] = "zombie/fx_robot_helper_revive_player_zod_zmb";
	ai::add_archetype_spawn_function("robot", &zodcompanionspawnsetup);
}

/*
	Name: zodcompanionspawnsetup
	Namespace: zodcompanionclientutils
	Checksum: 0x10FEFD58
	Offset: 0x3C8
	Size: 0x133
	Parameters: 1
	Flags: Private
*/
function private zodcompanionspawnsetup(localClientNum)
{
	entity = self;
	GibClientUtils::AddGibCallback(localClientNum, entity, 8, &zodcompanionheadgibfx);
	GibClientUtils::AddGibCallback(localClientNum, entity, 8, &_gibCallback);
	GibClientUtils::AddGibCallback(localClientNum, entity, 16, &_gibCallback);
	GibClientUtils::AddGibCallback(localClientNum, entity, 32, &_gibCallback);
	GibClientUtils::AddGibCallback(localClientNum, entity, 128, &_gibCallback);
	GibClientUtils::AddGibCallback(localClientNum, entity, 256, &_gibCallback);
	FxClientUtils::PlayFxBundle(localClientNum, entity, entity.fxdef);
}

/*
	Name: zodcompanionheadgibfx
	Namespace: zodcompanionclientutils
	Checksum: 0xAC04FC83
	Offset: 0x508
	Size: 0x103
	Parameters: 3
	Flags: None
*/
function zodcompanionheadgibfx(localClientNum, entity, gibFlag)
{
	if(!isdefined(entity) || !entity isai() || !isalive(entity))
	{
		return;
	}
	if(isdefined(entity.mindcontrolheadfx))
	{
		stopfx(localClientNum, entity.mindcontrolheadfx);
		entity.mindcontrolheadfx = undefined;
	}
	entity.headgibfx = PlayFXOnTag(localClientNum, level._effect["fx_dest_robot_head_sparks"], entity, "j_neck");
	playsound(0, "prj_bullet_impact_robot_headshot", entity.origin);
}

/*
	Name: zodcompaniondamagedfx
	Namespace: zodcompanionclientutils
	Checksum: 0x834F8091
	Offset: 0x618
	Size: 0x8F
	Parameters: 2
	Flags: None
*/
function zodcompaniondamagedfx(localClientNum, entity)
{
	if(!isdefined(entity) || !entity isai() || !isalive(entity))
	{
		return;
	}
	entity.damagedfx = PlayFXOnTag(localClientNum, level._effect["fx_dest_robot_body_sparks"], entity, "j_spine4");
}

/*
	Name: zodcompanionclearfx
	Namespace: zodcompanionclientutils
	Checksum: 0x8A42D885
	Offset: 0x6B0
	Size: 0x39
	Parameters: 2
	Flags: None
*/
function zodcompanionclearfx(localClientNum, entity)
{
	if(!isdefined(entity) || !entity isai())
	{
		return;
	}
}

/*
	Name: _gibCallback
	Namespace: zodcompanionclientutils
	Checksum: 0x579AA4E2
	Offset: 0x6F8
	Size: 0x91
	Parameters: 3
	Flags: Private
*/
function private _gibCallback(localClientNum, entity, gibFlag)
{
	if(!isdefined(entity) || !entity isai())
	{
		return;
	}
	switch(gibFlag)
	{
		case 8:
		{
			break;
		}
		case 16:
		{
			break;
		}
		case 32:
		{
			break;
		}
		case 128:
		{
			break;
		}
		case 256:
		{
			break;
		}
	}
}

/*
	Name: play_revival_fx
	Namespace: zodcompanionclientutils
	Checksum: 0x86B0ED7B
	Offset: 0x798
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function play_revival_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.robot_revival_fx) && oldVal == 1 && newVal == 0)
	{
		stopfx(localClientNum, self.robot_revival_fx);
	}
	if(newVal === 1)
	{
		self playsound(0, "evt_civil_protector_revive_plr");
		self.robot_revival_fx = PlayFXOnTag(localClientNum, level._effect["companion_revive_effect"], self, "j_spineupper");
	}
}

