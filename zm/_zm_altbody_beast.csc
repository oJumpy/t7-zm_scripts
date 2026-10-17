#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\grapple;
#using scripts\zm\_util;
#using scripts\zm\_zm_altbody;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace namespace_215602b6;

/*
	Name: __init__sytem__
	Namespace: namespace_215602b6
	Checksum: 0x2911AC80
	Offset: 0xA88
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_altbody_beast", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_215602b6
	Checksum: 0x21EAAE4
	Offset: 0xAC8
	Size: 0x41D
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!isdefined(level.var_767d230))
	{
		level.var_767d230 = [];
	}
	clientfield::register("missile", "bminteract", 1, 2, "int", &bminteract_changed, 0, 0);
	clientfield::register("scriptmover", "bminteract", 1, 2, "int", &bminteract_changed, 0, 0);
	clientfield::register("actor", "bm_zombie_melee_kill", 1, 1, "int", &function_b2532c75, 0, 0);
	clientfield::register("actor", "bm_zombie_grapple_kill", 1, 1, "int", &function_46405286, 0, 0);
	clientfield::register("toplayer", "beast_blood_on_player", 1, 1, "counter", &function_70f7f4d2, 0, 0);
	clientfield::register("world", "bm_superbeast", 1, 1, "int", undefined, 0, 0);
	function_10dcd1d5("beast_mode_kiosk");
	duplicate_render::set_dr_filter_offscreen("bmint", 35, "bminteract,bmplayer", undefined, 2, "mc/hud_keyline_beastmode", 0);
	zm_altbody::init("beast_mode", "beast_mode_kiosk", &"ZM_ZOD_ENTER_BEAST_MODE", "zombie_beast_2", 123, &player_enter_beastmode, &function_b2631b3c, &function_df3032fc, &function_da014198);
	callback::on_localclient_connect(&player_on_connect);
	callback::on_spawned(&player_on_spawned);
	level._effect["beast_kiosk_fx_reset"] = "zombie/fx_bmode_kiosk_fire_reset_zod_zmb";
	level._effect["beast_kiosk_fx_enabled"] = "zombie/fx_bmode_kiosk_fire_zod_zmb";
	level._effect["beast_kiosk_fx_disabled"] = "zombie/fx_bmode_kiosk_idle_zod_zmb";
	level._effect["beast_kiosk_fx_cursed"] = "zombie/fx_bmode_kiosk_fire_tainted_zod_zmb";
	level._effect["beast_kiosk_fx_super"] = "zombie/fx_ritual_pap_basin_fire_lg_zod_zmb";
	level._effect["beast_fork"] = "zombie/fx_bmode_tent_fork_zod_zmb";
	level._effect["beast_fork_1"] = "zombie/fx_bmode_tent_charging1_zod_zmb";
	level._effect["beast_fork_2"] = "zombie/fx_bmode_tent_charging2_zod_zmb";
	level._effect["beast_fork_3"] = "zombie/fx_bmode_tent_charging3_zod_zmb";
	level._effect["beast_3p_trail"] = "zombie/fx_bmode_trail_3p_zod_zmb";
	level._effect["beast_1p_light"] = "zombie/fx_bmode_tent_light_zod_zmb";
	level._effect["beast_melee_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_grapple_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
}

/*
	Name: player_on_connect
	Namespace: namespace_215602b6
	Checksum: 0x8323681C
	Offset: 0xEF0
	Size: 0x2D
	Parameters: 1
	Flags: None
*/
function player_on_connect(localClientNum)
{
	if(!isdefined(level.var_767d230[localClientNum]))
	{
		level.var_767d230[localClientNum] = [];
	}
}

/*
	Name: player_on_spawned
	Namespace: namespace_215602b6
	Checksum: 0xE77C623F
	Offset: 0xF28
	Size: 0x13B
	Parameters: 1
	Flags: None
*/
function player_on_spawned(localClientNum)
{
	if(!self isLocalPlayer() || !isdefined(self getlocalclientnumber()) || localClientNum != self getlocalclientnumber())
	{
		return;
	}
	setbeastmodeiconmaterial(localClientNum, 1, "t7_hud_zm_beastmode_meleeattack");
	setbeastmodeiconmaterial(localClientNum, 2, "t7_hud_zm_beastmode_electricityattack");
	setbeastmodeiconmaterial(localClientNum, 3, "t7_hud_zm_beastmode_grapplehook");
	self function_62095f03(localClientNum);
	filter::init_filter_blood_spatter(self);
	self thread player_update_beast_mode_objects(localClientNum, 0);
	self oed_sitrepscan_setradius(1800);
	/#
		self thread function_ac7706bc();
	#/
}

/*
	Name: player_enter_beastmode
	Namespace: namespace_215602b6
	Checksum: 0x76D2D048
	Offset: 0x1070
	Size: 0x2B3
	Parameters: 1
	Flags: None
*/
function player_enter_beastmode(localClientNum)
{
	var_84301bb1 = GetNonPredictedLocalPlayer(localClientNum);
	player = GetLocalPlayer(localClientNum);
	self.beast_mode = 1;
	self thread player_update_beast_mode_objects(localClientNum, !function_faf41e73(localClientNum));
	self thread sndbeastmode(player === var_84301bb1);
	self thread function_2a7bb7b3(localClientNum, 1);
	self thread function_b25c9962(1, "tag_flash", 0.15);
	self thread function_89d6f49a(localClientNum, 1);
	self function_2d565c0(localClientNum, 0);
	function_cce7ef03(localClientNum, 1);
	var_1ee18766 = 0;
	/#
		var_1ee18766 = GetDvarInt("Dev Block strings are not supported") > 0;
		self thread watch_scr_beast_no_visionset(localClientNum);
	#/
	if(IsDemoPlaying())
	{
		self thread function_cb236f81(localClientNum);
	}
	if(!var_1ee18766 && !function_faf41e73(localClientNum) && player === var_84301bb1)
	{
		setpbgactivebank(localClientNum, 2);
		self thread function_56c9cf9d(localClientNum);
		self.var_b65bad1f = PlayFXOnCamera(localClientNum, level._effect["beast_1p_light"]);
	}
	/#
		if(GetDvarInt("Dev Block strings are not supported") > 0)
		{
			self.var_45a700e5 = PlayFXOnTag(localClientNum, level._effect["Dev Block strings are not supported"], self, "Dev Block strings are not supported");
		}
	#/
}

/*
	Name: watch_scr_beast_no_visionset
	Namespace: namespace_215602b6
	Checksum: 0xAF52451D
	Offset: 0x1330
	Size: 0x167
	Parameters: 1
	Flags: None
*/
function watch_scr_beast_no_visionset(localClientNum)
{
	self endon("hash_dd954547");
	was_scr_beast_no_visionset = GetDvarInt("scr_beast_no_visionset") > 0;
	while(isdefined(self))
	{
		var_1ee18766 = GetDvarInt("scr_beast_no_visionset") > 0;
		if(var_1ee18766 != was_scr_beast_no_visionset)
		{
			if(var_1ee18766)
			{
				if(isdefined(self.var_b65bad1f))
				{
					stopfx(localClientNum, self.var_b65bad1f);
					self.var_b65bad1f = undefined;
				}
				setpbgactivebank(localClientNum, 1);
				self thread function_ea06d888(localClientNum);
			}
			else
			{
				setpbgactivebank(localClientNum, 2);
				self thread function_56c9cf9d(localClientNum);
				self.var_b65bad1f = PlayFXOnCamera(localClientNum, level._effect["beast_1p_light"]);
			}
		}
		was_scr_beast_no_visionset = var_1ee18766;
		wait(1);
	}
}

/*
	Name: function_faf41e73
	Namespace: namespace_215602b6
	Checksum: 0xA8290583
	Offset: 0x14A0
	Size: 0x31
	Parameters: 1
	Flags: None
*/
function function_faf41e73(localClientNum)
{
	return IsDemoPlaying() && DemoIsAnyFreeMoveCamera();
}

/*
	Name: function_cb236f81
	Namespace: namespace_215602b6
	Checksum: 0x562F9096
	Offset: 0x14E0
	Size: 0x197
	Parameters: 1
	Flags: None
*/
function function_cb236f81(localClientNum)
{
	self endon("hash_dd954547");
	if(!IsDemoPlaying())
	{
		return;
	}
	var_af2f137b = function_faf41e73(localClientNum);
	while(isdefined(self))
	{
		var_26495de5 = function_faf41e73(localClientNum);
		if(var_26495de5 != var_af2f137b)
		{
			if(var_26495de5)
			{
				if(isdefined(self.var_b65bad1f))
				{
					stopfx(localClientNum, self.var_b65bad1f);
					self.var_b65bad1f = undefined;
				}
				setpbgactivebank(localClientNum, 1);
				self thread function_ea06d888(localClientNum);
			}
			else
			{
				setpbgactivebank(localClientNum, 2);
				self thread function_56c9cf9d(localClientNum);
				self.var_b65bad1f = PlayFXOnCamera(localClientNum, level._effect["beast_1p_light"]);
			}
			self thread player_update_beast_mode_objects(localClientNum, !var_26495de5);
		}
		var_af2f137b = var_26495de5;
		wait(1);
	}
}

/*
	Name: function_56c9cf9d
	Namespace: namespace_215602b6
	Checksum: 0x3E8FC19F
	Offset: 0x1680
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function function_56c9cf9d(localClientNum)
{
	self thread postfx::playPostfxBundle("pstfx_zm_beast_mode_loop");
}

/*
	Name: function_b2631b3c
	Namespace: namespace_215602b6
	Checksum: 0xA4650177
	Offset: 0x16B8
	Size: 0x16F
	Parameters: 1
	Flags: None
*/
function function_b2631b3c(localClientNum)
{
	self notify("hash_dd954547");
	/#
		if(isdefined(self.var_45a700e5))
		{
			stopfx(localClientNum, self.var_45a700e5);
			self.var_45a700e5 = undefined;
		}
	#/
	if(isdefined(self.var_b65bad1f))
	{
		stopfx(localClientNum, self.var_b65bad1f);
		self.var_b65bad1f = undefined;
	}
	function_cce7ef03(localClientNum, 0);
	setpbgactivebank(localClientNum, 1);
	self thread function_89d6f49a(localClientNum, 0);
	self thread function_ea06d888(localClientNum);
	self thread function_b25c9962(0);
	self thread player_update_beast_mode_objects(localClientNum, 0);
	self thread function_2a7bb7b3(localClientNum, 0);
	self thread sndbeastmode(0);
	self oed_sitrepscan_enable(4);
	self.beast_mode = 0;
}

/*
	Name: function_ea06d888
	Namespace: namespace_215602b6
	Checksum: 0x13ADD9EF
	Offset: 0x1830
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_ea06d888(localClientNum)
{
	self thread postfx::exitPostfxBundle();
}

/*
	Name: function_df3032fc
	Namespace: namespace_215602b6
	Checksum: 0x594E1169
	Offset: 0x1860
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_df3032fc(localClientNum)
{
	self.var_45a700e5 = PlayFXOnTag(localClientNum, level._effect["beast_3p_trail"], self, "j_spinelower");
	self thread function_b25c9962(1, "J_Tent_Main_14_RI", 0.05);
}

/*
	Name: function_da014198
	Namespace: namespace_215602b6
	Checksum: 0xAE109876
	Offset: 0x18D8
	Size: 0x55
	Parameters: 1
	Flags: None
*/
function function_da014198(localClientNum)
{
	self thread function_b25c9962(0);
	if(isdefined(self.var_45a700e5))
	{
		stopfx(localClientNum, self.var_45a700e5);
		self.var_45a700e5 = undefined;
	}
}

/*
	Name: get_script_noteworthy_array
	Namespace: namespace_215602b6
	Checksum: 0x1213E76E
	Offset: 0x1938
	Size: 0xFF
	Parameters: 3
	Flags: None
*/
function get_script_noteworthy_array(localClientNum, VAL, key)
{
	all = GetEntArray(localClientNum);
	ret = [];
	foreach(ent in all)
	{
		if(isdefined(ent.script_noteworthy))
		{
			if(ent.script_noteworthy === VAL)
			{
				ret[ret.size] = ent;
			}
		}
	}
	return ret;
}

/*
	Name: function_70f7f4d2
	Namespace: namespace_215602b6
	Checksum: 0xCBD9FF07
	Offset: 0x1A40
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_70f7f4d2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	setsoundcontext("foley", "normal");
	if(newVal == 1)
	{
		self thread function_4685bc0f(localClientNum, 0.1, 3);
	}
}

/*
	Name: function_4685bc0f
	Namespace: namespace_215602b6
	Checksum: 0xB7FF55E9
	Offset: 0x1AD8
	Size: 0xB3
	Parameters: 3
	Flags: None
*/
function function_4685bc0f(localClientNum, time_up, var_72af98b3)
{
	self endon("entityshutdown");
	if(isdefined(self))
	{
		filter::enable_filter_blood_spatter(self, 5);
		self thread function_ef4c8536(localClientNum, time_up, var_72af98b3);
		self util::waittill_any_timeout(time_up + var_72af98b3, "beast_mode_exit", "entityshutdown");
		if(isdefined(self))
		{
			filter::disable_filter_blood_spatter(self, 5);
		}
	}
}

/*
	Name: function_ef4c8536
	Namespace: namespace_215602b6
	Checksum: 0x3574E92
	Offset: 0x1B98
	Size: 0x23B
	Parameters: 3
	Flags: None
*/
function function_ef4c8536(localClientNum, time_up, var_72af98b3)
{
	self notify("hash_ef4c8536");
	self endon("hash_ef4c8536");
	self endon("death");
	self endon("disconnect");
	self endon("entityshutdown");
	if(!isdefined(self.var_90b6339d))
	{
		self.var_90b6339d = 0;
	}
	filter::set_filter_blood_spatter_reveal(self, 5, 0, 0);
	for(t = 0; t <= time_up && isdefined(self);  = 0)
	{
		self.var_90b6339d = max(self.var_90b6339d, t / time_up);
		filter::set_filter_blood_spatter_reveal(self, 5, self.var_90b6339d, 0);
		wait(0.05);
	}
	self.var_90b6339d = 1;
	filter::set_filter_blood_spatter_reveal(self, 5, self.var_90b6339d, 0);
	for(t = 0; t <= var_72af98b3 && isdefined(self);  = 0)
	{
		self.var_90b6339d = min(self.var_90b6339d, 1 - t / var_72af98b3);
		filter::set_filter_blood_spatter_reveal(self, 5, self.var_90b6339d, 0);
		wait(0.05);
	}
	self.var_90b6339d = 0;
	filter::set_filter_blood_spatter_reveal(self, 5, self.var_90b6339d, 0);
}

/*
	Name: function_cce7ef03
	Namespace: namespace_215602b6
	Checksum: 0x96B4F06C
	Offset: 0x1DE0
	Size: 0xDB
	Parameters: 2
	Flags: None
*/
function function_cce7ef03(localClientNum, onOff)
{
	if(GetDvarInt("splitscreen_playerCount") == 2)
	{
		var_b401f607 = GetDvarInt("scr_num_in_beast");
		if(onOff)
		{
			var_b401f607++;
			SetDvar("cg_focalLength", 21);
		}
		else
		{
			var_b401f607--;
			if(var_b401f607 == 0)
			{
				SetDvar("cg_focalLength", 14.64);
			}
		}
		SetDvar("scr_num_in_beast", var_b401f607);
	}
}

/*
	Name: player_update_beast_mode_objects
	Namespace: namespace_215602b6
	Checksum: 0xA0C18453
	Offset: 0x1EC8
	Size: 0x133
	Parameters: 2
	Flags: None
*/
function player_update_beast_mode_objects(localClientNum, onOff)
{
	bmo = get_script_noteworthy_array(localClientNum, "beast_mode", "script_noteworthy");
	Array::run_all(bmo, &entity_set_visible, localClientNum, self, onOff);
	bmho = get_script_noteworthy_array(localClientNum, "not_beast_mode", "script_noteworthy");
	Array::run_all(bmho, &entity_set_visible, localClientNum, self, !onOff);
	wait(0.016);
	clean_deleted(level.var_767d230[localClientNum]);
	Array::run_all(level.var_767d230[localClientNum], &entity_set_bmplayer, localClientNum, onOff);
}

/*
	Name: entity_set_bmplayer
	Namespace: namespace_215602b6
	Checksum: 0x5225610A
	Offset: 0x2008
	Size: 0x16B
	Parameters: 2
	Flags: None
*/
function entity_set_bmplayer(localClientNum, onOff)
{
	if(!isdefined(self.var_2a7bb7b3))
	{
		self.var_2a7bb7b3 = [];
	}
	if(isdefined(self.var_2a7bb7b3[localClientNum]))
	{
		stopfx(localClientNum, self.var_2a7bb7b3[localClientNum]);
		self.var_2a7bb7b3[localClientNum] = undefined;
	}
	if(isdefined(self.model))
	{
		if(onOff)
		{
			FX = function_d9f5b74d(self.model);
		}
		else
		{
			FX = function_f74ecbae(self.model);
		}
		if(isdefined(FX))
		{
			self.var_2a7bb7b3[localClientNum] = PlayFXOnTag(localClientNum, FX, self, "tag_origin");
		}
	}
	if(!IsSplitscreen() && !IsDemoPlaying())
	{
		self duplicate_render::set_dr_flag("bmplayer", onOff);
		self duplicate_render::update_dr_filters(localClientNum);
	}
}

/*
	Name: function_d9f5b74d
	Namespace: namespace_215602b6
	Checksum: 0x726560EE
	Offset: 0x2180
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function function_d9f5b74d(modelName)
{
	switch(modelName)
	{
		case "p7_zm_zod_beast_gargoyle":
		{
			return "zombie/fx_bmode_glow_hook_zod_zmb";
		}
		case "p7_zm_zod_power_box_yellow":
		{
			return "zombie/fx_bmode_glow_pwrbox_zod_zmb";
		}
		case "p7_fxanim_zm_zod_beast_door_mod":
		{
			return "zombie/fx_bmode_glow_door_zod_zmb";
		}
		case "p7_zm_zod_crate_breakable_03":
		{
			return "zombie/fx_bmode_glow_crate_zod_zmb";
		}
		case "p7_fxanim_zm_zod_crate_breakable_03_mod":
		{
			return "zombie/fx_bmode_glow_crate_zod_zmb";
		}
		case "p7_fxanim_zm_zod_crate_breakable_01_mod":
		{
			return "zombie/fx_bmode_glow_crate_tall_zod_zmb";
		}
	}
	return undefined;
}

/*
	Name: function_f74ecbae
	Namespace: namespace_215602b6
	Checksum: 0xFF139AC7
	Offset: 0x2208
	Size: 0x2F
	Parameters: 1
	Flags: None
*/
function function_f74ecbae(modelName)
{
	switch(modelName)
	{
		case "p7_zm_zod_beast_gargoyle":
		{
			return "zombie/fx_bmode_glint_hook_zod_zmb";
		}
	}
	return undefined;
}

/*
	Name: entity_set_visible
	Namespace: namespace_215602b6
	Checksum: 0xA29A5215
	Offset: 0x2240
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function entity_set_visible(localClientNum, player, onOff)
{
	if(onOff)
	{
		self show();
	}
	else
	{
		self Hide();
	}
}

/*
	Name: add_remove_list
	Namespace: namespace_215602b6
	Checksum: 0x59747A3A
	Offset: 0x22A0
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function add_remove_list(a, on_off)
{
	if(!isdefined(a))
	{
		a = [];
	}
	if(on_off)
	{
		if(!IsInArray(a, self))
		{
			ArrayInsert(a, self, a.size);
		}
	}
	else
	{
		ArrayRemoveValue(a, self, 0);
	}
}

/*
	Name: clean_deleted
	Namespace: namespace_215602b6
	Checksum: 0x96643789
	Offset: 0x2330
	Size: 0xE1
	Parameters: 1
	Flags: None
*/
function clean_deleted(Array)
{
	done = 0;
	while(!done && Array.size > 0)
	{
		done = 1;
		foreach(VAL in Array)
		{
			if(!isdefined(VAL))
			{
				ArrayRemoveIndex(Array, key, 0);
				done = 0;
				break;
			}
		}
	}
}

/*
	Name: function_7d675424
	Namespace: namespace_215602b6
	Checksum: 0x69F457D7
	Offset: 0x2420
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function function_7d675424(type)
{
	if(type == 2)
	{
		up = anglesToUp(self.angles);
		FORWARD = AnglesToForward(self.angles);
		location = self.origin + 12 * FORWARD;
		return location;
	}
	return undefined;
}

/*
	Name: bminteract_changed
	Namespace: namespace_215602b6
	Checksum: 0x5BDEDEDC
	Offset: 0x24B8
	Size: 0x22B
	Parameters: 7
	Flags: None
*/
function bminteract_changed(local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	onOff = newVal != 0;
	location = self function_7d675424(newVal);
	if(isdefined(location))
	{
		self setentbeastmodeicontype(newVal, location);
	}
	else
	{
		self setentbeastmodeicontype(newVal);
	}
	self add_remove_list(level.var_767d230[local_client_num], onOff);
	if(!IsSplitscreen())
	{
		self duplicate_render::set_dr_flag("bmplayer", isdefined(GetLocalPlayer(local_client_num).beast_mode) && GetLocalPlayer(local_client_num).beast_mode);
	}
	if(onOff)
	{
		self duplicate_render::set_dr_flag("bminteract", onOff);
		self duplicate_render::update_dr_filters(local_client_num);
	}
	else if(!isdefined(self.var_2a7bb7b3))
	{
		self.var_2a7bb7b3 = [];
	}
	if(isdefined(self.var_2a7bb7b3[local_client_num]))
	{
		stopfx(local_client_num, self.var_2a7bb7b3[local_client_num]);
		self.var_2a7bb7b3[local_client_num] = undefined;
	}
	if(isdefined(self.currentdrfilter))
	{
		self duplicate_render::set_dr_flag("bminteract", onOff);
		self duplicate_render::update_dr_filters(local_client_num);
	}
}

/*
	Name: function_10dcd1d5
	Namespace: namespace_215602b6
	Checksum: 0x3B840A5A
	Offset: 0x26F0
	Size: 0x1D9
	Parameters: 1
	Flags: None
*/
function function_10dcd1d5(kiosk_name)
{
	level.beast_kiosks = struct::get_array(kiosk_name, "targetname");
	level.var_dc56ce87 = [];
	level.var_104eabe = [];
	foreach(kiosk in level.beast_kiosks)
	{
		if(!isdefined(kiosk.State))
		{
			kiosk.State = [];
		}
		if(!isdefined(kiosk.fake_ent))
		{
			kiosk.fake_ent = [];
		}
		kiosk.player_label = kiosk_name + "_plr_" + kiosk.origin;
		kiosk.var_39a60f4a = kiosk_name + "_crs_" + kiosk.origin;
		level.var_dc56ce87[kiosk.player_label] = kiosk;
		level.var_104eabe[kiosk.var_39a60f4a] = kiosk;
		clientfield::register("world", kiosk.player_label, 1, 4, "int", &function_fa828651, 0, 0);
	}
}

/*
	Name: function_62095f03
	Namespace: namespace_215602b6
	Checksum: 0xFF86EFD0
	Offset: 0x28D8
	Size: 0x1A1
	Parameters: 1
	Flags: None
*/
function function_62095f03(localClientNum)
{
	foreach(kiosk in level.beast_kiosks)
	{
		if(!isdefined(kiosk.State))
		{
			kiosk.State = [];
		}
		if(!isdefined(kiosk.fake_ent))
		{
			kiosk.fake_ent = [];
		}
		if(!isdefined(kiosk.fake_ent[localClientNum]))
		{
			kiosk.fake_ent[localClientNum] = util::spawn_model(localClientNum, "tag_origin", kiosk.origin, kiosk.angles);
			if(isdefined(kiosk.State[localClientNum]))
			{
				kiosk.fake_ent[localClientNum] update_kiosk_state(localClientNum, kiosk.State[localClientNum], kiosk.State[localClientNum], 1, 0, kiosk.player_label, 0);
			}
		}
	}
}

/*
	Name: function_fa828651
	Namespace: namespace_215602b6
	Checksum: 0x353B920E
	Offset: 0x2A88
	Size: 0x11B
	Parameters: 7
	Flags: None
*/
function function_fa828651(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	kiosk = level.var_dc56ce87[fieldName];
	if(isdefined(kiosk))
	{
		if(!isdefined(kiosk.State))
		{
			kiosk.State = [];
		}
		if(!isdefined(kiosk.fake_ent))
		{
			kiosk.fake_ent = [];
		}
		kiosk.State[localClientNum] = newVal;
		if(isdefined(kiosk.fake_ent[localClientNum]))
		{
			kiosk.fake_ent[localClientNum] update_kiosk_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
		}
	}
}

/*
	Name: update_kiosk_state
	Namespace: namespace_215602b6
	Checksum: 0x7580E43
	Offset: 0x2BB0
	Size: 0x333
	Parameters: 7
	Flags: None
*/
function update_kiosk_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = GetLocalPlayer(localClientNum);
	n_entnum = player GetEntityNumber();
	if(!isdefined(self.beast_kiosk_fx))
	{
		self.beast_kiosk_fx = [];
	}
	if(!isdefined(self.beast_kiosk_fx[localClientNum]))
	{
		self.beast_kiosk_fx[localClientNum] = [];
	}
	if(newVal & 1 << n_entnum)
	{
		if(isdefined(self.beast_kiosk_fx[localClientNum]["disabled"]))
		{
			stopfx(localClientNum, self.beast_kiosk_fx[localClientNum]["disabled"]);
			self.beast_kiosk_fx[localClientNum]["disabled"] = undefined;
		}
		if(!isdefined(self.beast_kiosk_fx[localClientNum]["enabled"]))
		{
			PlayFXOnTag(localClientNum, level._effect["beast_kiosk_fx_reset"], self, "tag_origin");
			playsound(0, "evt_beastmode_torch_ignite", self.origin);
			if(level clientfield::get("bm_superbeast"))
			{
				self.beast_kiosk_fx[localClientNum]["enabled"] = PlayFXOnTag(localClientNum, level._effect["beast_kiosk_fx_super"], self, "tag_origin");
			}
			else
			{
				self.beast_kiosk_fx[localClientNum]["enabled"] = PlayFXOnTag(localClientNum, level._effect["beast_kiosk_fx_enabled"], self, "tag_origin");
			}
		}
	}
	else if(isdefined(self.beast_kiosk_fx[localClientNum]["enabled"]))
	{
		stopfx(localClientNum, self.beast_kiosk_fx[localClientNum]["enabled"]);
		self.beast_kiosk_fx[localClientNum]["enabled"] = undefined;
	}
	if(!isdefined(self.beast_kiosk_fx[localClientNum]["disabled"]))
	{
		self.beast_kiosk_fx[localClientNum]["disabled"] = PlayFXOnTag(localClientNum, level._effect["beast_kiosk_fx_disabled"], self, "tag_origin");
	}
}

/*
	Name: function_5e873a4e
	Namespace: namespace_215602b6
	Checksum: 0xF71CF6CD
	Offset: 0x2EF0
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_5e873a4e(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	kiosk = level.var_104eabe[fieldName];
	if(isdefined(kiosk))
	{
		kiosk.fake_ent bm_cursed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump);
	}
}

/*
	Name: bm_cursed
	Namespace: namespace_215602b6
	Checksum: 0xBA005EDB
	Offset: 0x2F98
	Size: 0x15B
	Parameters: 7
	Flags: None
*/
function bm_cursed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = GetLocalPlayer(localClientNum);
	if(!isdefined(self.beast_kiosk_fx))
	{
		self.beast_kiosk_fx = [];
	}
	if(!isdefined(self.beast_kiosk_fx[localClientNum]))
	{
		self.beast_kiosk_fx[localClientNum] = [];
	}
	if(newVal)
	{
		if(!isdefined(self.beast_kiosk_fx[localClientNum]["denied"]))
		{
			self.beast_kiosk_fx[localClientNum]["denied"] = PlayFXOnTag(localClientNum, level._effect["beast_kiosk_fx_cursed"], self, "tag_origin");
		}
	}
	else if(isdefined(self.beast_kiosk_fx[localClientNum]["denied"]))
	{
		stopfx(localClientNum, self.beast_kiosk_fx[localClientNum]["denied"]);
	}
}

/*
	Name: sndbeastmode
	Namespace: namespace_215602b6
	Checksum: 0x280E7A3D
	Offset: 0x3100
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function sndbeastmode(activate)
{
	if(activate)
	{
		forceambientroom("zm_zod_beastmode");
		self thread sndbeastmode_manastart();
	}
	else
	{
		forceambientroom("");
		self thread sndbeastmode_manastop();
	}
}

/*
	Name: sndbeastmode_manastart
	Namespace: namespace_215602b6
	Checksum: 0x3C2397F0
	Offset: 0x3188
	Size: 0x117
	Parameters: 0
	Flags: None
*/
function sndbeastmode_manastart()
{
	level endon("sndmanastop");
	self endon("entityshutdown");
	if(!isdefined(level.sndbeastmodeent))
	{
		level.sndbeastmodeent = spawn(0, (0, 0, 0), "script_origin");
		soundId = level.sndbeastmodeent PlayLoopSound("zmb_beastmode_mana_looper", 2);
		setSoundVolume(soundId, 0);
	}
	while(1)
	{
		if(isdefined(self.mana))
		{
			if(self.mana <= 0.5)
			{
				volume = 0.51 - self.mana;
				if(isdefined(soundId))
				{
					setSoundVolume(soundId, volume);
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: sndbeastmode_manastop
	Namespace: namespace_215602b6
	Checksum: 0x12619A13
	Offset: 0x32A8
	Size: 0x45
	Parameters: 0
	Flags: None
*/
function sndbeastmode_manastop()
{
	level notify("sndmanastop");
	if(isdefined(level.sndbeastmodeent))
	{
		level.sndbeastmodeent delete();
		level.sndbeastmodeent = undefined;
	}
}

/*
	Name: function_14637ad2
	Namespace: namespace_215602b6
	Checksum: 0xEB78A48D
	Offset: 0x32F8
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function function_14637ad2(localClientNum)
{
	if(isdefined(self.var_a4e22c06))
	{
		stopfx(localClientNum, self.var_a4e22c06);
		self.var_a4e22c06 = undefined;
	}
}

/*
	Name: function_2a7bb7b3
	Namespace: namespace_215602b6
	Checksum: 0xBDD54BDC
	Offset: 0x3340
	Size: 0x1F7
	Parameters: 2
	Flags: None
*/
function function_2a7bb7b3(localClientNum, on_off)
{
	self notify("hash_2a7bb7b3");
	self endon("hash_2a7bb7b3");
	function_14637ad2(localClientNum);
	if(on_off)
	{
		while(isdefined(self))
		{
			level waittill("Notetrack", lcn, note);
			if(note == "shock_loop")
			{
				function_14637ad2(localClientNum);
				charge = getweaponchargelevel(localClientNum);
				switch(charge)
				{
					case 2:
					{
						self.var_a4e22c06 = PlayViewmodelFX(localClientNum, level._effect["beast_fork_2"], "tag_flash_le");
						break;
					}
					case 3:
					{
						self.var_a4e22c06 = PlayViewmodelFX(localClientNum, level._effect["beast_fork_3"], "tag_flash_le");
						break;
					}
					case 1:
					case default:
					{
						self.var_a4e22c06 = PlayViewmodelFX(localClientNum, level._effect["beast_fork_1"], "tag_flash_le");
						break;
					}
				}
				self function_2d565c0(localClientNum, charge);
			}
			else if(note == "shock_loop_end")
			{
				function_14637ad2(localClientNum);
			}
		}
	}
}

/*
	Name: function_2d565c0
	Namespace: namespace_215602b6
	Checksum: 0x54DFA2E9
	Offset: 0x3540
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function function_2d565c0(localClientNum, charge)
{
	time = 0.85;
	pmin = 0;
	pmax = 1;
	switch(charge)
	{
		case default:
		{
			time = 2;
			break;
		}
		case 1:
		{
			time = 0.5;
			break;
		}
		case 2:
		{
			time = 0.25;
			break;
		}
		case 3:
		{
			time = 0.15;
			break;
		}
	}
	self thread function_892cc334(localClientNum, time, pmin, pmax, charge);
}

/*
	Name: function_892cc334
	Namespace: namespace_215602b6
	Checksum: 0x76FEC9A1
	Offset: 0x3638
	Size: 0x15F
	Parameters: 5
	Flags: None
*/
function function_892cc334(localClientNum, time, pmin, pmax, charge)
{
	self notify("hash_892cc334");
	self endon("hash_892cc334");
	self endon("hash_dd954547");
	if(!isdefined(self.var_652e98))
	{
		self.var_652e98 = 0;
	}
	while(isdefined(self))
	{
		self.var_652e98 = self.var_652e98 + 0.016;
		if(self.var_652e98 > time)
		{
			self.var_652e98 = self.var_652e98 - time;
		}
		VAL = LerpFloat(pmin, pmax, self.var_652e98 / time);
		self setarmpulseposition(VAL);
		if(charge != getweaponchargelevel(localClientNum))
		{
			self function_2d565c0(localClientNum, getweaponchargelevel(localClientNum));
		}
		wait(0.016);
	}
}

/*
	Name: function_ac7706bc
	Namespace: namespace_215602b6
	Checksum: 0xBB7B6D6B
	Offset: 0x37A0
	Size: 0x2DB
	Parameters: 0
	Flags: None
*/
function function_ac7706bc()
{
	/#
		self notify("hash_ac7706bc");
		self endon("hash_ac7706bc");
		if(!isdefined(self.var_652e98))
		{
			self.var_652e98 = 0;
		}
		while(isdefined(self))
		{
			if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				self notify("hash_892cc334");
				time = GetDvarFloat("Dev Block strings are not supported");
				speed = GetDvarFloat("Dev Block strings are not supported");
				pulse = GetDvarFloat("Dev Block strings are not supported");
				if(time > 0)
				{
					self setarmpulse(time, speed, pulse, "Dev Block strings are not supported");
					wait(time);
				}
				else
				{
					wait(0.016);
				}
			}
			else if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				self notify("hash_892cc334");
				pos = GetDvarFloat("Dev Block strings are not supported");
				self setarmpulseposition(pos);
				wait(0.016);
			}
			else if(GetDvarInt("Dev Block strings are not supported") > 0)
			{
				self notify("hash_892cc334");
				time = GetDvarFloat("Dev Block strings are not supported");
				pmin = GetDvarFloat("Dev Block strings are not supported");
				pmax = GetDvarFloat("Dev Block strings are not supported");
				self.var_652e98 = self.var_652e98 + 0.016;
				if(self.var_652e98 > time)
				{
					self.var_652e98 = self.var_652e98 - time;
				}
				VAL = LerpFloat(pmin, pmax, self.var_652e98 / time);
				self setarmpulseposition(VAL);
				wait(0.016);
			}
			else
			{
				wait(0.016);
			}
		}
	#/
}

/*
	Name: function_55af4b5b
	Namespace: namespace_215602b6
	Checksum: 0xC2CBFF8D
	Offset: 0x3A88
	Size: 0x53
	Parameters: 4
	Flags: None
*/
function function_55af4b5b(player, tag, pivot, delay)
{
	player endon("grapple_done");
	wait(delay);
	thread grapple_beam(player, tag, pivot);
}

/*
	Name: grapple_beam
	Namespace: namespace_215602b6
	Checksum: 0xF46C7C5B
	Offset: 0x3AE8
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function grapple_beam(player, tag, pivot)
{
	level beam::launch(player, tag, pivot, "tag_origin", "zod_beast_grapple_beam");
	player waittill("grapple_done");
	level beam::kill(player, tag, pivot, "tag_origin", "zod_beast_grapple_beam");
}

/*
	Name: function_b25c9962
	Namespace: namespace_215602b6
	Checksum: 0x1062B659
	Offset: 0x3B80
	Size: 0x199
	Parameters: 3
	Flags: None
*/
function function_b25c9962(onOff, tag, delay)
{
	if(!isdefined(tag))
	{
		tag = "tag_flash";
	}
	if(!isdefined(delay))
	{
		delay = 0.15;
	}
	self notify("grapple_done");
	self notify("hash_b25c9962");
	self endon("hash_b25c9962");
	if(onOff)
	{
		while(isdefined(self))
		{
			self waittill("grapple_beam_on", pivot);
			ptag = tag;
			/#
				if(GetDvarInt("Dev Block strings are not supported") > 0)
				{
					ptag = "Dev Block strings are not supported";
				}
			#/
			if(isdefined(pivot) && !pivot isPlayer())
			{
				thread function_55af4b5b(self, ptag, pivot, delay);
			}
			evt = self util::waittill_any_ex(7.5, "grapple_pulled", "grapple_landed", "grapple_cancel", "grapple_beam_off", "grapple_watch", "disconnect");
			self notify("grapple_done");
		}
	}
}

/*
	Name: function_4778b020
	Namespace: namespace_215602b6
	Checksum: 0x4780DD3A
	Offset: 0x3D28
	Size: 0x95
	Parameters: 2
	Flags: None
*/
function function_4778b020(lo, Hi)
{
	color = (RandomFloatRange(lo[0], Hi[0]), RandomFloatRange(lo[1], Hi[1]), RandomFloatRange(lo[2], Hi[2]));
	return color;
}

/*
	Name: function_4b2bbece
	Namespace: namespace_215602b6
	Checksum: 0x3CFEDAC2
	Offset: 0x3DC8
	Size: 0xA9
	Parameters: 3
	Flags: None
*/
function function_4b2bbece(cfrom, cto, frac)
{
	frac0 = 1 - frac;
	color = (frac0 * cfrom[0] + frac * cto[0], frac0 * cfrom[1] + frac * cto[1], frac0 * cfrom[2] + frac * cto[2]);
	return color;
}

/*
	Name: function_89d6f49a
	Namespace: namespace_215602b6
	Checksum: 0xEE1F3FD6
	Offset: 0x3E80
	Size: 0x1E1
	Parameters: 2
	Flags: None
*/
function function_89d6f49a(localClientNum, onOff)
{
	self notify("hash_89d6f49a");
	self endon("hash_89d6f49a");
	if(!onOff)
	{
		self SetControllerLightbarColor(localClientNum);
		self.controllerColor = undefined;
		return;
	}
	if(IsDemoPlaying())
	{
		return;
	}
	var_781fc232 = (63, 103, 4) / 255;
	var_27745be8 = (105, 148, 24) / 255;
	cycle_period = 2;
	cycle_refresh = 0.25;
	cycle_time = cycle_period;
	old_color = function_4778b020(var_781fc232, var_27745be8);
	new_color = old_color;
	while(isdefined(self))
	{
		if(cycle_time >= cycle_period)
		{
			old_color = new_color;
			new_color = function_4778b020(var_781fc232, var_27745be8);
			cycle_time = 0;
		}
		color = function_4b2bbece(old_color, new_color, cycle_time / cycle_period);
		self SetControllerLightbarColor(localClientNum, color);
		self.controllerColor = color;
		cycle_time = cycle_time + cycle_refresh;
		wait(cycle_refresh);
	}
}

/*
	Name: function_b2532c75
	Namespace: namespace_215602b6
	Checksum: 0x8404D992
	Offset: 0x4070
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_b2532c75(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(util::is_mature() && !util::is_gib_restricted_build())
	{
		PlayFXOnTag(localClientNum, level._effect["beast_melee_kill"], self, "j_spineupper");
	}
}

/*
	Name: function_46405286
	Namespace: namespace_215602b6
	Checksum: 0x2DF04B7A
	Offset: 0x4118
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_46405286(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(util::is_mature() && !util::is_gib_restricted_build())
	{
		PlayFXOnTag(localClientNum, level._effect["beast_grapple_kill"], self, "j_spineupper");
	}
}

