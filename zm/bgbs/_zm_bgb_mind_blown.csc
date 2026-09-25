#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_42b119c2;

/*
	Name: __init__sytem__
	Namespace: namespace_42b119c2
	Checksum: 0xC885AC39
	Offset: 0x218
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_mind_blown", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_42b119c2
	Checksum: 0x1380574B
	Offset: 0x258
	Size: 0xCB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("actor", "zm_bgb_mind_pop_fx", 15000, 1, "int", &function_f10358c6, 0, 0);
	clientfield::register("actor", "zm_bgb_mind_ray_fx", 15000, 1, "int", &function_57f7c3a1, 0, 0);
	bgb::register("zm_bgb_mind_blown", "activated");
}

/*
	Name: function_57f7c3a1
	Namespace: namespace_42b119c2
	Checksum: 0x7CB530B7
	Offset: 0x330
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function function_57f7c3a1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	playsound(0, "zmb_bgb_mindblown_start", self GetTagOrigin("j_neck"));
	self.var_f40a5f31 = PlayFXOnTag(localClientNum, "zombie/fx_bgb_head_pop_ray", self, "j_neck");
	self.var_bbd257f7 = PlayFXOnTag(localClientNum, "dlc4/genesis/fx_bgb_mindblown_heatup", self, "j_spine4");
}

/*
	Name: function_f10358c6
	Namespace: namespace_42b119c2
	Checksum: 0x4E4097DE
	Offset: 0x410
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_f10358c6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_f40a5f31))
	{
		KillFX(localClientNum, self.var_f40a5f31);
	}
	if(isdefined(self.var_bbd257f7))
	{
		stopfx(localClientNum, self.var_bbd257f7);
	}
	PlayFXOnTag(localClientNum, "zombie/fx_bgb_head_pop", self, "j_neck");
}

