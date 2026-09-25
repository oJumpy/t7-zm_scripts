#using scripts\codescripts\struct;
#using scripts\core\_multi_extracam;
#using scripts\shared\animation_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace weapon_customization_icon;

/*
	Name: __init__sytem__
	Namespace: weapon_customization_icon
	Checksum: 0xC79D156B
	Offset: 0x290
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("weapon_customization_icon", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: weapon_customization_icon
	Checksum: 0x48D085E0
	Offset: 0x2D0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.extra_cam_wc_paintjob_icon = [];
	level.extra_cam_wc_variant_icon = [];
	level.extra_cam_render_wc_paintjobicon_func_callback = &process_wc_paintjobicon_extracam_request;
	level.extra_cam_render_wc_varianticon_func_callback = &process_wc_varianticon_extracam_request;
	level.weaponCustomizationIconSetup = &wc_icon_setup;
}

/*
	Name: wc_icon_setup
	Namespace: weapon_customization_icon
	Checksum: 0xF1A49229
	Offset: 0x340
	Size: 0x63
	Parameters: 1
	Flags: None
*/
function wc_icon_setup(localClientNum)
{
	level.extra_cam_wc_paintjob_icon[localClientNum] = spawnstruct();
	level.extra_cam_wc_variant_icon[localClientNum] = spawnstruct();
	level thread update_wc_icon_extracam(localClientNum);
}

/*
	Name: update_wc_icon_extracam
	Namespace: weapon_customization_icon
	Checksum: 0xB8B450AF
	Offset: 0x3B0
	Size: 0x77
	Parameters: 1
	Flags: None
*/
function update_wc_icon_extracam(localClientNum)
{
	level endon("disconnect");
	while(1)
	{
		level waittill("process_wc_icon_extracam_" + localClientNum, extracam_data_struct);
		setup_wc_weapon_model(localClientNum, extracam_data_struct);
		setup_wc_extracam_settings(localClientNum, extracam_data_struct);
	}
}

/*
	Name: wait_for_extracam_close
	Namespace: weapon_customization_icon
	Checksum: 0xF3F57DD6
	Offset: 0x430
	Size: 0x9B
	Parameters: 3
	Flags: None
*/
function wait_for_extracam_close(localClientNum, camera_ent, extracam_data_struct)
{
	level waittill("render_complete_" + localClientNum + "_" + extracam_data_struct.extraCamIndex);
	multi_extracam::extracam_reset_index(localClientNum, extracam_data_struct.extraCamIndex);
	if(isdefined(extracam_data_struct.weapon_script_model))
	{
		extracam_data_struct.weapon_script_model delete();
	}
}

/*
	Name: GetXcam
	Namespace: weapon_customization_icon
	Checksum: 0xBEDD7AD0
	Offset: 0x4D8
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function GetXcam(weapon_name, camera)
{
	xcam = GetWeaponXCam(weapon_name, camera);
	if(!isdefined(xcam))
	{
		xcam = GetWeaponXCam(GetWeapon("ar_damage"), camera);
	}
	return xcam;
}

/*
	Name: setup_wc_extracam_settings
	Namespace: weapon_customization_icon
	Checksum: 0x3466D9A5
	Offset: 0x560
	Size: 0x363
	Parameters: 2
	Flags: None
*/
function setup_wc_extracam_settings(localClientNum, extracam_data_struct)
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
		if(isdefined(struct::get("weapon_icon_staging_camera")))
		{
			camera_ent = multi_extracam::extracam_init_index(localClientNum, "weapon_icon_staging_camera", extracam_data_struct.extraCamIndex);
		}
		else
		{
			camera_ent = multi_extracam::extracam_init_item(localClientNum, get_safehouse_position_struct(), extracam_data_struct.extraCamIndex);
		}
	}
	/#
		Assert(isdefined(camera_ent));
	#/
	if(extracam_data_struct.loadoutSlot == "default_camo_render")
	{
		extracam_data_struct.xcam = "ui_cam_icon_camo_export";
		extracam_data_struct.subxcam = "cam_icon";
	}
	else
	{
		extracam_data_struct.xcam = GetXcam(extracam_data_struct.current_weapon, "cam_icon_weapon");
		extracam_data_struct.subxcam = "cam_icon";
	}
	position = extracam_data_struct.weapon_position;
	camera_ent PlayExtraCamXCam(extracam_data_struct.xcam, 0, extracam_data_struct.subxcam, extracam_data_struct.Notetrack, position.origin, position.angles, extracam_data_struct.weapon_script_model, position.origin, position.angles);
	while(!extracam_data_struct.weapon_script_model isStreamed())
	{
		wait(0.016);
	}
	if(extracam_data_struct.loadoutSlot == "default_camo_render")
	{
		wait(0.5);
	}
	else
	{
		level util::waittill_notify_or_timeout("paintshop_ready_" + extracam_data_struct.jobIndex, 5);
	}
	setExtraCamRenderReady(extracam_data_struct.jobIndex);
	extracam_data_struct.jobIndex = undefined;
	if(initializedExtracam)
	{
		level thread wait_for_extracam_close(localClientNum, camera_ent, extracam_data_struct);
	}
}

/*
	Name: set_wc_icon_weapon_options
	Namespace: weapon_customization_icon
	Checksum: 0xF64ECED3
	Offset: 0x8D0
	Size: 0xF3
	Parameters: 2
	Flags: None
*/
function set_wc_icon_weapon_options(weapon_options_param, extracam_data_struct)
{
	weapon_options = StrTok(weapon_options_param, ",");
	if(isdefined(weapon_options) && isdefined(extracam_data_struct.weapon_script_model))
	{
		extracam_data_struct.weapon_script_model SetWeaponRenderOptions(Int(weapon_options[0]), Int(weapon_options[1]), 0, 0, Int(weapon_options[2]), extracam_data_struct.paintjobSlot, extracam_data_struct.paintjobIndex, 1, extracam_data_struct.isFilesharePreview);
	}
}

/*
	Name: spawn_weapon_model
	Namespace: weapon_customization_icon
	Checksum: 0xD6D4BF13
	Offset: 0x9D0
	Size: 0x7F
	Parameters: 3
	Flags: None
*/
function spawn_weapon_model(localClientNum, origin, angles)
{
	weapon_model = spawn(localClientNum, origin, "script_model");
	if(isdefined(angles))
	{
		weapon_model.angles = angles;
	}
	weapon_model SetHighDetail();
	return weapon_model;
}

/*
	Name: set_wc_icon_cosmetic_variants
	Namespace: weapon_customization_icon
	Checksum: 0x1AAC04F6
	Offset: 0xA58
	Size: 0xCF
	Parameters: 3
	Flags: None
*/
function set_wc_icon_cosmetic_variants(acv_param, weapon_full_name, extracam_data_struct)
{
	acv_indexes = StrTok(acv_param, ",");
	for(i = 0; i + 1 < acv_indexes.size;  = 0)
	{
		extracam_data_struct.weapon_script_model SetAttachmentCosmeticVariantIndex(weapon_full_name, acv_indexes[i], Int(acv_indexes[i + 1]));
	}
}

/*
	Name: get_safehouse_position_struct
	Namespace: weapon_customization_icon
	Checksum: 0xB329842C
	Offset: 0xB30
	Size: 0xE5
	Parameters: 0
	Flags: None
*/
function get_safehouse_position_struct()
{
	position = spawnstruct();
	position.angles = (0, 0, 0);
	switch(ToLower(GetDvarString("mapname")))
	{
		case "cp_sh_cairo":
		{
			position.origin = (-527, 1569, -25);
			break;
		}
		case "cp_sh_singapore":
		{
			position.origin = (-1215, 2464, 190);
			break;
		}
		case default:
		{
			position.origin = (191, 113, -2550);
			break;
		}
	}
	return position;
}

/*
	Name: setup_wc_weapon_model
	Namespace: weapon_customization_icon
	Checksum: 0x4CB8BFE6
	Offset: 0xC20
	Size: 0x253
	Parameters: 2
	Flags: None
*/
function setup_wc_weapon_model(localClientNum, extracam_data_struct)
{
	base_weapon_slot = extracam_data_struct.loadoutSlot;
	weapon_full_name = extracam_data_struct.weaponPlusAttachments;
	weapon_options_param = extracam_data_struct.weaponOptions;
	acv_param = extracam_data_struct.attachmentVariantString;
	if(isdefined(weapon_full_name))
	{
		position = struct::get("weapon_icon_staging");
		if(!isdefined(position))
		{
			position = get_safehouse_position_struct();
		}
		if(!isdefined(extracam_data_struct.weapon_script_model))
		{
			extracam_data_struct.weapon_script_model = spawn_weapon_model(localClientNum, position.origin, position.angles);
		}
		extracam_data_struct.current_weapon = GetWeaponWithAttachments(weapon_full_name);
		if(isdefined(extracam_data_struct.current_weapon.frontendmodel))
		{
			extracam_data_struct.weapon_script_model UseWeaponModel(extracam_data_struct.current_weapon, extracam_data_struct.current_weapon.frontendmodel);
		}
		else
		{
			extracam_data_struct.weapon_script_model UseWeaponModel(extracam_data_struct.current_weapon);
		}
		extracam_data_struct.weapon_position = position;
		if(isdefined(acv_param) && acv_param != "none")
		{
			set_wc_icon_cosmetic_variants(acv_param, weapon_full_name, extracam_data_struct);
		}
		if(isdefined(weapon_options_param) && weapon_options_param != "none")
		{
			set_wc_icon_weapon_options(weapon_options_param, extracam_data_struct);
		}
	}
}

/*
	Name: process_wc_paintjobicon_extracam_request
	Namespace: weapon_customization_icon
	Checksum: 0x3216106C
	Offset: 0xE80
	Size: 0x18F
	Parameters: 10
	Flags: None
*/
function process_wc_paintjobicon_extracam_request(localClientNum, extraCamIndex, jobIndex, attachmentVariantString, weaponOptions, weaponPlusAttachments, loadoutSlot, paintjobIndex, paintjobSlot, isFilesharePreview)
{
	level.extra_cam_wc_paintjob_icon[localClientNum].jobIndex = jobIndex;
	level.extra_cam_wc_paintjob_icon[localClientNum].extraCamIndex = extraCamIndex;
	level.extra_cam_wc_paintjob_icon[localClientNum].attachmentVariantString = attachmentVariantString;
	level.extra_cam_wc_paintjob_icon[localClientNum].weaponOptions = weaponOptions;
	level.extra_cam_wc_paintjob_icon[localClientNum].weaponPlusAttachments = weaponPlusAttachments;
	level.extra_cam_wc_paintjob_icon[localClientNum].loadoutSlot = loadoutSlot;
	level.extra_cam_wc_paintjob_icon[localClientNum].paintjobIndex = paintjobIndex;
	level.extra_cam_wc_paintjob_icon[localClientNum].paintjobSlot = paintjobSlot;
	level.extra_cam_wc_paintjob_icon[localClientNum].Notetrack = "paintjobpreview";
	level.extra_cam_wc_paintjob_icon[localClientNum].isFilesharePreview = isFilesharePreview;
	level notify("process_wc_icon_extracam_" + localClientNum, level.extra_cam_wc_paintjob_icon[localClientNum]);
}

/*
	Name: process_wc_varianticon_extracam_request
	Namespace: weapon_customization_icon
	Checksum: 0xA21AD56
	Offset: 0x1018
	Size: 0x18F
	Parameters: 10
	Flags: None
*/
function process_wc_varianticon_extracam_request(localClientNum, extraCamIndex, jobIndex, attachmentVariantString, weaponOptions, weaponPlusAttachments, loadoutSlot, paintjobIndex, paintjobSlot, isFilesharePreview)
{
	level.extra_cam_wc_variant_icon[localClientNum].jobIndex = jobIndex;
	level.extra_cam_wc_variant_icon[localClientNum].extraCamIndex = extraCamIndex;
	level.extra_cam_wc_variant_icon[localClientNum].attachmentVariantString = attachmentVariantString;
	level.extra_cam_wc_variant_icon[localClientNum].weaponOptions = weaponOptions;
	level.extra_cam_wc_variant_icon[localClientNum].weaponPlusAttachments = weaponPlusAttachments;
	level.extra_cam_wc_variant_icon[localClientNum].loadoutSlot = loadoutSlot;
	level.extra_cam_wc_variant_icon[localClientNum].paintjobIndex = paintjobIndex;
	level.extra_cam_wc_variant_icon[localClientNum].paintjobSlot = paintjobSlot;
	level.extra_cam_wc_variant_icon[localClientNum].Notetrack = "variantpreview";
	level.extra_cam_wc_variant_icon[localClientNum].isFilesharePreview = isFilesharePreview;
	level notify("process_wc_icon_extracam_" + localClientNum, level.extra_cam_wc_variant_icon[localClientNum]);
}

