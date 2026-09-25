#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;

#namespace raz;

/*
	Name: main
	Namespace: raz
	Checksum: 0xEC9CC4C9
	Offset: 0x828
	Size: 0x2FB
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("scriptmover", "raz_detonate_ground_torpedo", 12000, 1, "int", &RazClientUtils::razDetonateGroundTorpedo, 0, 0);
	clientfield::register("scriptmover", "raz_torpedo_play_fx_on_self", 12000, 1, "int", &RazClientUtils::razPlaySelfFX, 0, 0);
	clientfield::register("scriptmover", "raz_torpedo_play_trail", 12000, 1, "counter", &RazClientUtils::razTorpedoPlayTrailFX, 0, 0);
	clientfield::register("actor", "raz_detach_gun", 12000, 1, "int", &RazClientUtils::razDetachGunFX, 0, 0);
	clientfield::register("actor", "raz_gun_weakpoint_hit", 12000, 1, "counter", &RazClientUtils::razGunWeakpointHitFX, 0, 0);
	clientfield::register("actor", "raz_detach_helmet", 12000, 1, "int", &RazClientUtils::razHelmetDetach, 0, 0);
	clientfield::register("actor", "raz_detach_chest_armor", 12000, 1, "int", &RazClientUtils::razChestArmorDetach, 0, 0);
	clientfield::register("actor", "raz_detach_l_shoulder_armor", 12000, 1, "int", &RazClientUtils::razLeftShoulderArmorDetach, 0, 0);
	clientfield::register("actor", "raz_detach_r_thigh_armor", 12000, 1, "int", &RazClientUtils::razRightThighArmorDetach, 0, 0);
	clientfield::register("actor", "raz_detach_l_thigh_armor", 12000, 1, "int", &RazClientUtils::razLeftThighArmorDetach, 0, 0);
	ai::add_archetype_spawn_function("raz", &RazClientUtils::razSpawn);
}

/*
	Name: Precache
	Namespace: raz
	Checksum: 0xF7860ABD
	Offset: 0xB30
	Size: 0x70D
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
	level._effect["fx_mech_foot_step"] = "dlc1/castle/fx_mech_foot_step";
	level._effect["fx_raz_mc_shockwave_projectile_impact"] = "dlc3/stalingrad/fx_raz_mc_shockwave_projectile_impact";
	level._effect["fx_bul_impact_concrete_xtreme"] = "impacts/fx_bul_impact_concrete_xtreme";
	level._effect["fx_raz_mc_shockwave_projectile"] = "dlc3/stalingrad/fx_raz_mc_shockwave_projectile";
	level._effect["fx_raz_dest_weak_point_exp"] = "dlc3/stalingrad/fx_raz_dest_weak_point_exp";
	level._effect["fx_raz_dest_weak_point_sparking_loop"] = "dlc3/stalingrad/fx_raz_dest_weak_point_sparking_loop";
	level._effect["fx_raz_dmg_weak_point"] = "dlc3/stalingrad/fx_raz_dmg_weak_point";
	level._effect["fx_raz_dest_weak_point_exp_generic"] = "dlc3/stalingrad/fx_raz_dest_weak_point_exp_generic";
	level._raz_taunts = [];
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_0";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_1";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_2";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_3";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_4";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_5";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_6";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_7";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_8";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_9";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_10";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_11";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_12";
	if(!isdefined(level._raz_taunts))
	{
		level._raz_taunts = [];
	}
	else if(!IsArray(level._raz_taunts))
	{
		level._raz_taunts = Array(level._raz_taunts);
	}
	level._raz_taunts[level._raz_taunts.size] = "vox_mang_mangler_taunt_13";
}

#namespace RazClientUtils;

/*
	Name: razSpawn
	Namespace: RazClientUtils
	Checksum: 0xCB1B6099
	Offset: 0x1248
	Size: 0x73
	Parameters: 1
	Flags: Private
*/
function private razSpawn(localClientNum)
{
	level._footstepCBFuncs[self.archetype] = &razProcessFootstep;
	self thread razPlayFireEmissiveShader(localClientNum);
	self thread razPlayRoarSound(localClientNum);
	self thread razPlayTaunts(localClientNum);
}

/*
	Name: razPlayFireEmissiveShader
	Namespace: RazClientUtils
	Checksum: 0xFCAC9BEF
	Offset: 0x12C8
	Size: 0x87
	Parameters: 1
	Flags: Private
*/
function private razPlayFireEmissiveShader(localClientNum)
{
	self endon("death");
	while(isdefined(self))
	{
		self waittill("lights_on");
		self MapShaderConstant(localClientNum, 0, "scriptVector3", 0, 1, 1);
		self waittill("lights_off");
		self MapShaderConstant(localClientNum, 0, "scriptVector3", 0, 0, 0);
	}
}

/*
	Name: razPlayRoarSound
	Namespace: RazClientUtils
	Checksum: 0x47B95DFE
	Offset: 0x1358
	Size: 0x6F
	Parameters: 1
	Flags: Private
*/
function private razPlayRoarSound(localClientNum)
{
	self endon("death");
	while(isdefined(self))
	{
		self waittill("roar");
		self playsound(localClientNum, "vox_raz_exert_enrage", self GetTagOrigin("tag_eye"));
	}
}

/*
	Name: razPlayTaunts
	Namespace: RazClientUtils
	Checksum: 0x9A291190
	Offset: 0x13D0
	Size: 0xFF
	Parameters: 1
	Flags: Private
*/
function private razPlayTaunts(localClientNum)
{
	self endon("death_start");
	self thread razStopTauntsOnDeath(localClientNum);
	while(isdefined(self))
	{
		taunt_wait = randomIntRange(5, 12);
		wait(taunt_wait);
		if(isdefined(level.voxAIdeactivate) && level.voxAIdeactivate)
		{
			continue;
		}
		else if(isdefined(self))
		{
			taunt_alias = level._raz_taunts[RandomInt(level._raz_taunts.size)];
			self.taunt_id = self playsound(localClientNum, taunt_alias, self GetTagOrigin("tag_eye"));
		}
	}
}

/*
	Name: razStopTauntsOnDeath
	Namespace: RazClientUtils
	Checksum: 0x913D0257
	Offset: 0x14D8
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private razStopTauntsOnDeath(localClientNum)
{
	self waittill("death_start");
	if(isdefined(self.taunt_id))
	{
		stopSound(self.taunt_id);
	}
}

/*
	Name: razProcessFootstep
	Namespace: RazClientUtils
	Checksum: 0xAC242E75
	Offset: 0x1520
	Size: 0x237
	Parameters: 5
	Flags: None
*/
function razProcessFootstep(localClientNum, pos, surface, Notetrack, bone)
{
	e_player = GetLocalPlayer(localClientNum);
	n_dist = DistanceSquared(pos, e_player.origin);
	n_raz_dist = 160000;
	if(n_raz_dist > 0)
	{
		n_scale = n_raz_dist - n_dist / n_raz_dist;
	}
	else
	{
		return;
	}
	if(n_scale > 1 || n_scale < 0)
	{
		return;
	}
	if(n_scale <= 0.01)
	{
		return;
	}
	earthquake_scale = n_scale * 0.1;
	if(earthquake_scale > 0.01)
	{
		e_player Earthquake(earthquake_scale, 0.1, pos, n_dist);
	}
	if(n_scale <= 1 && n_scale > 0.8)
	{
		e_player PlayRumbleOnEntity(localClientNum, "damage_heavy");
	}
	else if(n_scale <= 0.8 && n_scale > 0.4)
	{
		e_player PlayRumbleOnEntity(localClientNum, "damage_light");
	}
	else
	{
		e_player PlayRumbleOnEntity(localClientNum, "reload_small");
	}
	FX = PlayFXOnTag(localClientNum, level._effect["fx_mech_foot_step"], self, bone);
}

/*
	Name: razDetonateGroundTorpedo
	Namespace: RazClientUtils
	Checksum: 0x6E2C6BB9
	Offset: 0x1760
	Size: 0x77
	Parameters: 7
	Flags: Private
*/
function private razDetonateGroundTorpedo(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	FX = playFX(localClientNum, level._effect["fx_raz_mc_shockwave_projectile_impact"], self.origin);
}

/*
	Name: razTorpedoPlayTrailFX
	Namespace: RazClientUtils
	Checksum: 0xD277068F
	Offset: 0x17E0
	Size: 0x77
	Parameters: 7
	Flags: Private
*/
function private razTorpedoPlayTrailFX(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	FX = playFX(localClientNum, level._effect["fx_bul_impact_concrete_xtreme"], self.origin);
}

/*
	Name: razPlaySelfFX
	Namespace: RazClientUtils
	Checksum: 0x8B518E65
	Offset: 0x1860
	Size: 0xD3
	Parameters: 7
	Flags: Private
*/
function private razPlaySelfFX(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue == 0 && isdefined(self.RAZ_TORPEDO_SELF_FX))
	{
		stopfx(localClientNum, self.RAZ_TORPEDO_SELF_FX);
		self.RAZ_TORPEDO_SELF_FX = undefined;
	}
	if(newValue == 1 && !isdefined(self.RAZ_TORPEDO_SELF_FX))
	{
		self.RAZ_TORPEDO_SELF_FX = PlayFXOnTag(localClientNum, level._effect["fx_raz_mc_shockwave_projectile"], self, "tag_origin");
	}
}

/*
	Name: razCreateDynEntAndLaunch
	Namespace: RazClientUtils
	Checksum: 0xB79BAFBA
	Offset: 0x1940
	Size: 0x1BB
	Parameters: 7
	Flags: Private
*/
function private razCreateDynEntAndLaunch(localClientNum, model, pos, angles, hitPos, vel_factor, direction)
{
	if(!isdefined(vel_factor))
	{
		vel_factor = 1;
	}
	if(!isdefined(pos) || !isdefined(angles))
	{
		return;
	}
	velocity = self GetVelocity();
	velocity_normal = VectorNormalize(velocity);
	velocity_length = length(velocity);
	if(isdefined(direction) && direction == "back")
	{
		launch_dir = AnglesToForward(self.angles) * -1;
	}
	else
	{
		launch_dir = AnglesToForward(self.angles);
	}
	velocity_length = velocity_length * 0.1;
	if(velocity_length < 10)
	{
		velocity_length = 10;
	}
	launch_dir = launch_dir * 0.5 + velocity_normal * 0.5;
	launch_dir = launch_dir * velocity_length;
	CreateDynEntAndLaunch(localClientNum, model, pos, angles, self.origin, launch_dir * vel_factor);
}

/*
	Name: razDetachGunFX
	Namespace: RazClientUtils
	Checksum: 0x5A69A0A4
	Offset: 0x1B08
	Size: 0x1DB
	Parameters: 7
	Flags: Private
*/
function private razDetachGunFX(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	FX = PlayFXOnTag(localClientNum, level._effect["fx_raz_dest_weak_point_exp"], self, "TAG_FX_Shoulder_RI_GIB");
	gun_pos = self GetTagOrigin("j_elbow_ri");
	gun_ang = self GetTagAngles("j_elbow_ri");
	gun_core_pos = self GetTagOrigin("j_shouldertwist_ri_attach");
	gun_core_ang = self GetTagAngles("j_shouldertwist_ri_attach");
	dynEnt = razCreateDynEntAndLaunch(localClientNum, "c_zom_dlc3_raz_s_armcannon", gun_pos, gun_ang, self.origin, 1.3, "back");
	dynEnt = razCreateDynEntAndLaunch(localClientNum, "c_zom_dlc3_raz_s_cannonpowercore", gun_core_pos, gun_core_ang, self.origin, 1, "back");
	self playsound(localClientNum, "zmb_raz_gun_explo", self GetTagOrigin("tag_eye"));
}

/*
	Name: razGunWeakpointHitFX
	Namespace: RazClientUtils
	Checksum: 0xFA8D97A2
	Offset: 0x1CF0
	Size: 0x77
	Parameters: 7
	Flags: Private
*/
function private razGunWeakpointHitFX(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	FX = PlayFXOnTag(localClientNum, level._effect["fx_raz_dmg_weak_point"], self, "j_shoulder_ri");
}

/*
	Name: razHelmetDetach
	Namespace: RazClientUtils
	Checksum: 0x118C2A4F
	Offset: 0x1D70
	Size: 0x173
	Parameters: 7
	Flags: None
*/
function razHelmetDetach(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_elbow_ri");
	ang = self GetTagAngles("j_elbow_ri");
	FX = PlayFXOnTag(localClientNum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_Helmet");
	dynEnt = razCreateDynEntAndLaunch(localClientNum, "c_zom_dlc3_raz_s_helmet", pos, ang, self.origin, 1, "back");
	thread ApplyNewFaceAnim(localClientNum, "ai_zm_dlc3_face_armored_zombie_generic_idle_1");
	self playsound(localClientNum, "zmb_raz_armor_explo", self GetTagOrigin("tag_eye"));
}

/*
	Name: razChestArmorDetach
	Namespace: RazClientUtils
	Checksum: 0xA08C6597
	Offset: 0x1EF0
	Size: 0x143
	Parameters: 7
	Flags: None
*/
function razChestArmorDetach(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_spine4_attach");
	ang = self GetTagAngles("j_spine4_attach");
	FX = PlayFXOnTag(localClientNum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_ChestPlate");
	dynEnt = razCreateDynEntAndLaunch(localClientNum, "c_zom_dlc3_raz_s_chestplate", pos, ang, self.origin);
	self playsound(localClientNum, "zmb_raz_armor_explo", self GetTagOrigin("tag_eye"));
}

/*
	Name: razLeftShoulderArmorDetach
	Namespace: RazClientUtils
	Checksum: 0x83B541F4
	Offset: 0x2040
	Size: 0x143
	Parameters: 7
	Flags: None
*/
function razLeftShoulderArmorDetach(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_shouldertwist_le_attach");
	ang = self GetTagAngles("j_shouldertwist_le_attach");
	FX = PlayFXOnTag(localClientNum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_Shoulder_LE");
	dynEnt = razCreateDynEntAndLaunch(localClientNum, "c_zom_dlc3_raz_s_leftshoulderpad", pos, ang, self.origin);
	self playsound(localClientNum, "zmb_raz_armor_explo", self GetTagOrigin("tag_eye"));
}

/*
	Name: razLeftThighArmorDetach
	Namespace: RazClientUtils
	Checksum: 0xC40D7C52
	Offset: 0x2190
	Size: 0x143
	Parameters: 7
	Flags: None
*/
function razLeftThighArmorDetach(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_hiptwist_le_attach");
	ang = self GetTagAngles("j_hiptwist_le_attach");
	FX = PlayFXOnTag(localClientNum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_Thigh_LE");
	dynEnt = razCreateDynEntAndLaunch(localClientNum, "c_zom_dlc3_raz_s_leftthighpad", pos, ang, self.origin);
	self playsound(localClientNum, "zmb_raz_armor_explo", self GetTagOrigin("tag_eye"));
}

/*
	Name: razRightThighArmorDetach
	Namespace: RazClientUtils
	Checksum: 0x4E4B077D
	Offset: 0x22E0
	Size: 0x143
	Parameters: 7
	Flags: None
*/
function razRightThighArmorDetach(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_hiptwist_ri_attach");
	ang = self GetTagAngles("j_hiptwist_ri_attach");
	FX = PlayFXOnTag(localClientNum, level._effect["fx_raz_dest_weak_point_exp_generic"], self, "TAG_FX_Thigh_RI");
	dynEnt = razCreateDynEntAndLaunch(localClientNum, "c_zom_dlc3_raz_s_rightthighpad", pos, ang, self.origin);
	self playsound(localClientNum, "zmb_raz_armor_explo", self GetTagOrigin("tag_eye"));
}

/*
	Name: ApplyNewFaceAnim
	Namespace: RazClientUtils
	Checksum: 0x76A7BAB8
	Offset: 0x2430
	Size: 0xD3
	Parameters: 2
	Flags: Private
*/
function private ApplyNewFaceAnim(localClientNum, animation)
{
	self endon("disconnect");
	ClearCurrentFacialAnim(localClientNum);
	if(isdefined(animation))
	{
		self._currentFaceAnim = animation;
		if(self hasdobj(localClientNum) && self HasAnimTree())
		{
			self SetFlaggedAnimKnob("ai_secondary_facial_anim", animation, 1, 0.1, 1);
			self waittill("death_start");
			ClearCurrentFacialAnim(localClientNum);
		}
	}
}

/*
	Name: ClearCurrentFacialAnim
	Namespace: RazClientUtils
	Checksum: 0xDAA067E6
	Offset: 0x2510
	Size: 0x7D
	Parameters: 1
	Flags: Private
*/
function private ClearCurrentFacialAnim(localClientNum)
{
	if(isdefined(self._currentFaceAnim) && self hasdobj(localClientNum) && self HasAnimTree())
	{
		self ClearAnim(self._currentFaceAnim, 0.2);
	}
	self._currentFaceAnim = undefined;
}

