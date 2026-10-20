#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace zm_ai_wasp;

/*
	Name: __init__sytem__
	Namespace: zm_ai_wasp
	Checksum: 0x6049CFE1
	Offset: 0x2D8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_wasp", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_wasp
	Checksum: 0xE2313690
	Offset: 0x318
	Size: 0x165
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "parasite_round_fx", 15000, 1, "counter", &parasite_round_fx, 0, 0);
	clientfield::register("world", "toggle_on_parasite_fog", 15000, 2, "int", &parasite_fog_on, 0, 0);
	clientfield::register("toplayer", "parasite_round_ring_fx", 15000, 1, "counter", &PARASITE_ROUND_RING_FX, 0, 0);
	clientfield::register("toplayer", "genesis_parasite_damage", 15000, 1, "counter", &genesis_parasite_damage, 0, 0);
	visionset_mgr::register_visionset_info("zm_wasp_round_visionset", 15000, 31, undefined, "zm_wasp_round_visionset");
	level._effect["parasite_round"] = "zombie/fx_parasite_round_tell_zod_zmb";
}

/*
	Name: parasite_fog_on
	Namespace: zm_ai_wasp
	Checksum: 0xB8717701
	Offset: 0x488
	Size: 0x115
	Parameters: 7
	Flags: None
*/
function parasite_fog_on(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		for(localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++)
		{
			SetLitFogBank(localClientNum, -1, 1, -1);
			SetWorldFogActiveBank(localClientNum, 2);
		}
	}
	else if(newVal == 2)
	{
		for(localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++)
		{
			SetLitFogBank(localClientNum, -1, 0, -1);
			SetWorldFogActiveBank(localClientNum, 1);
		}
	}
}

/*
	Name: parasite_round_fx
	Namespace: zm_ai_wasp
	Checksum: 0x601B8A80
	Offset: 0x5A8
	Size: 0xCB
	Parameters: 7
	Flags: None
*/
function parasite_round_fx(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	self endon("disconnect");
	self endon("death");
	if(IsSpectating(n_local_client))
	{
		return;
	}
	self.n_parasite_round_fx_id = PlayFXOnCamera(n_local_client, level._effect["parasite_round"]);
	wait(3.5);
	deletefx(n_local_client, self.n_parasite_round_fx_id);
}

/*
	Name: PARASITE_ROUND_RING_FX
	Namespace: zm_ai_wasp
	Checksum: 0x34F33B9C
	Offset: 0x680
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function PARASITE_ROUND_RING_FX(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("disconnect");
	if(IsSpectating(localClientNum))
	{
		return;
	}
	self thread postfx::playPostfxBundle("pstfx_ring_loop");
	wait(1.5);
	self postfx::exitPostfxBundle();
}

/*
	Name: genesis_parasite_damage
	Namespace: zm_ai_wasp
	Checksum: 0x3DAF2EED
	Offset: 0x728
	Size: 0x63
	Parameters: 7
	Flags: Private
*/
function private genesis_parasite_damage(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		self postfx::playPostfxBundle("pstfx_parasite_chaos");
	}
}

