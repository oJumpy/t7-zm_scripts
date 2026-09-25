#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_7550a904;

/*
	Name: init
	Namespace: namespace_7550a904
	Checksum: 0xFBBE0173
	Offset: 0x610
	Size: 0x31B
	Parameters: 0
	Flags: None
*/
function init()
{
	clientfield::register("scriptmover", "plant_growth_siege_anims", 9000, 2, "int", &function_4539a4cd, 0, 0);
	clientfield::register("scriptmover", "cache_plant_interact_fx", 9000, 1, "int", &function_d6804e46, 0, 0);
	clientfield::register("scriptmover", "plant_hit_with_ww_fx", 9000, 1, "int", &function_c2c4b7be, 0, 0);
	clientfield::register("scriptmover", "plant_watered_fx", 9000, 1, "int", &function_8fcaa237, 0, 0);
	clientfield::register("scriptmover", "planter_model_watered", 9000, 1, "int", &function_a7073474, 0, 0);
	clientfield::register("scriptmover", "babysitter_plant_fx", 9000, 1, "int", &function_b8cf2db, 0, 0);
	clientfield::register("scriptmover", "trap_plant_fx", 9000, 1, "int", &function_22008d73, 0, 0);
	clientfield::register("toplayer", "player_spawned_from_clone_plant", 9000, 1, "int", &function_316f5fd4, 0, 0);
	clientfield::register("toplayer", "player_cloned_fx", 9000, 1, "int", &function_60a2a795, 0, 0);
	clientfield::register("scriptmover", "zombie_or_grenade_spawned_from_minor_cache_plant", 9000, 2, "int", &function_6acdc163, 0, 0);
	clientfield::register("allplayers", "player_vomit_fx", 9000, 1, "int", &function_f244344b, 0, 0);
}

/*
	Name: function_4539a4cd
	Namespace: namespace_7550a904
	Checksum: 0x6F02F9EB
	Offset: 0x938
	Size: 0x37B
	Parameters: 7
	Flags: None
*/
function function_4539a4cd(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.var_600eec00))
	{
		self.var_600eec00 = util::spawn_model(localClientNum, "p7_fxanim_zm_island_plant_bulb_smod", self.origin, self.angles);
	}
	if(!isdefined(self.var_a32dfd4))
	{
		self.var_a32dfd4 = util::spawn_model(localClientNum, "p7_fxanim_zm_island_plant_roots_smod", self.origin, self.angles);
	}
	if(newVal == 1)
	{
		self endon("hash_336ee8b2");
		self.var_600eec00 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_bulb_grow1_sanim", "unloop");
		self.var_a32dfd4 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_roots_grow1_sanim", "unloop");
		n_wait_time = getanimlength("p7_fxanim_zm_island_plant_bulb_grow1_sanim");
		wait(n_wait_time);
		self.var_600eec00 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_bulb_grow1_idle_sanim", "loop");
		self.var_a32dfd4 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_roots_grow1_idle_sanim", "loop");
	}
	else if(newVal == 2)
	{
		self endon("hash_d6c6e49");
		self notify("hash_336ee8b2");
		self.var_600eec00 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_bulb_grow2_sanim", "unloop");
		self.var_a32dfd4 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_roots_grow2_sanim", "unloop");
		n_wait_time = getanimlength("p7_fxanim_zm_island_plant_bulb_grow2_sanim");
		wait(n_wait_time);
		self.var_600eec00 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_bulb_grow2_idle_sanim", "loop");
		self.var_a32dfd4 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_roots_grow2_idle_sanim", "loop");
	}
	else if(newVal == 3)
	{
		self notify("hash_d6c6e49");
		self.var_600eec00 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_bulb_open_sanim", "unloop");
		self.var_a32dfd4 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_roots_open_sanim", "unloop");
	}
	else
	{
		self.var_600eec00 SiegeCmd("set_anim", "p7_fxanim_zm_island_plant_bulb_dead_sanim", "unloop");
	}
}

/*
	Name: function_d6804e46
	Namespace: namespace_7550a904
	Checksum: 0x31E7E1D
	Offset: 0xCC0
	Size: 0xBB
	Parameters: 7
	Flags: None
*/
function function_d6804e46(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx_id))
	{
		deletefx(localClientNum, self.fx_id, 0);
		self.fx_id = undefined;
	}
	else if(newVal == 1)
	{
		self.fx_id = PlayFXOnTag(localClientNum, level._effect["major_cache_plant"], self, "fx_tag_plant_cache_major_jnt");
	}
}

/*
	Name: function_b8cf2db
	Namespace: namespace_7550a904
	Checksum: 0xCA083F16
	Offset: 0xD88
	Size: 0xBD
	Parameters: 7
	Flags: None
*/
function function_b8cf2db(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_b8cf2db = PlayFXOnTag(localClientNum, level._effect["babysitter_plant"], self, "tag_origin");
	}
	else if(isdefined(self.var_b8cf2db))
	{
		deletefx(localClientNum, self.var_b8cf2db, 0);
		self.var_b8cf2db = undefined;
	}
}

/*
	Name: function_22008d73
	Namespace: namespace_7550a904
	Checksum: 0x4C0965DB
	Offset: 0xE50
	Size: 0xBD
	Parameters: 7
	Flags: None
*/
function function_22008d73(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_22008d73 = PlayFXOnTag(localClientNum, level._effect["trap_plant"], self, "tag_origin");
	}
	else if(isdefined(self.var_22008d73))
	{
		deletefx(localClientNum, self.var_22008d73, 0);
		self.var_22008d73 = undefined;
	}
}

/*
	Name: function_c2c4b7be
	Namespace: namespace_7550a904
	Checksum: 0x966FDA38
	Offset: 0xF18
	Size: 0xCD
	Parameters: 7
	Flags: None
*/
function function_c2c4b7be(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_c00f8b20 = playFX(localClientNum, level._effect["plant_hit_with_ww"], self.origin + VectorScale((0, 0, 1), 8));
	}
	else if(isdefined(self.var_c00f8b20))
	{
		deletefx(localClientNum, self.var_c00f8b20, 0);
		self.var_c00f8b20 = undefined;
	}
}

/*
	Name: function_8fcaa237
	Namespace: namespace_7550a904
	Checksum: 0xE84E4693
	Offset: 0xFF0
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function function_8fcaa237(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("hash_15110cf6");
	if(isdefined(self.var_5257f4ba))
	{
		deletefx(localClientNum, self.var_5257f4ba, 0);
		self.var_5257f4ba = undefined;
	}
	if(newVal == 1)
	{
		self thread function_2179698b(localClientNum);
	}
}

/*
	Name: function_2179698b
	Namespace: namespace_7550a904
	Checksum: 0xC0DCFC71
	Offset: 0x10A0
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function function_2179698b(localClientNum)
{
	level endon("demo_jump");
	self endon("hash_15110cf6");
	self.var_5257f4ba = playFX(localClientNum, level._effect["plant_watered_startup"], self.origin + VectorScale((0, 0, 1), 8));
	wait(2);
	if(isdefined(self))
	{
		self.var_5257f4ba = playFX(localClientNum, level._effect["plant_watered"], self.origin + VectorScale((0, 0, 1), 8));
	}
}

/*
	Name: function_a7073474
	Namespace: namespace_7550a904
	Checksum: 0xC2BC7107
	Offset: 0x1170
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function function_a7073474(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self thread function_b8ba462e(localClientNum, 1);
	}
	else
	{
		self thread function_b8ba462e(localClientNum, 0);
	}
}

/*
	Name: function_b8ba462e
	Namespace: namespace_7550a904
	Checksum: 0xD90DB32
	Offset: 0x1200
	Size: 0x1CF
	Parameters: 2
	Flags: None
*/
function function_b8ba462e(localClientNum, b_on)
{
	if(!isdefined(b_on))
	{
		b_on = 1;
	}
	self endon("entityshutdown");
	self notify("hash_67a9e087");
	self endon("hash_67a9e087");
	level endon("demo_jump");
	n_start_time = GetTime();
	n_end_time = n_start_time + 2 * 1000;
	b_is_updating = 1;
	if(isdefined(b_on) && b_on)
	{
		n_max = 1;
		n_min = 0;
		continue;
	}
	n_max = 0;
	n_min = 1;
	while(b_is_updating && isdefined(self))
	{
		n_time = GetTime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_time);
		}
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_316f5fd4
	Namespace: namespace_7550a904
	Checksum: 0x9FE6B0BA
	Offset: 0x13D8
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_316f5fd4(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self thread postfx::playPostfxBundle("pstfx_thrasher_stomach");
	}
	else if(isdefined(self.playingPostfxBundle))
	{
		self thread postfx::stopPlayingPostfxBundle();
	}
}

/*
	Name: function_60a2a795
	Namespace: namespace_7550a904
	Checksum: 0x6FB72D5C
	Offset: 0x1470
	Size: 0xBD
	Parameters: 7
	Flags: None
*/
function function_60a2a795(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_23200cb7 = PlayFXOnTag(localClientNum, level._effect["clone_plant_emerge"], self, "tag_camera");
	}
	else if(isdefined(self.var_23200cb7))
	{
		deletefx(localClientNum, self.var_23200cb7, 0);
		self.var_23200cb7 = undefined;
	}
}

/*
	Name: function_6acdc163
	Namespace: namespace_7550a904
	Checksum: 0x70305D3A
	Offset: 0x1538
	Size: 0x105
	Parameters: 7
	Flags: None
*/
function function_6acdc163(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_7fec15a0 = PlayFXOnTag(localClientNum, level._effect["cache_slime"], self, "plant_cache_major_feeler_03_03_jnt");
	}
	else if(newVal == 2)
	{
		self.var_7fec15a0 = PlayFXOnTag(localClientNum, level._effect["cache_slime_small"], self, "plant_cache_major_feeler_03_03_jnt");
	}
	else if(isdefined(self.var_7fec15a0))
	{
		deletefx(localClientNum, self.var_7fec15a0, 0);
		self.var_7fec15a0 = undefined;
	}
}

/*
	Name: function_f244344b
	Namespace: namespace_7550a904
	Checksum: 0xDDB6B668
	Offset: 0x1648
	Size: 0xBD
	Parameters: 7
	Flags: None
*/
function function_f244344b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		self.var_a56aa1f9 = PlayFXOnTag(localClientNum, level._effect["fruit_plant_vomit"], self, "j_neck");
	}
	else if(isdefined(self.var_a56aa1f9))
	{
		deletefx(localClientNum, self.var_a56aa1f9, 0);
		self.var_a56aa1f9 = undefined;
	}
}

