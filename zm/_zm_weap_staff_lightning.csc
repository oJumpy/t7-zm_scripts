#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_staff_common;

#namespace namespace_dc4ed61a;

/*
	Name: __init__sytem__
	Namespace: namespace_dc4ed61a
	Checksum: 0x82BD8C9C
	Offset: 0x2E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_lightning", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_dc4ed61a
	Checksum: 0xEA4DCBA1
	Offset: 0x320
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["lightning_miss"] = "dlc5/zmb_weapon/fx_staff_elec_impact_ug_miss";
	level._effect["lightning_arc"] = "dlc5/zmb_weapon/fx_staff_elec_trail_bolt_cheap";
	level._effect["lightning_impact"] = "dlc5/zmb_weapon/fx_staff_elec_impact_ug_hit_torso";
	level._effect["tesla_shock_eyes"] = "zombie/fx_tesla_shock_eyes_zmb";
	clientfield::register("actor", "lightning_impact_fx", 21000, 1, "int", &function_41819534, 0, 0);
	clientfield::register("scriptmover", "lightning_miss_fx", 21000, 1, "int", &function_6a2c832a, 0, 0);
	clientfield::register("actor", "lightning_arc_fx", 21000, 1, "int", &function_fb3ed342, 0, 0);
	level.var_1d5f245c = [];
	namespace_c9806b9::function_4be5e665(GetWeapon("staff_lightning_upgraded"), "dlc5/zmb_weapon/fx_staff_charge_elec_lv1");
}

/*
	Name: function_41819534
	Namespace: namespace_dc4ed61a
	Checksum: 0x9FCEE703
	Offset: 0x4B0
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_41819534(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["lightning_impact"], self, "J_SpineUpper");
		self playsound(0, "wpn_imp_lightningstaff");
	}
}

/*
	Name: function_6a2c832a
	Namespace: namespace_dc4ed61a
	Checksum: 0xB771C5C6
	Offset: 0x550
	Size: 0x101
	Parameters: 7
	Flags: None
*/
function function_6a2c832a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["lightning_miss"], self, "tag_origin");
		level.var_1d5f245c[localClientNum] = self;
		ent = spawn(0, self.origin, "script_origin");
		ent LinkTo(self);
		self thread function_80209369(localClientNum, ent);
		level notify("lightning_ball_created");
	}
}

/*
	Name: function_80209369
	Namespace: namespace_dc4ed61a
	Checksum: 0xCCFE6267
	Offset: 0x660
	Size: 0x3F
	Parameters: 2
	Flags: None
*/
function function_80209369(localClientNum, ent)
{
	self waittill("entityshutdown");
	ent delete();
	level.var_1d5f245c[localClientNum] = undefined;
}

/*
	Name: function_749acb79
	Namespace: namespace_dc4ed61a
	Checksum: 0x55347330
	Offset: 0x6A8
	Size: 0x1F7
	Parameters: 1
	Flags: None
*/
function function_749acb79(localClientNum)
{
	self endon("entityshutdown");
	self endon("hash_7a8f9f49");
	if(!isdefined(level.var_1d5f245c[localClientNum]))
	{
		level waittill("lightning_ball_created");
	}
	var_46352a82 = level.var_1d5f245c[localClientNum];
	var_46352a82 endon("entityshutdown");
	util::server_wait(localClientNum, RandomFloatRange(0.1, 0.5));
	self.e_fx = spawn(localClientNum, var_46352a82.origin, "script_model");
	self.e_fx SetModel("tag_origin");
	self.var_3de869a2 = PlayFXOnTag(localClientNum, level._effect["lightning_arc"], self.e_fx, "tag_origin");
	while(1)
	{
		var_8d0b58f1 = self GetTagOrigin("J_SpineUpper");
		self.e_fx moveto(var_8d0b58f1, 0.1);
		util::server_wait(localClientNum, 0.5);
		self.e_fx moveto(var_46352a82.origin, 0.1);
		util::server_wait(localClientNum, 0.5);
	}
}

/*
	Name: function_fb3ed342
	Namespace: namespace_dc4ed61a
	Checksum: 0xB75706CA
	Offset: 0x8A8
	Size: 0xD5
	Parameters: 7
	Flags: None
*/
function function_fb3ed342(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self thread function_749acb79(localClientNum);
	}
	else
	{
		self notify("hash_7a8f9f49");
		if(isdefined(self.var_3de869a2))
		{
			stopfx(localClientNum, self.var_3de869a2);
			self.var_3de869a2 = undefined;
		}
		if(isdefined(self.e_fx))
		{
			self.e_fx delete();
			self.e_fx = undefined;
		}
	}
}

