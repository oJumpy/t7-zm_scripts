#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\util_shared;

#namespace margwa;

/*
	Name: main
	Namespace: margwa
	Checksum: 0xCF7B9303
	Offset: 0x760
	Size: 0x69D
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "margwa_head_left", 1, 2, "int", &MargwaClientUtils::margwaHeadLeftCallback, 0, 0);
	clientfield::register("actor", "margwa_head_mid", 1, 2, "int", &MargwaClientUtils::margwaHeadMidCallback, 0, 0);
	clientfield::register("actor", "margwa_head_right", 1, 2, "int", &MargwaClientUtils::margwaHeadRightCallback, 0, 0);
	clientfield::register("actor", "margwa_fx_in", 1, 1, "counter", &MargwaClientUtils::margwaFxInCallback, 0, 0);
	clientfield::register("actor", "margwa_fx_out", 1, 1, "counter", &MargwaClientUtils::margwaFxOutCallback, 0, 0);
	clientfield::register("actor", "margwa_fx_spawn", 1, 1, "counter", &MargwaClientUtils::margwaFxSpawnCallback, 0, 0);
	clientfield::register("actor", "margwa_smash", 1, 1, "counter", &MargwaClientUtils::margwaSmashCallback, 0, 0);
	clientfield::register("actor", "margwa_head_left_hit", 1, 1, "counter", &MargwaClientUtils::margwaLeftHitCallback, 0, 0);
	clientfield::register("actor", "margwa_head_mid_hit", 1, 1, "counter", &MargwaClientUtils::margwaMidHitCallback, 0, 0);
	clientfield::register("actor", "margwa_head_right_hit", 1, 1, "counter", &MargwaClientUtils::margwaRightHitCallback, 0, 0);
	clientfield::register("actor", "margwa_head_killed", 1, 2, "int", &MargwaClientUtils::margwaHeadKilledCallback, 0, 0);
	clientfield::register("actor", "margwa_jaw", 1, 6, "int", &MargwaClientUtils::margwaJawCallback, 0, 0);
	clientfield::register("toplayer", "margwa_head_explosion", 1, 1, "counter", &MargwaClientUtils::margwaHeadExplosion, 0, 0);
	clientfield::register("scriptmover", "margwa_fx_travel", 1, 1, "int", &MargwaClientUtils::margwaFxTravelCallback, 0, 0);
	clientfield::register("scriptmover", "margwa_fx_travel_tell", 1, 1, "int", &MargwaClientUtils::margwaFxTravelTellCallback, 0, 0);
	clientfield::register("actor", "supermargwa", 1, 1, "int", undefined, 0, 0);
	ai::add_archetype_spawn_function("margwa", &MargwaClientUtils::margwaSpawn);
	level._jaw = [];
	level._jaw[1] = "idle_1";
	level._jaw[3] = "idle_pain_head_l_explode";
	level._jaw[4] = "idle_pain_head_m_explode";
	level._jaw[5] = "idle_pain_head_r_explode";
	level._jaw[6] = "react_stun";
	level._jaw[8] = "react_idgun";
	level._jaw[9] = "react_idgun_pack";
	level._jaw[7] = "run_charge_f";
	level._jaw[13] = "run_f";
	level._jaw[14] = "smash_attack_1";
	level._jaw[15] = "swipe";
	level._jaw[16] = "swipe_player";
	level._jaw[17] = "teleport_in";
	level._jaw[18] = "teleport_out";
	level._jaw[19] = "trv_jump_across_256";
	level._jaw[20] = "trv_jump_down_128";
	level._jaw[21] = "trv_jump_down_36";
	level._jaw[22] = "trv_jump_down_96";
	level._jaw[23] = "trv_jump_up_128";
	level._jaw[24] = "trv_jump_up_36";
	level._jaw[25] = "trv_jump_up_96";
}

/*
	Name: Precache
	Namespace: margwa
	Checksum: 0x5B5921E6
	Offset: 0xE08
	Size: 0xC5
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
	level._effect["fx_margwa_teleport_zod_zmb"] = "zombie/fx_margwa_teleport_zod_zmb";
	level._effect["fx_margwa_teleport_travel_zod_zmb"] = "zombie/fx_margwa_teleport_travel_zod_zmb";
	level._effect["fx_margwa_teleport_tell_zod_zmb"] = "zombie/fx_margwa_teleport_tell_zod_zmb";
	level._effect["fx_margwa_teleport_intro_zod_zmb"] = "zombie/fx_margwa_teleport_intro_zod_zmb";
	level._effect["fx_margwa_head_shot_zod_zmb"] = "zombie/fx_margwa_head_shot_zod_zmb";
	level._effect["fx_margwa_roar_zod_zmb"] = "zombie/fx_margwa_roar_zod_zmb";
	level._effect["fx_margwa_roar_purple_zod_zmb"] = "zombie/fx_margwa_roar_purple_zod_zmb";
}

#namespace MargwaClientUtils;

/*
	Name: margwaSpawn
	Namespace: MargwaClientUtils
	Checksum: 0x879A66C0
	Offset: 0xED8
	Size: 0x33F
	Parameters: 1
	Flags: Private
*/
function private margwaSpawn(localClientNum)
{
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	self SetAnim("ai_margwa_head_l_closed_add", 1, 0.2, 1);
	self SetAnim("ai_margwa_head_m_closed_add", 1, 0.2, 1);
	self SetAnim("ai_margwa_head_r_closed_add", 1, 0.2, 1);
	for(i = 1; i <= 7; i++)
	{
		leftTentacle = "ai_margwa_tentacle_l_0" + i;
		rightTentacle = "ai_margwa_tentacle_r_0" + i;
		self SetAnim(leftTentacle, 1, 0.2, 1);
		self SetAnim(rightTentacle, 1, 0.2, 1);
	}
	level._footstepCBFuncs[self.archetype] = &margwaProcessFootstep;
	self.heads = [];
	self.heads[1] = spawnstruct();
	self.heads[1].index = 1;
	self.heads[1].prevHeadAnim = "ai_margwa_head_l_closed_add";
	self.heads[1].jawBase = "ai_margwa_jaw_l_";
	self.heads[2] = spawnstruct();
	self.heads[2].index = 2;
	self.heads[2].prevHeadAnim = "ai_margwa_head_m_closed_add";
	self.heads[2].jawBase = "ai_margwa_jaw_m_";
	self.heads[3] = spawnstruct();
	self.heads[3].index = 3;
	self.heads[3].prevHeadAnim = "ai_margwa_head_r_closed_add";
	self.heads[3].jawBase = "ai_margwa_jaw_r_";
}

/*
	Name: margwaHeadLeftCallback
	Namespace: MargwaClientUtils
	Checksum: 0x39899429
	Offset: 0x1220
	Size: 0x40D
	Parameters: 7
	Flags: Private
*/
function private margwaHeadLeftCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(isdefined(self.leftGlowFx))
	{
		stopfx(localClientNum, self.leftGlowFx);
	}
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newValue)
	{
		case 1:
		{
			self.heads[1].prevHeadAnim = "ai_margwa_head_l_open_add";
			self SetAnim("ai_margwa_head_l_open_add", 1, 0.1, 1);
			self ClearAnim("ai_margwa_head_l_closed_add", 0.1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.leftGlowFx = PlayFXOnTag(localClientNum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_left");
			}
			else
			{
				self.leftGlowFx = PlayFXOnTag(localClientNum, roar_effect, self, "tag_head_left");
			}
			break;
		}
		case 2:
		{
			self.heads[1].prevHeadAnim = "ai_margwa_head_l_closed_add";
			self SetAnim("ai_margwa_head_l_closed_add", 1, 0.1, 1);
			self ClearAnim("ai_margwa_head_l_open_add", 0.1);
			self ClearAnim("ai_margwa_head_l_smash_attack_1", 0.1);
			break;
		}
		case 3:
		{
			self.heads[1].prevHeadAnim = "ai_margwa_head_l_smash_attack_1";
			self ClearAnim("ai_margwa_head_l_open_add", 0.1);
			self ClearAnim("ai_margwa_head_l_closed_add", 0.1);
			self SetAnimRestart("ai_margwa_head_l_smash_attack_1", 1, 0.1, 1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.leftGlowFx = PlayFXOnTag(localClientNum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_left");
			}
			else
			{
				self.leftGlowFx = PlayFXOnTag(localClientNum, roar_effect, self, "tag_head_left");
			}
			self thread margwaStopSmashFx(localClientNum);
			break;
		}
	}
}

/*
	Name: margwaHeadMidCallback
	Namespace: MargwaClientUtils
	Checksum: 0xE539DFDD
	Offset: 0x1638
	Size: 0x3A5
	Parameters: 7
	Flags: Private
*/
function private margwaHeadMidCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(isdefined(self.midGlowFx))
	{
		stopfx(localClientNum, self.midGlowFx);
	}
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newValue)
	{
		case 1:
		{
			self SetAnim("ai_margwa_head_m_open_add", 1, 0.1, 1);
			self ClearAnim("ai_margwa_head_m_closed_add", 0.1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.midGlowFx = PlayFXOnTag(localClientNum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_mid");
			}
			else
			{
				self.midGlowFx = PlayFXOnTag(localClientNum, roar_effect, self, "tag_head_mid");
			}
			break;
		}
		case 2:
		{
			self SetAnim("ai_margwa_head_m_closed_add", 1, 0.1, 1);
			self ClearAnim("ai_margwa_head_m_open_add", 0.1);
			self ClearAnim("ai_margwa_head_m_smash_attack_1", 0.1);
			break;
		}
		case 3:
		{
			self ClearAnim("ai_margwa_head_m_open_add", 0.1);
			self ClearAnim("ai_margwa_head_m_closed_add", 0.1);
			self SetAnimRestart("ai_margwa_head_m_smash_attack_1", 1, 0.1, 1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.midGlowFx = PlayFXOnTag(localClientNum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_mid");
			}
			else
			{
				self.midGlowFx = PlayFXOnTag(localClientNum, roar_effect, self, "tag_head_mid");
			}
			self thread margwaStopSmashFx(localClientNum);
			break;
		}
	}
}

/*
	Name: margwaHeadRightCallback
	Namespace: MargwaClientUtils
	Checksum: 0xC6C44191
	Offset: 0x19E8
	Size: 0x3A5
	Parameters: 7
	Flags: Private
*/
function private margwaHeadRightCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(isdefined(self.rightGlowFx))
	{
		stopfx(localClientNum, self.rightGlowFx);
	}
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newValue)
	{
		case 1:
		{
			self SetAnim("ai_margwa_head_r_open_add", 1, 0.1, 1);
			self ClearAnim("ai_margwa_head_r_closed_add", 0.1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.rightGlowFx = PlayFXOnTag(localClientNum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_right");
			}
			else
			{
				self.rightGlowFx = PlayFXOnTag(localClientNum, roar_effect, self, "tag_head_right");
			}
			break;
		}
		case 2:
		{
			self SetAnim("ai_margwa_head_r_closed_add", 1, 0.1, 1);
			self ClearAnim("ai_margwa_head_r_open_add", 0.1);
			self ClearAnim("ai_margwa_head_r_smash_attack_1", 0.1);
			break;
		}
		case 3:
		{
			self ClearAnim("ai_margwa_head_r_open_add", 0.1);
			self ClearAnim("ai_margwa_head_r_closed_add", 0.1);
			self SetAnimRestart("ai_margwa_head_r_smash_attack_1", 1, 0.1, 1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.rightGlowFx = PlayFXOnTag(localClientNum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_right");
			}
			else
			{
				self.rightGlowFx = PlayFXOnTag(localClientNum, roar_effect, self, "tag_head_right");
			}
			self thread margwaStopSmashFx(localClientNum);
			break;
		}
	}
}

/*
	Name: margwaStopSmashFx
	Namespace: MargwaClientUtils
	Checksum: 0xEDFE9ECD
	Offset: 0x1D98
	Size: 0x9B
	Parameters: 1
	Flags: Private
*/
function private margwaStopSmashFx(localClientNum)
{
	self endon("entityshutdown");
	wait(0.6);
	if(isdefined(self.leftGlowFx))
	{
		stopfx(localClientNum, self.leftGlowFx);
	}
	if(isdefined(self.midGlowFx))
	{
		stopfx(localClientNum, self.midGlowFx);
	}
	if(isdefined(self.rightGlowFx))
	{
		stopfx(localClientNum, self.rightGlowFx);
	}
}

/*
	Name: margwaFxInCallback
	Namespace: MargwaClientUtils
	Checksum: 0x915558A6
	Offset: 0x1E40
	Size: 0x93
	Parameters: 7
	Flags: Private
*/
function private margwaFxInCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		self.teleportFxIn = playFX(localClientNum, level._effect["fx_margwa_teleport_zod_zmb"], self GetTagOrigin("j_spine_1"));
	}
}

/*
	Name: margwaFxOutCallback
	Namespace: MargwaClientUtils
	Checksum: 0xD40F1B8B
	Offset: 0x1EE0
	Size: 0xA3
	Parameters: 7
	Flags: Private
*/
function private margwaFxOutCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		tagPos = self GetTagOrigin("j_spine_1");
		self.teleportFxOut = playFX(localClientNum, level._effect["fx_margwa_teleport_zod_zmb"], tagPos);
	}
}

/*
	Name: margwaFxTravelCallback
	Namespace: MargwaClientUtils
	Checksum: 0x90B68D05
	Offset: 0x1F90
	Size: 0xBD
	Parameters: 7
	Flags: Private
*/
function private margwaFxTravelCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	switch(newValue)
	{
		case 0:
		{
			deletefx(localClientNum, self.travelerFx);
			break;
		}
		case 1:
		{
			self.travelerFx = PlayFXOnTag(localClientNum, level._effect["fx_margwa_teleport_travel_zod_zmb"], self, "tag_origin");
			break;
		}
	}
}

/*
	Name: margwaFxTravelTellCallback
	Namespace: MargwaClientUtils
	Checksum: 0x819F763B
	Offset: 0x2058
	Size: 0xDD
	Parameters: 7
	Flags: Private
*/
function private margwaFxTravelTellCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	switch(newValue)
	{
		case 0:
		{
			deletefx(localClientNum, self.travelerTellFx);
			self notify("stop_margwaTravelTell");
			break;
		}
		case 1:
		{
			self.travelerTellFx = PlayFXOnTag(localClientNum, level._effect["fx_margwa_teleport_tell_zod_zmb"], self, "tag_origin");
			self thread margwaTravelTellUpdate(localClientNum);
			break;
		}
	}
}

/*
	Name: margwaTravelTellUpdate
	Namespace: MargwaClientUtils
	Checksum: 0xAB59EBAC
	Offset: 0x2140
	Size: 0xD7
	Parameters: 1
	Flags: Private
*/
function private margwaTravelTellUpdate(localClientNum)
{
	self notify("stop_margwaTravelTell");
	self endon("stop_margwaTravelTell");
	self endon("entityshutdown");
	player = GetLocalPlayer(localClientNum);
	while(1)
	{
		if(isdefined(player))
		{
			dist_sq = DistanceSquared(player.origin, self.origin);
			if(dist_sq < 1000000)
			{
				player PlayRumbleOnEntity(localClientNum, "tank_rumble");
			}
		}
		wait(0.05);
	}
}

/*
	Name: margwaFxSpawnCallback
	Namespace: MargwaClientUtils
	Checksum: 0x477C632A
	Offset: 0x2220
	Size: 0x113
	Parameters: 7
	Flags: Private
*/
function private margwaFxSpawnCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		spawnFx = level._effect["fx_margwa_teleport_intro_zod_zmb"];
		if(isdefined(self.margwa_spawn_effect))
		{
			spawnFx = self.margwa_spawn_effect;
		}
		if(isdefined(self.margwa_play_spawn_effect))
		{
			self thread [[self.margwa_play_spawn_effect]](localClientNum);
		}
		else
		{
			self.spawnFx = playFX(localClientNum, spawnFx, self GetTagOrigin("j_spine_1"));
		}
		playsound(0, "zmb_margwa_spawn", self GetTagOrigin("j_spine_1"));
	}
}

/*
	Name: margwaHeadExplosion
	Namespace: MargwaClientUtils
	Checksum: 0x54ECFD4E
	Offset: 0x2340
	Size: 0x63
	Parameters: 7
	Flags: Private
*/
function private margwaHeadExplosion(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		self postfx::playPostfxBundle("pstfx_parasite_dmg");
	}
}

/*
	Name: margwaProcessFootstep
	Namespace: MargwaClientUtils
	Checksum: 0xC39DCBF6
	Offset: 0x23B0
	Size: 0x20B
	Parameters: 5
	Flags: None
*/
function margwaProcessFootstep(localClientNum, pos, surface, Notetrack, bone)
{
	e_player = GetLocalPlayer(localClientNum);
	n_dist = DistanceSquared(pos, e_player.origin);
	n_margwa_dist = GetDvarInt("scr_margwa_footstep_eq_radius", 1000) * GetDvarInt("scr_margwa_footstep_eq_radius", 1000);
	if(n_margwa_dist > 0)
	{
		n_scale = n_margwa_dist - n_dist / n_margwa_dist;
	}
	else
	{
		return;
	}
	if(n_scale > 1 || n_scale < 0)
	{
		return;
	}
	n_scale = n_scale * 0.25;
	if(n_scale <= 0.01)
	{
		return;
	}
	e_player Earthquake(n_scale, 0.1, pos, n_dist);
	if(n_scale <= 0.25 && n_scale > 0.2)
	{
		e_player PlayRumbleOnEntity(localClientNum, "shotgun_fire");
	}
	else if(n_scale <= 0.2 && n_scale > 0.1)
	{
		e_player PlayRumbleOnEntity(localClientNum, "damage_heavy");
	}
	else
	{
		e_player PlayRumbleOnEntity(localClientNum, "reload_small");
	}
}

/*
	Name: margwaSmashCallback
	Namespace: MargwaClientUtils
	Checksum: 0x61E8731C
	Offset: 0x25C8
	Size: 0x193
	Parameters: 7
	Flags: Private
*/
function private margwaSmashCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		e_player = GetLocalPlayer(localClientNum);
		smashPos = self.origin + VectorScale(AnglesToForward(self.angles), 60);
		distSq = DistanceSquared(smashPos, e_player.origin);
		if(distSq < 20736)
		{
			e_player Earthquake(0.7, 0.25, e_player.origin, 3000);
			e_player PlayRumbleOnEntity(localClientNum, "shotgun_fire");
		}
		else if(distSq < 36864)
		{
			e_player Earthquake(0.7, 0.25, e_player.origin, 1500);
			e_player PlayRumbleOnEntity(localClientNum, "damage_heavy");
		}
	}
}

/*
	Name: margwaLeftHitCallback
	Namespace: MargwaClientUtils
	Checksum: 0xF2B2D95
	Offset: 0x2768
	Size: 0xAB
	Parameters: 7
	Flags: Private
*/
function private margwaLeftHitCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		effect = level._effect["fx_margwa_head_shot_zod_zmb"];
		if(isdefined(self.margwa_head_hit_fx))
		{
			effect = self.margwa_head_hit_fx;
		}
		self.leftHitFx = PlayFXOnTag(localClientNum, effect, self, "tag_head_left");
	}
}

/*
	Name: margwaMidHitCallback
	Namespace: MargwaClientUtils
	Checksum: 0x42A9F94F
	Offset: 0x2820
	Size: 0xAB
	Parameters: 7
	Flags: Private
*/
function private margwaMidHitCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		effect = level._effect["fx_margwa_head_shot_zod_zmb"];
		if(isdefined(self.margwa_head_hit_fx))
		{
			effect = self.margwa_head_hit_fx;
		}
		self.midHitFx = PlayFXOnTag(localClientNum, effect, self, "tag_head_mid");
	}
}

/*
	Name: margwaRightHitCallback
	Namespace: MargwaClientUtils
	Checksum: 0xE19FCFAF
	Offset: 0x28D8
	Size: 0xAB
	Parameters: 7
	Flags: Private
*/
function private margwaRightHitCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		effect = level._effect["fx_margwa_head_shot_zod_zmb"];
		if(isdefined(self.margwa_head_hit_fx))
		{
			effect = self.margwa_head_hit_fx;
		}
		self.rightHitFx = PlayFXOnTag(localClientNum, effect, self, "tag_head_right");
	}
}

/*
	Name: margwaHeadKilledCallback
	Namespace: MargwaClientUtils
	Checksum: 0x3C4188
	Offset: 0x2990
	Size: 0x5F
	Parameters: 7
	Flags: Private
*/
function private margwaHeadKilledCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		self.heads[newValue].killed = 1;
	}
}

/*
	Name: margwaJawCallback
	Namespace: MargwaClientUtils
	Checksum: 0x94DDD068
	Offset: 0x29F8
	Size: 0x1C1
	Parameters: 7
	Flags: Private
*/
function private margwaJawCallback(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		foreach(head in self.heads)
		{
			if(isdefined(head.killed) && head.killed)
			{
				if(isdefined(head.prevJawAnim))
				{
					self ClearAnim(head.prevJawAnim, 0.2);
				}
				if(isdefined(head.prevHeadAnim))
				{
					self ClearAnim(head.prevHeadAnim, 0.1);
				}
				jawAnim = head.jawBase + level._jaw[newValue];
				head.prevJawAnim = jawAnim;
				self SetAnim(jawAnim, 1, 0.2, 1);
			}
		}
	}
}

