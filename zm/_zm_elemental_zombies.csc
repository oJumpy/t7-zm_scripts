#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_elemental_zombie;

/*
	Name: __init__sytem__
	Namespace: zm_elemental_zombie
	Checksum: 0x9EE85906
	Offset: 0x460
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_elemental_zombie", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_elemental_zombie
	Checksum: 0xF650F3DD
	Offset: 0x4A0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_fx();
	register_clientfields();
}

/*
	Name: init_fx
	Namespace: zm_elemental_zombie
	Checksum: 0xCC4092A1
	Offset: 0x4D0
	Size: 0xA9
	Parameters: 0
	Flags: None
*/
function init_fx()
{
	level._effect["elemental_zombie_sparky"] = "electric/fx_ability_elec_surge_short_robot_optim";
	level._effect["elemental_sparky_zombie_suicide"] = "explosions/fx_ability_exp_ravage_core_optim";
	level._effect["elemental_zombie_fire_damage"] = "fire/fx_embers_burst_optim";
	level._effect["elemental_napalm_zombie_suicide"] = "explosions/fx_exp_dest_barrel_concussion_sm_optim";
	level._effect["elemental_zombie_spark_light"] = "light/fx_light_spark_chest_zombie_optim";
	level._effect["elemental_electric_spark"] = "electric/fx_elec_sparks_burst_blue_optim";
}

/*
	Name: register_clientfields
	Namespace: zm_elemental_zombie
	Checksum: 0xF020CA59
	Offset: 0x588
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("actor", "sparky_zombie_spark_fx", 1, 1, "int", &sparky_zombie_spark_fx_cb, 0, 0);
	clientfield::register("actor", "sparky_zombie_death_fx", 1, 1, "int", &sparky_zombie_death_fx_cb, 0, 0);
	clientfield::register("actor", "napalm_zombie_death_fx", 1, 1, "int", &napalm_zombie_death_fx_cb, 0, 0);
	clientfield::register("actor", "sparky_damaged_fx", 1, 1, "counter", &function_86aaed61, 0, 0);
	clientfield::register("actor", "napalm_damaged_fx", 1, 1, "counter", &function_16467cb6, 0, 0);
	clientfield::register("actor", "napalm_sfx", 11000, 1, "int", &function_b542950d, 0, 0);
}

/*
	Name: napalm_zombie_death_fx_cb
	Namespace: zm_elemental_zombie
	Checksum: 0x60E3AA95
	Offset: 0x748
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function napalm_zombie_death_fx_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(oldVal !== newVal && newVal === 1)
	{
		FX = PlayFXOnTag(localClientNum, level._effect["elemental_napalm_zombie_suicide"], self, "j_spineupper");
		self playsound(0, "zmb_elemental_zombie_explode_fire");
	}
}

/*
	Name: function_16467cb6
	Namespace: zm_elemental_zombie
	Checksum: 0x6B19976B
	Offset: 0x828
	Size: 0x143
	Parameters: 7
	Flags: None
*/
function function_16467cb6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		if(isdefined(level._effect["elemental_zombie_fire_damage"]))
		{
			playsound(localClientNum, "gdt_electro_bounce", self.origin);
			locs = Array("j_wrist_le", "j_wrist_ri");
			FX = PlayFXOnTag(localClientNum, level._effect["elemental_zombie_fire_damage"], self, Array::random(locs));
			SetFXIgnorePause(localClientNum, FX, 1);
		}
	}
}

/*
	Name: function_b542950d
	Namespace: zm_elemental_zombie
	Checksum: 0x39FD6108
	Offset: 0x978
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_b542950d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		if(!isdefined(self.napalm_sfx_loop))
		{
			self.napalm_sfx_loop = self PlayLoopSound("zmb_elemental_zombie_loop_fire", 0.2);
		}
	}
}

/*
	Name: sparky_zombie_spark_fx_cb
	Namespace: zm_elemental_zombie
	Checksum: 0x97C34110
	Offset: 0xA08
	Size: 0x1BB
	Parameters: 7
	Flags: None
*/
function sparky_zombie_spark_fx_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(newVal))
	{
		return;
	}
	if(newVal == 1)
	{
		if(!isdefined(self.var_e863c331))
		{
			self.var_e863c331 = self PlayLoopSound("zmb_electrozomb_lp", 0.2);
		}
		str_tag = "J_SpineUpper";
		if(isdefined(self.var_46d9c2ee))
		{
			str_tag = self.var_46d9c2ee;
		}
		str_fx = level._effect["elemental_zombie_sparky"];
		if(isdefined(self.var_7abb4217))
		{
			str_fx = self.var_7abb4217;
		}
		FX = PlayFXOnTag(localClientNum, str_fx, self, str_tag);
		SetFXIgnorePause(localClientNum, FX, 1);
		var_4473cd0 = level._effect["elemental_zombie_spark_light"];
		if(isdefined(self.var_e22d3880))
		{
			var_4473cd0 = self.var_e22d3880;
		}
		FX = PlayFXOnTag(localClientNum, var_4473cd0, self, str_tag);
		SetFXIgnorePause(localClientNum, FX, 1);
	}
}

/*
	Name: sparky_zombie_death_fx_cb
	Namespace: zm_elemental_zombie
	Checksum: 0xDF73AD0D
	Offset: 0xBD0
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function sparky_zombie_death_fx_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(oldVal !== newVal && newVal === 1)
	{
		FX = PlayFXOnTag(localClientNum, level._effect["elemental_sparky_zombie_suicide"], self, "j_spineupper");
		self playsound(0, "zmb_elemental_zombie_explode_elec");
	}
}

/*
	Name: function_86aaed61
	Namespace: zm_elemental_zombie
	Checksum: 0xDF8AA709
	Offset: 0xC90
	Size: 0x12B
	Parameters: 7
	Flags: None
*/
function function_86aaed61(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(newVal))
	{
		return;
	}
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal >= 1)
	{
		if(!isdefined(self.var_e863c331))
		{
			self.var_e863c331 = self PlayLoopSound("zmb_electrozomb_lp", 0.2);
		}
		FX = PlayFXOnTag(localClientNum, level._effect["elemental_electric_spark"], self, "J_SpineUpper");
		SetFXIgnorePause(localClientNum, FX, 1);
	}
}

