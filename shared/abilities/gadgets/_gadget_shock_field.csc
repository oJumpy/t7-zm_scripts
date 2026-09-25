#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_shock_field;

/*
	Name: __init__sytem__
	Namespace: _gadget_shock_field
	Checksum: 0xED55D009
	Offset: 0x2A0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_shock_field", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_shock_field
	Checksum: 0xF1C73C81
	Offset: 0x2E0
	Size: 0x57
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "shock_field", 1, 1, "int", &player_shock_changed, 0, 1);
	level.shock_field_fx = [];
}

/*
	Name: is_local_player
	Namespace: _gadget_shock_field
	Checksum: 0x73CF8C00
	Offset: 0x340
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function is_local_player(localClientNum)
{
	player_view = GetLocalPlayer(localClientNum);
	if(!isdefined(player_view))
	{
		return 0;
	}
	sameEntity = self == player_view;
	return sameEntity;
}

/*
	Name: player_shock_changed
	Namespace: _gadget_shock_field
	Checksum: 0x1F156B61
	Offset: 0x3A0
	Size: 0x14F
	Parameters: 7
	Flags: None
*/
function player_shock_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	entid = GetLocalPlayer(localClientNum) GetEntityNumber();
	if(newVal)
	{
		if(!isdefined(level.shock_field_fx[entid]))
		{
			FX = "player/fx_plyr_shock_field";
			if(is_local_player(localClientNum))
			{
				FX = "player/fx_plyr_shock_field_1p";
			}
			tag = "j_spinelower";
			level.shock_field_fx[entid] = PlayFXOnTag(localClientNum, FX, self, tag);
		}
	}
	else if(isdefined(level.shock_field_fx[entid]))
	{
		stopfx(localClientNum, level.shock_field_fx[entid]);
		level.shock_field_fx[entid] = undefined;
	}
}

