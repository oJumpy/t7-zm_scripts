#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_staff_common;

#namespace namespace_42f5ba79;

/*
	Name: __init__sytem__
	Namespace: namespace_42f5ba79
	Checksum: 0x19AF50FB
	Offset: 0x2E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_water", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_42f5ba79
	Checksum: 0x25546EB0
	Offset: 0x320
	Size: 0x1BB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "staff_blizzard_fx", 21000, 1, "int", &function_968ecc77, 1, 0);
	clientfield::register("actor", "attach_bullet_model", 21000, 1, "int", &attach_model, 0, 0);
	clientfield::register("actor", "staff_shatter_fx", 21000, 1, "int", &function_e6e6eaf8, 0, 0);
	level._effect["staff_water_blizzard"] = "dlc5/zmb_weapon/fx_staff_ice_impact_ug_hit";
	level._effect["staff_water_ice_shard"] = "dlc5/zmb_weapon/fx_staff_ice_trail_bolt";
	level._effect["staff_water_shatter"] = "dlc5/zmb_weapon/fx_staff_ice_exp";
	clientfield::register("actor", "anim_rate", 21000, 2, "float", undefined, 0, 0);
	setupclientfieldanimspeedcallbacks("actor", 1, "anim_rate");
	namespace_c9806b9::function_4be5e665(GetWeapon("staff_water_upgraded"), "dlc5/zmb_weapon/fx_staff_charge_ice_lv1");
}

/*
	Name: attach_model
	Namespace: namespace_42f5ba79
	Checksum: 0xE02FC1BB
	Offset: 0x4E8
	Size: 0x133
	Parameters: 7
	Flags: None
*/
function attach_model(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		if(isdefined(self.ice_shard_fx))
		{
			stopfx(localClientNum, self.ice_shard_fx);
		}
		self.ice_shard_fx = PlayFXOnTag(localClientNum, level._effect["staff_water_ice_shard"], self, "j_spine4");
		self thread ice_freeze_fx(localClientNum);
		self playsound(0, "wpn_waterstaff_freeze_zombie");
	}
	else if(isdefined(self.ice_shard_fx))
	{
		deletefx(localClientNum, self.ice_shard_fx);
		self.ice_shard_fx = undefined;
	}
	self thread ice_unfreeze(localClientNum);
}

/*
	Name: ice_freeze_fx
	Namespace: namespace_42f5ba79
	Checksum: 0x68303D64
	Offset: 0x628
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function ice_freeze_fx(localClientNum)
{
	self endon("entityshutdown");
	self endon("unfreeze");
	max_charamount = 0.9;
	rate = RandomFloatRange(0.005, 0.01);
	for(f = 0.6; f <= max_charamount;  = 0.6)
	{
		self SetShaderConstant(localClientNum, 0, f, 1, 0, 0);
		util::server_wait(localClientNum, 0.05);
	}
}

/*
	Name: ice_unfreeze
	Namespace: namespace_42f5ba79
	Checksum: 0x8199D85B
	Offset: 0x720
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function ice_unfreeze(localClientNum)
{
	self endon("entityshutdown");
	self notify("unfreeze");
	for(f = 1; f >= 0.6;  = 1)
	{
		self SetShaderConstant(localClientNum, 0, f, 1, 0, 0);
		util::server_wait(localClientNum, 0.05);
	}
	self SetShaderConstant(localClientNum, 0, 0, 0, 0, 0);
}

/*
	Name: function_968ecc77
	Namespace: namespace_42f5ba79
	Checksum: 0x5FAD75C0
	Offset: 0x7F0
	Size: 0x19D
	Parameters: 7
	Flags: None
*/
function function_968ecc77(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		self.ice_fx = PlayFXOnTag(localClientNum, level._effect["staff_water_blizzard"], self, "tag_origin");
		if(!isdefined(self.sndent))
		{
			self.sndent = spawn(0, self.origin, "script_origin");
			self.sndent playsound(0, "wpn_waterstaff_storm_imp");
			self.sndent.n_id = self.sndent PlayLoopSound("wpn_waterstaff_storm");
		}
	}
	else if(isdefined(self.ice_fx))
	{
		stopfx(localClientNum, self.ice_fx);
	}
	if(isdefined(self.sndent))
	{
		self.sndent StopLoopSound(self.sndent.n_id, 1.5);
		self.sndent delete();
		self.sndent = undefined;
	}
}

/*
	Name: function_e6e6eaf8
	Namespace: namespace_42f5ba79
	Checksum: 0xD8C475FD
	Offset: 0x998
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_e6e6eaf8(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		self.var_5d11d365 = PlayFXOnTag(localClientNum, level._effect["staff_water_shatter"], self, "J_SpineLower");
	}
}

