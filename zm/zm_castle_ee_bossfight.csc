#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_b1bc995c;

/*
	Name: __init__sytem__
	Namespace: namespace_b1bc995c
	Checksum: 0xF14FC4F9
	Offset: 0xC88
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_ee_bossfight", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_b1bc995c
	Checksum: 0x95C85F9A
	Offset: 0xCC8
	Size: 0x82B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "player_snow_fx_off", 5000, 1, "counter", &function_45f17e5b, 0, 0);
	clientfield::register("actor", "boss_skeleton_eye_glow_fx_change", 5000, 1, "counter", &function_6bb3bdae, 0, 0);
	level._effect["boss_skeleton_eye_glow"] = "dlc1/castle/fx_glow_eye_orange_skeleton";
	clientfield::register("scriptmover", "boss_mpd_fx", 5000, 1, "int", &function_3847c737, 0, 0);
	level._effect["boss_mpd_mist"] = "dlc1/castle/fx_ee_keeper_small_mist_trail";
	level._effect["boss_mpd_mouth"] = "dlc1/castle/fx_ee_keeper_small_mouth_glow";
	clientfield::register("scriptmover", "boss_fx", 5000, 1, "int", &function_646d48a7, 0, 0);
	clientfield::register("scriptmover", "boss_weak_point_shader", 5000, 1, "int", &function_842bfcca, 0, 0);
	clientfield::register("actor", "boss_zombie_rise_fx", 1, 1, "int", &function_c5c4e352, 1, 1);
	level._effect["boss_mist"] = "dlc1/castle/fx_ee_keeper_mist_trail";
	level._effect["boss_mouth"] = "dlc1/castle/fx_ee_keeper_mouth_glow";
	level._effect["boss_rise_burst"] = "dlc1/castle/fx_ee_keeper_hand_burst_zmb";
	level._effect["boss_rise_billow"] = "dlc1/castle/fx_ee_keeper_body_billowing_zmb";
	clientfield::register("scriptmover", "boss_teleport_fx", 5000, 1, "counter", &function_b87abae5, 0, 0);
	level._effect["boss_teleport"] = "dlc1/castle/fx_ee_keeper_teleport";
	clientfield::register("scriptmover", "boss_elemental_storm_cast_fx", 5000, 1, "int", &function_8773a235, 0, 0);
	clientfield::register("scriptmover", "boss_elemental_storm_explode_fx", 5000, 1, "int", &function_22e3090d, 0, 0);
	clientfield::register("scriptmover", "boss_elemental_storm_stunned_keeper_fx", 5000, 1, "int", &function_c8f3c754, 0, 0);
	clientfield::register("scriptmover", "boss_elemental_storm_stunned_spikes_fx", 5000, 1, "int", &function_cffccd99, 0, 0);
	level._effect["boss_elemental_storm_cast"] = "dlc1/castle/fx_ee_keeper_storm_tell";
	level._effect["boss_elemental_storm_explode_loop"] = "dlc1/zmb_weapon/fx_bow_storm_funnel_loop_zmb";
	level._effect["boss_elemental_storm_explode_end"] = "dlc1/zmb_weapon/fx_bow_storm_funnel_end_zmb";
	level._effect["boss_elemental_storm_stunned_spikes"] = "dlc1/castle/fx_ee_keeper_beam_stunned_src";
	level._effect["boss_elemental_storm_stunned_keeper"] = "dlc1/castle/fx_ee_keeper_beam_stunned_tgt";
	clientfield::register("scriptmover", "boss_demongate_cast_fx", 5000, 1, "int", &function_f53d6e40, 0, 0);
	clientfield::register("scriptmover", "boss_demongate_chomper_fx", 5000, 1, "int", &function_4004ceb1, 0, 0);
	clientfield::register("scriptmover", "boss_demongate_chomper_bite_fx", 5000, 1, "counter", &function_7f03b7a2, 0, 0);
	level._effect["boss_demongate_portal_open"] = "dlc1/castle/fx_ee_keeper_demongate_portal_open";
	level._effect["boss_demongate_portal_loop"] = "dlc1/castle/fx_ee_keeper_demongate_portal_loop";
	level._effect["boss_demongate_portal_close"] = "dlc1/castle/fx_ee_keeper_demongate_portal_close";
	level._effect["boss_demongate_chomper_trail"] = "dlc1/castle/fx_ee_keeper_demonhead_trail";
	level._effect["boss_demongate_chomper_bite"] = "dlc1/castle/fx_ee_keeper_demonhead_despawn";
	level._effect["boss_demongate_chomper_despawn"] = "dlc1/castle/fx_ee_keeper_demonhead_despawn";
	clientfield::register("scriptmover", "boss_rune_prison_erupt_fx", 5000, 1, "int", &function_78f6d6a3, 0, 0);
	clientfield::register("scriptmover", "boss_rune_prison_rock_fx", 5000, 1, "int", &function_c5202764, 0, 0);
	clientfield::register("scriptmover", "boss_rune_prison_explode_fx", 5000, 1, "int", &function_5cf0ffb0, 0, 0);
	clientfield::register("allplayers", "boss_rune_prison_dot_fx", 5000, 1, "int", &function_8c589c72, 0, 0);
	clientfield::register("world", "sndBossBattle", 5000, 1, "int", &function_c5548517, 0, 0);
	level._effect["boss_rune_prison_erupt"] = "dlc1/castle/fx_ee_keeper_runeprison_glow";
	level._effect["boss_rune_prison_explode"] = "dlc1/castle/fx_ee_keeper_runeprison_fire";
	level._effect["boss_rune_prison_dot"] = "dlc1/zmb_weapon/fx_bow_rune_fire_torso_zmb";
	clientfield::register("world", "boss_wolf_howl_fx_change", 5000, 1, "int", &function_a20d2e82, 0, 0);
	clientfield::register("world", "boss_gravity_spike_fx_change", 5000, 1, "int", &function_c1ed35c2, 0, 0);
}

/*
	Name: function_45f17e5b
	Namespace: namespace_b1bc995c
	Checksum: 0xE341DF9D
	Offset: 0x1500
	Size: 0x7F
	Parameters: 7
	Flags: None
*/
function function_45f17e5b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(level.var_18402cb[localClientNum]))
	{
		deletefx(localClientNum, level.var_18402cb[localClientNum], 1);
		level.var_18402cb[localClientNum] = undefined;
	}
}

/*
	Name: function_6bb3bdae
	Namespace: namespace_b1bc995c
	Checksum: 0x6CE90DA0
	Offset: 0x1588
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function function_6bb3bdae(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self._eyeglow_fx_override = level._effect["boss_skeleton_eye_glow"];
}

/*
	Name: function_3847c737
	Namespace: namespace_b1bc995c
	Checksum: 0xAA544299
	Offset: 0x15E8
	Size: 0x195
	Parameters: 7
	Flags: None
*/
function function_3847c737(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_3b5b8133 = PlayFXOnTag(localClientNum, level._effect["boss_mpd_mist"], self, "j_spinelower");
		self.var_20e08654 = PlayFXOnTag(localClientNum, level._effect["boss_mpd_mist"], self, "j_robe_front_03");
		self.var_40ad10ca = PlayFXOnTag(localClientNum, level._effect["boss_mpd_mouth"], self, "j_head");
	}
	else if(isdefined(self.var_3b5b8133))
	{
		deletefx(localClientNum, self.var_3b5b8133, 0);
		self.var_3b5b8133 = undefined;
	}
	if(isdefined(self.var_20e08654))
	{
		deletefx(localClientNum, self.var_20e08654, 0);
		self.var_20e08654 = undefined;
	}
	if(isdefined(self.var_40ad10ca))
	{
		deletefx(localClientNum, self.var_40ad10ca, 0);
		self.var_40ad10ca = undefined;
	}
}

/*
	Name: function_646d48a7
	Namespace: namespace_b1bc995c
	Checksum: 0x65DA8121
	Offset: 0x1788
	Size: 0x195
	Parameters: 7
	Flags: None
*/
function function_646d48a7(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_3b5b8133 = PlayFXOnTag(localClientNum, level._effect["boss_mist"], self, "j_spinelower");
		self.var_20e08654 = PlayFXOnTag(localClientNum, level._effect["boss_mist"], self, "j_robe_front_03");
		self.var_40ad10ca = PlayFXOnTag(localClientNum, level._effect["boss_mouth"], self, "j_head");
	}
	else if(isdefined(self.var_3b5b8133))
	{
		deletefx(localClientNum, self.var_3b5b8133, 0);
		self.var_3b5b8133 = undefined;
	}
	if(isdefined(self.var_20e08654))
	{
		deletefx(localClientNum, self.var_20e08654, 0);
		self.var_20e08654 = undefined;
	}
	if(isdefined(self.var_40ad10ca))
	{
		deletefx(localClientNum, self.var_40ad10ca, 0);
		self.var_40ad10ca = undefined;
	}
}

/*
	Name: function_842bfcca
	Namespace: namespace_b1bc995c
	Checksum: 0x19CB9426
	Offset: 0x1928
	Size: 0x103
	Parameters: 7
	Flags: None
*/
function function_842bfcca(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		var_79974a0f = 0;
		if(isdefined(self.sndId))
		{
			self StopLoopSound(self.sndId, 1);
			self.sndId = undefined;
		}
	}
	else
	{
		var_79974a0f = 1;
		if(!isdefined(self.sndId))
		{
			self.sndId = self PlayLoopSound("zmb_keeper_downed_lp", 1);
		}
	}
	self MapShaderConstant(localClientNum, 0, "scriptVector3", 0, var_79974a0f, 0, 0);
}

/*
	Name: function_c5c4e352
	Namespace: namespace_b1bc995c
	Checksum: 0xA895A8D0
	Offset: 0x1A38
	Size: 0x12D
	Parameters: 7
	Flags: None
*/
function function_c5c4e352(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	if(newVal)
	{
		localPlayers = level.localPlayers;
		var_f7130542 = "zmb_zombie_spawn";
		var_7bc37da8 = level._effect["boss_rise_burst"];
		var_ee65ea53 = level._effect["boss_rise_billow"];
		playsound(0, var_f7130542, self.origin);
		for(i = 0; i < localPlayers.size; i++)
		{
			self thread function_200d4bd2(i, var_ee65ea53, var_7bc37da8);
		}
	}
}

/*
	Name: function_200d4bd2
	Namespace: namespace_b1bc995c
	Checksum: 0xCAD8435D
	Offset: 0x1B70
	Size: 0xEB
	Parameters: 3
	Flags: None
*/
function function_200d4bd2(localClientNum, var_ee65ea53, var_7bc37da8)
{
	self endon("entityshutdown");
	level endon("demo_jump");
	playFX(localClientNum, var_7bc37da8, self.origin + (0, 0, randomIntRange(5, 10)));
	wait(0.25);
	playFX(localClientNum, var_ee65ea53, self.origin + (randomIntRange(-10, 10), randomIntRange(-10, 10), randomIntRange(5, 10)));
}

/*
	Name: function_b87abae5
	Namespace: namespace_b1bc995c
	Checksum: 0x3F7DCDFD
	Offset: 0x1C68
	Size: 0xAD
	Parameters: 7
	Flags: None
*/
function function_b87abae5(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self.var_b1fe1ee = PlayFXOnTag(localClientNum, level._effect["boss_teleport"], self, "j_mainroot");
	wait(0.5);
	if(isdefined(self.var_b1fe1ee))
	{
		deletefx(localClientNum, self.var_b1fe1ee, 0);
		self.var_b1fe1ee = undefined;
	}
}

/*
	Name: function_8773a235
	Namespace: namespace_b1bc995c
	Checksum: 0xA9C485A0
	Offset: 0x1D20
	Size: 0xFD
	Parameters: 7
	Flags: None
*/
function function_8773a235(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self playsound(0, "zmb_keeper_storm_cast");
		self function_4278d80d(localClientNum);
	}
	else
	{
		self notify("hash_1c2dfa5e");
		if(isdefined(self.var_b1fe1ee))
		{
			deletefx(localClientNum, self.var_b1fe1ee, 0);
			self.var_b1fe1ee = undefined;
		}
		if(isdefined(self.var_64741ec0))
		{
			self StopLoopSound(self.var_64741ec0, 4);
			self.var_64741ec0 = undefined;
		}
	}
}

/*
	Name: function_4278d80d
	Namespace: namespace_b1bc995c
	Checksum: 0x43B4CD7F
	Offset: 0x1E28
	Size: 0xD7
	Parameters: 1
	Flags: None
*/
function function_4278d80d(localClientNum)
{
	self endon("hash_1c2dfa5e");
	while(isdefined(self))
	{
		if(isdefined(self.var_b1fe1ee))
		{
			deletefx(localClientNum, self.var_b1fe1ee, 0);
			self.var_b1fe1ee = undefined;
		}
		if(!isdefined(self.var_64741ec0))
		{
			self.var_64741ec0 = self PlayLoopSound("zmb_keeper_storm_cast_lp", 0.5);
		}
		self.var_b1fe1ee = PlayFXOnTag(localClientNum, level._effect["boss_elemental_storm_cast"], self, "tag_origin");
		wait(0.5);
	}
}

/*
	Name: function_22e3090d
	Namespace: namespace_b1bc995c
	Checksum: 0x62B08E19
	Offset: 0x1F08
	Size: 0x12B
	Parameters: 7
	Flags: None
*/
function function_22e3090d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(isdefined(self.var_b1fe1ee))
		{
			deletefx(localClientNum, self.var_b1fe1ee, 0);
			self.var_53f7dac0 = undefined;
		}
		self.var_b1fe1ee = PlayFXOnTag(localClientNum, level._effect["boss_elemental_storm_explode_loop"], self, "tag_origin");
	}
	else if(isdefined(self.var_b1fe1ee))
	{
		deletefx(localClientNum, self.var_b1fe1ee, 0);
		self.var_53f7dac0 = undefined;
	}
	wait(0.4);
	self.var_53f7dac0 = PlayFXOnTag(localClientNum, level._effect["boss_elemental_storm_explode_end"], self, "tag_origin");
}

/*
	Name: function_cffccd99
	Namespace: namespace_b1bc995c
	Checksum: 0x2C87F867
	Offset: 0x2040
	Size: 0xB5
	Parameters: 7
	Flags: None
*/
function function_cffccd99(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_ee45d30a = PlayFXOnTag(localClientNum, level._effect["boss_elemental_storm_stunned_spikes"], self, "tag_origin");
	}
	else if(isdefined(self.var_ee45d30a))
	{
		deletefx(localClientNum, self.var_ee45d30a, 0);
		self.var_b1fe1ee = undefined;
	}
}

/*
	Name: function_c8f3c754
	Namespace: namespace_b1bc995c
	Checksum: 0xA8FFB5D8
	Offset: 0x2100
	Size: 0xB5
	Parameters: 7
	Flags: None
*/
function function_c8f3c754(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_ee45d30a = PlayFXOnTag(localClientNum, level._effect["boss_elemental_storm_stunned_keeper"], self, "j_spinelower");
	}
	else if(isdefined(self.var_ee45d30a))
	{
		deletefx(localClientNum, self.var_ee45d30a, 0);
		self.var_b1fe1ee = undefined;
	}
}

/*
	Name: function_f53d6e40
	Namespace: namespace_b1bc995c
	Checksum: 0x9130BDFA
	Offset: 0x21C0
	Size: 0x1A5
	Parameters: 7
	Flags: None
*/
function function_f53d6e40(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_fd0edd83 = PlayFXOnTag(localClientNum, level._effect["boss_demongate_portal_open"], self, "tag_weapon_right");
		self.var_4b6fd850 = self PlayLoopSound("zmb_keeper_demongate_portal_lp", 1);
		wait(0.45);
		self.var_fd0edd83 = PlayFXOnTag(localClientNum, level._effect["boss_demongate_portal_loop"], self, "tag_weapon_right");
	}
	else if(isdefined(self.var_fd0edd83))
	{
		playFX(localClientNum, level._effect["boss_demongate_portal_close"], self.origin, AnglesToForward(self.angles));
	}
	if(isdefined(self.var_4b6fd850))
	{
		self StopLoopSound(self.var_4b6fd850, 1);
		self.var_4b6fd850 = undefined;
	}
	wait(0.45);
	deletefx(localClientNum, self.var_fd0edd83, 0);
	self.var_fd0edd83 = undefined;
}

/*
	Name: function_4004ceb1
	Namespace: namespace_b1bc995c
	Checksum: 0x7447692F
	Offset: 0x2370
	Size: 0x1A3
	Parameters: 7
	Flags: None
*/
function function_4004ceb1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(newVal)
	{
		if(isdefined(self.var_a581816a))
		{
			deletefx(localClientNum, self.var_a581816a, 1);
		}
		self.var_a581816a = PlayFXOnTag(localClientNum, level._effect["boss_demongate_chomper_trail"], self, "tag_fx");
		self.var_965cdbdb = self PlayLoopSound("zmb_keeper_demongate_chomper_lp", 1);
	}
	else if(isdefined(self.var_a581816a))
	{
		deletefx(localClientNum, self.var_a581816a, 0);
		self.var_a581816a = undefined;
	}
	if(isdefined(self.var_965cdbdb))
	{
		self StopLoopSound(self.var_965cdbdb, 0.5);
		self.var_965cdbdb = undefined;
	}
	self playsound(0, "zmb_keeper_demongate_chomper_disappear");
	PlayFXOnTag(localClientNum, level._effect["boss_demongate_chomper_despawn"], self, "tag_fx");
}

/*
	Name: function_7f03b7a2
	Namespace: namespace_b1bc995c
	Checksum: 0x99BF320E
	Offset: 0x2520
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_7f03b7a2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self.var_64b4f506 = playFX(localClientNum, level._effect["boss_demongate_chomper_bite"], self.origin);
	self playsound(0, "zmb_keeper_demongate_chomper_bite");
	wait(0.1);
	stopfx(localClientNum, self.var_64b4f506);
}

/*
	Name: function_78f6d6a3
	Namespace: namespace_b1bc995c
	Checksum: 0x7F38B183
	Offset: 0x25E8
	Size: 0xA5
	Parameters: 7
	Flags: None
*/
function function_78f6d6a3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self thread function_92f90eb7(localClientNum);
	}
	else
	{
		self notify("hash_f40e20dc");
		if(isdefined(self.var_b1fe1ee))
		{
			deletefx(localClientNum, self.var_b1fe1ee, 1);
			self.var_b1fe1ee = undefined;
		}
	}
}

/*
	Name: function_92f90eb7
	Namespace: namespace_b1bc995c
	Checksum: 0x50EC4B39
	Offset: 0x2698
	Size: 0xB7
	Parameters: 1
	Flags: None
*/
function function_92f90eb7(localClientNum)
{
	self endon("hash_f40e20dc");
	self endon("entityshutdown");
	while(1)
	{
		self.var_b1fe1ee = playFX(localClientNum, level._effect["boss_rune_prison_erupt"], self.origin);
		wait(1);
		if(isdefined(self) && isdefined(self.var_b1fe1ee))
		{
			deletefx(localClientNum, self.var_b1fe1ee, 0);
			self.var_b1fe1ee = undefined;
		}
		else if(!isdefined(self))
		{
			return;
		}
	}
}

/*
	Name: function_c5202764
	Namespace: namespace_b1bc995c
	Checksum: 0xAC2BE47C
	Offset: 0x2758
	Size: 0xB5
	Parameters: 7
	Flags: None
*/
function function_c5202764(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 0:
		{
			self scene::Play("p7_fxanim_zm_bow_rune_prison_red_01_bundle");
			self scene::stop(1);
			break;
		}
		case 1:
		{
			self thread scene::init("p7_fxanim_zm_bow_rune_prison_red_01_bundle");
			break;
		}
	}
}

/*
	Name: function_5cf0ffb0
	Namespace: namespace_b1bc995c
	Checksum: 0x71C84A4C
	Offset: 0x2818
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_5cf0ffb0(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["boss_rune_prison_explode"], self.origin, (0, 0, 1), (1, 0, 0));
	}
}

/*
	Name: function_8c589c72
	Namespace: namespace_b1bc995c
	Checksum: 0x6AAFF86F
	Offset: 0x28A0
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_8c589c72(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_1892be10 = PlayFXOnTag(localClientNum, level._effect["boss_rune_prison_dot"], self, "j_spine4");
	}
	else
	{
		deletefx(localClientNum, self.var_1892be10, 0);
	}
}

/*
	Name: function_a20d2e82
	Namespace: namespace_b1bc995c
	Checksum: 0x83DF4EF0
	Offset: 0x2948
	Size: 0x7D
	Parameters: 7
	Flags: None
*/
function function_a20d2e82(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level._effect["dog_trail_fire"] = "dlc1/castle/fx_ee_keeper_dog_fire_trail";
	}
	else
	{
		level._effect["dog_trail_fire"] = "zombie/fx_dog_fire_trail_zmb";
	}
}

/*
	Name: function_c1ed35c2
	Namespace: namespace_b1bc995c
	Checksum: 0x560B04C1
	Offset: 0x29D0
	Size: 0xB5
	Parameters: 7
	Flags: None
*/
function function_c1ed35c2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level._effect["gravityspikes_trap_start"] = "dlc1/castle/fx_ee_keeper_wpn_spike_trap_start";
		level._effect["gravityspikes_trap_loop"] = "dlc1/castle/fx_ee_keeper_wpn_spike_trap_loop";
	}
	else
	{
		level._effect["gravityspikes_trap_start"] = "dlc1/zmb_weapon/fx_wpn_spike_trap_start";
		level._effect["gravityspikes_trap_loop"] = "dlc1/zmb_weapon/fx_wpn_spike_trap_loop";
	}
}

/*
	Name: function_c5548517
	Namespace: namespace_b1bc995c
	Checksum: 0x236F0DD4
	Offset: 0x2A90
	Size: 0xE3
	Parameters: 7
	Flags: None
*/
function function_c5548517(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		level notify("hash_51d7bc7c", "bossbattle");
		audio::snd_set_snapshot("zmb_castle_bossbattle");
		playsound(0, "zmb_keeper_trans_into");
	}
	else
	{
		level notify("hash_51d7bc7c", "crypt");
		audio::snd_set_snapshot("default");
		playsound(0, "zmb_keeper_trans_outof");
	}
}

