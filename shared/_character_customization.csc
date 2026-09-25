#using scripts\codescripts\struct;
#using scripts\core\_multi_extracam;
#using scripts\shared\abilities\gadgets\_gadget_camo_render;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\end_game_taunts;
#using scripts\shared\filter_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace character_customization;

/*
	Name: __init__sytem__
	Namespace: character_customization
	Checksum: 0xF8D150B6
	Offset: 0xAB0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("character_customization", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: character_customization
	Checksum: 0x8EC07DC2
	Offset: 0xAF0
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.extra_cam_render_hero_func_callback = &process_character_extracam_request;
	level.extra_cam_render_lobby_client_hero_func_callback = &process_lobby_client_character_extracam_request;
	level.extra_cam_render_current_hero_headshot_func_callback = &process_current_hero_headshot_extracam_request;
	level.extra_cam_render_outfit_preview_func_callback = &process_outfit_preview_extracam_request;
	level.extra_cam_render_character_body_item_func_callback = &process_character_body_item_extracam_request;
	level.extra_cam_render_character_helmet_item_func_callback = &process_character_helmet_item_extracam_request;
	level.extra_cam_render_character_head_item_func_callback = &process_character_head_item_extracam_request;
	level.model_type_bones = associativeArray("helmet", "", "head", "");
	if(!isdefined(level.liveCCData))
	{
		level.liveCCData = [];
	}
	if(!isdefined(level.custom_characters))
	{
		level.custom_characters = [];
	}
	if(!isdefined(level.extra_cam_hero_data))
	{
		level.extra_cam_hero_data = [];
	}
	if(!isdefined(level.extra_cam_lobby_client_hero_data))
	{
		level.extra_cam_lobby_client_hero_data = [];
	}
	if(!isdefined(level.extra_cam_headshot_hero_data))
	{
		level.extra_cam_headshot_hero_data = [];
	}
	if(!isdefined(level.extra_cam_outfit_preview_data))
	{
		level.extra_cam_outfit_preview_data = [];
	}
	level.characterCustomizationSetup = &localclientconnect;
}

/*
	Name: localclientconnect
	Namespace: character_customization
	Checksum: 0xD8EC5C0D
	Offset: 0xC88
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function localclientconnect(localClientNum)
{
	level.liveCCData[localClientNum] = setup_live_character_customization_target(localClientNum);
	if(isdefined(level.liveCCData[localClientNum]))
	{
		setup_character_streaming(level.liveCCData[localClientNum]);
	}
	level.staticCCData = setup_static_character_customization_target(localClientNum);
}

/*
	Name: create_character_data_struct
	Namespace: character_customization
	Checksum: 0xBEF7C521
	Offset: 0xD18
	Size: 0x417
	Parameters: 3
	Flags: None
*/
function create_character_data_struct(characterModel, localClientNum, alt_render_mode)
{
	if(!isdefined(alt_render_mode))
	{
		alt_render_mode = 1;
	}
	if(!isdefined(characterModel))
	{
		return undefined;
	}
	if(!isdefined(level.custom_characters[localClientNum]))
	{
		level.custom_characters[localClientNum] = [];
	}
	if(isdefined(level.custom_characters[localClientNum][characterModel.targetname]))
	{
		return level.custom_characters[localClientNum][characterModel.targetname];
	}
	data_struct = spawnstruct();
	level.custom_characters[localClientNum][characterModel.targetname] = data_struct;
	data_struct.characterModel = characterModel;
	data_struct.attached_model_anims = Array();
	data_struct.attached_models = Array();
	data_struct.attached_entities = Array();
	data_struct.origin = characterModel.origin;
	data_struct.angles = characterModel.angles;
	data_struct.characterindex = 0;
	data_struct.characterMode = 3;
	data_struct.splitScreenClient = undefined;
	data_struct.bodyIndex = 0;
	data_struct.bodyColors = Array(0, 0, 0);
	data_struct.helmetIndex = 0;
	data_struct.helmetColors = Array(0, 0, 0);
	data_struct.headIndex = 0;
	data_struct.align_target = undefined;
	data_struct.currentAnimation = undefined;
	data_struct.currentScene = undefined;
	data_struct.body_render_options = GetCharacterBodyRenderOptions(0, 0, 0, 0, 0);
	data_struct.helmet_render_options = GetCharacterHelmetRenderOptions(0, 0, 0, 0, 0);
	data_struct.head_render_options = GetCharacterHeadRenderOptions(0);
	data_struct.mode_render_options = GetCharacterModeRenderOptions(0);
	data_struct.alt_render_mode = alt_render_mode;
	data_struct.useFrozenMomentAnim = 0;
	data_struct.frozenMomentStyle = "weapon";
	data_struct.show_helmets = 1;
	data_struct.allow_showcase_weapons = 0;
	data_struct.force_prologue_body = 0;
	if(SessionModeIsCampaignGame())
	{
		highestMapReached = GetDStat(localClientNum, "highestMapReached");
		data_struct.force_prologue_body = !isdefined(highestMapReached) || highestMapReached == 0 && GetDvarString("mapname") == "core_frontend";
	}
	characterModel SetHighDetail(1, data_struct.alt_render_mode);
	return data_struct;
}

/*
	Name: handle_forced_streaming
	Namespace: character_customization
	Checksum: 0x38C1B610
	Offset: 0x1138
	Size: 0x2B1
	Parameters: 1
	Flags: None
*/
function handle_forced_streaming(game_mode)
{
	return;
	heroes = GetHeroes(game_mode);
	foreach(hero in heroes)
	{
		bodies = GetHeroBodyModelIndices(hero, game_mode);
		helmets = GetHeroHelmetModelIndices(hero, game_mode);
		foreach(helmet in helmets)
		{
			ForceStreamXModel(helmet, 8, -1);
		}
		foreach(body in bodies)
		{
			ForceStreamXModel(body, 8, -1);
		}
	}
	heads = GetHeroHeadModelIndices(game_mode);
	foreach(head in heads)
	{
		ForceStreamXModel(head, 8, -1);
	}
}

/*
	Name: loadEquippedCharacterOnModel
	Namespace: character_customization
	Checksum: 0xD7FF6F8
	Offset: 0x13F8
	Size: 0x389
	Parameters: 4
	Flags: None
*/
function loadEquippedCharacterOnModel(localClientNum, data_struct, characterindex, params)
{
	/#
		Assert(isdefined(data_struct));
	#/
	if(isdefined(data_struct.splitScreenClient))
	{
	}
	else
	{
	}
	data_lcn = localClientNum;
	if(!isdefined(characterindex))
	{
		characterindex = GetEquippedHeroIndex(data_lcn, params.sessionMode);
	}
	defaultIndex = undefined;
	if(isdefined(params.isDefaultHero) && params.isDefaultHero)
	{
		defaultIndex = 0;
	}
	set_character(data_struct, characterindex);
	characterMode = params.sessionMode;
	set_character_mode(data_struct, characterMode);
	body = get_character_body(data_lcn, characterMode, characterindex, params.extracam_data);
	bodyColors = get_character_body_colors(data_lcn, characterMode, characterindex, body, params.extracam_data);
	set_body(data_struct, characterMode, characterindex, body, bodyColors);
	head = get_character_head(data_lcn, characterMode, params.extracam_data);
	set_head(data_struct, characterMode, head);
	helmet = get_character_helmet(data_lcn, characterMode, characterindex, params.extracam_data);
	helmetColors = get_character_helmet_colors(data_lcn, characterMode, data_struct.characterindex, helmet, params.extracam_data);
	set_helmet(data_struct, characterMode, characterindex, helmet, helmetColors);
	if(isdefined(data_struct.allow_showcase_weapons) && data_struct.allow_showcase_weapons)
	{
		showcaseWeapon = get_character_showcase_weapon(data_lcn, characterMode, characterindex, params.extracam_data);
		set_showcase_weapon(data_struct, characterMode, data_lcn, undefined, characterindex, showcaseWeapon.weaponName, showcaseWeapon.attachmentInfo, showcaseWeapon.weaponRenderOptions, 0, 1);
	}
	return update(localClientNum, data_struct, params);
}

/*
	Name: update_model_attachment
	Namespace: character_customization
	Checksum: 0xC01E0981
	Offset: 0x1790
	Size: 0x513
	Parameters: 7
	Flags: None
*/
function update_model_attachment(localClientNum, data_struct, attached_model, slot, model_anim, model_intro_anim, force_update)
{
	/#
		Assert(isdefined(data_struct.attached_models));
	#/
	/#
		Assert(isdefined(data_struct.attached_model_anims));
	#/
	/#
		Assert(isdefined(level.model_type_bones));
	#/
	if(force_update || attached_model !== data_struct.attached_models[slot] || model_anim !== data_struct.attached_model_anims[slot])
	{
		bone = slot;
		if(isdefined(level.model_type_bones[slot]))
		{
			bone = level.model_type_bones[slot];
		}
		/#
			Assert(isdefined(bone));
		#/
		if(isdefined(data_struct.attached_models[slot]))
		{
			if(isdefined(data_struct.attached_entities[slot]))
			{
				data_struct.attached_entities[slot] Unlink();
				data_struct.attached_entities[slot] delete();
				data_struct.attached_entities[slot] = undefined;
			}
			else if(data_struct.characterModel IsAttached(data_struct.attached_models[slot], bone))
			{
				data_struct.characterModel Detach(data_struct.attached_models[slot], bone);
			}
			data_struct.attached_models[slot] = undefined;
		}
		data_struct.attached_models[slot] = attached_model;
		if(isdefined(data_struct.attached_models[slot]))
		{
			if(isdefined(model_anim))
			{
				ent = spawn(localClientNum, data_struct.characterModel.origin, "script_model");
				ent SetHighDetail(1, data_struct.alt_render_mode);
				data_struct.attached_entities[slot] = ent;
				ent SetModel(data_struct.attached_models[slot]);
				if(!ent HasAnimTree())
				{
					ent useanimtree(-1);
				}
				ent.origin = data_struct.characterModel.origin;
				ent.angles = data_struct.characterModel.angles;
				ent.chosenOrigin = ent.origin;
				ent.chosenAngles = ent.angles;
				ent thread play_intro_and_animation(model_intro_anim, model_anim, 1);
			}
			else if(!data_struct.characterModel IsAttached(data_struct.attached_models[slot], bone))
			{
				data_struct.characterModel Attach(data_struct.attached_models[slot], bone);
			}
			data_struct.attached_model_anims[slot] = model_anim;
		}
	}
	if(isdefined(data_struct.attached_entities[slot]))
	{
		data_struct.attached_entities[slot] SetBodyRenderOptions(data_struct.mode_render_options, data_struct.body_render_options, data_struct.helmet_render_options, data_struct.head_render_options);
	}
}

/*
	Name: set_character
	Namespace: character_customization
	Checksum: 0x27B5D188
	Offset: 0x1CB0
	Size: 0x27
	Parameters: 2
	Flags: None
*/
function set_character(data_struct, characterindex)
{
	data_struct.characterindex = characterindex;
}

/*
	Name: set_character_mode
	Namespace: character_customization
	Checksum: 0xEC73505A
	Offset: 0x1CE0
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function set_character_mode(data_struct, characterMode)
{
	/#
		Assert(isdefined(characterMode));
	#/
	data_struct.characterMode = characterMode;
	data_struct.mode_render_options = GetCharacterModeRenderOptions(characterMode);
}

/*
	Name: set_body
	Namespace: character_customization
	Checksum: 0xB3943CA1
	Offset: 0x1D50
	Size: 0x1CB
	Parameters: 5
	Flags: None
*/
function set_body(data_struct, mode, characterindex, bodyIndex, bodyColors)
{
	/#
		Assert(isdefined(mode));
	#/
	/#
		Assert(mode != 3);
	#/
	if(mode == 2 && (isdefined(data_struct.force_prologue_body) && data_struct.force_prologue_body))
	{
		bodyIndex = 1;
	}
	data_struct.bodyIndex = bodyIndex;
	data_struct.bodyModel = GetCharacterBodyModel(characterindex, bodyIndex, mode);
	if(isdefined(data_struct.bodyModel))
	{
		data_struct.characterModel SetModel(data_struct.bodyModel);
	}
	if(isdefined(bodyColors))
	{
		set_body_colors(data_struct, mode, bodyColors);
	}
	render_options = GetCharacterBodyRenderOptions(data_struct.characterindex, data_struct.bodyIndex, data_struct.bodyColors[0], data_struct.bodyColors[1], data_struct.bodyColors[2]);
	data_struct.body_render_options = render_options;
}

/*
	Name: set_body_colors
	Namespace: character_customization
	Checksum: 0x36DA94C7
	Offset: 0x1F28
	Size: 0x7D
	Parameters: 3
	Flags: None
*/
function set_body_colors(data_struct, mode, bodyColors)
{
	for(i = 0; i < bodyColors.size && i < bodyColors.size; i++)
	{
		set_body_color(data_struct, i, bodyColors[i]);
	}
}

/*
	Name: set_body_color
	Namespace: character_customization
	Checksum: 0xF3F5D371
	Offset: 0x1FB0
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function set_body_color(data_struct, colorSlot, colorIndex)
{
	data_struct.bodyColors[colorSlot] = colorIndex;
	render_options = GetCharacterBodyRenderOptions(data_struct.characterindex, data_struct.bodyIndex, data_struct.bodyColors[0], data_struct.bodyColors[1], data_struct.bodyColors[2]);
	data_struct.body_render_options = render_options;
}

/*
	Name: set_head
	Namespace: character_customization
	Checksum: 0x28A683A9
	Offset: 0x2078
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function set_head(data_struct, mode, headIndex)
{
	data_struct.headIndex = headIndex;
	data_struct.Headmodel = GetCharacterHeadModel(headIndex, mode);
	render_options = GetCharacterHeadRenderOptions(headIndex);
	data_struct.head_render_options = render_options;
}

/*
	Name: set_helmet
	Namespace: character_customization
	Checksum: 0x26B32404
	Offset: 0x2110
	Size: 0x83
	Parameters: 5
	Flags: None
*/
function set_helmet(data_struct, mode, characterindex, helmetIndex, helmetColors)
{
	data_struct.helmetIndex = helmetIndex;
	data_struct.helmetModel = GetCharacterHelmetModel(characterindex, helmetIndex, mode);
	set_helmet_colors(data_struct, helmetColors);
}

/*
	Name: set_showcase_weapon
	Namespace: character_customization
	Checksum: 0x88493AF2
	Offset: 0x21A0
	Size: 0xBCB
	Parameters: 10
	Flags: None
*/
function set_showcase_weapon(data_struct, mode, localClientNum, xuid, characterindex, showcaseWeaponName, showcaseWeaponAttachmentInfo, weaponRenderOptions, useShowcasePaintjob, useLocalPaintshop)
{
	if(isdefined(xuid))
	{
		SetShowcaseWeaponPaintshopXUID(localClientNum, xuid);
	}
	else
	{
		SetShowcaseWeaponPaintshopXUID(localClientNum);
	}
	data_struct.showcaseWeaponName = showcaseWeaponName;
	data_struct.showcaseWeaponModel = GetWeaponWithAttachments(showcaseWeaponName);
	if(data_struct.showcaseWeaponModel == GetWeapon("none"))
	{
		data_struct.showcaseWeaponModel = GetWeapon("ar_standard");
		data_struct.showcaseWeaponName = data_struct.showcaseWeaponModel.name;
	}
	attachmentNames = [];
	attachmentIndices = [];
	tokenizedAttachmentInfo = StrTok(showcaseWeaponAttachmentInfo, ",");
	for(index = 0; index + 1 < tokenizedAttachmentInfo.size;  = 0)
	{
		attachmentNames[attachmentNames.size] = tokenizedAttachmentInfo[index];
		attachmentIndices[attachmentIndices.size] = Int(tokenizedAttachmentInfo[index + 1]);
	}
	for(index = tokenizedAttachmentInfo.size; index + 1 < 16;  = tokenizedAttachmentInfo.size)
	{
		attachmentNames[attachmentNames.size] = "none";
		attachmentIndices[attachmentIndices.size] = 0;
	}
	data_struct.acvi = GetAttachmentCosmeticVariantIndexes(data_struct.showcaseWeaponModel, attachmentNames[0], attachmentIndices[0], attachmentNames[1], attachmentIndices[1], attachmentNames[2], attachmentIndices[2], attachmentNames[3], attachmentIndices[3], attachmentNames[4], attachmentIndices[4], attachmentNames[5], attachmentIndices[5], attachmentNames[6], attachmentIndices[6], attachmentNames[7], attachmentIndices[7]);
	camoIndex = 0;
	paintjobSlot = 15;
	paintjobIndex = 15;
	showPaintshop = 0;
	tokenizedWeaponRenderOptions = StrTok(weaponRenderOptions, ",");
	if(tokenizedWeaponRenderOptions.size > 2)
	{
		camoIndex = Int(tokenizedWeaponRenderOptions[0]);
		paintjobSlot = Int(tokenizedWeaponRenderOptions[1]);
		paintjobIndex = Int(tokenizedWeaponRenderOptions[2]);
		showPaintshop = paintjobSlot != 15 && paintjobIndex != 15;
	}
	paintshopClassType = 0;
	if(useShowcasePaintjob)
	{
		paintshopClassType = 1;
	}
	else if(useLocalPaintshop)
	{
		paintshopClassType = 2;
	}
	data_struct.weaponRenderOptions = CalcWeaponOptions(localClientNum, camoIndex, 0, 0, 0, 0, showPaintshop, paintshopClassType);
	weapon_root_name = data_struct.showcaseWeaponModel.rootweapon.name;
	weapon_is_dual_wield = data_struct.showcaseWeaponModel.isDualWield;
	weapon_group = GetItemGroupForWeaponName(weapon_root_name);
	if(weapon_group == "weapon_launcher")
	{
		if(weapon_root_name == "launcher_lockonly" || weapon_root_name == "launcher_multi")
		{
			weapon_group = "weapon_launcher_alt";
		}
		else if(weapon_root_name == "launcher_ex41")
		{
			weapon_group = "weapon_smg_ppsh";
		}
	}
	else if(weapon_group == "weapon_assault")
	{
		if(weapon_root_name == "ar_m14")
		{
			weapon_group = "weapon_shotgun_olympia";
		}
	}
	else if(weapon_group == "weapon_pistol" && weapon_is_dual_wield)
	{
		weapon_group = "weapon_pistol_dw";
	}
	else if(weapon_group == "weapon_smg")
	{
		if(weapon_root_name == "smg_ppsh")
		{
			weapon_group = "weapon_smg_ppsh";
		}
		else if(weapon_root_name == "smg_sten2")
		{
			weapon_group = "weapon_knuckles";
		}
	}
	else if(weapon_group == "weapon_cqb")
	{
		if(weapon_root_name == "shotgun_olympia")
		{
			weapon_group = "weapon_shotgun_olympia";
		}
	}
	else if(weapon_group == "weapon_special")
	{
		if(weapon_root_name == "special_crossbow" || weapon_root_name == "special_discgun")
		{
			weapon_group = "weapon_smg";
		}
		else if(weapon_root_name == "special_crossbow_dw")
		{
			weapon_group = "weapon_pistol_dw";
		}
		else if(weapon_root_name == "knife_ballistic")
		{
			weapon_group = "weapon_knife_ballistic";
		}
	}
	else if(weapon_group == "weapon_knife")
	{
		if(weapon_root_name == "melee_knuckles" || weapon_root_name == "melee_boxing")
		{
			weapon_group = "weapon_knuckles";
		}
		else if(weapon_root_name == "melee_chainsaw" || weapon_root_name == "melee_boneglass" || weapon_root_name == "melee_crescent")
		{
			weapon_group = "weapon_chainsaw";
		}
		else if(weapon_root_name == "melee_improvise" || weapon_root_name == "melee_shovel")
		{
			weapon_group = "weapon_improvise";
		}
		else if(weapon_root_name == "melee_wrench" || weapon_root_name == "melee_crowbar" || weapon_root_name == "melee_shockbaton")
		{
			weapon_group = "weapon_wrench";
		}
		else if(weapon_root_name == "melee_nunchuks")
		{
			weapon_group = "weapon_nunchucks";
		}
		else if(weapon_root_name == "melee_sword" || weapon_root_name == "melee_bat" || weapon_root_name == "melee_fireaxe" || weapon_root_name == "melee_mace" || weapon_root_name == "melee_katana")
		{
			weapon_group = "weapon_sword";
		}
		else if(weapon_root_name == "melee_prosthetic")
		{
			weapon_group = "weapon_prosthetic";
		}
	}
	else if(weapon_group == "miscweapon")
	{
		if(weapon_root_name == "blackjack_coin")
		{
			weapon_group = "brawler";
		}
		else if(weapon_root_name == "blackjack_cards")
		{
			weapon_group = "brawler";
		}
	}
	if(data_struct.characterMode === 0)
	{
		data_struct.anim_name = "pb_cac_rifle_showcase_cp";
	}
	else if(isdefined(associativeArray("weapon_smg", "pb_cac_smg_showcase", "weapon_assault", "pb_cac_rifle_showcase", "weapon_cqb", "pb_cac_rifle_showcase", "weapon_lmg", "pb_cac_rifle_showcase", "weapon_sniper", "pb_cac_sniper_showcase", "weapon_pistol", "pb_cac_pistol_showcase", "weapon_pistol_dw", "pb_cac_pistol_dw_showcase", "weapon_launcher", "pb_cac_launcher_showcase", "weapon_launcher_alt", "pb_cac_launcher_alt_showcase", "weapon_knife", "pb_cac_knife_showcase", "weapon_knuckles", "pb_cac_brass_knuckles_showcase", "weapon_wrench", "pb_cac_wrench_showcase", "weapon_improvise", "pb_cac_improvise_showcase", "weapon_sword", "pb_cac_sword_showcase", "weapon_nunchucks", "pb_cac_nunchucks_showcase", "weapon_mace", "pb_cac_sword_showcase", "brawler", "pb_cac_brawler_showcase", "weapon_prosthetic", "pb_cac_prosthetic_arm_showcase", "weapon_chainsaw", "pb_cac_chainsaw_showcase", "weapon_smg_ppsh", "pb_cac_smg_ppsh_showcase", "weapon_knife_ballistic", "pb_cac_b_knife_showcase", "weapon_shotgun_olympia", "pb_cac_shotgun_olympia_showcase")[weapon_group]))
	{
		data_struct.anim_name = associativeArray("weapon_smg", "pb_cac_smg_showcase", "weapon_assault", "pb_cac_rifle_showcase", "weapon_cqb", "pb_cac_rifle_showcase", "weapon_lmg", "pb_cac_rifle_showcase", "weapon_sniper", "pb_cac_sniper_showcase", "weapon_pistol", "pb_cac_pistol_showcase", "weapon_pistol_dw", "pb_cac_pistol_dw_showcase", "weapon_launcher", "pb_cac_launcher_showcase", "weapon_launcher_alt", "pb_cac_launcher_alt_showcase", "weapon_knife", "pb_cac_knife_showcase", "weapon_knuckles", "pb_cac_brass_knuckles_showcase", "weapon_wrench", "pb_cac_wrench_showcase", "weapon_improvise", "pb_cac_improvise_showcase", "weapon_sword", "pb_cac_sword_showcase", "weapon_nunchucks", "pb_cac_nunchucks_showcase", "weapon_mace", "pb_cac_sword_showcase", "brawler", "pb_cac_brawler_showcase", "weapon_prosthetic", "pb_cac_prosthetic_arm_showcase", "weapon_chainsaw", "pb_cac_chainsaw_showcase", "weapon_smg_ppsh", "pb_cac_smg_ppsh_showcase", "weapon_knife_ballistic", "pb_cac_b_knife_showcase", "weapon_shotgun_olympia", "pb_cac_shotgun_olympia_showcase")[weapon_group];
	}
}

/*
	Name: set_helmet_colors
	Namespace: character_customization
	Checksum: 0xDA774788
	Offset: 0x2D78
	Size: 0x103
	Parameters: 2
	Flags: None
*/
function set_helmet_colors(data_struct, colors)
{
	for(i = 0; i < colors.size && i < data_struct.helmetColors.size; i++)
	{
		set_helmet_color(data_struct, i, colors[i]);
	}
	render_options = GetCharacterHelmetRenderOptions(data_struct.characterindex, data_struct.helmetIndex, data_struct.helmetColors[0], data_struct.helmetColors[1], data_struct.helmetColors[2]);
	data_struct.helmet_render_options = render_options;
}

/*
	Name: set_helmet_color
	Namespace: character_customization
	Checksum: 0x91B57759
	Offset: 0x2E88
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function set_helmet_color(data_struct, colorSlot, colorIndex)
{
	data_struct.helmetColors[colorSlot] = colorIndex;
	render_options = GetCharacterHelmetRenderOptions(data_struct.characterindex, data_struct.helmetIndex, data_struct.helmetColors[0], data_struct.helmetColors[1], data_struct.helmetColors[2]);
	data_struct.helmet_render_options = render_options;
}

/*
	Name: update
	Namespace: character_customization
	Checksum: 0xA763D5BC
	Offset: 0x2F50
	Size: 0x303
	Parameters: 3
	Flags: None
*/
function update()
{
System.Exception: Unexpected non-stack operation within jump expression
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‪⁮⁮‪‪‭‎‎‍⁪⁪⁭⁮‎⁪​‎‎⁪‏⁭‪⁬⁫‏‍​‎‬‏‏​​⁫‫⁫‭‎‭⁯‮(ScriptOp )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.​‮‍‬⁯⁭‍⁫‌‭‎⁫‪⁮‏‏⁯⁫‏‏‮⁫⁪‫‪⁪⁭⁯‮⁯‭⁯‫⁯‎‏‍‌⁫‪‮(ScriptOp , ⁯‪‪‏⁮‮‎‏‏⁯‍⁬‮⁭‮‏‫‬‌‌‏​⁬‫⁯⁬‮‮⁫⁬‍‫⁮⁫‬⁪⁮‮⁭‌‮ )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‬‪‎⁭⁭⁮‎⁮⁭⁯‭‍⁯⁯⁪⁬‪‎⁪⁮‎⁭‬‪​‍‭⁪‮‪​‮‪⁯‪⁮⁬‪‮‏‮(Int32 )
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮.‫⁯⁪​‍⁭​⁫‫⁯‮​‍‬‮‌‪‪‎‫⁫‎‭‫⁪‫⁪⁬‪‍⁮‏‌⁪​‎‎⁯‮‭‮()
   at ‍​⁯‮⁪‍‪⁫⁮‎‫⁬‌⁭⁪​‫‬‫​​‌⁬‏‮⁫‪​‪⁫⁭⁮‫​⁮‍‭‌‬‎‮..ctor(ScriptExport , ScriptBase )
}

/*
	Name: is_character_streamed
	Namespace: character_customization
	Checksum: 0x329C6342
	Offset: 0x3260
	Size: 0xE3
	Parameters: 1
	Flags: None
*/
function is_character_streamed(data_struct)
{
	if(isdefined(data_struct.characterModel))
	{
		if(!data_struct.characterModel isStreamed())
		{
			return 0;
		}
	}
	foreach(ent in data_struct.attached_entities)
	{
		if(isdefined(ent))
		{
			if(!ent isStreamed())
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: setup_character_streaming
	Namespace: character_customization
	Checksum: 0x6F785B67
	Offset: 0x3350
	Size: 0xF1
	Parameters: 1
	Flags: None
*/
function setup_character_streaming(data_struct)
{
	if(isdefined(data_struct.characterModel))
	{
		data_struct.characterModel SetHighDetail(1, data_struct.alt_render_mode);
	}
	foreach(ent in data_struct.attached_entities)
	{
		if(isdefined(ent))
		{
			ent SetHighDetail(1, data_struct.alt_render_mode);
		}
	}
}

/*
	Name: get_character_mode
	Namespace: character_customization
	Checksum: 0xFEB99280
	Offset: 0x3450
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function get_character_mode(localClientNum)
{
	return GetEquippedHeroMode(localClientNum);
}

/*
	Name: get_character_body
	Namespace: character_customization
	Checksum: 0x2385B98A
	Offset: 0x3480
	Size: 0x24B
	Parameters: 4
	Flags: None
*/
function get_character_body(localClientNum, characterMode, characterindex, extracamData)
{
	/#
		Assert(isdefined(characterindex));
	#/
	if(characterMode === 2 && SessionModeIsCampaignGame() && GetDvarString("mapname") == "core_frontend")
	{
		mapIndex = GetDStat(localClientNum, "highestMapReached");
		if(isdefined(mapIndex) && mapIndex < 1)
		{
			str_gender = GetHeroGender(GetEquippedHeroIndex(localClientNum, 2), "cp");
			n_body_id = GetCharacterBodyStyleIndex(str_gender == "female", "CPUI_OUTFIT_PROLOGUE");
			return n_body_id;
		}
	}
	if(isdefined(extracamData) && (isdefined(extracamData.isDefaultHero) && extracamData.isDefaultHero))
	{
		return 0;
	}
	else if(isdefined(extracamData) && extracamData.useLobbyPlayers)
	{
		return GetEquippedBodyIndexForHero(localClientNum, characterMode, extracamData.jobIndex, 1);
	}
	else if(isdefined(extracamData) && isdefined(extracamData.useBodyIndex))
	{
		return extracamData.useBodyIndex;
	}
	else if(isdefined(extracamData) && (isdefined(extracamData.defaultImageRender) && extracamData.defaultImageRender))
	{
		return 0;
	}
	else
	{
		return GetEquippedBodyIndexForHero(localClientNum, characterMode, characterindex);
	}
}

/*
	Name: get_character_body_color
	Namespace: character_customization
	Checksum: 0xEFB6BF0E
	Offset: 0x36D8
	Size: 0x11B
	Parameters: 6
	Flags: None
*/
function get_character_body_color(localClientNum, characterMode, characterindex, bodyIndex, colorSlot, extracamData)
{
	if(isdefined(extracamData) && (isdefined(extracamData.isDefaultHero) && extracamData.isDefaultHero))
	{
		return 0;
	}
	else if(isdefined(extracamData) && extracamData.useLobbyPlayers)
	{
		return GetEquippedBodyAccentColorForHero(localClientNum, characterMode, extracamData.jobIndex, bodyIndex, colorSlot, 1);
	}
	else if(isdefined(extracamData) && (isdefined(extracamData.defaultImageRender) && extracamData.defaultImageRender))
	{
		return 0;
	}
	else
	{
		return GetEquippedBodyAccentColorForHero(localClientNum, characterMode, characterindex, bodyIndex, colorSlot);
	}
}

/*
	Name: get_character_body_colors
	Namespace: character_customization
	Checksum: 0xC6081C42
	Offset: 0x3800
	Size: 0xF3
	Parameters: 5
	Flags: None
*/
function get_character_body_colors(localClientNum, characterMode, characterindex, bodyIndex, extracamData)
{
	bodyAccentColorCount = GetBodyAccentColorCountForHero(localClientNum, characterMode, characterindex, bodyIndex);
	colors = [];
	for(i = 0; i < 3; i++)
	{
		colors[i] = 0;
	}
	for(i = 0; i < bodyAccentColorCount; i++)
	{
		colors[i] = get_character_body_color(localClientNum, characterMode, characterindex, bodyIndex, i, extracamData);
	}
	return colors;
}

/*
	Name: get_character_head
	Namespace: character_customization
	Checksum: 0xC705F92E
	Offset: 0x3900
	Size: 0x11B
	Parameters: 3
	Flags: None
*/
function get_character_head(localClientNum, characterMode, extracamData)
{
	if(isdefined(extracamData) && (isdefined(extracamData.isDefaultHero) && extracamData.isDefaultHero))
	{
		return 0;
	}
	else if(isdefined(extracamData) && extracamData.useLobbyPlayers)
	{
		return GetEquippedHeadIndexForHero(localClientNum, characterMode, extracamData.jobIndex);
	}
	else if(isdefined(extracamData) && isdefined(extracamData.useHeadIndex))
	{
		return extracamData.useHeadIndex;
	}
	else if(isdefined(extracamData) && (isdefined(extracamData.defaultImageRender) && extracamData.defaultImageRender))
	{
		return 0;
	}
	else
	{
		return GetEquippedHeadIndexForHero(localClientNum, characterMode);
	}
}

/*
	Name: get_character_helmet
	Namespace: character_customization
	Checksum: 0xC2B5987F
	Offset: 0x3A28
	Size: 0x12B
	Parameters: 4
	Flags: None
*/
function get_character_helmet(localClientNum, characterMode, characterindex, extracamData)
{
	if(isdefined(extracamData) && (isdefined(extracamData.isDefaultHero) && extracamData.isDefaultHero))
	{
		return 0;
	}
	else if(isdefined(extracamData) && extracamData.useLobbyPlayers)
	{
		return GetEquippedHelmetIndexForHero(localClientNum, characterMode, extracamData.jobIndex, 1);
	}
	else if(isdefined(extracamData) && isdefined(extracamData.useHelmetIndex))
	{
		return extracamData.useHelmetIndex;
	}
	else if(isdefined(extracamData) && (isdefined(extracamData.defaultImageRender) && extracamData.defaultImageRender))
	{
		return 0;
	}
	else
	{
		return GetEquippedHelmetIndexForHero(localClientNum, characterMode, characterindex);
	}
}

/*
	Name: get_character_showcase_weapon
	Namespace: character_customization
	Checksum: 0x70BCE869
	Offset: 0x3B60
	Size: 0xF3
	Parameters: 4
	Flags: None
*/
function get_character_showcase_weapon(localClientNum, characterMode, characterindex, extracamData)
{
	if(isdefined(extracamData) && (isdefined(extracamData.isDefaultHero) && extracamData.isDefaultHero))
	{
		return undefined;
	}
	else if(isdefined(extracamData) && extracamData.useLobbyPlayers)
	{
		return GetEquippedShowcaseWeaponForHero(localClientNum, characterMode, extracamData.jobIndex, 1);
	}
	else if(isdefined(extracamData) && isdefined(extracamData.useShowcaseWeapon))
	{
		return extracamData.useShowcaseWeapon;
	}
	else
	{
		return GetEquippedShowcaseWeaponForHero(localClientNum, characterMode, characterindex);
	}
}

/*
	Name: get_character_helmet_color
	Namespace: character_customization
	Checksum: 0x7F254641
	Offset: 0x3C60
	Size: 0x11B
	Parameters: 6
	Flags: None
*/
function get_character_helmet_color(localClientNum, characterMode, characterindex, helmetIndex, colorSlot, extracamData)
{
	if(isdefined(extracamData) && (isdefined(extracamData.isDefaultHero) && extracamData.isDefaultHero))
	{
		return 0;
	}
	else if(isdefined(extracamData) && extracamData.useLobbyPlayers)
	{
		return GetEquippedHelmetAccentColorForHero(localClientNum, characterMode, extracamData.jobIndex, helmetIndex, colorSlot, 1);
	}
	else if(isdefined(extracamData) && (isdefined(extracamData.defaultImageRender) && extracamData.defaultImageRender))
	{
		return 0;
	}
	else
	{
		return GetEquippedHelmetAccentColorForHero(localClientNum, characterMode, characterindex, helmetIndex, colorSlot);
	}
}

/*
	Name: get_character_helmet_colors
	Namespace: character_customization
	Checksum: 0xBA60C942
	Offset: 0x3D88
	Size: 0xF3
	Parameters: 5
	Flags: None
*/
function get_character_helmet_colors(localClientNum, characterMode, characterindex, helmetIndex, extracamData)
{
	helmetColorCount = GetHelmetAccentColorCountForHero(localClientNum, characterMode, characterindex, helmetIndex);
	colors = [];
	for(i = 0; i < 3; i++)
	{
		colors[i] = 0;
	}
	for(i = 0; i < helmetColorCount; i++)
	{
		colors[i] = get_character_helmet_color(localClientNum, characterMode, characterindex, helmetIndex, i, extracamData);
	}
	return colors;
}

/*
	Name: update_character_animation_tree_for_scene
	Namespace: character_customization
	Checksum: 0xFF379647
	Offset: 0x3E88
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function update_character_animation_tree_for_scene(characterModel)
{
	if(!characterModel HasAnimTree())
	{
		characterModel useanimtree(-1);
	}
}

/*
	Name: reaper_body3_hack
	Namespace: character_customization
	Checksum: 0x225EAFF0
	Offset: 0x3ED8
	Size: 0xC7
	Parameters: 1
	Flags: None
*/
function reaper_body3_hack(params)
{
	if(isdefined(params.weapon_right) && params.weapon_right == "wpn_t7_hero_reaper_minigun_prop" && isdefined(level.mp_lobby_data_struct.characterModel) && IsSubStr(level.mp_lobby_data_struct.characterModel.model, "body3"))
	{
		params.weapon_right = "wpn_t7_loot_hero_reaper3_minigun_prop";
		params.weapon = GetWeapon("hero_minigun_body3");
		return 1;
	}
	return 0;
}

/*
	Name: get_current_frozen_moment_params
	Namespace: character_customization
	Checksum: 0x796D2F6F
	Offset: 0x3FA8
	Size: 0x4D3
	Parameters: 3
	Flags: None
*/
function get_current_frozen_moment_params(localClientNum, data_struct, params)
{
	fields = GetCharacterFields(data_struct.characterindex, data_struct.characterMode);
	if(data_struct.frozenMomentStyle == "weapon")
	{
		if(isdefined(fields.weaponFrontendFrozenMomentXAnim))
		{
			params.anim_name = fields.weaponFrontendFrozenMomentXAnim;
		}
		params.scene = undefined;
		if(isdefined(fields.weaponFrontendFrozenMomentWeaponLeftModel))
		{
			params.weapon_left = fields.weaponFrontendFrozenMomentWeaponLeftModel;
		}
		if(isdefined(fields.weaponFrontendFrozenMomentWeaponLeftAnim))
		{
			params.weapon_left_anim = fields.weaponFrontendFrozenMomentWeaponLeftAnim;
		}
		if(isdefined(fields.weaponFrontendFrozenMomentWeaponRightModel))
		{
			params.weapon_right = fields.weaponFrontendFrozenMomentWeaponRightModel;
		}
		if(isdefined(fields.weaponFrontendFrozenMomentWeaponRightAnim))
		{
			params.weapon_right_anim = fields.weaponFrontendFrozenMomentWeaponRightAnim;
		}
		if(isdefined(fields.weaponFrontendFrozenMomentExploder))
		{
			params.exploder_id = fields.weaponFrontendFrozenMomentExploder;
		}
		if(isdefined(struct::get(fields.weaponFrontendFrozenMomentAlignTarget)))
		{
			params.align_struct = struct::get(fields.weaponFrontendFrozenMomentAlignTarget);
		}
		if(isdefined(fields.weaponFrontendFrozenMomentXCam))
		{
			params.xcam = fields.weaponFrontendFrozenMomentXCam;
		}
		if(isdefined(fields.weaponFrontendFrozenMomentXCamSubXCam))
		{
			params.subxcam = fields.weaponFrontendFrozenMomentXCamSubXCam;
		}
		if(isdefined(fields.weaponFrontendFrozenMomentXCamFrame))
		{
			params.xcamFrame = fields.weaponFrontendFrozenMomentXCamFrame;
		}
	}
	else if(data_struct.frozenMomentStyle == "ability")
	{
		if(isdefined(fields.abilityFrontendFrozenMomentXAnim))
		{
			params.anim_name = fields.abilityFrontendFrozenMomentXAnim;
		}
		params.scene = undefined;
		if(isdefined(fields.abilityFrontendFrozenMomentWeaponLeftModel))
		{
			params.weapon_left = fields.abilityFrontendFrozenMomentWeaponLeftModel;
		}
		if(isdefined(fields.abilityFrontendFrozenMomentWeaponLeftAnim))
		{
			params.weapon_left_anim = fields.abilityFrontendFrozenMomentWeaponLeftAnim;
		}
		if(isdefined(fields.abilityFrontendFrozenMomentWeaponRightModel))
		{
			params.weapon_right = fields.abilityFrontendFrozenMomentWeaponRightModel;
		}
		if(isdefined(fields.abilityFrontendFrozenMomentWeaponRightAnim))
		{
			params.weapon_right_anim = fields.abilityFrontendFrozenMomentWeaponRightAnim;
		}
		if(isdefined(fields.abilityFrontendFrozenMomentExploder))
		{
			params.exploder_id = fields.abilityFrontendFrozenMomentExploder;
		}
		if(isdefined(struct::get(fields.abilityFrontendFrozenMomentAlignTarget)))
		{
			params.align_struct = struct::get(fields.abilityFrontendFrozenMomentAlignTarget);
		}
		if(isdefined(fields.abilityFrontendFrozenMomentXCam))
		{
			params.xcam = fields.abilityFrontendFrozenMomentXCam;
		}
		if(isdefined(fields.abilityFrontendFrozenMomentXCamSubXCam))
		{
			params.subxcam = fields.abilityFrontendFrozenMomentXCamSubXCam;
		}
		if(isdefined(fields.abilityFrontendFrozenMomentXCamFrame))
		{
			params.xcamFrame = fields.abilityFrontendFrozenMomentXCamFrame;
		}
	}
	reaper_body3_hack(params);
	if(!isdefined(params.align_struct))
	{
		params.align_struct = data_struct;
	}
}

/*
	Name: play_intro_and_animation
	Namespace: character_customization
	Checksum: 0xBBA413B5
	Offset: 0x4488
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function play_intro_and_animation(intro_anim_name, anim_name, b_keep_link)
{
	self notify("stop_vignette_animation");
	self endon("stop_vignette_animation");
	if(isdefined(intro_anim_name))
	{
		self animation::Play(intro_anim_name, self.chosenOrigin, self.chosenAngles, 1, 0, 0, 0, b_keep_link);
	}
	self animation::Play(anim_name, self.chosenOrigin, self.chosenAngles, 1, 0, 0, 0, b_keep_link);
}

/*
	Name: update_character_animation_based_on_showcase_weapon
	Namespace: character_customization
	Checksum: 0x198F8B20
	Offset: 0x4540
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function update_character_animation_based_on_showcase_weapon(data_struct, params)
{
	if(!isdefined(params.weapon_right) && !isdefined(params.weapon_left))
	{
		if(isdefined(data_struct.anim_name))
		{
			params.anim_name = data_struct.anim_name;
		}
	}
}

/*
	Name: update_character_animation_and_attachments
	Namespace: character_customization
	Checksum: 0xFC2DFAEE
	Offset: 0x45B8
	Size: 0x88B
	Parameters: 3
	Flags: None
*/
function update_character_animation_and_attachments(localClientNum, data_struct, params)
{
	changed = 0;
	if(!isdefined(params))
	{
		params = spawnstruct();
	}
	if(data_struct.useFrozenMomentAnim && isdefined(data_struct.frozenMomentStyle))
	{
		get_current_frozen_moment_params(localClientNum, data_struct, params);
	}
	if(!isdefined(params.exploder_id))
	{
		params.exploder_id = data_struct.default_exploder;
	}
	align_changed = 0;
	if(!isdefined(params.align_struct))
	{
		params.align_struct = struct::get(data_struct.align_target);
	}
	if(!isdefined(params.align_struct))
	{
		params.align_struct = data_struct;
	}
	if(isdefined(params.align_struct) && (params.align_struct.origin !== data_struct.characterModel.chosenOrigin || params.align_struct.angles !== data_struct.characterModel.chosenAngles))
	{
		data_struct.characterModel.chosenOrigin = params.align_struct.origin;
		data_struct.characterModel.chosenAngles = params.align_struct.angles;
		if(isdefined(params.anim_name))
		{
		}
		else
		{
		}
		params.anim_name = data_struct.currentAnimation;
		align_changed = 1;
	}
	if(isdefined(data_struct.allow_showcase_weapons) && data_struct.allow_showcase_weapons)
	{
		update_character_animation_based_on_showcase_weapon(data_struct, params);
	}
	if(reaper_body3_hack(params))
	{
		align_changed = 1;
		changed = 1;
	}
	if(isdefined(params.weapon_right) && params.weapon_right !== data_struct.weapon_right)
	{
		align_changed = 1;
	}
	if(isdefined(params.anim_name) && (params.anim_name !== data_struct.currentAnimation || align_changed))
	{
		changed = 1;
		end_game_taunts::cancelTaunt(localClientNum, data_struct.characterModel);
		end_game_taunts::cancelGesture(data_struct.characterModel);
		data_struct.currentAnimation = params.anim_name;
		data_struct.weapon_right = params.weapon_right;
		if(!data_struct.characterModel HasAnimTree())
		{
			data_struct.characterModel useanimtree(-1);
		}
		data_struct.characterModel thread play_intro_and_animation(params.anim_intro_name, params.anim_name, 0);
	}
	else if(isdefined(params.scene) && params.scene !== data_struct.currentScene)
	{
		if(isdefined(data_struct.currentScene))
		{
			level scene::stop(data_struct.currentScene, 0);
		}
		update_character_animation_tree_for_scene(data_struct.characterModel);
		data_struct.currentScene = params.scene;
		level thread scene::Play(params.scene);
	}
	if(data_struct.exploder_id !== params.exploder_id)
	{
		if(isdefined(data_struct.exploder_id))
		{
			KillRadiantExploder(localClientNum, data_struct.exploder_id);
		}
		if(isdefined(params.exploder_id))
		{
			PlayRadiantExploder(localClientNum, params.exploder_id);
		}
		data_struct.exploder_id = params.exploder_id;
	}
	if(isdefined(params.weapon_right) || isdefined(params.weapon_left))
	{
		update_model_attachment(localClientNum, data_struct, params.weapon_right, "tag_weapon_right", params.weapon_right_anim, params.weapon_right_anim_intro, align_changed);
		update_model_attachment(localClientNum, data_struct, params.weapon_left, "tag_weapon_left", params.weapon_left_anim, params.weapon_left_anim_intro, align_changed);
	}
	else if(isdefined(data_struct.showcaseWeaponModel))
	{
		if(isdefined(data_struct.attached_models["tag_weapon_right"]) && data_struct.characterModel IsAttached(data_struct.attached_models["tag_weapon_right"], "tag_weapon_right"))
		{
			data_struct.characterModel Detach(data_struct.attached_models["tag_weapon_right"], "tag_weapon_right");
		}
		if(isdefined(data_struct.attached_models["tag_weapon_left"]) && data_struct.characterModel IsAttached(data_struct.attached_models["tag_weapon_left"], "tag_weapon_left"))
		{
			data_struct.characterModel Detach(data_struct.attached_models["tag_weapon_left"], "tag_weapon_left");
		}
		data_struct.characterModel AttachWeapon(data_struct.showcaseWeaponModel, data_struct.weaponRenderOptions, data_struct.acvi);
		data_struct.characterModel UseWeaponHideTags(data_struct.showcaseWeaponModel);
		data_struct.characterModel.showcaseWeapon = data_struct.showcaseWeaponModel;
		data_struct.characterModel.showcaseWeaponRenderOptions = data_struct.weaponRenderOptions;
		data_struct.characterModel.showcaseWeaponACVI = data_struct.acvi;
	}
	return changed;
}

/*
	Name: update_use_frozen_moments
	Namespace: character_customization
	Checksum: 0x14272D55
	Offset: 0x4E50
	Size: 0x117
	Parameters: 3
	Flags: None
*/
function update_use_frozen_moments(localClientNum, data_struct, useFrozenMoments)
{
	if(data_struct.useFrozenMomentAnim != useFrozenMoments)
	{
		data_struct.useFrozenMomentAnim = useFrozenMoments;
		params = spawnstruct();
		if(!data_struct.useFrozenMomentAnim)
		{
			params.align_struct = struct::get("character_customization");
			params.anim_name = "pb_cac_main_lobby_idle";
		}
		MarkAsDirty(data_struct.characterModel);
		update_character_animation_and_attachments(localClientNum, data_struct, params);
		if(data_struct.useFrozenMomentAnim)
		{
			level notify("frozenMomentChanged" + localClientNum);
		}
	}
}

/*
	Name: update_show_helmets
	Namespace: character_customization
	Checksum: 0x8A740EAF
	Offset: 0x4F70
	Size: 0xCB
	Parameters: 3
	Flags: None
*/
function update_show_helmets(localClientNum, data_struct, show_helmets)
{
	if(data_struct.show_helmets != show_helmets)
	{
		data_struct.show_helmets = show_helmets;
		params = spawnstruct();
		params.weapon_right = data_struct.attached_models["tag_weapon_right"];
		params.weapon_left = data_struct.attached_models["tag_weapon_left"];
		update(localClientNum, data_struct, params);
	}
}

/*
	Name: set_character_align
	Namespace: character_customization
	Checksum: 0x6C7E1BAC
	Offset: 0x5048
	Size: 0xCB
	Parameters: 3
	Flags: None
*/
function set_character_align(localClientNum, data_struct, align_target)
{
	if(data_struct.align_target !== align_target)
	{
		data_struct.align_target = align_target;
		params = spawnstruct();
		params.weapon_right = data_struct.attached_models["tag_weapon_right"];
		params.weapon_left = data_struct.attached_models["tag_weapon_left"];
		update(localClientNum, data_struct, params);
	}
}

/*
	Name: setup_live_character_customization_target
	Namespace: character_customization
	Checksum: 0x9153773A
	Offset: 0x5120
	Size: 0xC3
	Parameters: 1
	Flags: None
*/
function setup_live_character_customization_target(localClientNum)
{
	characterEnt = GetEnt(localClientNum, "character_customization", "targetname");
	if(isdefined(characterEnt))
	{
		customization_data_struct = create_character_data_struct(characterEnt, localClientNum, 1);
		customization_data_struct.default_exploder = "char_customization";
		customization_data_struct.allow_showcase_weapons = 1;
		level thread updateEventThread(localClientNum, customization_data_struct);
		return customization_data_struct;
	}
	return undefined;
}

/*
	Name: update_locked_shader
	Namespace: character_customization
	Checksum: 0xC732CB99
	Offset: 0x51F0
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function update_locked_shader(localClientNum, params)
{
	if(isdefined(params.isItemUnlocked) && params.isItemUnlocked != 1)
	{
		EnableFrontendLockedWeaponOverlay(localClientNum, 1);
	}
	else
	{
		EnableFrontendLockedWeaponOverlay(localClientNum, 0);
	}
}

/*
	Name: updateEventThread
	Namespace: character_customization
	Checksum: 0x9DCC7968
	Offset: 0x5278
	Size: 0x6B9
	Parameters: 2
	Flags: None
*/
function updateEventThread(localClientNum, data_struct)
{
	while(1)
	{
		level waittill("updateHero" + localClientNum, eventType, param1, param2, param3, param4);
		switch(eventType)
		{
			case "update_lcn":
			{
				data_struct.splitScreenClient = param1;
				break;
			}
			case "refresh":
			{
				data_struct.splitScreenClient = param1;
				params = spawnstruct();
				params.anim_name = "pb_cac_main_lobby_idle";
				params.sessionMode = param2;
				loadEquippedCharacterOnModel(localClientNum, data_struct, undefined, params);
				if(isdefined(param3) && param3 != "")
				{
					level.mp_lobby_data_struct.playsound = param3;
				}
				break;
			}
			case "changeHero":
			{
				params = spawnstruct();
				params.anim_name = "pb_cac_main_lobby_idle";
				params.sessionMode = param2;
				loadEquippedCharacterOnModel(localClientNum, data_struct, param1, params);
				break;
			}
			case "changeBody":
			{
				params = spawnstruct();
				params.sessionMode = param2;
				params.isItemUnlocked = param3;
				set_body(data_struct, param2, data_struct.characterindex, param1, get_character_body_colors(localClientNum, param2, data_struct.characterindex, param1));
				update(localClientNum, data_struct, params);
				update_locked_shader(localClientNum, params);
				break;
			}
			case "changeHelmet":
			{
				params = spawnstruct();
				params.sessionMode = param2;
				params.isItemUnlocked = param3;
				set_helmet(data_struct, param2, data_struct.characterindex, param1, get_character_helmet_colors(localClientNum, param2, data_struct.characterindex, param1));
				update(localClientNum, data_struct, params);
				update_locked_shader(localClientNum, params);
				break;
			}
			case "changeShowcaseWeapon":
			{
				params = spawnstruct();
				params.sessionMode = param4;
				set_showcase_weapon(data_struct, param4, localClientNum, undefined, data_struct.characterindex, param1, param2, param3, 0, 1);
				update(localClientNum, data_struct, params);
				break;
			}
			case "changeHead":
			{
				params = spawnstruct();
				params.sessionMode = param2;
				set_head(data_struct, param2, param1);
				update(localClientNum, data_struct, params);
				break;
			}
			case "changeBodyAccentColor":
			{
				params = spawnstruct();
				params.sessionMode = param3;
				set_body_color(data_struct, param1, param2);
				update(localClientNum, data_struct, params);
				break;
			}
			case "changeHelmetAccentColor":
			{
				params = spawnstruct();
				params.sessionMode = param3;
				set_helmet_color(data_struct, param1, param2);
				update(localClientNum, data_struct, params);
				break;
			}
			case "changeFrozenMoment":
			{
				data_struct.frozenMomentStyle = param1;
				if(data_struct.useFrozenMomentAnim)
				{
					MarkAsDirty(data_struct.characterModel);
					update_character_animation_and_attachments(localClientNum, data_struct, undefined);
				}
				level notify("frozenMomentChanged" + localClientNum);
				break;
			}
			case "previewGesture":
			{
				data_struct.currentAnimation = param1;
				thread end_game_taunts::previewGesture(localClientNum, data_struct.characterModel, data_struct.anim_name, param1);
				break;
			}
			case "previewTaunt":
			{
				if(is_character_streamed(data_struct))
				{
					data_struct.currentAnimation = param1;
					thread end_game_taunts::previewTaunt(localClientNum, data_struct.characterModel, data_struct.anim_name, param1);
				}
				break;
			}
		}
	}
}

/*
	Name: rotation_thread_spawner
	Namespace: character_customization
	Checksum: 0xADDD4AEC
	Offset: 0x5940
	Size: 0xF3
	Parameters: 3
	Flags: None
*/
function rotation_thread_spawner(localClientNum, data_struct, endOnEvent)
{
	if(!isdefined(endOnEvent))
	{
		return;
	}
	/#
		Assert(isdefined(data_struct.characterModel));
	#/
	model = data_struct.characterModel;
	baseAngles = model.angles;
	level thread update_model_rotation_for_right_stick(localClientNum, data_struct, endOnEvent);
	level waittill(endOnEvent);
	if(!(isdefined(data_struct.characterModel.anglesOverride) && data_struct.characterModel.anglesOverride))
	{
		model.angles = baseAngles;
	}
}

/*
	Name: update_model_rotation_for_right_stick
	Namespace: character_customization
	Checksum: 0xDB18EA1A
	Offset: 0x5A40
	Size: 0x2B7
	Parameters: 3
	Flags: None
*/
function update_model_rotation_for_right_stick(localClientNum, data_struct, endOnEvent)
{
	level endon(endOnEvent);
	/#
		Assert(isdefined(data_struct.characterModel));
	#/
	model = data_struct.characterModel;
	while(1)
	{
		if(isdefined(data_struct.splitScreenClient))
		{
		}
		else
		{
		}
		data_lcn = localClientNum;
		if(localClientActive(data_lcn) && (!isdefined(data_struct.characterModel.anglesOverride) && data_struct.characterModel.anglesOverride))
		{
			pos = GetControllerPosition(data_lcn);
			if(isdefined(pos["rightStick"]))
			{
				model.angles = (model.angles[0], AbsAngleClamp360(model.angles[1] + pos["rightStick"][0] * 3), model.angles[2]);
			}
			else
			{
				model.angles = (model.angles[0], AbsAngleClamp360(model.angles[1] + pos["look"][0] * 3), model.angles[2]);
			}
			if(IsPC())
			{
				pos = GetXCamMouseControl(data_lcn);
				model.angles = (model.angles[0], AbsAngleClamp360(model.angles[1] - pos["yaw"] * 3), model.angles[2]);
			}
		}
		wait(0.016);
	}
}

/*
	Name: setup_static_character_customization_target
	Namespace: character_customization
	Checksum: 0x953566BD
	Offset: 0x5D00
	Size: 0x17B
	Parameters: 1
	Flags: None
*/
function setup_static_character_customization_target(localClientNum)
{
	characterEnt = GetEnt(localClientNum, "character_customization_staging", "targetname");
	level.extra_cam_hero_data[localClientNum] = setup_character_extracam_struct("ui_cam_character_customization", "cam_menu_unfocus", "pb_cac_main_lobby_idle", 0);
	level.extra_cam_lobby_client_hero_data[localClientNum] = setup_character_extracam_struct("ui_cam_char_identity", "cam_bust", "pb_cac_vs_screen_idle_1", 1);
	level.extra_cam_headshot_hero_data[localClientNum] = setup_character_extracam_struct("ui_cam_char_identity", "cam_bust", "pb_cac_vs_screen_idle_1", 0);
	level.extra_cam_outfit_preview_data[localClientNum] = setup_character_extracam_struct("ui_cam_char_identity", "cam_bust", "pb_cac_main_lobby_idle", 0);
	if(isdefined(characterEnt))
	{
		customization_data_struct = create_character_data_struct(characterEnt, localClientNum, 0);
		level thread update_character_extracam(localClientNum, customization_data_struct);
		return customization_data_struct;
	}
	return undefined;
}

/*
	Name: setup_character_extracam_struct
	Namespace: character_customization
	Checksum: 0x47133DE6
	Offset: 0x5E88
	Size: 0x93
	Parameters: 4
	Flags: None
*/
function setup_character_extracam_struct(xcam, subxcam, model_animation, useLobbyPlayers)
{
	newStruct = spawnstruct();
	newStruct.xcam = xcam;
	newStruct.subxcam = subxcam;
	newStruct.anim_name = model_animation;
	newStruct.useLobbyPlayers = useLobbyPlayers;
	return newStruct;
}

/*
	Name: wait_for_extracam_close
	Namespace: character_customization
	Checksum: 0x5F015678
	Offset: 0x5F28
	Size: 0x53
	Parameters: 3
	Flags: None
*/
function wait_for_extracam_close(localClientNum, camera_ent, extraCamIndex)
{
	level waittill("render_complete_" + localClientNum + "_" + extraCamIndex);
	multi_extracam::extracam_reset_index(localClientNum, extraCamIndex);
}

/*
	Name: setup_character_extracam_settings
	Namespace: character_customization
	Checksum: 0x3C73414
	Offset: 0x5F88
	Size: 0x323
	Parameters: 3
	Flags: None
*/
function setup_character_extracam_settings(localClientNum, data_struct, extracam_data_struct)
{
	/#
		Assert(isdefined(extracam_data_struct.jobIndex));
	#/
	if(!isdefined(level.camera_ents))
	{
		level.camera_ents = [];
	}
	initializedExtracam = 0;
	if(isdefined(level.camera_ents[localClientNum]))
	{
	}
	else
	{
	}
	camera_ent = undefined;
	if(!isdefined(camera_ent))
	{
		initializedExtracam = 1;
		multi_extracam::extracam_init_index(localClientNum, "character_staging_extracam" + extracam_data_struct.extraCamIndex + 1, extracam_data_struct.extraCamIndex);
		camera_ent = level.camera_ents[localClientNum][extracam_data_struct.extraCamIndex];
	}
	/#
		Assert(isdefined(camera_ent));
	#/
	camera_ent PlayExtraCamXCam(extracam_data_struct.xcam, 0, extracam_data_struct.subxcam);
	params = spawnstruct();
	params.anim_name = extracam_data_struct.anim_name;
	params.extracam_data = extracam_data_struct;
	params.isDefaultHero = extracam_data_struct.isDefaultHero;
	params.sessionMode = extracam_data_struct.sessionMode;
	params.hide_helmet = isdefined(extracam_data_struct.hideHelmet) && extracam_data_struct.hideHelmet;
	data_struct.alt_render_mode = 0;
	loadEquippedCharacterOnModel(localClientNum, data_struct, extracam_data_struct.characterindex, params);
	while(!is_character_streamed(data_struct))
	{
		wait(0.016);
	}
	if(isdefined(extracam_data_struct.defaultImageRender) && extracam_data_struct.defaultImageRender)
	{
		wait(0.5);
	}
	else
	{
		wait(0.1);
	}
	setExtraCamRenderReady(extracam_data_struct.jobIndex);
	extracam_data_struct.jobIndex = undefined;
	if(initializedExtracam)
	{
		level thread wait_for_extracam_close(localClientNum, camera_ent, extracam_data_struct.extraCamIndex);
	}
}

/*
	Name: update_character_extracam
	Namespace: character_customization
	Checksum: 0x3A1A1507
	Offset: 0x62B8
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function update_character_extracam(localClientNum, data_struct)
{
	level endon("disconnect");
	while(1)
	{
		level waittill("process_character_extracam" + localClientNum, extracam_data_struct);
		setup_character_extracam_settings(localClientNum, data_struct, extracam_data_struct);
	}
}

/*
	Name: process_character_extracam_request
	Namespace: character_customization
	Checksum: 0x43A318D
	Offset: 0x6328
	Size: 0xBB
	Parameters: 5
	Flags: None
*/
function process_character_extracam_request(localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex)
{
	level.extra_cam_hero_data[localClientNum].jobIndex = jobIndex;
	level.extra_cam_hero_data[localClientNum].extraCamIndex = extraCamIndex;
	level.extra_cam_hero_data[localClientNum].characterindex = characterindex;
	level.extra_cam_hero_data[localClientNum].sessionMode = sessionMode;
	level notify("process_character_extracam" + localClientNum, level.extra_cam_hero_data[localClientNum]);
}

/*
	Name: process_lobby_client_character_extracam_request
	Namespace: character_customization
	Checksum: 0x58265A59
	Offset: 0x63F0
	Size: 0xC7
	Parameters: 4
	Flags: None
*/
function process_lobby_client_character_extracam_request(localClientNum, jobIndex, extraCamIndex, sessionMode)
{
	level.extra_cam_lobby_client_hero_data[localClientNum].jobIndex = jobIndex;
	level.extra_cam_lobby_client_hero_data[localClientNum].extraCamIndex = extraCamIndex;
	level.extra_cam_lobby_client_hero_data[localClientNum].characterindex = GetEquippedCharacterIndexForLobbyClientHero(localClientNum, jobIndex);
	level.extra_cam_lobby_client_hero_data[localClientNum].sessionMode = sessionMode;
	level notify("process_character_extracam" + localClientNum, level.extra_cam_lobby_client_hero_data[localClientNum]);
}

/*
	Name: process_current_hero_headshot_extracam_request
	Namespace: character_customization
	Checksum: 0x8EB5CE75
	Offset: 0x64C0
	Size: 0xDF
	Parameters: 6
	Flags: None
*/
function process_current_hero_headshot_extracam_request(localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex, isDefaultHero)
{
	level.extra_cam_headshot_hero_data[localClientNum].jobIndex = jobIndex;
	level.extra_cam_headshot_hero_data[localClientNum].extraCamIndex = extraCamIndex;
	level.extra_cam_headshot_hero_data[localClientNum].characterindex = characterindex;
	level.extra_cam_headshot_hero_data[localClientNum].isDefaultHero = isDefaultHero;
	level.extra_cam_headshot_hero_data[localClientNum].sessionMode = sessionMode;
	level notify("process_character_extracam" + localClientNum, level.extra_cam_headshot_hero_data[localClientNum]);
}

/*
	Name: process_outfit_preview_extracam_request
	Namespace: character_customization
	Checksum: 0xA20BAE34
	Offset: 0x65A8
	Size: 0xBB
	Parameters: 5
	Flags: None
*/
function process_outfit_preview_extracam_request(localClientNum, jobIndex, extraCamIndex, sessionMode, outfitIndex)
{
	level.extra_cam_outfit_preview_data[localClientNum].jobIndex = jobIndex;
	level.extra_cam_outfit_preview_data[localClientNum].extraCamIndex = extraCamIndex;
	level.extra_cam_outfit_preview_data[localClientNum].characterindex = outfitIndex;
	level.extra_cam_outfit_preview_data[localClientNum].sessionMode = sessionMode;
	level notify("process_character_extracam" + localClientNum, level.extra_cam_outfit_preview_data[localClientNum]);
}

/*
	Name: process_character_body_item_extracam_request
	Namespace: character_customization
	Checksum: 0xB812158C
	Offset: 0x6670
	Size: 0x17F
	Parameters: 7
	Flags: None
*/
function process_character_body_item_extracam_request(localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex, itemIndex, defaultImageRender)
{
	extracam_data = undefined;
	if(defaultImageRender)
	{
		extracam_data = setup_character_extracam_struct("ui_cam_char_customization_icons_render", "loot_body", "pb_cac_vs_screen_idle_1", 0);
		extracam_data.useHeadIndex = GetFirstHeadOfGender(GetHeroGender(characterindex, sessionMode), sessionMode);
	}
	else
	{
		extracam_data = setup_character_extracam_struct("ui_cam_char_customization_icons", "cam_body", "pb_cac_vs_screen_idle_1", 0);
	}
	extracam_data.jobIndex = jobIndex;
	extracam_data.extraCamIndex = extraCamIndex;
	extracam_data.sessionMode = sessionMode;
	extracam_data.characterindex = characterindex;
	extracam_data.useBodyIndex = itemIndex;
	extracam_data.defaultImageRender = defaultImageRender;
	level notify("process_character_extracam" + localClientNum, extracam_data);
}

/*
	Name: process_character_helmet_item_extracam_request
	Namespace: character_customization
	Checksum: 0xF26E4081
	Offset: 0x67F8
	Size: 0x17F
	Parameters: 7
	Flags: None
*/
function process_character_helmet_item_extracam_request(localClientNum, jobIndex, extraCamIndex, sessionMode, characterindex, itemIndex, defaultImageRender)
{
	extracam_data = undefined;
	if(defaultImageRender)
	{
		extracam_data = setup_character_extracam_struct("ui_cam_char_customization_icons_render", "loot_helmet", "pb_cac_vs_screen_idle_1", 0);
		extracam_data.useHeadIndex = GetFirstHeadOfGender(GetHeroGender(characterindex, sessionMode), sessionMode);
	}
	else
	{
		extracam_data = setup_character_extracam_struct("ui_cam_char_customization_icons", "cam_helmet", "pb_cac_vs_screen_idle_1", 0);
	}
	extracam_data.jobIndex = jobIndex;
	extracam_data.extraCamIndex = extraCamIndex;
	extracam_data.sessionMode = sessionMode;
	extracam_data.characterindex = characterindex;
	extracam_data.useHelmetIndex = itemIndex;
	extracam_data.defaultImageRender = defaultImageRender;
	level notify("process_character_extracam" + localClientNum, extracam_data);
}

/*
	Name: process_character_head_item_extracam_request
	Namespace: character_customization
	Checksum: 0xF3653415
	Offset: 0x6980
	Size: 0x177
	Parameters: 6
	Flags: None
*/
function process_character_head_item_extracam_request(localClientNum, jobIndex, extraCamIndex, sessionMode, headIndex, defaultImageRender)
{
	extracam_data = undefined;
	if(defaultImageRender)
	{
		extracam_data = setup_character_extracam_struct("ui_cam_char_customization_icons_render", "cam_head", "pb_cac_vs_screen_idle_1", 0);
		extracam_data.characterindex = GetFirstHeroOfGender(GetHeadGender(headIndex, sessionMode), sessionMode);
	}
	else
	{
		extracam_data = setup_character_extracam_struct("ui_cam_char_customization_icons", "cam_head", "pb_cac_vs_screen_idle_1", 0);
	}
	extracam_data.jobIndex = jobIndex;
	extracam_data.extraCamIndex = extraCamIndex;
	extracam_data.sessionMode = sessionMode;
	extracam_data.useHeadIndex = headIndex;
	extracam_data.hideHelmet = 1;
	extracam_data.defaultImageRender = defaultImageRender;
	level notify("process_character_extracam" + localClientNum, extracam_data);
}

