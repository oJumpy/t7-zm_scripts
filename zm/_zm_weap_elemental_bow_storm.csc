#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_elemental_bow;

#namespace namespace_156ea490;

/*
	Name: __init__sytem__
	Namespace: namespace_156ea490
	Checksum: 0xE5BF068
	Offset: 0x538
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("_zm_weap_elemental_bow_storm", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_156ea490
	Checksum: 0xF0C12582
	Offset: 0x578
	Size: 0x371
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "elemental_bow_storm" + "_ambient_bow_fx", 5000, 1, "int", &function_e73829fb, 0, 0);
	clientfield::register("missile", "elemental_bow_storm" + "_arrow_impact_fx", 5000, 1, "int", &function_93740776, 0, 0);
	clientfield::register("missile", "elemental_bow_storm4" + "_arrow_impact_fx", 5000, 1, "int", &function_c50a03db, 0, 0);
	clientfield::register("scriptmover", "elem_storm_fx", 5000, 1, "int", &function_3481f83b, 0, 0);
	clientfield::register("toplayer", "elem_storm_whirlwind_rumble", 1, 1, "int", &function_d6997d17, 0, 0);
	clientfield::register("scriptmover", "elem_storm_bolt_fx", 5000, 1, "int", &function_3b5511c9, 0, 0);
	clientfield::register("scriptmover", "elem_storm_zap_ambient", 5000, 1, "int", &function_ca0ac11f, 0, 0);
	clientfield::register("actor", "elem_storm_shock_fx", 5000, 2, "int", &function_df6db522, 0, 0);
	level._effect["elem_storm_ambient_bow"] = "dlc1/zmb_weapon/fx_bow_storm_ambient_1p_zmb";
	level._effect["elem_storm_arrow_impact"] = "dlc1/zmb_weapon/fx_bow_storm_impact_zmb";
	level._effect["elem_storm_arrow_charged_impact"] = "dlc1/zmb_weapon/fx_bow_storm_impact_ug_zmb";
	level._effect["elem_storm_whirlwind_loop"] = "dlc1/zmb_weapon/fx_bow_storm_funnel_loop_zmb";
	level._effect["elem_storm_whirlwind_end"] = "dlc1/zmb_weapon/fx_bow_storm_funnel_end_zmb";
	level._effect["elem_storm_zap_ambient"] = "dlc1/zmb_weapon/fx_bow_storm_orb_zmb";
	level._effect["elem_storm_zap_bolt"] = "dlc1/zmb_weapon/fx_bow_storm_bolt_zap_zmb";
	level._effect["elem_storm_shock_eyes"] = "zombie/fx_tesla_shock_eyes_zmb";
	level._effect["elem_storm_shock"] = "zombie/fx_tesla_shock_zmb";
	level._effect["elem_storm_shock_nonfatal"] = "zombie/fx_bmode_shock_os_zod_zmb";
}

/*
	Name: function_e73829fb
	Namespace: namespace_156ea490
	Checksum: 0x6825C11E
	Offset: 0x8F8
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_e73829fb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self zm_weap_elemental_bow::function_3158b481(localClientNum, newVal, "elem_storm_ambient_bow");
}

/*
	Name: function_93740776
	Namespace: namespace_156ea490
	Checksum: 0x58223664
	Offset: 0x968
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_93740776(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["elem_storm_arrow_impact"], self.origin);
	}
}

/*
	Name: function_c50a03db
	Namespace: namespace_156ea490
	Checksum: 0xF325DA09
	Offset: 0x9E8
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_c50a03db(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["elem_storm_arrow_charged_impact"], self.origin);
	}
}

/*
	Name: function_3481f83b
	Namespace: namespace_156ea490
	Checksum: 0x3C0431D5
	Offset: 0xA68
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_3481f83b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(newVal)
	{
		self.var_53f7dac0 = PlayFXOnTag(localClientNum, level._effect["elem_storm_whirlwind_loop"], self, "tag_origin");
	}
	else if(isdefined(self.var_53f7dac0))
	{
		deletefx(localClientNum, self.var_53f7dac0, 0);
		self.var_53f7dac0 = undefined;
	}
	wait(0.4);
	playFX(localClientNum, level._effect["elem_storm_whirlwind_end"], self.origin);
}

/*
	Name: function_d6997d17
	Namespace: namespace_156ea490
	Checksum: 0xB5894B1
	Offset: 0xB70
	Size: 0x6D
	Parameters: 7
	Flags: None
*/
function function_d6997d17(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread function_4d18057(localClientNum);
	}
	else
	{
		self notify("hash_171d986a");
	}
}

/*
	Name: function_4d18057
	Namespace: namespace_156ea490
	Checksum: 0xE46D7C5B
	Offset: 0xBE8
	Size: 0x5F
	Parameters: 1
	Flags: None
*/
function function_4d18057(localClientNum)
{
	level endon("demo_jump");
	self endon("hash_171d986a");
	self endon("death");
	while(isdefined(self))
	{
		self PlayRumbleOnEntity(localClientNum, "zod_idgun_vortex_interior");
		wait(0.075);
	}
}

/*
	Name: function_3b5511c9
	Namespace: namespace_156ea490
	Checksum: 0x542B354B
	Offset: 0xC50
	Size: 0xFB
	Parameters: 7
	Flags: None
*/
function function_3b5511c9(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(self.var_ca6ae14c))
		{
			deletefx(localClientNum, self.var_ca6ae14c, 0);
			self.var_ca6ae14c = undefined;
		}
		v_forward = AnglesToForward(self.angles);
		v_up = anglesToUp(self.angles);
		self.var_ca6ae14c = PlayFXOnTag(localClientNum, level._effect["elem_storm_zap_bolt"], self, "tag_origin");
	}
}

/*
	Name: function_ca0ac11f
	Namespace: namespace_156ea490
	Checksum: 0xF60246DD
	Offset: 0xD58
	Size: 0xA5
	Parameters: 7
	Flags: None
*/
function function_ca0ac11f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_dab5ed7 = PlayFXOnTag(localClientNum, level._effect["elem_storm_zap_ambient"], self, "tag_origin");
	}
	else
	{
		deletefx(localClientNum, self.var_dab5ed7, 0);
		self.var_dab5ed7 = undefined;
	}
}

/*
	Name: function_df6db522
	Namespace: namespace_156ea490
	Checksum: 0x44F5A072
	Offset: 0xE08
	Size: 0x25D
	Parameters: 7
	Flags: None
*/
function function_df6db522(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(self isai())
	{
	}
	else
	{
	}
	tag = "tag_origin";
	switch(newVal)
	{
		case 0:
		{
			if(isdefined(self.var_a9b1ee1b))
			{
				deletefx(localClientNum, self.var_a9b1ee1b, 1);
			}
			if(isdefined(self.var_ae1320f9))
			{
				deletefx(localClientNum, self.var_ae1320f9, 1);
			}
			if(isdefined(self.var_523596b1))
			{
				deletefx(localClientNum, self.var_523596b1, 1);
			}
			self.var_a9b1ee1b = undefined;
			self.var_ae1320f9 = undefined;
			self.var_bb955880 = undefined;
			break;
		}
		case 1:
		{
			if(!isdefined(self.var_ae1320f9))
			{
				self.var_ae1320f9 = PlayFXOnTag(localClientNum, level._effect["elem_storm_shock"], self, tag);
			}
			break;
		}
		case 2:
		{
			if(!isdefined(self.var_a9b1ee1b))
			{
				self.var_111812ed = PlayFXOnTag(localClientNum, level._effect["elem_storm_shock_eyes"], self, "J_Eyeball_LE");
			}
			if(!isdefined(self.var_ae1320f9))
			{
				self.var_ae1320f9 = PlayFXOnTag(localClientNum, level._effect["elem_storm_shock"], self, tag);
			}
			if(!isdefined(self.var_523596b1))
			{
				self.var_523596b1 = PlayFXOnTag(localClientNum, level._effect["elem_storm_shock_nonfatal"], self, tag);
			}
			break;
		}
	}
}

