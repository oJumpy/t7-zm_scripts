#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;

#namespace namespace_27f8b154;

/*
	Name: __init__sytem__
	Namespace: namespace_27f8b154
	Checksum: 0x74AC68A9
	Offset: 0x580
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_spiders", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: namespace_27f8b154
	Checksum: 0x9231C098
	Offset: 0x5C8
	Size: 0x163
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["spider_round"] = "dlc2/island/fx_spider_round_tell";
	level._effect["spider_web_grenade_stuck"] = "dlc2/island/fx_web_grenade_tell";
	level._effect["spider_web_bgb_tear"] = "dlc2/island/fx_web_bgb_tearing";
	level._effect["spider_web_bgb_tear_complete"] = "dlc2/island/fx_web_bgb_reveal";
	level._effect["spider_web_perk_machine_tear"] = "dlc2/island/fx_web_perk_machine_tearing";
	level._effect["spider_web_perk_machine_tear_complete"] = "dlc2/island/fx_web_perk_machine_reveal";
	level._effect["spider_web_doorbuy_tear"] = "dlc2/island/fx_web_barrier_tearing";
	level._effect["spider_web_doorbuy_tear_complete"] = "dlc2/island/fx_web_barrier_reveal";
	level._effect["spider_web_tear_explosive"] = "dlc2/island/fx_web_impact_rocket";
	register_clientfields();
	vehicle::add_vehicletype_callback("spider", &function_7c1ef59b);
	visionset_mgr::register_visionset_info("zm_isl_parasite_spider_visionset", 9000, 16, undefined, "zm_isl_parasite_spider");
}

/*
	Name: __main__
	Namespace: namespace_27f8b154
	Checksum: 0x99EC1590
	Offset: 0x738
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function __main__()
{
}

/*
	Name: register_clientfields
	Namespace: namespace_27f8b154
	Checksum: 0xF282ED5A
	Offset: 0x748
	Size: 0x263
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("toplayer", "spider_round_fx", 9000, 1, "counter", &function_cf314378, 0, 0);
	clientfield::register("toplayer", "spider_round_ring_fx", 9000, 1, "counter", &function_ea4a561d, 0, 0);
	clientfield::register("toplayer", "spider_end_of_round_reset", 9000, 1, "counter", &function_5a0b8305, 0, 0);
	clientfield::register("scriptmover", "set_fade_material", 9000, 1, "int", &function_4ff90290, 0, 0);
	clientfield::register("scriptmover", "web_fade_material", 9000, 3, "float", &function_50dc34c6, 0, 0);
	clientfield::register("missile", "play_grenade_stuck_in_web_fx", 9000, 1, "int", &function_adde492f, 0, 0);
	clientfield::register("scriptmover", "play_spider_web_tear_fx", 9000, GetMinBitCountForNum(4), "int", &function_bcbf0bf6, 0, 0);
	clientfield::register("scriptmover", "play_spider_web_tear_complete_fx", 9000, GetMinBitCountForNum(4), "int", &function_25ccb29e, 0, 0);
}

/*
	Name: function_7c1ef59b
	Namespace: namespace_27f8b154
	Checksum: 0x5FC1C07B
	Offset: 0x9B8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_7c1ef59b(localClientNum)
{
	self.str_tag_tesla_death_fx = "J_SpineUpper";
	self.str_tag_tesla_shock_eyes_fx = "J_SpineUpper";
}

/*
	Name: function_cf314378
	Namespace: namespace_27f8b154
	Checksum: 0xD917F427
	Offset: 0x9F0
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function function_cf314378(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	self endon("disconnect");
	SetWorldFogActiveBank(n_local_client, 8);
	if(IsSpectating(n_local_client))
	{
		return;
	}
	self.var_d5173f21 = PlayFXOnCamera(n_local_client, level._effect["spider_round"]);
	playsound(0, "zmb_spider_round_webup", (0, 0, 0));
	wait(0.016);
	self thread postfx::playPostfxBundle("pstfx_parasite_spider");
	wait(3.5);
	deletefx(n_local_client, self.var_d5173f21);
}

/*
	Name: function_5a0b8305
	Namespace: namespace_27f8b154
	Checksum: 0x3DBFB6EE
	Offset: 0xB20
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_5a0b8305(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		SetWorldFogActiveBank(localClientNum, 1);
	}
}

/*
	Name: function_ea4a561d
	Namespace: namespace_27f8b154
	Checksum: 0xA444230F
	Offset: 0xB90
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_ea4a561d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("disconnect");
	if(IsSpectating(localClientNum))
	{
		return;
	}
	self thread postfx::playPostfxBundle("pstfx_ring_loop");
	wait(1.5);
	self postfx::exitPostfxBundle();
}

/*
	Name: function_bea149a5
	Namespace: namespace_27f8b154
	Checksum: 0xEA21B61B
	Offset: 0xC38
	Size: 0x2D3
	Parameters: 7
	Flags: None
*/
function function_bea149a5(localClientNum, var_afc7cc94, var_b05b3457, b_on, n_alpha, var_abf03d83, var_c0ce8db2)
{
	if(!isdefined(n_alpha))
	{
		n_alpha = 1;
	}
	if(!isdefined(var_abf03d83))
	{
		var_abf03d83 = 0;
	}
	if(!isdefined(var_c0ce8db2))
	{
		var_c0ce8db2 = 0;
	}
	self endon("entityshutdown");
	if(self.b_on === b_on)
	{
		return;
	}
	else
	{
		self.b_on = b_on;
	}
	if(var_abf03d83)
	{
		if(b_on)
		{
			self transition_shader(localClientNum, n_alpha, var_afc7cc94);
		}
		else
		{
			self transition_shader(localClientNum, 0, var_afc7cc94);
		}
		return;
	}
	if(b_on)
	{
		var_24fbb6c6 = 0;
		i = 0;
		while(var_24fbb6c6 <= n_alpha)
		{
			self transition_shader(localClientNum, var_24fbb6c6, var_afc7cc94);
			if(var_c0ce8db2)
			{
				var_24fbb6c6 = sqrt(i);
			}
			else
			{
				var_24fbb6c6 = i;
			}
			wait(0.01);
			i = i + var_b05b3457;
		}
		self.var_bbfa5d7d = n_alpha;
		self transition_shader(localClientNum, n_alpha, var_afc7cc94);
	}
	else if(isdefined(self.var_bbfa5d7d))
	{
		var_bbfa5d7d = self.var_bbfa5d7d;
	}
	else
	{
		var_bbfa5d7d = 1;
	}
	var_24fbb6c6 = var_bbfa5d7d;
	i = var_bbfa5d7d;
	while(var_24fbb6c6 >= 0)
	{
		self transition_shader(localClientNum, var_24fbb6c6, var_afc7cc94);
		if(var_c0ce8db2)
		{
			var_24fbb6c6 = sqrt(i);
		}
		else
		{
			var_24fbb6c6 = i;
		}
		wait(0.01);
		i = i - var_b05b3457;
	}
	self transition_shader(localClientNum, 0, var_afc7cc94);
}

/*
	Name: transition_shader
	Namespace: namespace_27f8b154
	Checksum: 0x2589E5E
	Offset: 0xF18
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function transition_shader(localClientNum, n_value, var_afc7cc94)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector" + var_afc7cc94, n_value, n_value, 0, 0);
}

/*
	Name: function_4ff90290
	Namespace: namespace_27f8b154
	Checksum: 0xD6855BC2
	Offset: 0xF78
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_4ff90290(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector0", newVal, 0, 0, 0);
}

/*
	Name: function_50dc34c6
	Namespace: namespace_27f8b154
	Checksum: 0x7168E1F
	Offset: 0xFE8
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_50dc34c6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_f2efc20a = 0;
	if(newVal <= 0)
	{
		var_f2efc20a = 0;
		var_32ee3d8b = newVal;
	}
	else
	{
		var_f2efc20a = 1;
		var_32ee3d8b = newVal;
	}
	self thread function_bea149a5(localClientNum, 0, 0.025, var_f2efc20a, var_32ee3d8b);
}

/*
	Name: function_adde492f
	Namespace: namespace_27f8b154
	Checksum: 0x735967E2
	Offset: 0x10A8
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_adde492f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self))
	{
		PlayFXOnTag(localClientNum, level._effect["spider_web_grenade_stuck"], self, "tag_origin");
	}
}

/*
	Name: function_bcbf0bf6
	Namespace: namespace_27f8b154
	Checksum: 0xEDEEA937
	Offset: 0x1128
	Size: 0x223
	Parameters: 7
	Flags: None
*/
function function_bcbf0bf6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 0:
		{
			if(isdefined(self) && isdefined(self.var_d5eda36c))
			{
				stopfx(localClientNum, self.var_d5eda36c);
				self.var_d5eda36c = undefined;
			}
			if(isdefined(self) && isdefined(self.var_cac11e11))
			{
				self StopLoopSound(self.var_cac11e11, 0.5);
				self playsound(0, "zmb_spider_web_tear_stop");
				self.var_cac11e11 = undefined;
			}
			return;
		}
		case 1:
		{
			str_effect = "spider_web_bgb_tear";
			break;
		}
		case 2:
		{
			str_effect = "spider_web_perk_machine_tear";
			break;
		}
		case 3:
		{
			str_effect = "spider_web_doorbuy_tear";
			break;
		}
		case default:
		{
			return;
		}
	}
	if(!isdefined(self.var_cac11e11))
	{
		self.var_cac11e11 = self PlayLoopSound("zmb_spider_web_tear_loop", 1);
		self playsound(0, "zmb_spider_web_tear_start");
	}
	if(!isdefined(self.var_d5eda36c))
	{
		self.var_d5eda36c = playFX(localClientNum, level._effect[str_effect], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
	}
}

/*
	Name: function_25ccb29e
	Namespace: namespace_27f8b154
	Checksum: 0xBE7A484F
	Offset: 0x1358
	Size: 0x11B
	Parameters: 7
	Flags: None
*/
function function_25ccb29e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			str_effect = "spider_web_bgb_tear_complete";
			break;
		}
		case 2:
		{
			str_effect = "spider_web_perk_machine_tear_complete";
			break;
		}
		case 3:
		{
			str_effect = "spider_web_doorbuy_tear_complete";
			break;
		}
		case 4:
		{
			str_effect = "spider_web_tear_explosive";
			break;
		}
		case default:
		{
			return;
		}
	}
	playFX(localClientNum, level._effect[str_effect], self.origin, AnglesToForward(self.angles), anglesToUp(self.angles));
}

