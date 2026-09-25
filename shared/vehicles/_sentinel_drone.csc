#using scripts\codescripts\struct;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace sentinel_drone;

/*
	Name: __init__sytem__
	Namespace: sentinel_drone
	Checksum: 0xA226F90F
	Offset: 0x8B8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("sentinel_drone", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: sentinel_drone
	Checksum: 0x14034BB2
	Offset: 0x8F8
	Size: 0x865
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "sentinel_drone_beam_set_target_id", 12000, 5, "int", &sentinel_drone_beam_set_target_id, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_set_source_to_target", 12000, 5, "int", &sentinel_drone_beam_set_source_to_target, 0, 0);
	clientfield::register("toplayer", "sentinel_drone_damage_player_fx", 12000, 1, "counter", &sentinel_drone_damage_player_fx, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_fire1", 12000, 1, "int", &sentinel_drone_beam_fire1, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_fire2", 12000, 1, "int", &sentinel_drone_beam_fire2, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_fire3", 12000, 1, "int", &sentinel_drone_beam_fire3, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_arm_cut_1", 12000, 1, "int", &sentinel_drone_arm_cut_1, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_arm_cut_2", 12000, 1, "int", &sentinel_drone_arm_cut_2, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_arm_cut_3", 12000, 1, "int", &sentinel_drone_arm_cut_3, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_face_cut", 12000, 1, "int", &sentinel_drone_face_cut, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_charge", 12000, 1, "int", &sentinel_drone_beam_charge, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_camera_scanner", 12000, 1, "int", &sentinel_drone_camera_scanner, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_camera_destroyed", 12000, 1, "int", &sentinel_drone_camera_destroyed, 0, 0);
	clientfield::register("scriptmover", "sentinel_drone_deathfx", 1, 1, "int", &sentinel_drone_deathfx, 0, 0);
	level._sentinel_Enemy_Detected_Taunts = [];
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_0";
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_1";
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_2";
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_3";
	if(!isdefined(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Enemy_Detected_Taunts))
	{
		level._sentinel_Enemy_Detected_Taunts = Array(level._sentinel_Enemy_Detected_Taunts);
	}
	level._sentinel_Enemy_Detected_Taunts[level._sentinel_Enemy_Detected_Taunts.size] = "vox_valk_valkyrie_detected_4";
	level._sentinel_Attack_Taunts = [];
	if(!isdefined(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = Array(level._sentinel_Attack_Taunts);
	}
	level._sentinel_Attack_Taunts[level._sentinel_Attack_Taunts.size] = "vox_valk_valkyrie_attack_0";
	if(!isdefined(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = Array(level._sentinel_Attack_Taunts);
	}
	level._sentinel_Attack_Taunts[level._sentinel_Attack_Taunts.size] = "vox_valk_valkyrie_attack_1";
	if(!isdefined(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = Array(level._sentinel_Attack_Taunts);
	}
	level._sentinel_Attack_Taunts[level._sentinel_Attack_Taunts.size] = "vox_valk_valkyrie_attack_2";
	if(!isdefined(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = Array(level._sentinel_Attack_Taunts);
	}
	level._sentinel_Attack_Taunts[level._sentinel_Attack_Taunts.size] = "vox_valk_valkyrie_attack_3";
	if(!isdefined(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = [];
	}
	else if(!IsArray(level._sentinel_Attack_Taunts))
	{
		level._sentinel_Attack_Taunts = Array(level._sentinel_Attack_Taunts);
	}
	level._sentinel_Attack_Taunts[level._sentinel_Attack_Taunts.size] = "vox_valk_valkyrie_attack_4";
}

/*
	Name: sentinel_is_drone_initialized
	Namespace: sentinel_drone
	Checksum: 0xB6FC3237
	Offset: 0x1168
	Size: 0xDF
	Parameters: 2
	Flags: None
*/
function sentinel_is_drone_initialized(localClientNum, b_check_for_target_existance_only)
{
	if(!(isdefined(b_check_for_target_existance_only) && b_check_for_target_existance_only))
	{
		if(!(isdefined(self.init) && self.init))
		{
			return 0;
		}
		if(!self hasdobj(localClientNum))
		{
			return 0;
		}
		return 1;
	}
	else
	{
		source_num = self GetEntityNumber();
		if(isdefined(level.sentinel_drone_source_to_target) && isdefined(level.sentinel_drone_source_to_target[source_num]) && isdefined(level.sentinel_drone_target_id) && isdefined(level.sentinel_drone_target_id[level.sentinel_drone_source_to_target[source_num]]))
		{
			return 1;
		}
		return 0;
	}
}

/*
	Name: sentinel_drone_damage_player_fx
	Namespace: sentinel_drone
	Checksum: 0x97C2F600
	Offset: 0x1250
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function sentinel_drone_damage_player_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	localPlayer = GetLocalPlayer(localClientNum);
	if(isdefined(localPlayer))
	{
		localPlayer thread postfx::playPostfxBundle("sentinel_pstfx_shock_charge");
	}
}

/*
	Name: sentinel_drone_deathfx
	Namespace: sentinel_drone
	Checksum: 0xE3C49F09
	Offset: 0x12E0
	Size: 0x117
	Parameters: 7
	Flags: None
*/
function sentinel_drone_deathfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	settings = struct::get_script_bundle("vehiclecustomsettings", "sentinel_drone_settings");
	if(isdefined(settings))
	{
		if(newVal)
		{
			handle = playFX(localClientNum, settings.drone_secondary_death_fx_1, self.origin);
			SetFXIgnorePause(localClientNum, handle, 1);
			if(isdefined(self.beam_target_fx) && isdefined(self.beam_target_fx[localClientNum]))
			{
				stopfx(localClientNum, self.beam_target_fx[localClientNum]);
				self.beam_target_fx[localClientNum] = undefined;
			}
		}
	}
}

/*
	Name: sentinel_drone_camera_scanner
	Namespace: sentinel_drone
	Checksum: 0xA3D27F8C
	Offset: 0x1400
	Size: 0x16B
	Parameters: 7
	Flags: None
*/
function sentinel_drone_camera_scanner(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!sentinel_is_drone_initialized(localClientNum))
	{
		return 0;
	}
	if(newVal == 1)
	{
		if(!isdefined(self.CameraScannerFX) && (!isdefined(self.CameraDestroyed) && self.CameraDestroyed))
		{
			self.CameraScannerFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_scanner_light_glow", self, "tag_flash");
		}
		sentinel_play_engine_fx(localClientNum, 0, 1);
	}
	else
	{
		keep_scanner_on = GetDvarInt("Dev Block strings are not supported", 0);
		if(isdefined(self.CameraScannerFX) && (!isdefined(keep_scanner_on) && keep_scanner_on))
		{
			stopfx(localClientNum, self.CameraScannerFX);
			self.CameraScannerFX = undefined;
		}
		sentinel_play_engine_fx(localClientNum, 1, 0);
	}
	/#
	#/
}

/*
	Name: sentinel_drone_camera_destroyed
	Namespace: sentinel_drone
	Checksum: 0xF5720710
	Offset: 0x1578
	Size: 0xB5
	Parameters: 7
	Flags: None
*/
function sentinel_drone_camera_destroyed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self.CameraDestroyed = 1;
	if(isdefined(self.CameraScannerFX))
	{
		stopfx(localClientNum, self.CameraScannerFX);
		self.CameraScannerFX = undefined;
	}
	if(isdefined(self.CameraAmbientFX))
	{
		stopfx(localClientNum, self.CameraAmbientFX);
		self.CameraAmbientFX = undefined;
	}
}

/*
	Name: sentinel_drone_beam_fire1
	Namespace: sentinel_drone
	Checksum: 0xFA8E1002
	Offset: 0x1638
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function sentinel_drone_beam_fire1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	sentinel_drone_beam_fire(localClientNum, newVal, "tag_fx1");
}

/*
	Name: sentinel_drone_beam_fire2
	Namespace: sentinel_drone
	Checksum: 0xE9AD0CB8
	Offset: 0x16A0
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function sentinel_drone_beam_fire2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	sentinel_drone_beam_fire(localClientNum, newVal, "tag_fx2");
}

/*
	Name: sentinel_drone_beam_fire3
	Namespace: sentinel_drone
	Checksum: 0xB3A596EA
	Offset: 0x1708
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function sentinel_drone_beam_fire3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	sentinel_drone_beam_fire(localClientNum, newVal, "tag_fx3");
}

/*
	Name: sentinel_drone_beam_fire
	Namespace: sentinel_drone
	Checksum: 0x970C0DDA
	Offset: 0x1770
	Size: 0x283
	Parameters: 3
	Flags: None
*/
function sentinel_drone_beam_fire(localClientNum, newVal, tag_id)
{
	if(sentinel_is_drone_initialized(localClientNum, newVal == 0))
	{
		source_num = self GetEntityNumber();
		beam_target = level.sentinel_drone_target_id[level.sentinel_drone_source_to_target[source_num]];
	}
	else
	{
		return;
	}
	if(newVal == 1)
	{
		level beam::launch(self, tag_id, beam_target, "tag_origin", "electric_taser_beam_1");
		self playsound(0, "zmb_sentinel_attack_short");
		if(!isdefined(beam_target.beam_target_fx))
		{
			beam_target.beam_target_fx = [];
		}
		if(!isdefined(beam_target.beam_target_fx[localClientNum]))
		{
			beam_target.beam_target_fx[localClientNum] = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_taser_fire_tgt", beam_target, "tag_origin");
		}
		/#
			keep_scanner_on = GetDvarInt("Dev Block strings are not supported", 0);
		#/
		if(isdefined(self.CameraScannerFX) && (!isdefined(keep_scanner_on) && keep_scanner_on))
		{
			stopfx(localClientNum, self.CameraScannerFX);
			self.CameraScannerFX = undefined;
		}
	}
	else
	{
		level beam::kill(self, tag_id, beam_target, "tag_origin", "electric_taser_beam_1");
		if(isdefined(beam_target.beam_target_fx) && isdefined(beam_target.beam_target_fx[localClientNum]))
		{
			stopfx(localClientNum, beam_target.beam_target_fx[localClientNum]);
			beam_target.beam_target_fx[localClientNum] = undefined;
		}
		self sentinel_play_claws_ambient_fx(localClientNum);
	}
}

/*
	Name: sentinel_drone_beam_set_target_id
	Namespace: sentinel_drone
	Checksum: 0x2D9EACC0
	Offset: 0x1A00
	Size: 0x65
	Parameters: 7
	Flags: None
*/
function sentinel_drone_beam_set_target_id(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.sentinel_drone_target_id))
	{
		level.sentinel_drone_target_id = [];
	}
	level.sentinel_drone_target_id[newVal] = self;
}

/*
	Name: sentinel_drone_beam_set_source_to_target
	Namespace: sentinel_drone
	Checksum: 0xA3FD07DD
	Offset: 0x1A70
	Size: 0x173
	Parameters: 7
	Flags: None
*/
function sentinel_drone_beam_set_source_to_target(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!isdefined(level.sentinel_drone_source_to_target))
	{
		level.sentinel_drone_source_to_target = [];
	}
	source_num = self GetEntityNumber();
	level.sentinel_drone_source_to_target[source_num] = newVal;
	self.init = 1;
	self sentinel_play_claws_ambient_fx(localClientNum);
	self.CameraAmbientFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_eye_camera_lens_glow", self, "tag_flash");
	self.CameraScannerFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_scanner_light_glow", self, "tag_flash");
	sentinel_play_engine_fx(localClientNum, 1, 0);
	self useanimtree(-1);
	self SetAnim("ai_zm_dlc3_sentinel_antenna_twitch");
}

/*
	Name: sentinel_drone_arm_cut_1
	Namespace: sentinel_drone
	Checksum: 0x9136D004
	Offset: 0x1BF0
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function sentinel_drone_arm_cut_1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	sentinel_drone_arm_cut(localClientNum, 1);
}

/*
	Name: sentinel_drone_arm_cut_2
	Namespace: sentinel_drone
	Checksum: 0xA99DC533
	Offset: 0x1C50
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function sentinel_drone_arm_cut_2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	sentinel_drone_arm_cut(localClientNum, 2);
}

/*
	Name: sentinel_drone_arm_cut_3
	Namespace: sentinel_drone
	Checksum: 0x185717D
	Offset: 0x1CB0
	Size: 0x53
	Parameters: 7
	Flags: None
*/
function sentinel_drone_arm_cut_3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	sentinel_drone_arm_cut(localClientNum, 3);
}

/*
	Name: sentinel_spawn_broken_arm
	Namespace: sentinel_drone
	Checksum: 0xF5C748FB
	Offset: 0x1D10
	Size: 0x2CB
	Parameters: 4
	Flags: None
*/
function sentinel_spawn_broken_arm(localClientNum, arm, arm_tag, claw_tag)
{
	if(!sentinel_is_drone_initialized(localClientNum))
	{
		return 0;
	}
	velocity = self GetVelocity();
	velocity_normal = VectorNormalize(velocity);
	velocity_length = length(velocity);
	if(arm == 3)
	{
		launch_dir = AnglesToForward(self.angles) * -1;
		launch_dir = launch_dir + (0, 0, 1);
		launch_dir = VectorNormalize(launch_dir);
	}
	else if(arm == 1)
	{
		launch_dir = AnglesToRight(self.angles);
	}
	else
	{
		launch_dir = AnglesToRight(self.angles) * -1;
	}
	velocity_length = velocity_length * 0.1;
	if(velocity_length < 10)
	{
		velocity_length = 10;
	}
	launch_dir = launch_dir * 0.5 + velocity_normal * 0.5;
	launch_dir = launch_dir * velocity_length;
	claw_pos = self GetTagOrigin(claw_tag) + launch_dir * 3;
	claw_ang = self GetTagAngles(claw_tag);
	thread sentinel_launch_piece(localClientNum, "veh_t7_dlc3_sentinel_drone_spawn_claw", claw_pos, claw_ang, self.origin, launch_dir * 1.3);
	arm_pos = self GetTagOrigin(arm_tag) + launch_dir * 2;
	arm_ang = self GetTagAngles(arm_tag);
	thread sentinel_launch_piece(localClientNum, "veh_t7_dlc3_sentinel_drone_spawn_arm", arm_pos, arm_ang, self.origin, launch_dir);
}

/*
	Name: sentinel_drone_arm_cut
	Namespace: sentinel_drone
	Checksum: 0xD4A3C8C5
	Offset: 0x1FE8
	Size: 0x3EB
	Parameters: 2
	Flags: None
*/
function sentinel_drone_arm_cut(localClientNum, arm)
{
	if(arm == 1)
	{
		if(!(isdefined(self.rightArmLost) && self.rightArmLost))
		{
			sentinel_spawn_broken_arm(localClientNum, 1, "tag_arm_right_04_d1", "tag_fx1");
			self.rightArmLost = 1;
			sentinel_drone_beam_fire(localClientNum, 0, "tag_fx1");
			if(isdefined(self.rightClawAmbientFX))
			{
				stopfx(localClientNum, self.rightClawAmbientFX);
				self.rightClawAmbientFX = undefined;
			}
			if(isdefined(self.rightClawChargeFX))
			{
				stopfx(localClientNum, self.rightClawChargeFX);
				self.rightClawChargeFX = undefined;
			}
			if(sentinel_is_drone_initialized(localClientNum))
			{
				PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_dest_arm", self, "tag_arm_right_04_d1");
				self SetAnim("ai_zm_dlc3_sentinel_arms_broken_right");
			}
		}
	}
	else if(arm == 2)
	{
		if(!(isdefined(self.leftArmLost) && self.leftArmLost))
		{
			sentinel_spawn_broken_arm(localClientNum, 2, "tag_arm_left_03_d1", "tag_fx2");
			self.leftArmLost = 1;
			sentinel_drone_beam_fire(localClientNum, 0, "tag_fx2");
			if(isdefined(self.leftClawAmbientFX))
			{
				stopfx(localClientNum, self.leftClawAmbientFX);
				self.leftClawAmbientFX = undefined;
			}
			if(isdefined(self.leftClawChargeFX))
			{
				stopfx(localClientNum, self.leftClawChargeFX);
				self.leftClawChargeFX = undefined;
			}
			if(sentinel_is_drone_initialized(localClientNum))
			{
				PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_dest_arm", self, "tag_arm_left_03_d1");
				self SetAnim("ai_zm_dlc3_sentinel_arms_broken_left");
			}
		}
	}
	else if(arm == 3)
	{
		if(!(isdefined(self.topArmLost) && self.topArmLost))
		{
			sentinel_spawn_broken_arm(localClientNum, 3, "tag_arm_top_03_d1", "tag_fx3");
			self.topArmLost = 1;
			sentinel_drone_beam_fire(localClientNum, 0, "tag_fx3");
			if(isdefined(self.topClawAmbientFX))
			{
				stopfx(localClientNum, self.topClawAmbientFX);
				self.topClawAmbientFX = undefined;
			}
			if(isdefined(self.topClawChargeFX))
			{
				stopfx(localClientNum, self.topClawChargeFX);
				self.topClawChargeFX = undefined;
			}
			if(sentinel_is_drone_initialized(localClientNum))
			{
				PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_dest_arm", self, "tag_arm_top_03_d1");
				self SetAnim("ai_zm_dlc3_sentinel_arms_broken_top");
			}
		}
	}
}

/*
	Name: sentinel_drone_beam_charge
	Namespace: sentinel_drone
	Checksum: 0xECB13EF2
	Offset: 0x23E0
	Size: 0x2A5
	Parameters: 7
	Flags: None
*/
function sentinel_drone_beam_charge(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!sentinel_is_drone_initialized(localClientNum))
	{
		return 0;
	}
	if(newVal == 1)
	{
		if(!isdefined(self.CameraScannerFX))
		{
			self.CameraScannerFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_scanner_light_glow", self, "tag_flash");
		}
		self sentinel_play_claws_ambient_fx(localClientNum, 1);
		if(!(isdefined(self.rightArmLost) && self.rightArmLost))
		{
			self.rightClawChargeFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_taser_charging", self, "tag_fx1");
		}
		if(!(isdefined(self.leftArmLost) && self.leftArmLost))
		{
			self.leftClawChargeFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_taser_charging", self, "tag_fx2");
		}
		if(!(isdefined(self.topArmLost) && self.topArmLost))
		{
			self.topClawChargeFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_taser_charging", self, "tag_fx3");
		}
		if(isdefined(self.enemy_already_spotted))
		{
			if(RandomInt(100) < 30)
			{
				sentinel_play_taunt(localClientNum, level._sentinel_Attack_Taunts);
			}
		}
		else
		{
			self.enemy_already_spotted = 1;
			sentinel_play_taunt(localClientNum, level._sentinel_Enemy_Detected_Taunts);
		}
	}
	else if(isdefined(self.rightClawChargeFX))
	{
		stopfx(localClientNum, self.rightClawChargeFX);
		self.rightClawChargeFX = undefined;
	}
	if(isdefined(self.leftClawChargeFX))
	{
		stopfx(localClientNum, self.leftClawChargeFX);
		self.leftClawChargeFX = undefined;
	}
	if(isdefined(self.topClawChargeFX))
	{
		stopfx(localClientNum, self.topClawChargeFX);
		self.topClawChargeFX = undefined;
	}
}

/*
	Name: sentinel_drone_face_cut
	Namespace: sentinel_drone
	Checksum: 0xD1045859
	Offset: 0x2690
	Size: 0x20B
	Parameters: 7
	Flags: None
*/
function sentinel_drone_face_cut(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!sentinel_is_drone_initialized(localClientNum))
	{
		return 0;
	}
	face_pos = self GetTagOrigin("tag_faceplate_d0");
	face_ang = self GetTagAngles("tag_faceplate_d0");
	velocity = self GetVelocity();
	velocity_normal = VectorNormalize(velocity);
	velocity_length = length(velocity);
	launch_dir = AnglesToForward(self.angles);
	velocity_length = velocity_length * 0.1;
	if(velocity_length < 10)
	{
		velocity_length = 10;
	}
	launch_dir = launch_dir * 0.5 + velocity_normal * 0.5;
	launch_dir = launch_dir * velocity_length;
	thread sentinel_launch_piece(localClientNum, "veh_t7_dlc3_sentinel_drone_faceplate", face_pos, face_ang, self.origin, launch_dir);
	PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_dest_core", self, "tag_faceplate_d0");
	PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_energy_core_glow", self, "ag_core_d0");
}

/*
	Name: sentinel_play_claws_ambient_fx
	Namespace: sentinel_drone
	Checksum: 0x9994C94C
	Offset: 0x28A8
	Size: 0x1DD
	Parameters: 2
	Flags: None
*/
function sentinel_play_claws_ambient_fx(localClientNum, b_false)
{
	if(!sentinel_is_drone_initialized(localClientNum))
	{
		return 0;
	}
	if(!(isdefined(b_false) && b_false))
	{
		if(!isdefined(self.rightArmLost) && self.rightArmLost && !isdefined(self.rightClawAmbientFX))
		{
			self.rightClawAmbientFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_taser_idle", self, "tag_fx1");
		}
		if(!isdefined(self.leftArmLost) && self.leftArmLost && !isdefined(self.leftClawAmbientFX))
		{
			self.leftClawAmbientFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_taser_idle", self, "tag_fx2");
		}
		if(!isdefined(self.topArmLost) && self.topArmLost && !isdefined(self.topClawAmbientFX))
		{
			self.topClawAmbientFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_taser_idle", self, "tag_fx3");
		}
	}
	else if(isdefined(self.rightClawAmbientFX))
	{
		stopfx(localClientNum, self.rightClawAmbientFX);
		self.rightClawAmbientFX = undefined;
	}
	if(isdefined(self.leftClawAmbientFX))
	{
		stopfx(localClientNum, self.leftClawAmbientFX);
		self.leftClawAmbientFX = undefined;
	}
	if(isdefined(self.topClawAmbientFX))
	{
		stopfx(localClientNum, self.topClawAmbientFX);
		self.topClawAmbientFX = undefined;
	}
}

/*
	Name: sentinel_play_engine_fx
	Namespace: sentinel_drone
	Checksum: 0xE8778DA9
	Offset: 0x2A90
	Size: 0x11B
	Parameters: 3
	Flags: None
*/
function sentinel_play_engine_fx(localClientNum, b_engine, b_roll_engine)
{
	if(!sentinel_is_drone_initialized(localClientNum))
	{
		return 0;
	}
	if(isdefined(b_engine) && b_engine)
	{
		self.EngineFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_engine_idle", self, "tag_fx_engine_left");
	}
	else if(isdefined(self.EngineFX))
	{
		stopfx(localClientNum, self.EngineFX);
	}
	if(isdefined(b_roll_engine) && b_roll_engine)
	{
		self.EngineRollFX = PlayFXOnTag(localClientNum, "dlc3/stalingrad/fx_sentinel_drone_engine_smk_fast", self, "tag_fx_engine_left");
	}
	else if(isdefined(self.EngineRollFX))
	{
		stopfx(localClientNum, self.EngineRollFX);
	}
}

/*
	Name: sentinel_play_taunt
	Namespace: sentinel_drone
	Checksum: 0xE12EC8DF
	Offset: 0x2BB8
	Size: 0xA3
	Parameters: 2
	Flags: None
*/
function sentinel_play_taunt(localClientNum, taunt_Arr)
{
	if(isdefined(level._lastplayed_drone_taunt) && GetTime() - level._lastplayed_drone_taunt < 6000)
	{
		return;
	}
	if(isdefined(level.voxAIdeactivate) && level.voxAIdeactivate)
	{
		return;
	}
	taunt = RandomInt(taunt_Arr.size);
	level._lastplayed_drone_taunt = GetTime();
	self playsound(localClientNum, taunt_Arr[taunt]);
}

/*
	Name: sentinel_launch_piece
	Namespace: sentinel_drone
	Checksum: 0x11988766
	Offset: 0x2C68
	Size: 0x283
	Parameters: 6
	Flags: None
*/
function sentinel_launch_piece(localClientNum, model, pos, angles, hitPos, force)
{
	dynEnt = CreateDynEntAndLaunch(localClientNum, model, pos, angles, hitPos, force);
	if(!isdefined(dynEnt))
	{
		return;
	}
	posHeight = pos[2];
	wait(0.5);
	if(!isdefined(dynEnt) || !IsDynEntValid(dynEnt))
	{
		return 0;
	}
	if(dynEnt.origin == pos)
	{
		SetDynEntEnabled(dynEnt, 0);
		return;
	}
	pos = dynEnt.origin;
	wait(0.4);
	if(!isdefined(dynEnt) || !IsDynEntValid(dynEnt))
	{
		return 0;
	}
	if(dynEnt.origin == pos)
	{
		SetDynEntEnabled(dynEnt, 0);
		return;
	}
	wait(1);
	if(!isdefined(dynEnt) || !IsDynEntValid(dynEnt))
	{
		return 0;
	}
	count = 0;
	old_pos = dynEnt.origin;
	while(isdefined(dynEnt) && IsDynEntValid(dynEnt))
	{
		if(old_pos == dynEnt.origin)
		{
			old_pos = dynEnt.origin;
			count++;
			if(count == 5)
			{
				if(posHeight - dynEnt.origin[2] < 15)
				{
					SetDynEntEnabled(dynEnt, 0);
				}
				else
				{
					break;
				}
			}
		}
		else
		{
			count = 0;
		}
		wait(0.2);
	}
}

