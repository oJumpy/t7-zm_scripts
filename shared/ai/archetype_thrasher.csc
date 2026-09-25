#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace archetype_thrasher;

/*
	Name: __init__sytem__
	Namespace: archetype_thrasher
	Checksum: 0xB33A4207
	Offset: 0x608
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("thrasher", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: archetype_thrasher
	Checksum: 0x383E2169
	Offset: 0x648
	Size: 0x27B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_visionset_info("zm_isl_thrasher_stomach_visionset", 9000, 16, undefined, "zm_isl_thrasher_stomach");
	if(ai::shouldRegisterClientFieldForArchetype("thrasher"))
	{
		clientfield::register("actor", "thrasher_spore_state", 5000, 3, "int", &ThrasherClientUtils::thrasherSporeExplode, 0, 0);
		clientfield::register("actor", "thrasher_berserk_state", 5000, 1, "int", &ThrasherClientUtils::thrasherBerserkMode, 0, 1);
		clientfield::register("actor", "thrasher_player_hide", 8000, 4, "int", &ThrasherClientUtils::thrasherHideFromPlayer, 0, 0);
		clientfield::register("toplayer", "sndPlayerConsumed", 10000, 1, "int", &ThrasherClientUtils::sndPlayerConsumed, 0, 1);
		foreach(spore in Array(1, 2, 4))
		{
			clientfield::register("actor", "thrasher_spore_impact" + spore, 8000, 1, "counter", &ThrasherClientUtils::thrasherSporeImpact, 0, 0);
		}
	}
	ai::add_archetype_spawn_function("thrasher", &ThrasherClientUtils::thrasherSpawn);
	level.thrasherPustules = [];
	level thread ThrasherClientUtils::thrasherFxCleanup();
}

/*
	Name: Precache
	Namespace: archetype_thrasher
	Checksum: 0x19BF02CF
	Offset: 0x8D0
	Size: 0x189
	Parameters: 0
	Flags: AutoExec
*/
function autoexec Precache()
{
	level._effect["fx_mech_foot_step"] = "dlc1/castle/fx_mech_foot_step";
	level._effect["fx_thrash_pustule_burst"] = "dlc2/island/fx_thrash_pustule_burst";
	level._effect["fx_thrash_pustule_spore_exp"] = "dlc2/island/fx_thrash_pustule_spore_exp";
	level._effect["fx_thrash_pustule_impact"] = "dlc2/island/fx_thrash_pustule_impact";
	level._effect["fx_thrash_eye_glow"] = "dlc2/island/fx_thrash_eye_glow";
	level._effect["fx_thrash_eye_glow_rage"] = "dlc2/island/fx_thrash_eye_glow_rage";
	level._effect["fx_thrash_rage_gas_torso"] = "dlc2/island/fx_thrash_rage_gas_torso";
	level._effect["fx_thrash_rage_gas_leg_lft"] = "dlc2/island/fx_thrash_rage_gas_leg_lft";
	level._effect["fx_thrash_rage_gas_leg_rgt"] = "dlc2/island/fx_thrash_rage_gas_leg_rgt";
	level._effect["fx_thrash_pustule_reinflate"] = "dlc2/island/fx_thrash_pustule_reinflate";
	level._effect["fx_spores_cloud_ambient_sm"] = "dlc2/island/fx_spores_cloud_ambient_sm";
	level._effect["fx_spores_cloud_ambient_md"] = "dlc2/island/fx_spores_cloud_ambient_md";
	level._effect["fx_spores_cloud_ambient_lrg"] = "dlc2/island/fx_thrash_pustule_reinflate";
	level._effect["fx_thrash_chest_mouth_drool"] = "dlc2/island/fx_thrash_chest_mouth_drool_1p";
}

#namespace ThrasherClientUtils;

/*
	Name: thrasherSpawn
	Namespace: ThrasherClientUtils
	Checksum: 0x7CEA4E7F
	Offset: 0xA68
	Size: 0x7B
	Parameters: 1
	Flags: Private
*/
function private thrasherSpawn(localClientNum)
{
	entity = self;
	entity.ignoreRagdoll = 1;
	level._footstepCBFuncs[entity.archetype] = &thrasherProcessFootstep;
	GibClientUtils::AddGibCallback(localClientNum, entity, 4, &thrasherDisableEyeGlow);
}

/*
	Name: thrasherFxCleanup
	Namespace: ThrasherClientUtils
	Checksum: 0xE3631728
	Offset: 0xAF0
	Size: 0x127
	Parameters: 0
	Flags: Private
*/
function private thrasherFxCleanup()
{
	while(1)
	{
		pustules = level.thrasherPustules;
		level.thrasherPustules = [];
		time = GetTime();
		foreach(pustule in pustules)
		{
			if(pustule.endTime <= time)
			{
				if(isdefined(pustule.FX))
				{
					stopfx(pustule.localClientNum, pustule.FX);
				}
				continue;
			}
			level.thrasherPustules[level.thrasherPustules.size] = pustule;
		}
		wait(0.5);
	}
}

/*
	Name: thrasherProcessFootstep
	Namespace: ThrasherClientUtils
	Checksum: 0x15B8197D
	Offset: 0xC20
	Size: 0x24B
	Parameters: 5
	Flags: None
*/
function thrasherProcessFootstep(localClientNum, pos, surface, Notetrack, bone)
{
	e_player = GetLocalPlayer(localClientNum);
	n_dist = DistanceSquared(pos, e_player.origin);
	n_thrasher_dist = 1000000;
	if(n_thrasher_dist <= 0)
	{
		return;
	}
	n_scale = n_thrasher_dist - n_dist / n_thrasher_dist;
	if(n_scale > 1 || n_scale < 0 || n_scale <= 0.01)
	{
		return;
	}
	FX = PlayFXOnTag(localClientNum, level._effect["fx_mech_foot_step"], self, bone);
	if(isdefined(e_player.thrasherLastFootstep) && e_player.thrasherLastFootstep + 400 > GetTime())
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
		e_player PlayRumbleOnEntity(localClientNum, "reload_small");
	}
	e_player.thrasherLastFootstep = GetTime();
}

/*
	Name: _StopFx
	Namespace: ThrasherClientUtils
	Checksum: 0x83A90997
	Offset: 0xE78
	Size: 0x3B
	Parameters: 2
	Flags: Private
*/
function private _StopFx(localClientNum, effect)
{
	if(isdefined(effect))
	{
		stopfx(localClientNum, effect);
	}
}

/*
	Name: thrasherHideFromPlayer
	Namespace: ThrasherClientUtils
	Checksum: 0xF7490221
	Offset: 0xEC0
	Size: 0x12B
	Parameters: 7
	Flags: Private
*/
function private thrasherHideFromPlayer(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(!isdefined(entity) || entity.archetype !== "thrasher" || !entity hasdobj(localClientNum))
	{
		return;
	}
	localPlayer = GetLocalPlayer(localClientNum);
	localPlayerNum = localPlayer GetEntityNumber();
	localPlayerBit = 1 << localPlayerNum;
	if(localPlayerBit & newValue)
	{
		entity Hide();
	}
	else
	{
		entity show();
	}
}

/*
	Name: thrasherBerserkMode
	Namespace: ThrasherClientUtils
	Checksum: 0x13DE531F
	Offset: 0xFF8
	Size: 0x301
	Parameters: 7
	Flags: Private
*/
function private thrasherBerserkMode(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	if(!isdefined(entity) || entity.archetype !== "thrasher" || !entity hasdobj(localClientNum))
	{
		return;
	}
	_StopFx(localClientNum, entity.thrasherEyeGlow);
	entity.thrasherEyeGlow = undefined;
	_StopFx(localClientNum, entity.thrasherAmbientFX1);
	entity.thrasherAmbientFX1 = undefined;
	_StopFx(localClientNum, entity.thrasherAmbientFX2);
	entity.thrasherAmbientFX2 = undefined;
	_StopFx(localClientNum, entity.thrasherAmbientFX3);
	entity.thrasherAmbientFX3 = undefined;
	hasHead = !GibClientUtils::IsGibbed(localClientNum, entity, 4);
	switch(newValue)
	{
		case 0:
		{
			if(hasHead)
			{
				entity.thrasherEyeGlow = PlayFXOnTag(localClientNum, level._effect["fx_thrash_eye_glow"], entity, "j_eyeball_le");
			}
			break;
		}
		case 1:
		{
			if(hasHead)
			{
				entity.thrasherEyeGlow = PlayFXOnTag(localClientNum, level._effect["fx_thrash_eye_glow_rage"], entity, "j_eyeball_le");
			}
			entity.thrasherAmbientFX1 = PlayFXOnTag(localClientNum, level._effect["fx_thrash_rage_gas_torso"], entity, "j_spinelower");
			entity.thrasherAmbientFX2 = PlayFXOnTag(localClientNum, level._effect["fx_thrash_rage_gas_leg_lft"], entity, "j_hip_le");
			entity.thrasherAmbientFX3 = PlayFXOnTag(localClientNum, level._effect["fx_thrash_rage_gas_leg_rgt"], entity, "j_hip_ri");
			break;
		}
	}
}

/*
	Name: thrasherSporeExplode
	Namespace: ThrasherClientUtils
	Checksum: 0xD3BB5BB1
	Offset: 0x1308
	Size: 0x36F
	Parameters: 7
	Flags: Private
*/
function private thrasherSporeExplode(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	sporeClientfields = Array(1, 2, 4);
	sporeTags = Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg");
	~sporeTags;
	newSporesExploded = oldValue ^ newValue & oldValue;
	~newSporesExploded;
	oldSporesInflated = oldValue ^ newValue & newValue;
	currentSpore = sporeClientfields[0];
	for(index = 0; index < Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg").size; index++)
	{
		sporeTag = sporeTags[index];
		pustuleInfo = undefined;
		if(newSporesExploded & currentSpore)
		{
			PlayFXOnTag(localClientNum, level._effect["fx_thrash_pustule_burst"], entity, sporeTag);
			PlayFXOnTag(localClientNum, level._effect["fx_thrash_pustule_spore_exp"], entity, sporeTag);
			pustuleInfo = spawnstruct();
			pustuleInfo.length = 5000;
			if(!(isdefined(level.b_thrasher_custom_spore_fx) && level.b_thrasher_custom_spore_fx))
			{
				pustuleInfo.FX = playFX(localClientNum, level._effect["fx_spores_cloud_ambient_md"], entity GetTagOrigin(sporeTag));
			}
		}
		else if(oldSporesInflated & currentSpore)
		{
			pustuleInfo = spawnstruct();
			pustuleInfo.length = 2000;
			pustuleInfo.FX = PlayFXOnTag(localClientNum, level._effect["fx_thrash_pustule_reinflate"], entity, sporeTag);
		}
		if(isdefined(pustuleInfo))
		{
			pustuleInfo.localClientNum = localClientNum;
			pustuleInfo.startTime = GetTime();
			pustuleInfo.endTime = pustuleInfo.startTime + pustuleInfo.length;
			level.thrasherPustules[level.thrasherPustules.size] = pustuleInfo;
		}
		currentSpore = currentSpore << 1;
	}
}

/*
	Name: thrasherSporeImpact
	Namespace: ThrasherClientUtils
	Checksum: 0x6754384
	Offset: 0x1680
	Size: 0x183
	Parameters: 7
	Flags: Private
*/
function private thrasherSporeImpact(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	entity = self;
	sporeTag = undefined;
	sporeClientfields = Array(1, 2, 4);
	/#
		Assert(sporeClientfields.size == Array("Dev Block strings are not supported", "Dev Block strings are not supported", "Dev Block strings are not supported").size);
	#/
	for(index = 0; index < sporeClientfields.size; index++)
	{
		if(fieldName == "thrasher_spore_impact" + sporeClientfields[index])
		{
			sporeTag = Array("tag_spore_chest", "tag_spore_back", "tag_spore_leg")[index];
			break;
		}
	}
	if(isdefined(sporeTag))
	{
		PlayFXOnTag(localClientNum, level._effect["fx_thrash_pustule_impact"], entity, sporeTag);
	}
}

/*
	Name: thrasherDisableEyeGlow
	Namespace: ThrasherClientUtils
	Checksum: 0xD48CD263
	Offset: 0x1810
	Size: 0x91
	Parameters: 3
	Flags: Private
*/
function private thrasherDisableEyeGlow(localClientNum, entity, gibFlag)
{
	if(!isdefined(entity) || entity.archetype !== "thrasher" || !entity hasdobj(localClientNum))
	{
		return;
	}
	_StopFx(localClientNum, entity.thrasherEyeGlow);
	entity.thrasherEyeGlow = undefined;
}

/*
	Name: sndPlayerConsumed
	Namespace: ThrasherClientUtils
	Checksum: 0x10D145C6
	Offset: 0x18B0
	Size: 0x1DB
	Parameters: 7
	Flags: Private
*/
function private sndPlayerConsumed(localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump)
{
	if(newValue)
	{
		if(!isdefined(self.sndPlayerConsumedID))
		{
			self.sndPlayerConsumedID = self PlayLoopSound("zmb_thrasher_consumed_lp", 5);
		}
		if(!isdefined(self.n_fx_id_player_consumed))
		{
			self.n_fx_id_player_consumed = PlayFXOnCamera(localClientNum, level._effect["fx_thrash_chest_mouth_drool"]);
		}
		self thread postfx::playPostfxBundle("pstfx_thrasher_stomach");
		EnableSpeedBlur(localClientNum, 0.07, 0.55, 0.9, 0, 100, 100);
	}
	else if(isdefined(self.sndPlayerConsumedID))
	{
		self StopLoopSound(self.sndPlayerConsumedID, 0.5);
		self.sndPlayerConsumedID = undefined;
	}
	if(isdefined(self.n_fx_id_player_consumed))
	{
		stopfx(localClientNum, self.n_fx_id_player_consumed);
		self.n_fx_id_player_consumed = undefined;
	}
	self StopAllLoopSounds(1);
	if(isdefined(self.playingPostfxBundle))
	{
		self thread postfx::stopPlayingPostfxBundle();
	}
	DisableSpeedBlur(localClientNum);
}

