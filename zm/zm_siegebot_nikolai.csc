#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\vehicle_shared;

#namespace namespace_f1e2170d;

/*
	Name: __init__sytem__
	Namespace: namespace_f1e2170d
	Checksum: 0xB79FB928
	Offset: 0x498
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_siegebot_nikolai", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_f1e2170d
	Checksum: 0x4A7A239D
	Offset: 0x4D8
	Size: 0x2FB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_vehicletype_callback("siegebot_nikolai", &on_spawned);
	clientfield::register("vehicle", "nikolai_destroyed_r_arm", 12000, 1, "int", &function_8ca32b42, 0, 0);
	clientfield::register("vehicle", "nikolai_destroyed_l_arm", 12000, 1, "int", &function_4c694fb0, 0, 0);
	clientfield::register("vehicle", "nikolai_destroyed_r_chest", 12000, 1, "int", &function_7d45e8fb, 0, 0);
	clientfield::register("vehicle", "nikolai_destroyed_l_chest", 12000, 1, "int", &function_dc246c0d, 0, 0);
	clientfield::register("vehicle", "nikolai_weakpoint_l_fx", 12000, 1, "int", &function_44a1e181, 0, 0);
	clientfield::register("vehicle", "nikolai_weakpoint_r_fx", 12000, 1, "int", &function_78d9544b, 0, 0);
	clientfield::register("vehicle", "nikolai_gatling_tell", 12000, 1, "int", &function_e504eaab, 0, 0);
	clientfield::register("missile", "harpoon_impact", 12000, 1, "int", &function_88c952b, 0, 0);
	clientfield::register("vehicle", "play_raps_trail_fx", 12000, 1, "int", &function_66f3947f, 0, 0);
	clientfield::register("vehicle", "raps_landing", 12000, 1, "int", &function_4dc797b1, 0, 0);
}

/*
	Name: on_spawned
	Namespace: namespace_f1e2170d
	Checksum: 0xD8240D81
	Offset: 0x7E0
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function on_spawned(localClientNum)
{
	self useanimtree(-1);
	self thread function_89d7e567(localClientNum);
	self thread function_48c3fc7d(localClientNum);
}

/*
	Name: function_48c3fc7d
	Namespace: namespace_f1e2170d
	Checksum: 0xEBAF355
	Offset: 0x848
	Size: 0x277
	Parameters: 1
	Flags: None
*/
function function_48c3fc7d(localClientNum)
{
	self endon("entityshutdown");
	self notify("hash_48c3fc7d");
	self endon("hash_48c3fc7d");
	NIKOLAI = undefined;
	while(1)
	{
		level waittill("hash_eeba0c72");
		if(!isdefined(NIKOLAI))
		{
			allEnts = GetEntArray(localClientNum);
			foreach(ent in allEnts)
			{
				if(ent.model === "c_zom_dlc_waw_nikolai_fb" && self isEntityLinkedToTag(ent))
				{
					NIKOLAI = ent;
				}
			}
		}
		Bottle = undefined;
		if(isdefined(NIKOLAI))
		{
			origin = NIKOLAI GetTagOrigin("j_ringbase_le");
			angles = NIKOLAI GetTagAngles("j_ringbase_le");
			up = anglesToUp(angles);
			angles = angles + VectorScale((0, 0, 1), 180);
			Bottle = spawn(localClientNum, origin, "script_model");
			Bottle SetModel("p7_zm_sta_bottle_vodka_01");
			Bottle.angles = angles;
			NIKOLAI thread function_97181777(Bottle);
		}
		level waittill("hash_13cefe1f");
		if(isdefined(Bottle))
		{
			Bottle delete();
		}
	}
}

/*
	Name: function_97181777
	Namespace: namespace_f1e2170d
	Checksum: 0x4ECD6910
	Offset: 0xAC8
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function function_97181777(Bottle)
{
	while(isdefined(self) && isdefined(Bottle))
	{
		origin = self GetTagOrigin("j_ringbase_le");
		angles = self GetTagAngles("j_ringbase_le");
		FORWARD = AnglesToForward(angles);
		right = AnglesToRight(angles);
		up = anglesToUp(angles);
		angles = angles + VectorScale((0, 0, 1), 180);
		offset = FORWARD * 1.6 + right * -1.2 + up * 11;
		Bottle.origin = origin + offset;
		Bottle.angles = angles;
		wait(0.016);
	}
}

/*
	Name: function_89d7e567
	Namespace: namespace_f1e2170d
	Checksum: 0xCE04DE2E
	Offset: 0xC28
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_89d7e567(localClientNum)
{
	self endon("disconnect");
	self endon("entityshutdown");
	while(1)
	{
		self waittill("hash_1323c42e");
		self SetAnim("ai_zm_dlc3_russian_mech_shoot_gunbarrel", 1, 0, 1);
	}
}

/*
	Name: function_e504eaab
	Namespace: namespace_f1e2170d
	Checksum: 0xFE384A06
	Offset: 0xC90
	Size: 0x185
	Parameters: 7
	Flags: None
*/
function function_e504eaab(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_16903828 = PlayFXOnTag(localClientNum, level._effect["nikolai_gatling_tell"], self, "tag_gunner_aim1");
		self playsound(localClientNum, "zmb_nikolaibot_rapidfire_start", self GetTagOrigin("tag_eye"));
		self.var_464db63 = self PlayLoopSound("zmb_nikolaibot_rapidfire_barrel_lp");
	}
	else if(isdefined(self.var_16903828))
	{
		stopfx(localClientNum, self.var_16903828);
	}
	self playsound(localClientNum, "zmb_nikolaibot_rapidfire_end", self GetTagOrigin("tag_eye"));
	if(isdefined(self.var_464db63))
	{
		self StopLoopSound(self.var_464db63);
		self.var_464db63 = undefined;
	}
}

/*
	Name: function_8ca32b42
	Namespace: namespace_f1e2170d
	Checksum: 0x9ECC9C86
	Offset: 0xE20
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_8ca32b42(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["nikolai_weakpoint_destroyed"], self, "tag_heat_vent_01_d1");
		self playsound(localClientNum, "zmb_nikolaibot_damage", self GetTagOrigin("tag_heat_vent_01_d1"));
	}
}

/*
	Name: function_4c694fb0
	Namespace: namespace_f1e2170d
	Checksum: 0x6AAB2F5D
	Offset: 0xEE0
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_4c694fb0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["nikolai_weakpoint_destroyed"], self, "tag_heat_vent_02_d1");
		self playsound(localClientNum, "zmb_nikolaibot_damage", self GetTagOrigin("tag_heat_vent_02_d1"));
	}
}

/*
	Name: function_7d45e8fb
	Namespace: namespace_f1e2170d
	Checksum: 0xB5EBA05E
	Offset: 0xFA0
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_7d45e8fb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["nikolai_weakpoint_destroyed"], self, "tag_heat_vent_03_d1");
		self playsound(localClientNum, "zmb_nikolaibot_damage", self GetTagOrigin("tag_heat_vent_03_d1"));
	}
}

/*
	Name: function_dc246c0d
	Namespace: namespace_f1e2170d
	Checksum: 0x6892A3EB
	Offset: 0x1060
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_dc246c0d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["nikolai_weakpoint_destroyed"], self, "tag_heat_vent_04_d1");
		self playsound(localClientNum, "zmb_nikolaibot_damage", self GetTagOrigin("tag_heat_vent_04_d1"));
	}
}

/*
	Name: function_78d9544b
	Namespace: namespace_f1e2170d
	Checksum: 0x6952148
	Offset: 0x1120
	Size: 0xB5
	Parameters: 7
	Flags: None
*/
function function_78d9544b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_da48848b = PlayFXOnTag(localClientNum, level._effect["nikolai_weakpoint_fx"], self, "tag_heat_vent_01_d0");
	}
	else if(isdefined(self.var_da48848b))
	{
		stopfx(localClientNum, self.var_da48848b);
		self.var_da48848b = undefined;
	}
}

/*
	Name: function_44a1e181
	Namespace: namespace_f1e2170d
	Checksum: 0x766C39B5
	Offset: 0x11E0
	Size: 0xB5
	Parameters: 7
	Flags: None
*/
function function_44a1e181(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_f639a615 = PlayFXOnTag(localClientNum, level._effect["nikolai_weakpoint_fx"], self, "tag_heat_vent_02_d0");
	}
	else if(isdefined(self.var_f639a615))
	{
		stopfx(localClientNum, self.var_f639a615);
		self.var_f639a615 = undefined;
	}
}

/*
	Name: function_88c952b
	Namespace: namespace_f1e2170d
	Checksum: 0x9B3E04A2
	Offset: 0x12A0
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_88c952b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["nikolai_harpoon_impact"], self.origin, AnglesToForward(self.angles) * -1);
		playsound(0, "zmb_nikolaibot_harpoon_impact", self.origin + VectorScale((0, 0, 1), 10));
		PlayRumbleOnPosition(localClientNum, "harpoon_land", self.origin + VectorScale((0, 0, 1), 10));
	}
}

/*
	Name: function_66f3947f
	Namespace: namespace_f1e2170d
	Checksum: 0xDBA8FF97
	Offset: 0x13A8
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function function_66f3947f(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	self endon("disconnect");
	self endon("entityshutdown");
	if(n_val_new)
	{
		self.var_9fa8c7a2 = PlayFXOnTag(n_local_client, level._effect["nikolai_raps_trail"], self, "tag_body");
		self playsound(0, "wpn_nikolaibot_raps_launch");
	}
	else if(isdefined(self.var_9fa8c7a2))
	{
		stopfx(n_local_client, self.var_9fa8c7a2);
	}
}

/*
	Name: function_4dc797b1
	Namespace: namespace_f1e2170d
	Checksum: 0x5043A525
	Offset: 0x1498
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_4dc797b1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["nikolai_raps_landing"], self, "tag_origin");
		self playsound(0, "zmb_nikolaibot_raps_impact");
	}
}

