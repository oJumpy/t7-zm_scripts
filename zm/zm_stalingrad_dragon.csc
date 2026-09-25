#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm_utility;

#namespace dragon;

/*
	Name: __init__sytem__
	Namespace: dragon
	Checksum: 0x988819F1
	Offset: 0x950
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("stalingrad_dragon", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: dragon
	Checksum: 0x28899976
	Offset: 0x990
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.var_ef6a691 = 0;
	level.var_a4d6e1f1 = 1;
	level.var_61699bd7[1] = Array("j_overshoulder_ri_anim_wound", "j_shoulder_ri_anim_wound");
	level.var_61699bd7[2] = Array("j_spine_2_anim_wound", "j_spine_3_anim_wound");
	level.var_61699bd7[3] = Array("j_neck_7_anim_wound", "j_neck_6_anim_wound");
	level.var_9d63af9a = [];
}

/*
	Name: init_clientfields
	Namespace: dragon
	Checksum: 0x1DFF18E
	Offset: 0xA50
	Size: 0x3CB
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	clientfield::register("scriptmover", "dragon_body_glow", 12000, 1, "int", &function_d28f5c87, 0, 0);
	clientfield::register("scriptmover", "dragon_notify_bullet_impact", 12000, 1, "int", &function_d6856592, 0, 0);
	clientfield::register("scriptmover", "dragon_wound_glow_on", 12000, 2, "int", &function_cb9fb04a, 0, 0);
	clientfield::register("scriptmover", "dragon_wound_glow_off", 12000, 2, "int", &function_bb6d58d0, 0, 0);
	clientfield::register("scriptmover", "dragon_mouth_fx", 12000, 1, "int", &function_7893300d, 0, 0);
	n_bits = GetMinBitCountForNum(10);
	clientfield::register("scriptmover", "dragon_notetracks", 12000, n_bits, "counter", &function_47d133a9, 0, 0);
	clientfield::register("toplayer", "dragon_fire_burn_tell", 12000, 3, "int", &function_2d57594b, 0, 0);
	clientfield::register("world", "dragon_hazard_fx_anim_init", 12000, 1, "int", &function_b4311e07, 0, 0);
	clientfield::register("world", "dragon_hazard_fountain", 12000, 1, "int", &function_50d62870, 0, 0);
	clientfield::register("world", "dragon_hazard_library", 12000, 1, "counter", &function_6865d0d5, 0, 0);
	clientfield::register("toplayer", "dragon_transportation_exploders", 12000, 1, "int", &function_9a134512, 0, 0);
	clientfield::register("allplayers", "dragon_transport_eject", 12000, 1, "int", &function_9f54e892, 0, 0);
	clientfield::register("world", "dragon_boss_guts", 12000, 2, "int", &function_30d64518, 0, 0);
}

/*
	Name: function_d28f5c87
	Namespace: dragon
	Checksum: 0x60B3DDB5
	Offset: 0xE28
	Size: 0x171
	Parameters: 7
	Flags: None
*/
function function_d28f5c87(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("hash_e77002d1");
	self endon("hash_e77002d1");
	self endon("entityshutdown");
	self thread function_9b0f57cf(localClientNum, newVal);
	if(newVal)
	{
		for(i = 0; i <= 1;  = 0)
		{
			if(!isdefined(self))
			{
				return;
			}
			self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, i, 0, 0);
			wait(0.016);
		}
		break;
	}
	for(i = 1; i > 0;  = 1)
	{
		if(!isdefined(self))
		{
			return;
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, i, 0, 0);
		wait(0.016);
	}
}

/*
	Name: function_9b0f57cf
	Namespace: dragon
	Checksum: 0x4F4A53ED
	Offset: 0xFA8
	Size: 0x129
	Parameters: 2
	Flags: None
*/
function function_9b0f57cf(localClientNum, newVal)
{
	self notify("hash_9b0f57cf");
	self endon("hash_9b0f57cf");
	if(newVal)
	{
		for(i = 0.25; i <= 1;  = 0.25)
		{
			if(!isdefined(self))
			{
				return;
			}
			self MapShaderConstant(localClientNum, 0, "scriptVector6", 0, i, 0, 0);
			wait(0.016);
		}
		break;
	}
	for(i = 1; i > 0.25;  = 1)
	{
		if(!isdefined(self))
		{
			return;
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector6", 0, i, 0, 0);
		wait(0.016);
	}
}

/*
	Name: function_7893300d
	Namespace: dragon
	Checksum: 0x35236F2E
	Offset: 0x10E0
	Size: 0x155
	Parameters: 7
	Flags: None
*/
function function_7893300d(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	if(n_new)
	{
		PlayFXOnTag(n_local_client, level._effect["dragon_tongue"], self, "tag_mouth_floor_fx");
		PlayFXOnTag(n_local_client, level._effect["dragon_mouth"], self, "tag_throat_fx");
		PlayFXOnTag(n_local_client, level._effect["dragon_eye_l"], self, "tag_eye_left_fx");
		PlayFXOnTag(n_local_client, level._effect["dragon_eye_r"], self, "tag_eye_right_fx");
		self.var_6f4c2683 = [];
		self.var_6f4c2683[1] = 0;
		self.var_6f4c2683[2] = 0;
		self.var_6f4c2683[3] = 0;
	}
}

/*
	Name: function_d6856592
	Namespace: dragon
	Checksum: 0xAC1488B9
	Offset: 0x1240
	Size: 0xB1
	Parameters: 7
	Flags: None
*/
function function_d6856592(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(oldVal == 0 && newVal == 1)
	{
		self.notifyOnBulletImpact = 1;
		self thread function_2ce58010(localClientNum);
	}
	else if(oldVal == 1 && newVal == 0)
	{
		self.notifyOnBulletImpact = 0;
		level notify("hash_a35dee4e");
	}
}

/*
	Name: function_2ce58010
	Namespace: dragon
	Checksum: 0xCBD9C71C
	Offset: 0x1300
	Size: 0x19D
	Parameters: 1
	Flags: None
*/
function function_2ce58010(n_local_client)
{
	self endon("entityshutdown");
	level endon("hash_a35dee4e");
	while(1)
	{
		self waittill("damage", e_attacker, v_impact_pos, var_778fe70f, var_77cbbb1b);
		if(level.var_ef6a691 > 0)
		{
			foreach(var_61c194b7 in level.var_61699bd7[level.var_ef6a691])
			{
				if(var_61c194b7 == var_77cbbb1b)
				{
					switch(level.var_ef6a691)
					{
						case 1:
						{
							str_tag = "j_shoulder_ri_wound_fx";
							break;
						}
						case 2:
						{
							str_tag = "j_spine_3_anim_wound_fx";
							break;
						}
						case 3:
						{
							str_tag = "j_neck_6_anim_wound_fx";
							break;
						}
					}
					PlayFXOnTag(n_local_client, level._effect["dragon_wound_hit"], self, str_tag);
				}
			}
		}
	}
}

/*
	Name: function_cb9fb04a
	Namespace: dragon
	Checksum: 0x28A7F27B
	Offset: 0x14A8
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_cb9fb04a(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(oldVal != newVal)
	{
		if(newVal > 0)
		{
			level.var_ef6a691 = newVal;
			self thread function_bd038ea4(localClientNum, level.var_ef6a691, 1);
		}
	}
}

/*
	Name: function_bb6d58d0
	Namespace: dragon
	Checksum: 0xE5929D24
	Offset: 0x1540
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_bb6d58d0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(oldVal != newVal)
	{
		if(newVal > 0)
		{
			self thread function_bd038ea4(localClientNum, newVal, 0);
		}
	}
}

/*
	Name: function_bd038ea4
	Namespace: dragon
	Checksum: 0xF12EED22
	Offset: 0x15C0
	Size: 0x33B
	Parameters: 3
	Flags: None
*/
function function_bd038ea4(n_local_client, var_2c17cb9d, var_116b515b)
{
	self notify("hash_bd038ea4");
	self endon("hash_bd038ea4");
	self endon("entityshutdown");
	var_4361a688 = undefined;
	switch(var_2c17cb9d)
	{
		case 1:
		{
			var_4361a688 = "scriptVector5";
			break;
		}
		case 2:
		{
			var_4361a688 = "scriptVector4";
			break;
		}
		case 3:
		{
			var_4361a688 = "scriptVector3";
			break;
		}
		case default:
		{
			var_4361a688 = undefined;
			break;
		}
	}
	if(var_116b515b)
	{
		while(1)
		{
			for(i = self.var_6f4c2683[var_2c17cb9d]; i < 1;  = self.var_6f4c2683[var_2c17cb9d])
			{
				if(!isdefined(self))
				{
					return;
				}
				self MapShaderConstant(n_local_client, 0, var_4361a688, 0, i, 0, 0);
				self.var_6f4c2683[var_2c17cb9d] = i;
				wait(0.01);
			}
			for(i = self.var_6f4c2683[var_2c17cb9d]; i > 0.1;  = self.var_6f4c2683[var_2c17cb9d])
			{
				if(!isdefined(self))
				{
					return;
				}
				self MapShaderConstant(n_local_client, 0, var_4361a688, 0, i, 0, 0);
				self.var_6f4c2683[var_2c17cb9d] = i;
				wait(0.01);
			}
		}
	}
	else
	{
		for(i = self.var_6f4c2683[var_2c17cb9d]; i > 0.1;  = self.var_6f4c2683[var_2c17cb9d])
		{
			if(!isdefined(self))
			{
				return;
			}
			self MapShaderConstant(n_local_client, 0, var_4361a688, 0, i, 0, 0);
			self.var_6f4c2683[var_2c17cb9d] = i;
			wait(0.01);
		}
		for(i = 1; i > 0.1;  = 1)
		{
			if(!isdefined(self))
			{
				return;
			}
			self MapShaderConstant(n_local_client, 0, var_4361a688, 0, i, 1, 0);
			self.var_6f4c2683[var_2c17cb9d] = i;
			wait(0.01);
		}
		self MapShaderConstant(n_local_client, 0, var_4361a688, 0, 0.1, 1, 0);
	}
}

/*
	Name: function_47d133a9
	Namespace: dragon
	Checksum: 0x9673C58B
	Offset: 0x1908
	Size: 0x3ED
	Parameters: 7
	Flags: None
*/
function function_47d133a9(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	if(n_new)
	{
		switch(n_new)
		{
			case 1:
			{
				v_tag_origin = self GetTagOrigin("tag_body_anim");
				PlayRumbleOnPosition(n_local_client, "zm_stalingrad_dragon_transport_arrival", v_tag_origin);
				playsound(n_local_client, "zmb_dragon_land_far", v_tag_origin);
				break;
			}
			case 2:
			{
				v_tag_origin = self GetTagOrigin("j_wrist_le_anim");
				PlayRumbleOnPosition(n_local_client, "zm_stalingrad_dragon_steps", v_tag_origin);
				playsound(n_local_client, "zmb_dragon_trans_step_arm", v_tag_origin);
				break;
			}
			case 3:
			{
				v_tag_origin = self GetTagOrigin("j_wrist_ri_anim");
				PlayRumbleOnPosition(n_local_client, "zm_stalingrad_dragon_steps", v_tag_origin);
				playsound(n_local_client, "zmb_dragon_trans_step_arm", v_tag_origin);
				break;
			}
			case 4:
			{
				v_tag_origin = self GetTagOrigin("j_ankle_1_le_anim");
				PlayRumbleOnPosition(n_local_client, "zm_stalingrad_dragon_steps", v_tag_origin);
				playsound(n_local_client, "zmb_dragon_trans_step_foot", v_tag_origin);
				break;
			}
			case 5:
			{
				v_tag_origin = self GetTagOrigin("j_ankle_1_ri_anim");
				PlayRumbleOnPosition(n_local_client, "zm_stalingrad_dragon_steps", v_tag_origin);
				playsound(n_local_client, "zmb_dragon_trans_step_foot", v_tag_origin);
				break;
			}
			case 6:
			case 9:
			{
				v_tag_origin = self GetTagOrigin("tag_body_anim");
				PlayRumbleOnPosition(n_local_client, "zm_stalingrad_dragon_big_wingflap", v_tag_origin);
				playsound(n_local_client, "zmb_dragon_wing_flap_far", v_tag_origin);
				break;
			}
			case 7:
			case 8:
			{
				v_tag_origin = self GetTagOrigin("tag_body_anim");
				PlayRumbleOnPosition(n_local_client, "zm_stalingrad_dragon_sml_wingflap", v_tag_origin);
				playsound(n_local_client, "zmb_dragon_wing_flap_far_qt", v_tag_origin);
				break;
			}
			case 10:
			{
				v_tag_origin = self GetTagOrigin("j_jaw_anim");
				PlayRumbleOnPosition(n_local_client, "artillery_rumble", v_tag_origin);
				playsound(n_local_client, "evt_dragon_pain_dragon_ride", v_tag_origin);
				break;
			}
		}
	}
}

/*
	Name: function_2d57594b
	Namespace: dragon
	Checksum: 0x3AF728C8
	Offset: 0x1D00
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function function_2d57594b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(level.var_9d63af9a[localClientNum]))
		{
			deletefx(localClientNum, level.var_9d63af9a[localClientNum], 1);
		}
		level.var_9d63af9a[localClientNum] = PlayFXOnTag(localClientNum, level._effect["dragon_fire_burn_tell"], self, "tag_origin");
		self thread postfx::playPostfxBundle("pstfx_arrow_rune");
	}
	else if(isdefined(level.var_9d63af9a[localClientNum]))
	{
		stopfx(localClientNum, level.var_9d63af9a[localClientNum]);
	}
	self thread postfx::exitPostfxBundle();
}

/*
	Name: function_b4311e07
	Namespace: dragon
	Checksum: 0xC3EC6ED0
	Offset: 0x1E30
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_b4311e07(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		var_c2e32e84 = GetEnt(localClientNum, "dh_fountain_banner_01", "targetname");
		var_34ea9dbf = GetEnt(localClientNum, "dh_fountain_banner_02", "targetname");
		level thread scene::init("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_01_idle_bundle", var_c2e32e84);
		level thread scene::init("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_02_idle_bundle", var_34ea9dbf);
	}
}

/*
	Name: function_50d62870
	Namespace: dragon
	Checksum: 0x898DD5E1
	Offset: 0x1F28
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_50d62870(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level thread function_fa043827(localClientNum);
		level thread function_87fcc8ec(localClientNum);
	}
}

/*
	Name: function_fa043827
	Namespace: dragon
	Checksum: 0xA9D71553
	Offset: 0x1FA8
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_fa043827(localClientNum)
{
	var_c2e32e84 = GetEnt(localClientNum, "dh_fountain_banner_01", "targetname");
	level scene::stop("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_01_idle_bundle");
	level thread scene::Play("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_01_gusty_bundle", var_c2e32e84);
	wait(13.63);
	level scene::stop("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_01_gusty_bundle");
	level scene::init("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_01_idle_bundle", var_c2e32e84);
}

/*
	Name: function_87fcc8ec
	Namespace: dragon
	Checksum: 0xAB5DA6F2
	Offset: 0x2078
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_87fcc8ec(localClientNum)
{
	var_34ea9dbf = GetEnt(localClientNum, "dh_fountain_banner_02", "targetname");
	level scene::stop("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_02_idle_bundle");
	level thread scene::Play("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_02_gusty_bundle", var_34ea9dbf);
	wait(13.63);
	level scene::stop("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_02_gusty_bundle");
	level scene::init("p7_fxanim_zm_stal_dragon_hazard_fountain_banner_02_idle_bundle", var_34ea9dbf);
}

/*
	Name: function_6865d0d5
	Namespace: dragon
	Checksum: 0xA9A3EA0C
	Offset: 0x2148
	Size: 0x159
	Parameters: 7
	Flags: None
*/
function function_6865d0d5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(level.var_a4d6e1f1) && level.var_a4d6e1f1)
		{
			level.var_a4d6e1f1 = undefined;
			level scene::add_scene_func("p7_fxanim_zm_stal_dragon_hazard_library_banner_01_bundle", &function_ae0e995e, "play");
		}
		var_f8efe776 = GetEntArray(localClientNum, "library_banner_01", "targetname");
		foreach(var_f558224f in var_f8efe776)
		{
			var_f558224f thread scene::Play("p7_fxanim_zm_stal_dragon_hazard_library_banner_01_bundle", var_f558224f);
		}
	}
}

/*
	Name: function_ae0e995e
	Namespace: dragon
	Checksum: 0xD4A3669F
	Offset: 0x22B0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_ae0e995e(a_ents)
{
	wait(8);
	a_ents["library_banner_01"] scene::init("p7_fxanim_zm_stal_dragon_hazard_library_banner_01_bundle", a_ents);
}

/*
	Name: function_9a134512
	Namespace: dragon
	Checksum: 0x2176542B
	Offset: 0x22F8
	Size: 0xC3
	Parameters: 7
	Flags: None
*/
function function_9a134512(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		PlayRadiantExploder(localClientNum, "dragon_transportation");
		StopRadiantExploder(localClientNum, "dragon_flight");
	}
	else
	{
		StopRadiantExploder(localClientNum, "dragon_transportation");
		PlayRadiantExploder(localClientNum, "dragon_flight");
	}
}

/*
	Name: function_9f54e892
	Namespace: dragon
	Checksum: 0xEF11D185
	Offset: 0x23C8
	Size: 0x153
	Parameters: 7
	Flags: None
*/
function function_9f54e892(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["transport_eject"], self.origin);
		player = GetLocalPlayer(localClientNum);
		if(self == player)
		{
			EnableSpeedBlur(localClientNum, 0.15, 0.3, 1, 0, 1, 1);
			self PlayRumbleLoopOnEntity(localClientNum, "zm_stalingrad_dragon_eject_wind");
		}
	}
	else
	{
		player = GetLocalPlayer(localClientNum);
		if(self == player)
		{
			DisableSpeedBlur(localClientNum);
			self StopRumble(localClientNum, "zm_stalingrad_dragon_eject_wind");
		}
	}
}

/*
	Name: function_30d64518
	Namespace: dragon
	Checksum: 0x27EFFD77
	Offset: 0x2528
	Size: 0x10D
	Parameters: 7
	Flags: None
*/
function function_30d64518(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			ForceStreamXModel("p7_fxanim_zm_stal_dragon_chunks_mod");
			ForceStreamXModel("p7_fxanim_zm_stal_dragon_chunks_guts_smod");
			ForceStreamXModel("p7_fxanim_zm_stal_dragon_chunks_head_smod");
			ForceStreamXModel("p7_fxanim_zm_stal_dragon_chunks_wing_l_upper_smod");
			ForceStreamXModel("p7_fxanim_zm_stal_dragon_chunks_wing_r_upper_smod");
			ForceStreamXModel("p7_fxanim_zm_stal_dragon_chunks_wing_r_lower_smod");
			break;
		}
		case 2:
		{
			level thread scene::Play("p7_fxanim_zm_stal_dragon_chunks_guts_bundle");
			break;
		}
	}
}

