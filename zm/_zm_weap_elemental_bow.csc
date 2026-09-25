#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_weap_elemental_bow;

/*
	Name: __init__sytem__
	Namespace: zm_weap_elemental_bow
	Checksum: 0xA8D9C37C
	Offset: 0x298
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("_zm_weap_elemental_bow", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_elemental_bow
	Checksum: 0x5C540656
	Offset: 0x2D8
	Size: 0x183
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "elemental_bow" + "_ambient_bow_fx", 5000, 1, "int", &function_5b4bf635, 0, 0);
	clientfield::register("missile", "elemental_bow" + "_arrow_impact_fx", 5000, 1, "int", &function_4e8aa99, 0, 0);
	clientfield::register("missile", "elemental_bow4" + "_arrow_impact_fx", 5000, 1, "int", &function_bdaa35c, 0, 0);
	level._effect["elemental_bow_ambient_bow"] = "dlc1/zmb_weapon/fx_bow_default_ambient_1p_zmb";
	level._effect["elemental_bow_arrow_impact"] = "dlc1/zmb_weapon/fx_bow_default_impact_zmb";
	level._effect["elemental_bow_arrow_charged_impact"] = "dlc1/zmb_weapon/fx_bow_default_impact_ug_zmb";
	SetDvar("bg_chargeShotUseOneAmmoForMultipleBullets", 0);
	SetDvar("bg_zm_dlc1_chargeShotMultipleBulletsForFullCharge", 2);
}

/*
	Name: function_5b4bf635
	Namespace: zm_weap_elemental_bow
	Checksum: 0xEF15891C
	Offset: 0x468
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_5b4bf635(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self function_3158b481(localClientNum, newVal, "elemental_bow_ambient_bow");
}

/*
	Name: function_4e8aa99
	Namespace: zm_weap_elemental_bow
	Checksum: 0x6DF5B6AA
	Offset: 0x4D8
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_4e8aa99(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["elemental_bow_arrow_impact"], self.origin);
	}
}

/*
	Name: function_bdaa35c
	Namespace: zm_weap_elemental_bow
	Checksum: 0x236441C4
	Offset: 0x558
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_bdaa35c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["elemental_bow_arrow_charged_impact"], self.origin);
	}
}

/*
	Name: function_e5c5e30
	Namespace: zm_weap_elemental_bow
	Checksum: 0xA80CFFBF
	Offset: 0x5D8
	Size: 0xB1
	Parameters: 2
	Flags: None
*/
function function_e5c5e30(localClientNum, str_fx_name)
{
	if(isdefined(self.var_505704d9) && isdefined(self.var_505704d9[str_fx_name]))
	{
		deletefx(localClientNum, self.var_505704d9[str_fx_name], 1);
	}
	if(isdefined(self.var_a96110c3) && isdefined(self.var_a96110c3[str_fx_name]))
	{
		deletefx(localClientNum, self.var_a96110c3[str_fx_name], 1);
	}
	self notify("hash_74395f6a");
}

/*
	Name: function_3158b481
	Namespace: zm_weap_elemental_bow
	Checksum: 0xDD9A91B9
	Offset: 0x698
	Size: 0x143
	Parameters: 3
	Flags: None
*/
function function_3158b481(localClientNum, newVal, str_fx_name)
{
	function_e5c5e30(localClientNum, str_fx_name);
	if(newVal)
	{
		if(!IsSpectating(localClientNum))
		{
			currentWeapon = GetCurrentWeapon(localClientNum);
			if(IsSubStr(currentWeapon.name, "elemental_bow"))
			{
				self.var_505704d9[str_fx_name] = PlayViewmodelFX(localClientNum, level._effect[str_fx_name], "tag_fx_02");
				self.var_a96110c3[str_fx_name] = PlayViewmodelFX(localClientNum, level._effect[str_fx_name], "tag_fx_03");
			}
		}
		if(IsDemoPlaying())
		{
			self thread function_74395f6a(localClientNum, str_fx_name);
		}
	}
}

/*
	Name: function_74395f6a
	Namespace: zm_weap_elemental_bow
	Checksum: 0xF8F8FC47
	Offset: 0x7E8
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function function_74395f6a(localClientNum, str_fx_name)
{
	self notify("hash_74395f6a");
	self endon("hash_74395f6a");
	level waittill("demo_plplayer_change", lcn, var_fcf6978f, var_3dfd550a);
	var_fcf6978f function_e5c5e30(localClientNum, str_fx_name);
}

