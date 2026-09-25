#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_403823cc;

/*
	Name: __init__sytem__
	Namespace: namespace_403823cc
	Checksum: 0x1BBDC055
	Offset: 0x248
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_burned_out", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_403823cc
	Checksum: 0x3BA5CFBA
	Offset: 0x288
	Size: 0x205
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_burned_out", "event");
	clientfield::register("toplayer", "zm_bgb_burned_out" + "_1p" + "toplayer", 1, 1, "counter", &function_9c2ec371, 0, 0);
	clientfield::register("allplayers", "zm_bgb_burned_out" + "_3p" + "_allplayers", 1, 1, "counter", &function_c8cfe3c0, 0, 0);
	clientfield::register("actor", "zm_bgb_burned_out" + "_fire_torso" + "_actor", 1, 1, "counter", &function_34caa903, 0, 0);
	clientfield::register("vehicle", "zm_bgb_burned_out" + "_fire_torso" + "_vehicle", 1, 1, "counter", &function_69abda16, 0, 0);
	level._effect["zm_bgb_burned_out" + "_1p"] = "zombie/fx_bgb_burned_out_1p_zmb";
	level._effect["zm_bgb_burned_out" + "_3p"] = "zombie/fx_bgb_burned_out_3p_zmb";
	level._effect["zm_bgb_burned_out" + "_fire_torso"] = "zombie/fx_bgb_burned_out_fire_torso_zmb";
}

/*
	Name: function_9c2ec371
	Namespace: namespace_403823cc
	Checksum: 0xCD973B6D
	Offset: 0x498
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_9c2ec371(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!IsThirdPerson(localClientNum))
	{
		PlayFXOnTag(localClientNum, level._effect["zm_bgb_burned_out" + "_1p"], self, "tag_origin");
	}
}

/*
	Name: function_c8cfe3c0
	Namespace: namespace_403823cc
	Checksum: 0xBCAB3E15
	Offset: 0x530
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function function_c8cfe3c0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!self isLocalPlayer() || self getlocalclientnumber() != localClientNum || IsThirdPerson(localClientNum))
	{
		PlayFXOnTag(localClientNum, level._effect["zm_bgb_burned_out" + "_3p"], self, "tag_origin");
	}
}

/*
	Name: function_34caa903
	Namespace: namespace_403823cc
	Checksum: 0x9AEB5676
	Offset: 0x600
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_34caa903(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_68b2c2e8 = "j_spinelower";
	if(isdefined(self GetTagOrigin(var_68b2c2e8)))
	{
		var_68b2c2e8 = "tag_origin";
	}
	PlayFXOnTag(localClientNum, level._effect["zm_bgb_burned_out" + "_fire_torso"], self, var_68b2c2e8);
}

/*
	Name: function_69abda16
	Namespace: namespace_403823cc
	Checksum: 0xEF5091D4
	Offset: 0x6C0
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_69abda16(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_68b2c2e8 = "tag_body";
	if(isdefined(self GetTagOrigin(var_68b2c2e8)))
	{
		var_68b2c2e8 = "tag_origin";
	}
	PlayFXOnTag(localClientNum, level._effect["zm_bgb_burned_out" + "_fire_torso"], self, var_68b2c2e8);
}

