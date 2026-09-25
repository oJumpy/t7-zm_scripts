#using scripts\codescripts\struct;
#using scripts\shared\abilities\gadgets\_gadget_camo_render;
#using scripts\shared\abilities\gadgets\_gadget_clone_render;
#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\animation_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace end_game_taunts;

/*
	Name: __init__sytem__
	Namespace: end_game_taunts
	Checksum: 0x807E8586
	Offset: 0x20D0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("end_game_taunts", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: end_game_taunts
	Checksum: 0x8780258C
	Offset: 0x2110
	Size: 0x3A3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	animation::add_notetrack_func("taunts::hide", &hideModel);
	animation::add_notetrack_func("taunts::show", &showModel);
	animation::add_notetrack_func("taunts::cloneshaderon", &cloneShaderOn);
	animation::add_notetrack_func("taunts::cloneshaderoff", &cloneShaderOff);
	animation::add_notetrack_func("taunts::camoshaderon", &camoShaderOn);
	animation::add_notetrack_func("taunts::camoshaderoff", &camoShaderOff);
	animation::add_notetrack_func("taunts::spawncameraglass", &spawnCameraGlass);
	animation::add_notetrack_func("taunts::deletecameraglass", &deleteCameraGlass);
	animation::add_notetrack_func("taunts::reaperbulletglass", &reaperBulletGlass);
	animation::add_notetrack_func("taunts::centerbulletglass", &centerBulletGlass);
	animation::add_notetrack_func("taunts::talonbulletglassleft", &talonBulletGlassLeft);
	animation::add_notetrack_func("taunts::talonbulletglassright", &talonBulletGlassRight);
	animation::add_notetrack_func("taunts::fireweapon", &FireWeapon);
	animation::add_notetrack_func("taunts::stopfireweapon", &stopFireWeapon);
	animation::add_notetrack_func("taunts::firebeam", &fireBeam);
	animation::add_notetrack_func("taunts::stopfirebeam", &stopFireBeam);
	animation::add_notetrack_func("taunts::playwinnerteamfx", &playWinnerTeamFx);
	animation::add_notetrack_func("taunts::playlocalteamfx", &playLocalTeamFx);
	level.epicTauntXModels = Array("gfx_p7_zm_asc_data_recorder_glass", "wpn_t7_hero_reaper_minigun_prop", "wpn_t7_loot_hero_reaper3_minigun_prop", "c_zsf_robot_grunt_body", "c_zsf_robot_grunt_head", "veh_t7_drone_raps_mp_lite", "veh_t7_drone_raps_mp_dark", "veh_t7_drone_attack_gun_litecolor", "veh_t7_drone_attack_gun_darkcolor", "wpn_t7_arm_blade_prop", "wpn_t7_hero_annihilator_prop", "wpn_t7_hero_bow_prop", "wpn_t7_hero_electro_prop_animate", "wpn_t7_hero_flamethrower_world", "wpn_t7_hero_mgl_world", "wpn_t7_hero_mgl_prop", "wpn_t7_hero_spike_prop", "wpn_t7_hero_seraph_machete_prop", "wpn_t7_loot_crowbar_world", "wpn_t7_spider_mine_world", "wpn_t7_zmb_katana_prop");
	stop_stream_epic_models();
}

/*
	Name: check_force_taunt
	Namespace: end_game_taunts
	Checksum: 0x7542072F
	Offset: 0x24C0
	Size: 0x237
	Parameters: 0
	Flags: None
*/
function check_force_taunt()
{
	/#
		while(1)
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(0.05);
			taunt = GetDvarString("Dev Block strings are not supported");
			if(taunt == "Dev Block strings are not supported")
			{
				continue;
			}
			model = level.topPlayerCharacters[0];
			if(!isdefined(model) || isdefined(model.playingTaunt) || (isdefined(model.playingGesture) && model.playingGesture))
			{
				continue;
			}
			bodyType = GetDvarInt("Dev Block strings are not supported", -1);
			SetDvar("Dev Block strings are not supported", -1);
			if(bodyType >= 0)
			{
				tauntModel = spawn_temp_specialist_model(model.localClientNum, bodyType, model.origin, model.angles, model.showcaseWeapon);
				model Hide();
			}
			else
			{
				tauntModel = model;
			}
			idleAnimName = getidleanimname(model.localClientNum, model, 0);
			playTaunt(model.localClientNum, tauntModel, 0, idleAnimName, taunt);
			if(tauntModel != model)
			{
				tauntModel delete();
				model show();
			}
		}
	#/
}

/*
	Name: check_force_gesture
	Namespace: end_game_taunts
	Checksum: 0x3007C725
	Offset: 0x2700
	Size: 0x13F
	Parameters: 0
	Flags: None
*/
function check_force_gesture()
{
	/#
		while(1)
		{
			SetDvar("Dev Block strings are not supported", "Dev Block strings are not supported");
			wait(0.05);
			gesture = GetDvarString("Dev Block strings are not supported");
			if(gesture == "Dev Block strings are not supported")
			{
				continue;
			}
			model = level.topPlayerCharacters[0];
			if(!isdefined(model) || isdefined(model.playingTaunt) || (isdefined(model.playingGesture) && model.playingGesture))
			{
				continue;
			}
			idleAnimName = getidleanimname(model.localClientNum, model, 0);
			playGesture(model.localClientNum, model, 0, idleAnimName, gesture, 1);
		}
	#/
}

/*
	Name: draw_runner_up_bounds
	Namespace: end_game_taunts
	Checksum: 0x7143C398
	Offset: 0x2848
	Size: 0xD9
	Parameters: 0
	Flags: None
*/
function draw_runner_up_bounds()
{
	/#
		while(1)
		{
			wait(0.016);
			if(!GetDvarInt("Dev Block strings are not supported", 0))
			{
				continue;
			}
			for(i = 1; i < 3; i++)
			{
				model = level.topPlayerCharacters[i];
				box(model.origin, VectorScale((-1, -1, 0), 15), (15, 15, 72), model.angles[1], (0, 0, 1), 0, 1);
			}
		}
	#/
}

/*
	Name: spawn_temp_specialist_model
	Namespace: end_game_taunts
	Checksum: 0x37198B44
	Offset: 0x2930
	Size: 0x211
	Parameters: 5
	Flags: None
*/
function spawn_temp_specialist_model(localClientNum, characterindex, origin, angles, showcaseWeapon)
{
	/#
		tempModel = spawn(localClientNum, origin, "Dev Block strings are not supported");
		tempModel.angles = angles;
		tempModel.showcaseWeapon = showcaseWeapon;
		tempModel.bodyModel = GetCharacterBodyModel(characterindex, 0, CurrentSessionMode());
		tempModel.helmetModel = GetCharacterHelmetModel(characterindex, 0, CurrentSessionMode());
		tempModel SetModel(tempModel.bodyModel);
		tempModel Attach(tempModel.helmetModel, "Dev Block strings are not supported");
		tempModel.modeRenderOptions = GetCharacterModeRenderOptions(CurrentSessionMode());
		tempModel.bodyRenderOptions = GetCharacterBodyRenderOptions(characterindex, 0, 0, 0, 0);
		tempModel.helmetRenderOptions = GetCharacterHelmetRenderOptions(characterindex, 0, 0, 0, 0);
		tempModel SetBodyRenderOptions(tempModel.modeRenderOptions, tempModel.bodyRenderOptions, tempModel.helmetRenderOptions, tempModel.helmetRenderOptions);
		return tempModel;
	#/
}

/*
	Name: playCurrentTaunt
	Namespace: end_game_taunts
	Checksum: 0x2984B9C6
	Offset: 0x2B50
	Size: 0x93
	Parameters: 3
	Flags: None
*/
function playCurrentTaunt(localClientNum, characterModel, topPlayerIndex)
{
	tauntAnimName = GetTopPlayersTaunt(localClientNum, topPlayerIndex, 0);
	idleAnimName = getidleanimname(localClientNum, characterModel, topPlayerIndex);
	playTaunt(localClientNum, characterModel, topPlayerIndex, idleAnimName, tauntAnimName);
}

/*
	Name: previewTaunt
	Namespace: end_game_taunts
	Checksum: 0xF74C229
	Offset: 0x2BF0
	Size: 0x7B
	Parameters: 4
	Flags: None
*/
function previewTaunt(localClientNum, characterModel, idleAnimName, tauntAnimName)
{
	cancelGesture(characterModel);
	deleteCameraGlass(undefined);
	playTaunt(localClientNum, characterModel, 0, idleAnimName, tauntAnimName, 0, 0);
}

/*
	Name: playTaunt
	Namespace: end_game_taunts
	Checksum: 0x2BF2E78C
	Offset: 0x2C78
	Size: 0x29B
	Parameters: 7
	Flags: None
*/
function playTaunt(localClientNum, characterModel, topPlayerIndex, idleAnimName, tauntAnimName, toTauntBlendTime, playTransitions)
{
	if(!isdefined(toTauntBlendTime))
	{
		toTauntBlendTime = 0;
	}
	if(!isdefined(playTransitions))
	{
		playTransitions = 1;
	}
	if(!isdefined(tauntAnimName) || tauntAnimName == "")
	{
		return;
	}
	cancelTaunt(localClientNum, characterModel);
	characterModel stopsounds();
	characterModel endon("cancelTaunt");
	characterModel util::waittill_dobj(localClientNum);
	if(!characterModel HasAnimTree())
	{
		characterModel useanimtree(-1);
	}
	characterModel.playingTaunt = tauntAnimName;
	characterModel notify("tauntStarted");
	characterModel ClearAnim(idleAnimName, toTauntBlendTime);
	idleInAnimName = getIdleInAnimName(characterModel, topPlayerIndex);
	hideWeapon(characterModel);
	characterModel thread playEpicTauntScene(localClientNum, tauntAnimName);
	characterModel animation::Play(tauntAnimName, undefined, undefined, 1, toTauntBlendTime, 0.4);
	if(isdefined(playTransitions) && playTransitions)
	{
		self thread waitAppearWeapon(characterModel);
		playTransitionAnim(characterModel, idleInAnimName, 0.4, 0.4);
	}
	showWeapon(characterModel);
	characterModel thread animation::Play(idleAnimName, undefined, undefined, 1, 0.4, 0);
	characterModel.playingTaunt = undefined;
	characterModel notify("tauntFinished");
	characterModel shutdownEpicTauntModels();
}

/*
	Name: cancelTaunt
	Namespace: end_game_taunts
	Checksum: 0x2BFB978A
	Offset: 0x2F20
	Size: 0xBD
	Parameters: 2
	Flags: None
*/
function cancelTaunt(localClientNum, characterModel)
{
	if(isdefined(characterModel.playingTaunt))
	{
		characterModel cloneShaderOff();
		characterModel shutdownEpicTauntModels();
		characterModel stopEpicTauntScene(localClientNum, characterModel.playingTaunt);
		characterModel stopsounds();
	}
	characterModel notify("cancelTaunt");
	characterModel.playingTaunt = undefined;
	characterModel.epicTauntModels = undefined;
}

/*
	Name: playGestureType
	Namespace: end_game_taunts
	Checksum: 0x2AD0302C
	Offset: 0x2FE8
	Size: 0x9B
	Parameters: 4
	Flags: None
*/
function playGestureType(localClientNum, characterModel, topPlayerIndex, gestureType)
{
	idleAnimName = getidleanimname(localClientNum, characterModel, topPlayerIndex);
	gestureAnimName = GetTopPlayersGesture(localClientNum, topPlayerIndex, gestureType);
	playGesture(localClientNum, characterModel, topPlayerIndex, idleAnimName, gestureAnimName);
}

/*
	Name: previewGesture
	Namespace: end_game_taunts
	Checksum: 0xF2F74FE6
	Offset: 0x3090
	Size: 0x7B
	Parameters: 4
	Flags: None
*/
function previewGesture(localClientNum, characterModel, idleAnimName, gestureAnimName)
{
	cancelTaunt(localClientNum, characterModel);
	deleteCameraGlass(undefined);
	playGesture(localClientNum, characterModel, 0, idleAnimName, gestureAnimName, 0);
}

/*
	Name: playGesture
	Namespace: end_game_taunts
	Checksum: 0x7E7752DC
	Offset: 0x3118
	Size: 0x2BB
	Parameters: 6
	Flags: None
*/
function playGesture(localClientNum, characterModel, topPlayerIndex, idleAnimName, gestureAnimName, playTransitions)
{
	if(!isdefined(playTransitions))
	{
		playTransitions = 1;
	}
	if(!isdefined(gestureAnimName) || gestureAnimName == "")
	{
		return;
	}
	cancelGesture(characterModel);
	characterModel endon("cancelGesture");
	characterModel util::waittill_dobj(localClientNum);
	if(!characterModel HasAnimTree())
	{
		characterModel useanimtree(-1);
	}
	characterModel.playingGesture = 1;
	characterModel notify("gestureStarted");
	characterModel ClearAnim(idleAnimName, 0.4);
	idleOutAnimName = getIdleOutAnimName(characterModel, topPlayerIndex);
	idleInAnimName = getIdleInAnimName(characterModel, topPlayerIndex);
	if(isdefined(playTransitions) && playTransitions)
	{
		self thread waitRemoveWeapon(characterModel);
		playTransitionAnim(characterModel, idleOutAnimName, 0.4, 0.4);
	}
	hideWeapon(characterModel);
	characterModel animation::Play(gestureAnimName, undefined, undefined, 1, 0.4, 0.4);
	if(isdefined(playTransitions) && playTransitions)
	{
		self thread waitAppearWeapon(characterModel);
		playTransitionAnim(characterModel, idleInAnimName, 0.4, 0.4);
	}
	showWeapon(characterModel);
	characterModel thread animation::Play(idleAnimName, undefined, undefined, 1, 0.4, 0);
	characterModel.playingGesture = 0;
	characterModel notify("gestureFinished");
}

/*
	Name: cancelGesture
	Namespace: end_game_taunts
	Checksum: 0x1FCD374E
	Offset: 0x33E0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function cancelGesture(characterModel)
{
	characterModel notify("cancelGesture");
	characterModel.playingGesture = 0;
}

/*
	Name: playTransitionAnim
	Namespace: end_game_taunts
	Checksum: 0xBA3E102C
	Offset: 0x3418
	Size: 0x9B
	Parameters: 4
	Flags: None
*/
function playTransitionAnim(characterModel, transitionAnimName, blendInTime, blendOutTime)
{
	if(!isdefined(blendInTime))
	{
		blendInTime = 0;
	}
	if(!isdefined(blendOutTime))
	{
		blendOutTime = 0;
	}
	characterModel endon("cancelTaunt");
	if(!isdefined(transitionAnimName) || transitionAnimName == "")
	{
		return;
	}
	characterModel animation::Play(transitionAnimName, undefined, undefined, 1, blendInTime, blendOutTime);
}

/*
	Name: waitRemoveWeapon
	Namespace: end_game_taunts
	Checksum: 0x2B49BBC0
	Offset: 0x34C0
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function waitRemoveWeapon(characterModel)
{
	characterModel endon("weaponHidden");
	while(1)
	{
		characterModel waittill("_anim_notify_", param1);
		if(param1 == "remove_from_hand")
		{
			hideWeapon(characterModel);
			return;
		}
	}
}

/*
	Name: waitAppearWeapon
	Namespace: end_game_taunts
	Checksum: 0xDF6FA944
	Offset: 0x3538
	Size: 0x69
	Parameters: 1
	Flags: None
*/
function waitAppearWeapon(characterModel)
{
	characterModel endon("weaponShown");
	while(1)
	{
		characterModel waittill("_anim_notify_", param1);
		if(param1 == "appear_in_hand")
		{
			showWeapon(characterModel);
			return;
		}
	}
}

/*
	Name: hideWeapon
	Namespace: end_game_taunts
	Checksum: 0x866CEE6A
	Offset: 0x35B0
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function hideWeapon(characterModel)
{
	if(characterModel.weapon == level.weaponNone)
	{
		return;
	}
	MarkAsDirty(characterModel);
	characterModel AttachWeapon(level.weaponNone);
	characterModel UseWeaponHideTags(level.weaponNone);
	characterModel notify("weaponHidden");
}

/*
	Name: showWeapon
	Namespace: end_game_taunts
	Checksum: 0xE9F9F1EB
	Offset: 0x3650
	Size: 0xFB
	Parameters: 1
	Flags: None
*/
function showWeapon(characterModel)
{
	if(!isdefined(characterModel.showcaseWeapon) || characterModel.weapon != level.weaponNone)
	{
		return;
	}
	MarkAsDirty(characterModel);
	if(isdefined(characterModel.showcaseWeaponRenderOptions))
	{
		characterModel AttachWeapon(characterModel.showcaseWeapon, characterModel.showcaseWeaponRenderOptions, characterModel.showcaseWeaponACVI);
		characterModel UseWeaponHideTags(characterModel.showcaseWeapon);
	}
	else
	{
		characterModel AttachWeapon(characterModel.showcaseWeapon);
	}
	characterModel notify("weaponShown");
}

/*
	Name: getidleanimname
	Namespace: end_game_taunts
	Checksum: 0xFAF2F370
	Offset: 0x3758
	Size: 0x10AD
	Parameters: 3
	Flags: None
*/
function getidleanimname(localClientNum, characterModel, topPlayerIndex)
{
	if(isdefined(characterModel.weapon))
	{
		weapon_group = GetItemGroupForWeaponName(characterModel.weapon.rootweapon.name);
		if(weapon_group == "weapon_launcher")
		{
			if(characterModel.weapon.rootweapon.name == "launcher_lockonly" || characterModel.weapon.rootweapon.name == "launcher_multi")
			{
				weapon_group = "weapon_launcher_alt";
			}
			else if(characterModel.weapon.rootweapon.name == "launcher_ex41")
			{
				weapon_group = "weapon_smg_ppsh";
			}
		}
		else if(weapon_group == "weapon_pistol" && characterModel.weapon.isDualWield)
		{
			weapon_group = "weapon_pistol_dw";
		}
		else if(weapon_group == "weapon_smg")
		{
			if(characterModel.weapon.rootweapon.name == "smg_ppsh")
			{
				weapon_group = "weapon_smg_ppsh";
			}
		}
		else if(weapon_group == "weapon_cqb")
		{
			if(characterModel.weapon.rootweapon.name == "shotgun_olympia")
			{
				weapon_group = "weapon_smg_ppsh";
			}
		}
		else if(weapon_group == "weapon_special")
		{
			if(characterModel.weapon.rootweapon.name == "special_crossbow" || characterModel.weapon.rootweapon.name == "special_discgun")
			{
				weapon_group = "weapon_smg";
			}
			else if(characterModel.weapon.rootweapon.name == "special_crossbow_dw")
			{
				weapon_group = "weapon_pistol_dw";
			}
			else if(characterModel.weapon.rootweapon.name == "knife_ballistic")
			{
				weapon_group = "weapon_knife_ballistic";
			}
		}
		else if(weapon_group == "weapon_knife")
		{
			if(characterModel.weapon.rootweapon.name == "melee_wrench" || characterModel.weapon.rootweapon.name == "melee_crowbar" || characterModel.weapon.rootweapon.name == "melee_improvise" || characterModel.weapon.rootweapon.name == "melee_shockbaton" || characterModel.weapon.rootweapon.name == "melee_shovel")
			{
				return Array("pb_wrench_endgame_1stplace_idle", "pb_wrench_endgame_2ndplace_idle", "pb_wrench_endgame_3rdplace_idle")[topPlayerIndex];
			}
			else if(characterModel.weapon.rootweapon.name == "melee_knuckles")
			{
				return Array("pb_brass_knuckles_endgame_1stplace_idle", "pb_brass_knuckles_endgame_2ndplace_idle", "pb_brass_knuckles_endgame_3rdplace_idle")[topPlayerIndex];
			}
			else if(characterModel.weapon.rootweapon.name == "melee_chainsaw" || characterModel.weapon.rootweapon.name == "melee_boneglass" || characterModel.weapon.rootweapon.name == "melee_crescent")
			{
				return Array("pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle")[topPlayerIndex];
			}
			else if(characterModel.weapon.rootweapon.name == "melee_boxing")
			{
				return Array("pb_boxing_gloves_endgame_1stplace_idle", "pb_boxing_gloves_endgame_2ndplace_idle", "pb_boxing_gloves_endgame_3rdplace_idle")[topPlayerIndex];
			}
			else if(characterModel.weapon.rootweapon.name == "melee_sword" || characterModel.weapon.rootweapon.name == "melee_katana")
			{
				return Array("pb_sword_endgame_1stplace_idle", "pb_sword_endgame_2ndplace_idle", "pb_sword_endgame_3rdplace_idle")[topPlayerIndex];
			}
			else if(characterModel.weapon.rootweapon.name == "melee_nunchuks")
			{
				return Array("pb_nunchucks_endgame_1stplace_idle", "pb_nunchucks_endgame_2ndplace_idle", "pb_nunchucks_endgame_3rdplace_idle")[topPlayerIndex];
			}
			else if(characterModel.weapon.rootweapon.name == "melee_bat" || characterModel.weapon.rootweapon.name == "melee_fireaxe" || characterModel.weapon.rootweapon.name == "melee_mace")
			{
				return Array("pb_mace_endgame_1stplace_idle", "pb_mace_endgame_2ndplace_idle", "pb_mace_endgame_3rdplace_idle")[topPlayerIndex];
			}
			else if(characterModel.weapon.rootweapon.name == "melee_prosthetic")
			{
				return Array("pb_prosthetic_arm_endgame_1stplace_idle", "pb_prosthetic_arm_endgame_2ndplace_idle", "pb_prosthetic_arm_endgame_3rdplace_idle")[topPlayerIndex];
			}
		}
		else if(weapon_group == "miscweapon")
		{
			if(characterModel.weapon.rootweapon.name == "blackjack_coin")
			{
				return Array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle")[topPlayerIndex];
			}
			else if(characterModel.weapon.rootweapon.name == "blackjack_cards")
			{
				return Array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle")[topPlayerIndex];
			}
		}
		if(isdefined(associativeArray("weapon_smg", Array("pb_smg_endgame_1stplace_idle", "pb_smg_endgame_2ndplace_idle", "pb_smg_endgame_3rdplace_idle"), "weapon_assault", Array("pb_rifle_endgame_1stplace_idle", "pb_rifle_endgame_2ndplace_idle", "pb_rifle_endgame_3rdplace_idle"), "weapon_cqb", Array("pb_shotgun_endgame_1stplace_idle", "pb_shotgun_endgame_2ndplace_idle", "pb_shotgun_endgame_3rdplace_idle"), "weapon_lmg", Array("pb_lmg_endgame_1stplace_idle", "pb_lmg_endgame_2ndplace_idle", "pb_lmg_endgame_3rdplace_idle"), "weapon_sniper", Array("pb_sniper_endgame_1stplace_idle", "pb_sniper_endgame_2ndplace_idle", "pb_sniper_endgame_3rdplace_idle"), "weapon_pistol", Array("pb_pistol_endgame_1stplace_idle", "pb_pistol_endgame_2ndplace_idle", "pb_pistol_endgame_3rdplace_idle"), "weapon_pistol_dw", Array("pb_pistol_dw_endgame_1stplace_idle", "pb_pistol_dw_endgame_2ndplace_idle", "pb_pistol_dw_endgame_3rdplace_idle"), "weapon_launcher", Array("pb_launcher_endgame_1stplace_idle", "pb_launcher_endgame_2ndplace_idle", "pb_launcher_endgame_3rdplace_idle"), "weapon_launcher_alt", Array("pb_launcher_alt_endgame_1stplace_idle", "pb_launcher_alt_endgame_2ndplace_idle", "pb_launcher_alt_endgame_3rdplace_idle"), "weapon_knife", Array("pb_knife_endgame_1stplace_idle", "pb_knife_endgame_2ndplace_idle", "pb_knife_endgame_3rdplace_idle"), "weapon_knuckles", Array("pb_brass_knuckles_endgame_1stplace_idle", "pb_brass_knuckles_endgame_2ndplace_idle", "pb_brass_knuckles_endgame_3rdplace_idle"), "weapon_boxing", Array("pb_boxing_gloves_endgame_1stplace_idle", "pb_boxing_gloves_endgame_2ndplace_idle", "pb_boxing_gloves_endgame_3rdplace_idle"), "weapon_wrench", Array("pb_wrench_endgame_1stplace_idle", "pb_wrench_endgame_2ndplace_idle", "pb_wrench_endgame_3rdplace_idle"), "weapon_sword", Array("pb_sword_endgame_1stplace_idle", "pb_sword_endgame_2ndplace_idle", "pb_sword_endgame_3rdplace_idle"), "weapon_nunchucks", Array("pb_nunchucks_endgame_1stplace_idle", "pb_nunchucks_endgame_2ndplace_idle", "pb_nunchucks_endgame_3rdplace_idle"), "weapon_mace", Array("pb_mace_endgame_1stplace_idle", "pb_mace_endgame_2ndplace_idle", "pb_mace_endgame_3rdplace_idle"), "brawler", Array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle"), "weapon_prosthetic", Array("pb_prosthetic_arm_endgame_1stplace_idle", "pb_prosthetic_arm_endgame_2ndplace_idle", "pb_prosthetic_arm_endgame_3rdplace_idle"), "weapon_chainsaw", Array("pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle"), "weapon_smg_ppsh", Array("pb_smg_ppsh_endgame_1stplace_idle", "pb_smg_ppsh_endgame_1stplace_idle", "pb_smg_ppsh_endgame_1stplace_idle"), "weapon_knife_ballistic", Array("pb_b_knife_endgame_1stplace_idle", "pb_b_knife_endgame_2ndplace_idle", "pb_b_knife_endgame_3rdplace_idle"))[weapon_group]))
		{
			anim_name = associativeArray("weapon_smg", Array("pb_smg_endgame_1stplace_idle", "pb_smg_endgame_2ndplace_idle", "pb_smg_endgame_3rdplace_idle"), "weapon_assault", Array("pb_rifle_endgame_1stplace_idle", "pb_rifle_endgame_2ndplace_idle", "pb_rifle_endgame_3rdplace_idle"), "weapon_cqb", Array("pb_shotgun_endgame_1stplace_idle", "pb_shotgun_endgame_2ndplace_idle", "pb_shotgun_endgame_3rdplace_idle"), "weapon_lmg", Array("pb_lmg_endgame_1stplace_idle", "pb_lmg_endgame_2ndplace_idle", "pb_lmg_endgame_3rdplace_idle"), "weapon_sniper", Array("pb_sniper_endgame_1stplace_idle", "pb_sniper_endgame_2ndplace_idle", "pb_sniper_endgame_3rdplace_idle"), "weapon_pistol", Array("pb_pistol_endgame_1stplace_idle", "pb_pistol_endgame_2ndplace_idle", "pb_pistol_endgame_3rdplace_idle"), "weapon_pistol_dw", Array("pb_pistol_dw_endgame_1stplace_idle", "pb_pistol_dw_endgame_2ndplace_idle", "pb_pistol_dw_endgame_3rdplace_idle"), "weapon_launcher", Array("pb_launcher_endgame_1stplace_idle", "pb_launcher_endgame_2ndplace_idle", "pb_launcher_endgame_3rdplace_idle"), "weapon_launcher_alt", Array("pb_launcher_alt_endgame_1stplace_idle", "pb_launcher_alt_endgame_2ndplace_idle", "pb_launcher_alt_endgame_3rdplace_idle"), "weapon_knife", Array("pb_knife_endgame_1stplace_idle", "pb_knife_endgame_2ndplace_idle", "pb_knife_endgame_3rdplace_idle"), "weapon_knuckles", Array("pb_brass_knuckles_endgame_1stplace_idle", "pb_brass_knuckles_endgame_2ndplace_idle", "pb_brass_knuckles_endgame_3rdplace_idle"), "weapon_boxing", Array("pb_boxing_gloves_endgame_1stplace_idle", "pb_boxing_gloves_endgame_2ndplace_idle", "pb_boxing_gloves_endgame_3rdplace_idle"), "weapon_wrench", Array("pb_wrench_endgame_1stplace_idle", "pb_wrench_endgame_2ndplace_idle", "pb_wrench_endgame_3rdplace_idle"), "weapon_sword", Array("pb_sword_endgame_1stplace_idle", "pb_sword_endgame_2ndplace_idle", "pb_sword_endgame_3rdplace_idle"), "weapon_nunchucks", Array("pb_nunchucks_endgame_1stplace_idle", "pb_nunchucks_endgame_2ndplace_idle", "pb_nunchucks_endgame_3rdplace_idle"), "weapon_mace", Array("pb_mace_endgame_1stplace_idle", "pb_mace_endgame_2ndplace_idle", "pb_mace_endgame_3rdplace_idle"), "brawler", Array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle"), "weapon_prosthetic", Array("pb_prosthetic_arm_endgame_1stplace_idle", "pb_prosthetic_arm_endgame_2ndplace_idle", "pb_prosthetic_arm_endgame_3rdplace_idle"), "weapon_chainsaw", Array("pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle"), "weapon_smg_ppsh", Array("pb_smg_ppsh_endgame_1stplace_idle", "pb_smg_ppsh_endgame_1stplace_idle", "pb_smg_ppsh_endgame_1stplace_idle"), "weapon_knife_ballistic", Array("pb_b_knife_endgame_1stplace_idle", "pb_b_knife_endgame_2ndplace_idle", "pb_b_knife_endgame_3rdplace_idle"))[weapon_group][topPlayerIndex];
		}
	}
	if(!isdefined(anim_name))
	{
		anim_name = Array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle")[topPlayerIndex];
	}
	return anim_name;
}

/*
	Name: getIdleOutAnimName
	Namespace: end_game_taunts
	Checksum: 0x2D91FAD9
	Offset: 0x4810
	Size: 0x4AD
	Parameters: 2
	Flags: None
*/
function getIdleOutAnimName(characterModel, topPlayerIndex)
{
	weapon_group = getWeaponGroup(characterModel);
	switch(weapon_group)
	{
		case "weapon_smg":
		{
			return Array("pb_smg_endgame_1stplace_out", "pb_smg_endgame_2ndplace_out", "pb_smg_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_assault":
		{
			return Array("pb_rifle_endgame_1stplace_out", "pb_rifle_endgame_2ndplace_out", "pb_rifle_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_cqb":
		{
			return Array("pb_shotgun_endgame_1stplace_out", "pb_shotgun_endgame_2ndplace_out", "pb_shotgun_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_lmg":
		{
			return Array("pb_lmg_endgame_1stplace_out", "pb_lmg_endgame_2ndplace_out", "pb_lmg_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_sniper":
		{
			return Array("pb_sniper_endgame_1stplace_out", "pb_sniper_endgame_2ndplace_out", "pb_sniper_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_pistol":
		{
			return Array("pb_pistol_endgame_1stplace_out", "pb_pistol_endgame_2ndplace_out", "pb_pistol_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_pistol_dw":
		{
			return Array("pb_pistol_dw_endgame_1stplace_out", "pb_pistol_dw_endgame_2ndplace_out", "pb_pistol_dw_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_launcher":
		{
			return Array("pb_launcher_endgame_1stplace_out", "pb_launcher_endgame_2ndplace_out", "pb_launcher_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_launcher_alt":
		{
			return Array("pb_launcher_alt_endgame_1stplace_out", "pb_launcher_alt_endgame_2ndplace_out", "pb_launcher_alt_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_knife":
		{
			return Array("pb_knife_endgame_1stplace_out", "pb_knife_endgame_2ndplace_out", "pb_knife_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_knuckles":
		{
			return Array("pb_brass_knuckles_endgame_1stplace_out", "pb_brass_knuckles_endgame_2ndplace_out", "pb_brass_knuckles_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_boxing":
		{
			return Array("pb_boxing_gloves_endgame_1stplace_out", "pb_boxing_gloves_endgame_2ndplace_out", "pb_boxing_gloves_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_wrench":
		{
			return Array("pb_wrench_endgame_1stplace_out", "pb_wrench_endgame_2ndplace_out", "pb_wrench_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_sword":
		{
			return Array("pb_sword_endgame_1stplace_out", "pb_sword_endgame_2ndplace_out", "pb_sword_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_nunchucks":
		{
			return Array("pb_nunchucks_endgame_1stplace_out", "pb_nunchucks_endgame_2ndplace_out", "pb_nunchucks_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_mace":
		{
			return Array("pb_mace_endgame_1stplace_out", "pb_mace_endgame_2ndplace_out", "pb_mace_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_prosthetic":
		{
			return Array("pb_prosthetic_arm_endgame_1stplace_out", "pb_prosthetic_arm_endgame_2ndplace_out", "pb_prosthetic_arm_endgame_3rdplace_out")[topPlayerIndex];
		}
		case "weapon_chainsaw":
		{
			return Array("pb_chainsaw_endgame_1stplace_idle_out", "pb_chainsaw_endgame_1stplace_idle_out", "pb_chainsaw_endgame_1stplace_idle_out")[topPlayerIndex];
		}
		case "weapon_smg_ppsh":
		{
			return Array("pb_smg_ppsh_endgame_1stplace_out", "pb_smg_ppsh_endgame_1stplace_out", "pb_smg_ppsh_endgame_1stplace_out")[topPlayerIndex];
		}
		case "weapon_knife_ballistic":
		{
			return Array("pb_b_knife_endgame_1stplace_out", "pb_b_knife_endgame_1stplace_out", "pb_b_knife_endgame_1stplace_out")[topPlayerIndex];
		}
	}
	return "";
}

/*
	Name: getIdleInAnimName
	Namespace: end_game_taunts
	Checksum: 0xC84431FE
	Offset: 0x4CC8
	Size: 0x4AD
	Parameters: 2
	Flags: None
*/
function getIdleInAnimName(characterModel, topPlayerIndex)
{
	weapon_group = getWeaponGroup(characterModel);
	switch(weapon_group)
	{
		case "weapon_smg":
		{
			return Array("pb_smg_endgame_1stplace_in", "pb_smg_endgame_2ndplace_in", "pb_smg_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_assault":
		{
			return Array("pb_rifle_endgame_1stplace_in", "pb_rifle_endgame_2ndplace_in", "pb_rifle_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_cqb":
		{
			return Array("pb_shotgun_endgame_1stplace_in", "pb_shotgun_endgame_2ndplace_in", "pb_shotgun_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_lmg":
		{
			return Array("pb_lmg_endgame_1stplace_in", "pb_lmg_endgame_2ndplace_in", "pb_lmg_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_sniper":
		{
			return Array("pb_sniper_endgame_1stplace_in", "pb_sniper_endgame_2ndplace_in", "pb_sniper_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_pistol":
		{
			return Array("pb_pistol_endgame_1stplace_in", "pb_pistol_endgame_2ndplace_in", "pb_pistol_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_pistol_dw":
		{
			return Array("pb_pistol_dw_endgame_1stplace_in", "pb_pistol_dw_endgame_2ndplace_in", "pb_pistol_dw_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_launcher":
		{
			return Array("pb_launcher_endgame_1stplace_in", "pb_launcher_endgame_2ndplace_in", "pb_launcher_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_launcher_alt":
		{
			return Array("pb_launcher_alt_endgame_1stplace_in", "pb_launcher_alt_endgame_2ndplace_in", "pb_launcher_alt_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_knife":
		{
			return Array("pb_knife_endgame_1stplace_in", "pb_knife_endgame_2ndplace_in", "pb_knife_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_knuckles":
		{
			return Array("pb_brass_knuckles_endgame_1stplace_in", "pb_brass_knuckles_endgame_2ndplace_in", "pb_brass_knuckles_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_boxing":
		{
			return Array("pb_boxing_gloves_endgame_1stplace_in", "pb_boxing_gloves_endgame_2ndplace_in", "pb_boxing_gloves_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_wrench":
		{
			return Array("pb_wrench_endgame_1stplace_in", "pb_wrench_endgame_2ndplace_in", "pb_wrench_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_sword":
		{
			return Array("pb_sword_endgame_1stplace_in", "pb_sword_endgame_2ndplace_in", "pb_sword_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_nunchucks":
		{
			return Array("pb_nunchucks_endgame_1stplace_in", "pb_nunchucks_endgame_2ndplace_in", "pb_nunchucks_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_mace":
		{
			return Array("pb_mace_endgame_1stplace_in", "pb_mace_endgame_2ndplace_in", "pb_mace_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_prosthetic":
		{
			return Array("pb_prosthetic_arm_endgame_1stplace_in", "pb_prosthetic_arm_endgame_2ndplace_in", "pb_prosthetic_arm_endgame_3rdplace_in")[topPlayerIndex];
		}
		case "weapon_chainsaw":
		{
			return Array("pb_chainsaw_endgame_1stplace_idle_in", "pb_chainsaw_endgame_1stplace_idle_in", "pb_chainsaw_endgame_1stplace_idle_in")[topPlayerIndex];
		}
		case "weapon_smg_ppsh":
		{
			return Array("pb_smg_ppsh_endgame_1stplace_in", "pb_smg_ppsh_endgame_1stplace_in", "pb_smg_ppsh_endgame_1stplace_in")[topPlayerIndex];
		}
		case "weapon_knife_ballistic":
		{
			return Array("pb_b_knife_endgame_1stplace_in", "pb_b_knife_endgame_1stplace_in", "pb_b_knife_endgame_1stplace_in")[topPlayerIndex];
		}
	}
	return "";
}

/*
	Name: getWeaponGroup
	Namespace: end_game_taunts
	Checksum: 0x80F9ED8
	Offset: 0x5180
	Size: 0x69B
	Parameters: 1
	Flags: None
*/
function getWeaponGroup(characterModel)
{
	if(!isdefined(characterModel.weapon))
	{
		return "";
	}
	weapon = characterModel.weapon;
	if(weapon == level.weaponNone && isdefined(characterModel.showcaseWeapon))
	{
		weapon = characterModel.showcaseWeapon;
	}
	weapon_group = GetItemGroupForWeaponName(weapon.rootweapon.name);
	if(weapon_group == "weapon_launcher")
	{
		if(characterModel.weapon.rootweapon.name == "launcher_lockonly" || characterModel.weapon.rootweapon.name == "launcher_multi")
		{
			weapon_group = "weapon_launcher_alt";
		}
		else if(characterModel.weapon.rootweapon.name == "launcher_ex41")
		{
			weapon_group = "weapon_smg_ppsh";
		}
	}
	else if(weapon_group == "weapon_pistol" && weapon.isDualWield)
	{
		weapon_group = "weapon_pistol_dw";
	}
	else if(weapon_group == "weapon_smg")
	{
		if(characterModel.weapon.rootweapon.name == "smg_ppsh")
		{
			weapon_group = "weapon_smg_ppsh";
		}
	}
	else if(weapon_group == "weapon_cqb")
	{
		if(characterModel.weapon.rootweapon.name == "shotgun_olympia")
		{
			weapon_group = "weapon_smg_ppsh";
		}
	}
	else if(weapon_group == "weapon_special")
	{
		if(characterModel.weapon.rootweapon.name == "special_crossbow" || characterModel.weapon.rootweapon.name == "special_discgun")
		{
			weapon_group = "weapon_smg";
		}
		else if(characterModel.weapon.rootweapon.name == "special_crossbow_dw")
		{
			weapon_group = "weapon_pistol_dw";
		}
		else if(characterModel.weapon.rootweapon.name == "knife_ballistic")
		{
			weapon_group = "weapon_knife_ballistic";
		}
	}
	else if(weapon_group == "weapon_knife")
	{
		if(characterModel.weapon.rootweapon.name == "melee_wrench" || characterModel.weapon.rootweapon.name == "melee_crowbar" || characterModel.weapon.rootweapon.name == "melee_improvise" || characterModel.weapon.rootweapon.name == "melee_shockbaton" || characterModel.weapon.rootweapon.name == "melee_shovel")
		{
			weapon_group = "weapon_wrench";
		}
		else if(characterModel.weapon.rootweapon.name == "melee_knuckles")
		{
			weapon_group = "weapon_knuckles";
		}
		else if(characterModel.weapon.rootweapon.name == "melee_chainsaw" || characterModel.weapon.rootweapon.name == "melee_boneglass" || characterModel.weapon.rootweapon.name == "melee_crescent")
		{
			weapon_group = "weapon_chainsaw";
		}
		else if(characterModel.weapon.rootweapon.name == "melee_boxing")
		{
			weapon_group = "weapon_boxing";
		}
		else if(characterModel.weapon.rootweapon.name == "melee_sword" || characterModel.weapon.rootweapon.name == "melee_katana")
		{
			weapon_group = "weapon_sword";
		}
		else if(characterModel.weapon.rootweapon.name == "melee_nunchuks")
		{
			weapon_group = "weapon_nunchucks";
		}
		else if(characterModel.weapon.rootweapon.name == "melee_bat" || characterModel.weapon.rootweapon.name == "melee_fireaxe" || characterModel.weapon.rootweapon.name == "melee_mace")
		{
			weapon_group = "weapon_mace";
		}
		else if(characterModel.weapon.rootweapon.name == "melee_prosthetic")
		{
			weapon_group = "weapon_prosthetic";
		}
	}
	return weapon_group;
}

/*
	Name: stream_epic_models
	Namespace: end_game_taunts
	Checksum: 0xC0B1A3AB
	Offset: 0x5828
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function stream_epic_models()
{
	foreach(model in level.epicTauntXModels)
	{
		ForceStreamXModel(model);
	}
}

/*
	Name: stop_stream_epic_models
	Namespace: end_game_taunts
	Checksum: 0x3B56F213
	Offset: 0x58C0
	Size: 0x89
	Parameters: 0
	Flags: None
*/
function stop_stream_epic_models()
{
	foreach(model in level.epicTauntXModels)
	{
		StopForceStreamingXModel(model);
	}
}

/*
	Name: playEpicTauntScene
	Namespace: end_game_taunts
	Checksum: 0x756DBDD1
	Offset: 0x5958
	Size: 0x27F
	Parameters: 2
	Flags: None
*/
function playEpicTauntScene(localClientNum, tauntAnimName)
{
	sceneBundle = struct::get_script_bundle("scene", tauntAnimName);
	if(!isdefined(sceneBundle))
	{
		return 0;
	}
	switch(tauntAnimName)
	{
		case "t7_loot_taunt_e_reaper_01":
		{
			self thread setupReaperMinigun(localClientNum);
			break;
		}
		case "t7_loot_taunt_e_nomad_03":
		{
			self thread spawnGiUnit(localClientNum, "gi_unit_victim");
			break;
		}
		case "t7_loot_taunt_e_seraph_04":
		{
			self thread spawnRap(localClientNum, "rap_1");
			self thread spawnRap(localClientNum, "rap_2");
			break;
		}
		case "t7_loot_taunt_e_reaper_main_03":
		{
			self thread spawnHiddenClone(localClientNum, "reaper_l");
			self thread spawnHiddenClone(localClientNum, "reaper_r");
			break;
		}
		case "t7_loot_taunt_e_spectre_03":
		{
			if(GetDvarString("mapname") == "core_frontend")
			{
				self SetHighDetail(1, 0);
				self handleCamoChange(self.localClientNum, 1);
			}
			else
			{
				self thread gadget_camo_render::forceOn(localClientNum);
			}
			self thread spawnGiUnit(localClientNum, "gi_unit_victim");
			break;
		}
		case "t7_loot_taunt_e_outrider_05":
		{
			self thread spawnTalon(localClientNum, "talon_bro_1", 0.65);
			self thread spawnTalon(localClientNum, "talon_bro_2", 0.65);
			break;
		}
	}
	self thread scene::Play(tauntAnimName);
	return 1;
}

/*
	Name: stopEpicTauntScene
	Namespace: end_game_taunts
	Checksum: 0x46049441
	Offset: 0x5BE0
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function stopEpicTauntScene(localClientNum, tauntAnimName)
{
	sceneBundle = struct::get_script_bundle("scene", tauntAnimName);
	if(!isdefined(sceneBundle))
	{
		return;
	}
	switch(tauntAnimName)
	{
		case "t7_loot_taunt_e_spectre_03":
		{
			if(GetDvarString("mapname") == "core_frontend")
			{
				self SetHighDetail(1, 0);
			}
			break;
		}
	}
	self thread scene::stop(tauntAnimName);
}

/*
	Name: addEpicSceneFunc
	Namespace: end_game_taunts
	Checksum: 0xAF4B0597
	Offset: 0x5CA8
	Size: 0x73
	Parameters: 3
	Flags: None
*/
function addEpicSceneFunc(tauntAnimName, func, State)
{
	sceneBundle = struct::get_script_bundle("scene", tauntAnimName);
	if(!isdefined(sceneBundle))
	{
		return;
	}
	scene::add_scene_func(tauntAnimName, func, State);
}

/*
	Name: shutdownEpicTauntModels
	Namespace: end_game_taunts
	Checksum: 0x1E3C7E0
	Offset: 0x5D28
	Size: 0xC1
	Parameters: 0
	Flags: None
*/
function shutdownEpicTauntModels()
{
	if(isdefined(self.epicTauntModels))
	{
		foreach(model in self.epicTauntModels)
		{
			if(isdefined(model))
			{
				model stopsounds();
				model delete();
			}
		}
		self.epicTauntModels = undefined;
	}
}

/*
	Name: hideModel
	Namespace: end_game_taunts
	Checksum: 0x326600BE
	Offset: 0x5DF8
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function hideModel(Param)
{
	self Hide();
}

/*
	Name: showModel
	Namespace: end_game_taunts
	Checksum: 0x86B4A77F
	Offset: 0x5E28
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function showModel(Param)
{
	self show();
}

/*
	Name: spawnCameraGlass
	Namespace: end_game_taunts
	Checksum: 0x2F187BE
	Offset: 0x5E58
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function spawnCameraGlass(Param)
{
	if(isdefined(level.cameraGlass))
	{
		deleteCameraGlass(Param);
	}
	level.cameraGlass = spawn(self.localClientNum, (0, 0, 0), "script_model");
	level.cameraGlass SetModel("gfx_p7_zm_asc_data_recorder_glass");
	level.cameraGlass SetScale(2);
	level.cameraGlass thread updateGlassPosition();
}

/*
	Name: updateGlassPosition
	Namespace: end_game_taunts
	Checksum: 0x7FCD81E2
	Offset: 0x5F18
	Size: 0xBF
	Parameters: 0
	Flags: None
*/
function updateGlassPosition()
{
	self endon("entityshutdown");
	while(1)
	{
		camAngles = GetCamAnglesByLocalClientNum(self.localClientNum);
		camPos = GetCamPosByLocalClientNum(self.localClientNum);
		fwd = AnglesToForward(camAngles);
		self.origin = camPos + fwd * 60;
		self.angles = camAngles + VectorScale((0, 1, 0), 180);
		wait(0.016);
	}
}

/*
	Name: deleteCameraGlass
	Namespace: end_game_taunts
	Checksum: 0x77DB1C2D
	Offset: 0x5FE0
	Size: 0x3D
	Parameters: 1
	Flags: None
*/
function deleteCameraGlass(Param)
{
	if(!isdefined(level.cameraGlass))
	{
		return;
	}
	level.cameraGlass delete();
	level.cameraGlass = undefined;
}

/*
	Name: reaperBulletGlass
	Namespace: end_game_taunts
	Checksum: 0x2086F689
	Offset: 0x6028
	Size: 0xDF
	Parameters: 1
	Flags: None
*/
function reaperBulletGlass(Param)
{
	waittillframeend;
	miniGun = GetWeapon("hero_minigun");
	for(i = 30; i > -30;  = 30)
	{
		if(!isdefined(self))
		{
			return;
		}
		self magicGlassBullet(self.localClientNum, miniGun, RandomFloatRange(2, 12), i);
		self playsound(0, "pfx_magic_bullet_glass");
		wait(miniGun.fireTime);
	}
}

/*
	Name: centerBulletGlass
	Namespace: end_game_taunts
	Checksum: 0x52A7EB9D
	Offset: 0x6110
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function centerBulletGlass(weaponName)
{
	waittillframeend;
	weapon = GetWeapon(weaponName);
	if(weapon == level.weaponNone)
	{
		return;
	}
	self magicGlassBullet(self.localClientNum, weapon, 4, -2);
	self playsound(0, "pfx_magic_bullet_glass");
}

/*
	Name: talonBulletGlassLeft
	Namespace: end_game_taunts
	Checksum: 0xB89878CB
	Offset: 0x61A8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function talonBulletGlassLeft(Param)
{
	self talonBulletGlass(-28, -10);
}

/*
	Name: talonBulletGlassRight
	Namespace: end_game_taunts
	Checksum: 0x2ABC79EE
	Offset: 0x61E0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function talonBulletGlassRight(Param)
{
	self talonBulletGlass(10, 28);
}

/*
	Name: talonBulletGlass
	Namespace: end_game_taunts
	Checksum: 0x415873A1
	Offset: 0x6218
	Size: 0xED
	Parameters: 2
	Flags: None
*/
function talonBulletGlass(yawMin, yawMax)
{
	waittillframeend;
	miniGun = GetWeapon("hero_minigun");
	for(i = 0; i < 15; i++)
	{
		if(!isdefined(self))
		{
			return;
		}
		self magicGlassBullet(self.localClientNum, miniGun, RandomFloatRange(4, 16), RandomFloatRange(yawMin, yawMax));
		self playsound(0, "pfx_magic_bullet_glass");
		wait(miniGun.fireTime);
	}
}

/*
	Name: cloneShaderOn
	Namespace: end_game_taunts
	Checksum: 0xBD49F12F
	Offset: 0x6310
	Size: 0x133
	Parameters: 1
	Flags: None
*/
function cloneShaderOn(Param)
{
	if(GetDvarString("mapname") == "core_frontend")
	{
		self SetHighDetail(1, 0);
	}
	localPlayerTeam = GetLocalPlayerTeam(self.localClientNum);
	topPlayerTeam = GetTopPlayersTeam(self.localClientNum, 0);
	friendly = localPlayerTeam === topPlayerTeam;
	if(friendly)
	{
		self duplicate_render::update_dr_flag(self.localClientNum, "clone_ally_on", 1);
	}
	else
	{
		self duplicate_render::update_dr_flag(self.localClientNum, "clone_enemy_on", 1);
	}
	self thread gadget_clone_render::transition_shader(self.localClientNum);
}

/*
	Name: cloneShaderOff
	Namespace: end_game_taunts
	Checksum: 0x564291C7
	Offset: 0x6450
	Size: 0x5B
	Parameters: 1
	Flags: None
*/
function cloneShaderOff(Param)
{
	self duplicate_render::update_dr_flag(self.localClientNum, "clone_ally_on", 0);
	self duplicate_render::update_dr_flag(self.localClientNum, "clone_enemy_on", 0);
}

/*
	Name: handleCamoChange
	Namespace: end_game_taunts
	Checksum: 0x36E8F8C2
	Offset: 0x64B8
	Size: 0x13B
	Parameters: 2
	Flags: None
*/
function handleCamoChange(localClientNum, camo_on)
{
	flags_changed = self duplicate_render::set_dr_flag("gadget_camo_friend", 0);
	flags_changed = flags_changed && self duplicate_render::set_dr_flag("gadget_camo_flicker", 0);
	flags_changed = flags_changed && self duplicate_render::set_dr_flag("gadget_camo_break", 0);
	flags_changed = flags_changed && self duplicate_render::set_dr_flag("gadget_camo_reveal", 0);
	flags_changed = flags_changed && self duplicate_render::set_dr_flag("gadget_camo_on", 0);
	if(flags_changed)
	{
		self duplicate_render::update_dr_filters();
	}
	if(camo_on)
	{
		self thread gadget_camo_render::forceOn(localClientNum);
	}
	else
	{
		self thread gadget_camo_render::doReveal(self.localClientNum, 0);
	}
}

/*
	Name: camoShaderOn
	Namespace: end_game_taunts
	Checksum: 0xEB61CCF2
	Offset: 0x6600
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function camoShaderOn(Param)
{
	if(GetDvarString("mapname") == "core_frontend")
	{
		self handleCamoChange(self.localClientNum, 1);
	}
	else
	{
		self thread gadget_camo_render::doReveal(self.localClientNum, 1);
	}
}

/*
	Name: camoShaderOff
	Namespace: end_game_taunts
	Checksum: 0x702FDFCE
	Offset: 0x6688
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function camoShaderOff(Param)
{
	if(GetDvarString("mapname") == "core_frontend")
	{
		self handleCamoChange(self.localClientNum, 0);
	}
	else
	{
		self thread gadget_camo_render::doReveal(self.localClientNum, 0);
	}
}

/*
	Name: FireWeapon
	Namespace: end_game_taunts
	Checksum: 0x89D96E8
	Offset: 0x6700
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function FireWeapon(weaponName)
{
	if(!isdefined(weaponName))
	{
		return;
	}
	self endon("stopFireWeapon");
	weapon = GetWeapon(weaponName);
	waittillframeend;
	while(1 && isdefined(self))
	{
		self MagicBullet(weapon, (0, 0, 0), (0, 0, 0));
		wait(weapon.fireTime);
	}
}

/*
	Name: stopFireWeapon
	Namespace: end_game_taunts
	Checksum: 0x7E3B1268
	Offset: 0x6798
	Size: 0x19
	Parameters: 1
	Flags: None
*/
function stopFireWeapon(Param)
{
	self notify("stopFireWeapon");
}

/*
	Name: fireBeam
	Namespace: end_game_taunts
	Checksum: 0x4E6681C8
	Offset: 0x67C0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function fireBeam(beam)
{
	if(isdefined(self.beamFx))
	{
		return;
	}
	self.beamFx = BeamLaunch(self.localClientNum, self, "tag_flash", undefined, "none", beam);
}

/*
	Name: stopFireBeam
	Namespace: end_game_taunts
	Checksum: 0xB0A7AA00
	Offset: 0x6818
	Size: 0x45
	Parameters: 1
	Flags: None
*/
function stopFireBeam(Param)
{
	if(!isdefined(self.beamFx))
	{
		return;
	}
	BeamKill(self.localClientNum, self.beamFx);
	self.beamFx = undefined;
}

/*
	Name: playWinnerTeamFx
	Namespace: end_game_taunts
	Checksum: 0xDD69D537
	Offset: 0x6868
	Size: 0xBB
	Parameters: 1
	Flags: None
*/
function playWinnerTeamFx(fxName)
{
	waittillframeend;
	topPlayerTeam = GetTopPlayersTeam(self.localClientNum, 0);
	if(!isdefined(topPlayerTeam))
	{
		topPlayerTeam = GetLocalPlayerTeam(self.localClientNum);
	}
	fxHandle = PlayFXOnTag(self.localClientNum, fxName, self, "tag_origin");
	if(isdefined(fxHandle))
	{
		SetFxTeam(self.localClientNum, fxHandle, topPlayerTeam);
	}
}

/*
	Name: playLocalTeamFx
	Namespace: end_game_taunts
	Checksum: 0x98DD951A
	Offset: 0x6930
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function playLocalTeamFx(fxName)
{
	waittillframeend;
	localPlayerTeam = GetLocalPlayerTeam(self.localClientNum);
	fxHandle = PlayFXOnTag(self.localClientNum, fxName, self, "tag_origin");
	if(isdefined(fxHandle))
	{
		SetFxTeam(self.localClientNum, fxHandle, localPlayerTeam);
	}
}

/*
	Name: magicGlassBullet
	Namespace: end_game_taunts
	Checksum: 0xBC5CD021
	Offset: 0x69C8
	Size: 0xAB
	Parameters: 4
	Flags: None
*/
function magicGlassBullet(localClientNum, weapon, pitchAngle, yawAngle)
{
	camPos = GetCamPosByLocalClientNum(localClientNum);
	camAngles = GetCamAnglesByLocalClientNum(localClientNum);
	bulletAngles = camAngles + (pitchAngle, yawAngle, 0);
	self MagicBullet(weapon, camPos, bulletAngles);
}

/*
	Name: launchProjectile
	Namespace: end_game_taunts
	Checksum: 0xE1888072
	Offset: 0x6A80
	Size: 0xF3
	Parameters: 3
	Flags: None
*/
function launchProjectile(localClientNum, projectileModel, projectileTrail)
{
	launchOrigin = self GetTagOrigin("tag_flash");
	if(!isdefined(launchOrigin))
	{
		return;
	}
	launchAngles = self GetTagAngles("tag_flash");
	launchDir = AnglesToForward(launchAngles);
	CreateDynEntAndLaunch(localClientNum, projectileModel, launchOrigin, (0, 0, 0), launchOrigin, launchDir * GetDvarFloat("launchspeed", 3.5), projectileTrail);
}

/*
	Name: setupReaperMinigun
	Namespace: end_game_taunts
	Checksum: 0x3C938B09
	Offset: 0x6B80
	Size: 0x1B1
	Parameters: 1
	Flags: None
*/
function setupReaperMinigun(localClientNum)
{
	model = spawn(localClientNum, self.origin, "script_model");
	model.angles = self.angles;
	model.targetname = "scythe_prop";
	model SetHighDetail(1);
	scytheModel = "wpn_t7_hero_reaper_minigun_prop";
	if(isdefined(self.bodyModel))
	{
		if(StrStartsWith(self.bodyModel, "c_t7_mp_reaper_mpc_body3"))
		{
			scytheModel = "wpn_t7_loot_hero_reaper3_minigun_prop";
		}
	}
	model SetModel(scytheModel);
	model SetBodyRenderOptions(self.modeRenderOptions, self.bodyRenderOptions, self.helmetRenderOptions, self.helmetRenderOptions);
	self HidePart(localClientNum, "tag_minigun_flaps");
	if(!isdefined(self.epicTauntModels))
	{
		self.epicTauntModels = [];
	}
	else if(!IsArray(self.epicTauntModels))
	{
		self.epicTauntModels = Array(self.epicTauntModels);
	}
	self.epicTauntModels[self.epicTauntModels.size] = model;
}

/*
	Name: spawnHiddenClone
	Namespace: end_game_taunts
	Checksum: 0x9774556B
	Offset: 0x6D40
	Size: 0x139
	Parameters: 2
	Flags: None
*/
function spawnHiddenClone(localClientNum, targetname)
{
	clone = self spawnPlayerModel(localClientNum, targetname, self.origin, self.angles, self.bodyModel, self.helmetModel, self.modeRenderOptions, self.bodyRenderOptions, self.helmetRenderOptions);
	clone SetScale(0);
	wait(0.016);
	clone Hide();
	clone SetScale(1);
	if(!isdefined(self.epicTauntModels))
	{
		self.epicTauntModels = [];
	}
	else if(!IsArray(self.epicTauntModels))
	{
		self.epicTauntModels = Array(self.epicTauntModels);
	}
	self.epicTauntModels[self.epicTauntModels.size] = clone;
}

/*
	Name: spawnTopPlayerModel
	Namespace: end_game_taunts
	Checksum: 0xCB6CFAD
	Offset: 0x6E88
	Size: 0x129
	Parameters: 5
	Flags: None
*/
function spawnTopPlayerModel(localClientNum, targetname, origin, angles, topPlayerIndex)
{
	bodyModel = GetTopPlayersBodyModel(localClientNum, topPlayerIndex);
	helmetModel = GetTopPlayersHelmetModel(localClientNum, topPlayerIndex);
	modeRenderOptions = GetCharacterModeRenderOptions(CurrentSessionMode());
	bodyRenderOptions = GetTopPlayersBodyRenderOptions(localClientNum, topPlayerIndex);
	helmetRenderOptions = GetTopPlayersHelmetRenderOptions(localClientNum, topPlayerIndex);
	return spawnPlayerModel(localClientNum, targetname, origin, angles, bodyModel, helmetModel, modeRenderOptions, bodyRenderOptions, helmetRenderOptions);
}

/*
	Name: spawnPlayerModel
	Namespace: end_game_taunts
	Checksum: 0x271FD9D1
	Offset: 0x6FC0
	Size: 0x157
	Parameters: 9
	Flags: None
*/
function spawnPlayerModel(localClientNum, targetname, origin, angles, bodyModel, helmetModel, modeRenderOptions, bodyRenderOptions, helmetRenderOptions)
{
	model = spawn(localClientNum, origin, "script_model");
	model.angles = angles;
	model.targetname = targetname;
	model SetHighDetail(1);
	model SetModel(bodyModel);
	model Attach(helmetModel, "");
	model SetBodyRenderOptions(modeRenderOptions, bodyRenderOptions, helmetRenderOptions, helmetRenderOptions);
	model Hide();
	model useanimtree(-1);
	return model;
}

/*
	Name: spawnGiUnit
	Namespace: end_game_taunts
	Checksum: 0xAEAFA648
	Offset: 0x7120
	Size: 0x141
	Parameters: 2
	Flags: None
*/
function spawnGiUnit(localClientNum, targetname)
{
	model = spawn(localClientNum, self.origin, "script_model");
	model.angles = self.angles;
	model.targetname = targetname;
	model SetHighDetail(1);
	model SetModel("c_zsf_robot_grunt_body");
	model Attach("c_zsf_robot_grunt_head", "");
	if(!isdefined(self.epicTauntModels))
	{
		self.epicTauntModels = [];
	}
	else if(!IsArray(self.epicTauntModels))
	{
		self.epicTauntModels = Array(self.epicTauntModels);
	}
	self.epicTauntModels[self.epicTauntModels.size] = model;
}

/*
	Name: spawnRap
	Namespace: end_game_taunts
	Checksum: 0xBC048767
	Offset: 0x7270
	Size: 0x1B9
	Parameters: 2
	Flags: None
*/
function spawnRap(localClientNum, targetname)
{
	model = spawn(localClientNum, self.origin, "script_model");
	model.angles = self.angles;
	model.targetname = targetname;
	localPlayerTeam = GetLocalPlayerTeam(self.localClientNum);
	topPlayerTeam = GetTopPlayersTeam(localClientNum, 0);
	if(!isdefined(topPlayerTeam) || localPlayerTeam == topPlayerTeam)
	{
		model SetModel("veh_t7_drone_raps_mp_lite");
		fxTeam = localPlayerTeam;
	}
	else
	{
		model SetModel("veh_t7_drone_raps_mp_dark");
		fxTeam = topPlayerTeam;
	}
	model util::waittill_dobj(localClientNum);
	if(!isdefined(self.epicTauntModels))
	{
		self.epicTauntModels = [];
	}
	else if(!IsArray(self.epicTauntModels))
	{
		self.epicTauntModels = Array(self.epicTauntModels);
	}
	self.epicTauntModels[self.epicTauntModels.size] = model;
}

/*
	Name: spawnTalon
	Namespace: end_game_taunts
	Checksum: 0x7664F7D
	Offset: 0x7438
	Size: 0x241
	Parameters: 3
	Flags: None
*/
function spawnTalon(localClientNum, targetname, scale)
{
	if(!isdefined(scale))
	{
		scale = 1;
	}
	model = spawn(localClientNum, self.origin, "script_model");
	model.angles = self.angles;
	model.targetname = targetname;
	localPlayerTeam = GetLocalPlayerTeam(self.localClientNum);
	topPlayerTeam = GetTopPlayersTeam(localClientNum, 0);
	if(!isdefined(topPlayerTeam) || localPlayerTeam == topPlayerTeam)
	{
		model SetModel("veh_t7_drone_attack_gun_litecolor");
		fxTeam = localPlayerTeam;
	}
	else
	{
		model SetModel("veh_t7_drone_attack_gun_darkcolor");
		fxTeam = topPlayerTeam;
	}
	model SetScale(scale);
	model util::waittill_dobj(localClientNum);
	fxHandle = PlayFXOnTag(localClientNum, "player/fx_loot_taunt_outrider_talon_lights", model, "tag_body");
	SetFxTeam(localClientNum, fxHandle, fxTeam);
	if(!isdefined(self.epicTauntModels))
	{
		self.epicTauntModels = [];
	}
	else if(!IsArray(self.epicTauntModels))
	{
		self.epicTauntModels = Array(self.epicTauntModels);
	}
	self.epicTauntModels[self.epicTauntModels.size] = model;
}

