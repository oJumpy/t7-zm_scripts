#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_wisps;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_wisps
	Checksum: 0x428F823F
	Offset: 0x308
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_wisps", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_wisps
	Checksum: 0xC5E553EB
	Offset: 0x350
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "set_funfact_fx", 15000, 3, "int", &set_funfact_fx, 0, 0);
	clientfield::register("scriptmover", "wisp_fx", 15000, 2, "int", &wisp_fx, 0, 0);
}

/*
	Name: __main__
	Namespace: zm_genesis_wisps
	Checksum: 0x99EC1590
	Offset: 0x3F0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: wisp_fx
	Namespace: zm_genesis_wisps
	Checksum: 0xAAB4BF93
	Offset: 0x400
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function wisp_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		PlayFXOnTag(localClientNum, level._effect["wisp_abcd"], self, "tag_origin");
	}
	if(newVal == 2)
	{
		PlayFXOnTag(localClientNum, level._effect["wisp_shad"], self, "tag_origin");
	}
}

/*
	Name: set_funfact_fx
	Namespace: zm_genesis_wisps
	Checksum: 0xE7C5E163
	Offset: 0x4C8
	Size: 0x193
	Parameters: 7
	Flags: None
*/
function set_funfact_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!isdefined(self.var_ab2ca08f))
		{
			var_6aa3898e = Array("stub", "s_fx_funfact_demp", "s_fx_funfact_niko", "s_fx_funfact_rich", "s_fx_funfact_take");
			var_43845c37 = var_6aa3898e[newVal];
			s_fx = struct::get(var_43845c37, "targetname");
			if(isdefined(s_fx))
			{
				self.var_ab2ca08f = util::spawn_model(localClientNum, "tag_origin", s_fx.origin, s_fx.angles);
				if(isdefined(self.var_ab2ca08f))
				{
					PlayFXOnTag(localClientNum, level._effect["wisp_abcd"], self.var_ab2ca08f, "tag_origin");
				}
			}
		}
	}
	else if(isdefined(self.var_ab2ca08f))
	{
		self.var_ab2ca08f delete();
	}
}

