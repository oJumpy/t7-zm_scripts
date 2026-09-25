#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace mechz;

/*
	Name: main
	Namespace: mechz
	Checksum: 0x5147F28B
	Offset: 0x748
	Size: 0x3AD
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "mechz_ft", 5000, 1, "int", &MechzClientUtils::mechzFlamethrowerCallback, 0, 0);
	clientfield::register("actor", "mechz_faceplate_detached", 5000, 1, "int", &MechzClientUtils::mechz_detach_faceplate, 0, 0);
	clientfield::register("actor", "mechz_powercap_detached", 5000, 1, "int", &MechzClientUtils::mechz_detach_powercap, 0, 0);
	clientfield::register("actor", "mechz_claw_detached", 5000, 1, "int", &MechzClientUtils::mechz_detach_claw, 0, 0);
	clientfield::register("actor", "mechz_115_gun_firing", 5000, 1, "int", &MechzClientUtils::mechz_115_gun_muzzle_flash, 0, 0);
	clientfield::register("actor", "mechz_rknee_armor_detached", 5000, 1, "int", &MechzClientUtils::mechz_detach_rknee_armor, 0, 0);
	clientfield::register("actor", "mechz_lknee_armor_detached", 5000, 1, "int", &MechzClientUtils::mechz_detach_lknee_armor, 0, 0);
	clientfield::register("actor", "mechz_rshoulder_armor_detached", 5000, 1, "int", &MechzClientUtils::mechz_detach_rshoulder_armor, 0, 0);
	clientfield::register("actor", "mechz_lshoulder_armor_detached", 5000, 1, "int", &MechzClientUtils::mechz_detach_lshoulder_armor, 0, 0);
	clientfield::register("actor", "mechz_headlamp_off", 5000, 2, "int", &MechzClientUtils::mechz_headlamp_off, 0, 0);
	clientfield::register("actor", "mechz_face", 1, 3, "int", &MechzClientUtils::mechzFaceCallback, 0, 0);
	ai::add_archetype_spawn_function("mechz", &MechzClientUtils::mechzSpawn);
	level._mechz_face = [];
	level._mechz_face[1] = "ai_face_zombie_generic_attack_1";
	level._mechz_face[2] = "ai_face_zombie_generic_death_1";
	level._mechz_face[3] = "ai_face_zombie_generic_idle_1";
	level._mechz_face[4] = "ai_face_zombie_generic_pain_1";
}

/*
	Name: Precache
	Namespace: mechz
	Checksum: 0xED11CCBE
	Offset: 0xB00
	Size: 0x1DD
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
	level._effect["fx_mech_wpn_flamethrower"] = "dlc1/castle/fx_mech_wpn_flamethrower";
	level._effect["fx_mech_dmg_armor_face"] = "dlc1/castle/fx_mech_dmg_armor_face";
	level._effect["fx_mech_dmg_armor"] = "dlc1/castle/fx_mech_dmg_armor";
	level._effect["fx_mech_dmg_armor"] = "dlc1/castle/fx_mech_dmg_armor";
	level._effect["fx_wpn_115_muz"] = "dlc1/castle/fx_wpn_115_muz";
	level._effect["fx_mech_dmg_armor"] = "dlc1/castle/fx_mech_dmg_armor";
	level._effect["fx_mech_dmg_armor"] = "dlc1/castle/fx_mech_dmg_armor";
	level._effect["fx_mech_dmg_armor"] = "dlc1/castle/fx_mech_dmg_armor";
	level._effect["fx_mech_dmg_armor"] = "dlc1/castle/fx_mech_dmg_armor";
	level._effect["fx_mech_head_light"] = "dlc1/castle/fx_mech_head_light";
	level._effect["fx_mech_dmg_sparks"] = "dlc1/castle/fx_mech_dmg_sparks";
	level._effect["fx_mech_dmg_knee_sparks"] = "dlc1/castle/fx_mech_dmg_knee_sparks";
	level._effect["fx_mech_dmg_sparks"] = "dlc1/castle/fx_mech_dmg_sparks";
	level._effect["fx_mech_foot_step"] = "dlc1/castle/fx_mech_foot_step";
	level._effect["fx_mech_light_dmg"] = "dlc1/castle/fx_mech_light_dmg";
	level._effect["fx_mech_foot_step_steam"] = "dlc1/castle/fx_mech_foot_step_steam";
	level._effect["fx_mech_dmg_body_light"] = "dlc1/castle/fx_mech_dmg_body_light";
}

#namespace MechzClientUtils;

/*
	Name: mechzSpawn
	Namespace: MechzClientUtils
	Checksum: 0xEB0EADEB
	Offset: 0xCE8
	Size: 0x87
	Parameters: 1
	Flags: Private
*/
function private mechzSpawn(localClientNum)
{
	level._footstepCBFuncs[self.archetype] = &mechzProcessFootstep;
	level thread mechzSndContext(self);
	self.headlight_fx = PlayFXOnTag(localClientNum, level._effect["fx_mech_head_light"], self, "tag_headlamp_FX");
	self.headlamp_on = 1;
}

/*
	Name: mechzSndContext
	Namespace: MechzClientUtils
	Checksum: 0x47788208
	Offset: 0xD78
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function mechzSndContext(mechz)
{
	wait(1);
	if(isdefined(mechz))
	{
		mechz setsoundentcontext("movement", "normal");
	}
}

/*
	Name: mechzProcessFootstep
	Namespace: MechzClientUtils
	Checksum: 0xAC5780DA
	Offset: 0xDC8
	Size: 0x2A7
	Parameters: 5
	Flags: None
*/
function mechzProcessFootstep(localClientNum, pos, surface, Notetrack, bone)
{
	e_player = GetLocalPlayer(localClientNum);
	n_dist = DistanceSquared(pos, e_player.origin);
	n_mechz_dist = 1000000;
	if(n_mechz_dist > 0)
	{
		n_scale = n_mechz_dist - n_dist / n_mechz_dist;
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
		e_player PlayRumbleOnEntity(localClientNum, "shotgun_fire");
	}
	else if(n_scale <= 0.8 && n_scale > 0.4)
	{
		e_player PlayRumbleOnEntity(localClientNum, "damage_heavy");
	}
	else
	{
		e_player PlayRumbleOnEntity(localClientNum, "reload_small");
	}
	FX = PlayFXOnTag(localClientNum, level._effect["fx_mech_foot_step"], self, bone);
	if(bone == "j_ball_le")
	{
		steam_bone = "tag_foot_steam_le";
	}
	else
	{
		steam_bone = "tag_foot_steam_ri";
	}
	steam_fx = PlayFXOnTag(localClientNum, level._effect["fx_mech_foot_step_steam"], self, steam_bone);
}

/*
	Name: mechzFlamethrowerCallback
	Namespace: MechzClientUtils
	Checksum: 0x2C0CA02
	Offset: 0x1078
	Size: 0x15D
	Parameters: 7
	Flags: Private
*/
function private mechzFlamethrowerCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	switch(newValue)
	{
		case 1:
		{
			self.fire_beam_id = BeamLaunch(localClientNum, self, "tag_flamethrower_fx", undefined, "none", "flamethrower_beam_3p_zm_mechz");
			self playsound(0, "wpn_flame_thrower_start_mechz");
			self.sndLoopID = self PlayLoopSound("wpn_flame_thrower_loop_mechz");
			break;
		}
		case 0:
		{
			self notify("stopFlamethrower");
			if(isdefined(self.fire_beam_id))
			{
				BeamKill(localClientNum, self.fire_beam_id);
				self playsound(0, "wpn_flame_thrower_stop_mechz");
				self StopLoopSound(self.sndLoopID);
			}
			break;
		}
	}
}

/*
	Name: mechz_detach_faceplate
	Namespace: MechzClientUtils
	Checksum: 0x98322F0D
	Offset: 0x11E0
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function mechz_detach_faceplate(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_faceplate");
	ang = self GetTagAngles("j_faceplate");
	velocity = self GetVelocity();
	dynEnt = CreateDynEntAndLaunch(localClientNum, "c_zom_mech_faceplate", pos, ang, self.origin, velocity);
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_armor_face"], self, "j_faceplate");
	self setsoundentcontext("movement", "loud");
	self playsound(0, "zmb_ai_mechz_faceplate");
}

/*
	Name: mechz_detach_powercap
	Namespace: MechzClientUtils
	Checksum: 0xEDC1D086
	Offset: 0x1358
	Size: 0x17B
	Parameters: 7
	Flags: None
*/
function mechz_detach_powercap(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("tag_powersupply");
	ang = self GetTagAngles("tag_powersupply");
	velocity = self GetVelocity();
	dynEnt = CreateDynEntAndLaunch(localClientNum, "c_zom_mech_powersupply_cap", pos, ang, self.origin, velocity);
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_armor"], self, "tag_powersupply");
	self playsound(0, "zmb_ai_mechz_destruction");
	self.MECHZ_POWERCORE_FX = PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_body_light"], self, "tag_powersupply");
}

/*
	Name: mechz_detach_claw
	Namespace: MechzClientUtils
	Checksum: 0x1F772A23
	Offset: 0x14E0
	Size: 0x1AB
	Parameters: 7
	Flags: None
*/
function mechz_detach_claw(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(isdefined(level.mechz_detach_claw_override))
	{
		self [[level.mechz_detach_claw_override]](localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump);
		return;
	}
	pos = self GetTagOrigin("tag_gun_spin");
	ang = self GetTagAngles("tag_gun_spin");
	velocity = self GetVelocity();
	dynEnt = CreateDynEntAndLaunch(localClientNum, "c_zom_mech_gun_barrel", pos, ang, self.origin, velocity);
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_armor"], self, "tag_gun_spin");
	self playsound(0, "zmb_ai_mechz_destruction");
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_sparks"], self, "tag_gun_spin");
}

/*
	Name: mechz_115_gun_muzzle_flash
	Namespace: MechzClientUtils
	Checksum: 0x82862DA8
	Offset: 0x1698
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function mechz_115_gun_muzzle_flash(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	PlayFXOnTag(localClientNum, level._effect["fx_wpn_115_muz"], self, "tag_gun_barrel2");
}

/*
	Name: mechz_detach_rknee_armor
	Namespace: MechzClientUtils
	Checksum: 0xE01CEDF1
	Offset: 0x1710
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function mechz_detach_rknee_armor(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_knee_attach_ri");
	ang = self GetTagAngles("j_knee_attach_ri");
	velocity = self GetVelocity();
	dynEnt = CreateDynEntAndLaunch(localClientNum, "c_zom_mech_armor_knee_right", pos, ang, pos, velocity);
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_armor"], self, "j_knee_attach_ri");
	self playsound(0, "zmb_ai_mechz_destruction");
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_knee_sparks"], self, "j_knee_attach_ri");
}

/*
	Name: mechz_detach_lknee_armor
	Namespace: MechzClientUtils
	Checksum: 0x4E303387
	Offset: 0x1888
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function mechz_detach_lknee_armor(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_knee_attach_le");
	ang = self GetTagAngles("j_knee_attach_le");
	velocity = self GetVelocity();
	dynEnt = CreateDynEntAndLaunch(localClientNum, "c_zom_mech_armor_knee_left", pos, ang, pos, velocity);
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_armor"], self, "j_knee_attach_le");
	self playsound(0, "zmb_ai_mechz_destruction");
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_knee_sparks"], self, "j_knee_attach_le");
}

/*
	Name: mechz_detach_rshoulder_armor
	Namespace: MechzClientUtils
	Checksum: 0x5EBC6239
	Offset: 0x1A00
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function mechz_detach_rshoulder_armor(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_shoulderarmor_ri");
	ang = self GetTagAngles("j_shoulderarmor_ri");
	velocity = self GetVelocity();
	dynEnt = CreateDynEntAndLaunch(localClientNum, "c_zom_mech_armor_shoulder_right", pos, ang, pos, velocity);
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_armor"], self, "j_shoulderarmor_ri");
	self playsound(0, "zmb_ai_mechz_destruction");
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_sparks"], self, "j_shoulderarmor_ri");
}

/*
	Name: mechz_detach_lshoulder_armor
	Namespace: MechzClientUtils
	Checksum: 0xABB2DF30
	Offset: 0x1B78
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function mechz_detach_lshoulder_armor(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	pos = self GetTagOrigin("j_shoulderarmor_le");
	ang = self GetTagAngles("j_shoulderarmor_le");
	velocity = self GetVelocity();
	dynEnt = CreateDynEntAndLaunch(localClientNum, "c_zom_mech_armor_shoulder_left", pos, ang, pos, velocity);
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_armor"], self, "j_shoulderarmor_le");
	self playsound(0, "zmb_ai_mechz_destruction");
	PlayFXOnTag(localClientNum, level._effect["fx_mech_dmg_sparks"], self, "j_shoulderarmor_le");
}

/*
	Name: mechz_headlamp_off
	Namespace: MechzClientUtils
	Checksum: 0x2DDDD751
	Offset: 0x1CF0
	Size: 0xCB
	Parameters: 7
	Flags: None
*/
function mechz_headlamp_off(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(self.headlamp_on === 1 && newValue != 0 && isdefined(self.headlight_fx))
	{
		stopfx(localClientNum, self.headlight_fx);
		self.headlamp_on = 0;
		if(newValue == 2)
		{
			PlayFXOnTag(localClientNum, level._effect["fx_mech_foot_step"], self, "tag_headlamp_fx");
		}
	}
}

/*
	Name: mechzFaceCallback
	Namespace: MechzClientUtils
	Checksum: 0x17342B62
	Offset: 0x1DC8
	Size: 0xC7
	Parameters: 7
	Flags: Private
*/
function private mechzFaceCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		if(isdefined(self.prevFaceAnim))
		{
			self ClearAnim(self.prevFaceAnim, 0.2);
		}
		faceAnim = level._mechz_face[newValue];
		self SetAnim(faceAnim, 1, 0.2, 1);
		self.prevFaceAnim = faceAnim;
	}
}

