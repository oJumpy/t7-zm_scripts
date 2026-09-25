#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_42aab40d;

/*
	Name: __init__sytem__
	Namespace: namespace_42aab40d
	Checksum: 0x3B620DB8
	Offset: 0x490
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_dragon_strike", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_42aab40d
	Checksum: 0x356358DD
	Offset: 0x4D0
	Size: 0x415
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "dragon_strike_spawn_fx", 12000, 1, "int", &function_9edf1eca, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_on", 12000, 1, "int", &function_a911d32e, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_fx", 12000, 1, "counter", &function_ba315afb, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_upgraded_fx", 12000, 1, "counter", &function_64751666, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_invalid_fx", 12000, 1, "counter", &function_20b03867, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_upgraded_invalid_fx", 12000, 1, "counter", &function_6072780a, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_flare_fx", 12000, 1, "int", &function_67175345, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_fx_fadeout", 12000, 1, "counter", &function_3fd3d9a8, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_upgraded_fx_fadeout", 12000, 1, "counter", &function_adb23339, 0, 0);
	clientfield::register("actor", "dragon_strike_zombie_fire", 12000, 2, "int", &function_aea822d9, 0, 0);
	clientfield::register("vehicle", "dragon_strike_zombie_fire", 12000, 2, "int", &function_aea822d9, 0, 0);
	clientfield::register("clientuimodel", "dragon_strike_invalid_use", 12000, 1, "counter", undefined, 0, 0);
	clientfield::register("clientuimodel", "hudItems.showDpadRight_DragonStrike", 12000, 1, "int", undefined, 0, 0);
	level._effect["dragon_strike_portal"] = "dlc3/stalingrad/fx_dragonstrike_portal_flash";
	level._effect["dragon_strike_beacon"] = "dlc3/stalingrad/fx_light_flare_sky_marker_red";
	level._effect["dragon_strike_zombie_fire"] = "dlc3/stalingrad/fx_fire_torso_zmb_green";
	level._effect["dragon_strike_mouth"] = "dlc3/stalingrad/fx_dragon_mouth_drips_boss";
	level._effect["dragon_strike_tongue"] = "dlc3/stalingrad/fx_dragon_mouth_drips_tongue_boss";
}

/*
	Name: function_9edf1eca
	Namespace: namespace_42aab40d
	Checksum: 0x4C679876
	Offset: 0x8F0
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function function_9edf1eca(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["dragon_strike_portal"], self, "tag_neck_fx");
		PlayFXOnTag(localClientNum, level._effect["dragon_strike_mouth"], self, "tag_throat_fx");
		PlayFXOnTag(localClientNum, level._effect["dragon_strike_tongue"], self, "tag_mouth_floor_fx");
	}
}

/*
	Name: function_a911d32e
	Namespace: namespace_42aab40d
	Checksum: 0x3F7B2534
	Offset: 0x9D0
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_a911d32e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self function_38b917b0(1);
		self thread function_778495b0(localClientNum);
	}
	else
	{
		self notify("hash_e98f7ec4");
		self function_38b917b0(0);
	}
}

/*
	Name: function_778495b0
	Namespace: namespace_42aab40d
	Checksum: 0x79D6D7C0
	Offset: 0xA78
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function function_778495b0(localClientNum)
{
	self endon("hash_e98f7ec4");
	self endon("entityshutdown");
	while(isdefined(self))
	{
		self function_808efef6(self.origin);
		wait(0.016);
	}
}

/*
	Name: function_ba315afb
	Namespace: namespace_42aab40d
	Checksum: 0x222CEC20
	Offset: 0xAD0
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_ba315afb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_32fc2895(0.25, 3, 0.25, 128, 0.5, 0);
}

/*
	Name: function_64751666
	Namespace: namespace_42aab40d
	Checksum: 0xA0F6A8C8
	Offset: 0xB58
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_64751666(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_32fc2895(0.15, 3, 0.15, 128, 0.75, 0);
}

/*
	Name: function_20b03867
	Namespace: namespace_42aab40d
	Checksum: 0xABBF7E1F
	Offset: 0xBE0
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_20b03867(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_32fc2895(4, 0.5, 0.25, 128, 0.5, 0);
}

/*
	Name: function_6072780a
	Namespace: namespace_42aab40d
	Checksum: 0xEF0E6351
	Offset: 0xC68
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_6072780a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_32fc2895(4, 0.5, 0.25, 128, 0.75, 0);
}

/*
	Name: function_67175345
	Namespace: namespace_42aab40d
	Checksum: 0xC8E7EA1A
	Offset: 0xCF0
	Size: 0xB5
	Parameters: 7
	Flags: None
*/
function function_67175345(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.fx_flare = playFX(localClientNum, level._effect["dragon_strike_beacon"], self.origin);
	}
	else if(isdefined(self.fx_flare))
	{
		deletefx(localClientNum, self.fx_flare, 1);
		self.fx_flare = undefined;
	}
}

/*
	Name: function_3fd3d9a8
	Namespace: namespace_42aab40d
	Checksum: 0x235DE35D
	Offset: 0xDB0
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_3fd3d9a8(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self thread function_1ba92b11(0.25, 3, 0.25, 0.5);
}

/*
	Name: function_adb23339
	Namespace: namespace_42aab40d
	Checksum: 0x45C02EC4
	Offset: 0xE30
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_adb23339(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self thread function_1ba92b11(0.15, 3, 0.15, 0.75);
}

/*
	Name: function_1ba92b11
	Namespace: namespace_42aab40d
	Checksum: 0x2189F563
	Offset: 0xEB0
	Size: 0xFD
	Parameters: 4
	Flags: None
*/
function function_1ba92b11(var_6d056a0e, var_9ad65443, var_cddc37e, var_76d07324)
{
	var_e0a873d1 = var_6d056a0e / 16;
	var_24ce51da = var_9ad65443 / 16;
	var_1e73d761 = var_cddc37e / 16;
	for(i = 0; i < 16; i++)
	{
		var_6d056a0e = var_6d056a0e - var_e0a873d1;
		var_9ad65443 = var_9ad65443 - var_24ce51da;
		var_cddc37e = var_cddc37e - var_1e73d761;
		self function_32fc2895(var_6d056a0e, var_9ad65443, var_cddc37e, 128, var_76d07324, 0);
		wait(0.016);
	}
}

/*
	Name: function_aea822d9
	Namespace: namespace_42aab40d
	Checksum: 0x98E285C
	Offset: 0xFB8
	Size: 0x11B
	Parameters: 7
	Flags: None
*/
function function_aea822d9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 2)
	{
		self zombie_death::flame_death_fx(localClientNum);
	}
	else
	{
		str_tag = "j_spinelower";
		v_tag = self GetTagOrigin(str_tag);
		if(!isdefined(v_tag))
		{
			str_tag = "tag_origin";
		}
		self.var_9f5c18b = 1;
		if(isdefined(self))
		{
			self.var_aea822d9 = PlayFXOnTag(localClientNum, level._effect["dragon_strike_zombie_fire"], self, str_tag);
			self thread function_3cc1555d(localClientNum);
		}
	}
}

/*
	Name: function_3cc1555d
	Namespace: namespace_42aab40d
	Checksum: 0x271D424
	Offset: 0x10E0
	Size: 0x67
	Parameters: 1
	Flags: None
*/
function function_3cc1555d(localClientNum)
{
	self endon("entityshutdown");
	wait(12);
	if(isdefined(self) && isalive(self))
	{
		stopfx(localClientNum, self.var_aea822d9);
		self.var_9f5c18b = 0;
	}
}

