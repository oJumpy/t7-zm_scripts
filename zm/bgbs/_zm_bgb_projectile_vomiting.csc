#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_a5a0319c;

/*
	Name: __init__sytem__
	Namespace: namespace_a5a0319c
	Checksum: 0x6DCE8D5F
	Offset: 0x248
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_projectile_vomiting", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_a5a0319c
	Checksum: 0xCC0EAEA8
	Offset: 0x288
	Size: 0xC3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("actor", "projectile_vomit", 12000, 1, "counter", &function_6ac13208, 0, 0);
	bgb::register("zm_bgb_projectile_vomiting", "rounds");
	level._effect["bgb_puke_reaction"] = "zombie/fx_liquid_vomit_stream_zmb";
	level._effect["bgb_puke_reaction_no_head"] = "zombie/fx_liquid_vomit_stream_neck_zmb";
	level.var_e0154011 = 0;
}

/*
	Name: function_6ac13208
	Namespace: namespace_a5a0319c
	Checksum: 0xB59A22BA
	Offset: 0x358
	Size: 0x10B
	Parameters: 7
	Flags: None
*/
function function_6ac13208(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(level.var_e0154011 < 10)
	{
		if(GibClientUtils::IsGibbed(localClientNum, self, 8))
		{
			PlayFXOnTag(localClientNum, level._effect["bgb_puke_reaction_no_head"], self, "j_neck");
		}
		else
		{
			PlayFXOnTag(localClientNum, level._effect["bgb_puke_reaction"], self, "j_neck");
		}
		self playsound(0, "zmb_bgb_vomit_vox");
		level thread function_6d325051();
	}
}

/*
	Name: function_6d325051
	Namespace: namespace_a5a0319c
	Checksum: 0x3D371B8D
	Offset: 0x470
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function function_6d325051()
{
	level.var_e0154011++;
	wait(1);
	level.var_e0154011--;
}

