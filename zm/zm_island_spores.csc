#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace namespace_7a07aa2f;

/*
	Name: init
	Namespace: namespace_7a07aa2f
	Checksum: 0xEBF3C173
	Offset: 0x580
	Size: 0x267
	Parameters: 0
	Flags: None
*/
function init()
{
	var_d1cfa380 = GetMinBitCountForNum(7);
	var_a15256dd = GetMinBitCountForNum(3);
	var_a17d01a1 = GetMinBitCountForNum(5);
	clientfield::register("scriptmover", "spore_glow_fx", 9000, 1, "int", &function_4d352e71, 0, 0);
	clientfield::register("scriptmover", "spore_cloud_fx", 9000, var_d1cfa380, "int", &function_63a5615b, 0, 0);
	clientfield::register("actor", "spore_trail_enemy_fx", 9000, var_a15256dd, "int", &function_d4effeda, 0, 0);
	clientfield::register("allplayers", "spore_trail_player_fx", 9000, var_a15256dd, "int", &function_d4effeda, 0, 0);
	clientfield::register("scriptmover", "spore_grows", 9000, var_a17d01a1, "int", &function_36be307d, 0, 0);
	clientfield::register("toplayer", "play_spore_bubbles", 9000, 1, "int", &function_6225657f, 0, 0);
	clientfield::register("toplayer", "spore_camera_fx", 9000, var_a15256dd, "int", &function_194bfed3, 0, 0);
	level.b_thrasher_custom_spore_fx = 1;
}

/*
	Name: function_4d352e71
	Namespace: namespace_7a07aa2f
	Checksum: 0xAD508920
	Offset: 0x7F0
	Size: 0x17D
	Parameters: 7
	Flags: None
*/
function function_4d352e71(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.var_b5a2b77f))
	{
		self.var_b5a2b77f = ArrayGetClosest(self.origin, struct::get_array("spore_fx_org", "script_noteworthy"));
	}
	if(newVal == 1)
	{
		if(isdefined(self.var_a1aff3d8))
		{
			stopfx(localClientNum, self.var_a1aff3d8);
		}
		self.var_a1aff3d8 = playFX(localClientNum, level._effect["SPORE_GLOW"], self.var_b5a2b77f.origin, AnglesToForward(self.var_b5a2b77f.angles), anglesToUp(self.var_b5a2b77f.angles));
	}
	else if(isdefined(self.var_a1aff3d8))
	{
		stopfx(localClientNum, self.var_a1aff3d8);
		self.var_a1aff3d8 = undefined;
	}
}

/*
	Name: function_63a5615b
	Namespace: namespace_7a07aa2f
	Checksum: 0x43A789FD
	Offset: 0x978
	Size: 0x85D
	Parameters: 7
	Flags: None
*/
function function_63a5615b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	if(!isdefined(self.var_a5969fbf) && !isdefined(self.var_338f3084) && !isdefined(self.var_5991aaed) && self.model != "tag_origin")
	{
		self.var_a5969fbf = ArrayGetClosest(self.origin, struct::get_array("spore_cloud_org_stage_01", "script_noteworthy"));
		self.var_338f3084 = ArrayGetClosest(self.origin, struct::get_array("spore_cloud_org_stage_02", "script_noteworthy"));
		self.var_5991aaed = ArrayGetClosest(self.origin, struct::get_array("spore_cloud_org_stage_03", "script_noteworthy"));
	}
	else if(!isdefined(self.var_a5969fbf) && !isdefined(self.var_338f3084) && !isdefined(self.var_5991aaed) && self.model == "tag_origin")
	{
		self.var_a5969fbf = spawnstruct();
		self.var_a5969fbf.origin = self.origin;
		self.var_a5969fbf.angles = self.angles;
		self.var_338f3084 = spawnstruct();
		self.var_338f3084.origin = self.origin;
		self.var_338f3084.angles = self.angles;
		self.var_5991aaed = spawnstruct();
		self.var_5991aaed.origin = self.origin;
		self.var_5991aaed.angles = self.angles;
	}
	if(!isdefined(self.var_b5a2b77f) && self.model != "tag_origin")
	{
		self.var_b5a2b77f = ArrayGetClosest(self.origin, struct::get_array("spore_fx_org", "script_noteworthy"));
	}
	else if(!isdefined(self.var_b5a2b77f) && self.model == "tag_origin")
	{
		self.var_b5a2b77f = spawnstruct();
		self.var_b5a2b77f.origin = self.origin;
		self.var_b5a2b77f.angles = self.angles;
	}
	if(newVal >= 1)
	{
		switch(newVal)
		{
			case 1:
			{
				playFX(localClientNum, level._effect["SPORE_CLOUD_EXP_GOOD_SM"], self.var_b5a2b77f.origin, AnglesToForward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playFX(localClientNum, level._effect["SPORE_CLOUD_GOOD_SM"], self.var_a5969fbf.origin, AnglesToForward(self.var_a5969fbf.angles));
				break;
			}
			case 2:
			{
				playFX(localClientNum, level._effect["SPORE_CLOUD_EXP_GOOD_MD"], self.var_b5a2b77f.origin, AnglesToForward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playFX(localClientNum, level._effect["SPORE_CLOUD_GOOD_MD"], self.var_338f3084.origin, AnglesToForward(self.var_338f3084.angles));
				break;
			}
			case 3:
			{
				playFX(localClientNum, level._effect["SPORE_CLOUD_EXP_GOOD_LG"], self.var_b5a2b77f.origin, AnglesToForward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playFX(localClientNum, level._effect["SPORE_CLOUD_GOOD_LG"], self.var_5991aaed.origin, AnglesToForward(self.var_5991aaed.angles));
				break;
			}
			case 4:
			{
				playFX(localClientNum, level._effect["SPORE_CLOUD_EXP_SM"], self.var_b5a2b77f.origin, AnglesToForward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playFX(localClientNum, level._effect["SPORE_CLOUD_SM"], self.var_a5969fbf.origin, AnglesToForward(self.var_a5969fbf.angles));
				break;
			}
			case 5:
			{
				playFX(localClientNum, level._effect["SPORE_CLOUD_EXP_MD"], self.var_b5a2b77f.origin, AnglesToForward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playFX(localClientNum, level._effect["SPORE_CLOUD_MD"], self.var_338f3084.origin, AnglesToForward(self.var_338f3084.angles));
				break;
			}
			case 6:
			{
				playFX(localClientNum, level._effect["SPORE_CLOUD_EXP_LG"], self.var_b5a2b77f.origin, AnglesToForward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playFX(localClientNum, level._effect["SPORE_CLOUD_LG"], self.var_5991aaed.origin, AnglesToForward(self.var_5991aaed.angles));
				break;
			}
		}
	}
	else if(isdefined(self.var_1ca05152))
	{
		stopfx(localClientNum, self.var_1ca05152);
		self.var_1ca05152 = undefined;
	}
}

/*
	Name: function_d4effeda
	Namespace: namespace_7a07aa2f
	Checksum: 0x4B9ACF25
	Offset: 0x11E0
	Size: 0x11D
	Parameters: 7
	Flags: None
*/
function function_d4effeda(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	if(newVal == 1)
	{
		self.var_b01b7371 = PlayFXOnTag(localClientNum, level._effect["SPORE_TRAIL_GOOD"], self, "j_spine4");
	}
	else if(newVal == 2)
	{
		self.var_b01b7371 = PlayFXOnTag(localClientNum, level._effect["SPORE_TRAIL"], self, "j_spine4");
	}
	else if(isdefined(self.var_b01b7371))
	{
		stopfx(localClientNum, self.var_b01b7371);
		self.var_b01b7371 = undefined;
	}
}

/*
	Name: function_36be307d
	Namespace: namespace_7a07aa2f
	Checksum: 0xF8F0141B
	Offset: 0x1308
	Size: 0x60B
	Parameters: 7
	Flags: None
*/
function function_36be307d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(self.var_baeb5712))
	{
		if(self.model == "p7_zm_isl_spore_flat")
		{
			self.var_baeb5712 = 1;
		}
		else
		{
			self.var_baeb5712 = 0;
		}
	}
	if(IsDemoPlaying() && function_c8c0455e(localClientNum) < 100)
	{
		return;
	}
	if(newVal >= 1)
	{
		switch(newVal)
		{
			case 1:
			{
				self scene::stop(1);
				if(self.var_baeb5712)
				{
					self scene::add_scene_func("p7_fxanim_zm_island_spores_wall_stage_01_bundle", &function_dd0015d, "play");
					self thread function_406fdb8("p7_fxanim_zm_island_spores_wall_stage_01_bundle");
				}
				else
				{
					self scene::add_scene_func("p7_fxanim_zm_island_spores_rock_stage_01_bundle", &function_dd0015d, "play");
					self thread function_406fdb8("p7_fxanim_zm_island_spores_rock_stage_01_bundle");
				}
				break;
			}
			case 2:
			{
				self scene::stop(1);
				if(isdefined(self.var_4df7e11b) && self.var_4df7e11b.size > 0)
				{
					self.var_4df7e11b = Array::remove_undefined(self.var_4df7e11b);
					Array::run_all(self.var_4df7e11b, &delete);
					self.var_4df7e11b = [];
				}
				if(self.var_baeb5712)
				{
					self thread function_406fdb8("p7_fxanim_zm_island_spores_wall_stage_02_bundle");
				}
				else
				{
					self thread function_406fdb8("p7_fxanim_zm_island_spores_rock_stage_02_bundle");
				}
				break;
			}
			case 3:
			{
				self scene::stop(1);
				if(self.var_baeb5712)
				{
					self scene::add_scene_func("p7_fxanim_zm_island_spores_wall_stage_02_rapid_bundle", &function_dd0015d, "play");
					self thread function_406fdb8("p7_fxanim_zm_island_spores_wall_stage_02_rapid_bundle");
				}
				else
				{
					self scene::add_scene_func("p7_fxanim_zm_island_spores_rock_stage_02_rapid_bundle", &function_dd0015d, "play");
					self thread function_406fdb8("p7_fxanim_zm_island_spores_rock_stage_02_rapid_bundle");
				}
				break;
			}
			case 4:
			{
				if(self.var_baeb5712)
				{
					self thread scene::init("p7_fxanim_zm_island_spores_wall_stage_01_bundle");
				}
				else
				{
					self thread scene::init("p7_fxanim_zm_island_spores_rock_stage_01_bundle");
				}
				break;
			}
			case 5:
			{
				self scene::stop(1);
				if(isdefined(self.var_4df7e11b) && self.var_4df7e11b.size > 0)
				{
					self.var_4df7e11b = Array::remove_undefined(self.var_4df7e11b);
					Array::run_all(self.var_4df7e11b, &delete);
					self.var_4df7e11b = [];
				}
				if(self.var_baeb5712)
				{
					self thread scene::init("p7_fxanim_zm_island_spores_wall_stage_01_bundle");
				}
				else
				{
					self thread scene::init("p7_fxanim_zm_island_spores_rock_stage_01_bundle");
				}
				break;
			}
		}
	}
	else
	{
		self scene::stop(1);
		if(self.var_baeb5712)
		{
			self scene::add_scene_func("p7_fxanim_zm_island_spores_wall_stage_03_bundle", &function_dd0015d, "play");
			self function_406fdb8("p7_fxanim_zm_island_spores_wall_stage_03_bundle");
		}
		else
		{
			self scene::add_scene_func("p7_fxanim_zm_island_spores_rock_stage_03_bundle", &function_dd0015d, "play");
			self function_406fdb8("p7_fxanim_zm_island_spores_rock_stage_03_bundle");
		}
		if(isdefined(self.var_4df7e11b) && self.var_4df7e11b.size > 0)
		{
			self.var_4df7e11b = Array::remove_undefined(self.var_4df7e11b);
			Array::run_all(self.var_4df7e11b, &delete);
			self.var_4df7e11b = [];
		}
		if(self.var_baeb5712)
		{
			self thread scene::init("p7_fxanim_zm_island_spores_wall_stage_01_bundle");
		}
		else
		{
			self thread scene::init("p7_fxanim_zm_island_spores_rock_stage_01_bundle");
		}
	}
}

/*
	Name: function_406fdb8
	Namespace: namespace_7a07aa2f
	Checksum: 0x584B5E1E
	Offset: 0x1920
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function function_406fdb8(scene)
{
	self notify("hash_406fdb8");
	self endon("hash_406fdb8");
	self scene::stop();
	self function_6221b6b9(scene);
	self scene::stop();
}

/*
	Name: function_6221b6b9
	Namespace: namespace_7a07aa2f
	Checksum: 0x10C21C44
	Offset: 0x1998
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function function_6221b6b9(scene, var_165d49f6)
{
	level endon("demo_jump");
	self scene::Play(scene);
}

/*
	Name: function_dd0015d
	Namespace: namespace_7a07aa2f
	Checksum: 0x2B6675A4
	Offset: 0x19D8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_dd0015d(a_ents)
{
	if(!isdefined(self.var_4df7e11b))
	{
		self.var_4df7e11b = [];
	}
	self.var_4df7e11b = ArrayCombine(self.var_4df7e11b, a_ents, 0, 0);
}

/*
	Name: function_6225657f
	Namespace: namespace_7a07aa2f
	Checksum: 0xB37AB55D
	Offset: 0x1A30
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_6225657f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	if(newVal)
	{
		self thread function_3ba5e2ae(localClientNum);
	}
	else
	{
		self thread function_7be165af(localClientNum);
	}
}

/*
	Name: function_3ba5e2ae
	Namespace: namespace_7a07aa2f
	Checksum: 0x19ED3A56
	Offset: 0x1AD8
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_3ba5e2ae(localClientNum)
{
	self endon("death");
	if(!isdefined(self.var_ea3e4398))
	{
		self.var_ea3e4398 = PlayFXOnCamera(localClientNum, level._effect["SPORE_BUBBLES"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		self thread function_9067dab6(localClientNum);
	}
}

/*
	Name: function_7be165af
	Namespace: namespace_7a07aa2f
	Checksum: 0x6582DA54
	Offset: 0x1B60
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function function_7be165af(localClientNum)
{
	if(isdefined(self.var_ea3e4398))
	{
		deletefx(localClientNum, self.var_ea3e4398, 1);
		self.var_ea3e4398 = undefined;
	}
	self notify("hash_a48959b9");
}

/*
	Name: function_9067dab6
	Namespace: namespace_7a07aa2f
	Checksum: 0xC9AD6A81
	Offset: 0x1BC0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_9067dab6(localClientNum)
{
	self endon("hash_a48959b9");
	self waittill("death");
	self function_7be165af(localClientNum);
}

/*
	Name: function_194bfed3
	Namespace: namespace_7a07aa2f
	Checksum: 0x87175BB5
	Offset: 0x1C08
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function function_194bfed3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(IsSpectating(localClientNum))
	{
		return;
	}
	if(newVal == 1)
	{
		self thread function_4ff31749(localClientNum, 1);
	}
	else if(newVal == 2)
	{
		self thread function_4ff31749(localClientNum, 0);
	}
	else
	{
		self thread function_b8071fc(localClientNum);
	}
}

/*
	Name: function_4ff31749
	Namespace: namespace_7a07aa2f
	Checksum: 0xE27D639D
	Offset: 0x1CE8
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function function_4ff31749(localClientNum, var_c55abf21)
{
	self endon("death");
	if(!isdefined(self.var_adac13ec))
	{
		if(var_c55abf21)
		{
			self.var_adac13ec = PlayFXOnCamera(localClientNum, level._effect["SPORE_TRAIL_GOOD_CAM"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		}
		else
		{
			self.var_adac13ec = PlayFXOnCamera(localClientNum, level._effect["SPORE_TRAIL_CAM"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		}
		self thread function_c0e328f2(localClientNum);
	}
}

/*
	Name: function_b8071fc
	Namespace: namespace_7a07aa2f
	Checksum: 0xB6AABCA5
	Offset: 0x1DC0
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function function_b8071fc(localClientNum)
{
	if(isdefined(self.var_adac13ec))
	{
		deletefx(localClientNum, self.var_adac13ec, 1);
		self.var_adac13ec = undefined;
	}
	self notify("hash_6cc118c6");
}

/*
	Name: function_c0e328f2
	Namespace: namespace_7a07aa2f
	Checksum: 0xE7BE9A04
	Offset: 0x1E20
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_c0e328f2(localClientNum)
{
	self endon("hash_6cc118c6");
	self waittill("death");
	self function_b8071fc(localClientNum);
}

