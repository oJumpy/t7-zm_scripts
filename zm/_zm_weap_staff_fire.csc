#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_staff_common;

#namespace namespace_ecdcc148;

/*
	Name: __init__sytem__
	Namespace: namespace_ecdcc148
	Checksum: 0xEE7A82F6
	Offset: 0x280
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_fire", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_ecdcc148
	Checksum: 0xBC361AEC
	Offset: 0x2C0
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("actor", "fire_char_fx", 21000, 1, "int", &function_657b61e3, 0, 0);
	clientfield::register("toplayer", "fire_muzzle_fx", 21000, 1, "counter", &function_d6107b2c, 0, 0);
	level._effect["fire_muzzle"] = "dlc5/zmb_weapon/fx_staff_fire_muz_flash_1p";
	level._effect["fire_muzzle_ug"] = "dlc5/zmb_weapon/fx_staff_fire_muz_flash_1p_ug";
	namespace_c9806b9::function_4be5e665(GetWeapon("staff_fire_upgraded"), "dlc5/zmb_weapon/fx_staff_charge_fire_lv1");
}

/*
	Name: function_d6107b2c
	Namespace: namespace_ecdcc148
	Checksum: 0xF6DDD742
	Offset: 0x3C8
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_d6107b2c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		if(HasWeapon(localClientNum, GetWeapon("staff_fire_upgraded")))
		{
			PlayViewmodelFX(localClientNum, level._effect["fire_muzzle_ug"], "tag_flash");
		}
		else
		{
			PlayViewmodelFX(localClientNum, level._effect["fire_muzzle"], "tag_flash");
		}
		playsound(localClientNum, "wpn_firestaff_fire_plr");
	}
}

/*
	Name: function_657b61e3
	Namespace: namespace_ecdcc148
	Checksum: 0x685522FD
	Offset: 0x4D0
	Size: 0x41F
	Parameters: 7
	Flags: None
*/
function function_657b61e3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self endon("entityshutdown");
	rate = RandomFloatRange(0.01, 0.015);
	if(isdefined(self.var_a90ff836))
	{
		stopfx(localClientNum, self.var_a90ff836);
		self.var_a90ff836 = undefined;
	}
	if(isdefined(self.var_44f239e3))
	{
		stopfx(localClientNum, self.var_44f239e3);
		self.var_44f239e3 = undefined;
	}
	if(isdefined(self.sndent))
	{
		self.sndent notify("sndDeleting");
		self.sndent delete();
		self.sndent = undefined;
	}
	if(newVal == 1)
	{
		self.var_a90ff836 = PlayFXOnTag(localClientNum, level._effect["character_fire_death_torso"], self, "j_spinelower");
		self.var_44f239e3 = PlayFXOnTag(localClientNum, level._effect["character_fire_death_sm"], self, "j_head");
		self.sndent = spawn(0, self.origin, "script_origin");
		self.sndent LinkTo(self);
		self.sndent PlayLoopSound("zmb_fire_loop", 0.5);
		self.sndent thread function_613e39fa(self);
		if(!(isdefined(self.var_ff3ddd5b) && self.var_ff3ddd5b))
		{
			self.var_ff3ddd5b = 1;
		}
		var_5e5728a8 = 1;
		var_2094128c = 0.6;
		for(i = 0; i < 2; i++)
		{
			for(f = 0.6; f <= 0.85;  = 0.6)
			{
				util::server_wait(localClientNum, 0.05);
				self SetShaderConstant(localClientNum, 0, f, 0, 0, 0);
			}
			for(f = 0.85; f >= 0.6;  = 0.85)
			{
				util::server_wait(localClientNum, 0.05);
				self SetShaderConstant(localClientNum, 0, f, 0, 0, 0);
			}
		}
		for(f = 0.6; f <= 1;  = 0.6)
		{
			util::server_wait(localClientNum, 0.05);
			self SetShaderConstant(localClientNum, 0, f, 0, 0, 0);
		}
	}
}

/*
	Name: function_613e39fa
	Namespace: namespace_ecdcc148
	Checksum: 0x277627D2
	Offset: 0x8F8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_613e39fa(zomb)
{
	self endon("sndDeleting");
	zomb waittill("entityshutdown");
	self delete();
}

