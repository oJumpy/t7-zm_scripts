#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_genesis_apothican;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_apothican
	Checksum: 0x316BD226
	Offset: 0x4A0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_apothican", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_apothican
	Checksum: 0xFC2A0099
	Offset: 0x4E0
	Size: 0x2E7
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "apothicon_player_keyline", 15000, 1, "int", &apothicon_player_keyline, 0, 0);
	clientfield::register("toplayer", "apothicon_entry_postfx", 15000, 1, "int", &apothicon_entry_postfx, 0, 0);
	clientfield::register("world", "gas_fog_bank_switch", 15000, 1, "int", &gas_fog_bank_switch, 0, 0);
	clientfield::register("scriptmover", "egg_spawn_fx", 15000, 1, "int", &egg_spawn_fx, 0, 0);
	clientfield::register("scriptmover", "gateworm_mtl", 15000, 1, "int", &gateworm_mtl, 0, 0);
	clientfield::register("toplayer", "player_apothicon_egg", 15000, 1, "int", &zm_utility::setInventoryUIModels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_apothicon_egg", 15000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_apothicon_egg_bg", 15000, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "player_gate_worm", 15000, 1, "int", &zm_utility::setInventoryUIModels, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.widget_gate_worm", 15000, 1, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.player_gate_worm_bg", 15000, 1, "int", undefined, 0, 0);
	level.var_e8af7a2f = 0;
}

/*
	Name: function_b77a78c9
	Namespace: zm_genesis_apothican
	Checksum: 0x21B3DD22
	Offset: 0x7D0
	Size: 0xB3
	Parameters: 5
	Flags: None
*/
function function_b77a78c9(localClientNum, str_fx, v_origin, n_duration, v_angles)
{
	if(isdefined(v_angles))
	{
		FX = playFX(localClientNum, str_fx, v_origin, v_angles);
	}
	else
	{
		FX = playFX(localClientNum, str_fx, v_origin);
	}
	wait(n_duration);
	stopfx(localClientNum, FX);
}

/*
	Name: scene_play
	Namespace: zm_genesis_apothican
	Checksum: 0x52CB4414
	Offset: 0x890
	Size: 0x7B
	Parameters: 2
	Flags: None
*/
function scene_play(scene, mdl_pod)
{
	self notify("scene_play");
	self endon("scene_play");
	self scene::stop();
	self function_6221b6b9(scene, mdl_pod);
	self scene::stop();
}

/*
	Name: function_6221b6b9
	Namespace: zm_genesis_apothican
	Checksum: 0x38D0BCE1
	Offset: 0x918
	Size: 0x3B
	Parameters: 2
	Flags: None
*/
function function_6221b6b9(scene, mdl_pod)
{
	level endon("demo_jump");
	self scene::Play(scene, mdl_pod);
}

/*
	Name: apothicon_player_keyline
	Namespace: zm_genesis_apothican
	Checksum: 0xF99EDD72
	Offset: 0x960
	Size: 0x10B
	Parameters: 7
	Flags: None
*/
function apothicon_player_keyline(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(!IsSpectating(localClientNum) && self isLocalPlayer() && localClientNum == self getlocalclientnumber())
	{
		return;
	}
	if(newVal == 1)
	{
		self duplicate_render::set_dr_flag("keyline_active", 0);
		self duplicate_render::update_dr_filters(localClientNum);
	}
	else
	{
		self duplicate_render::set_dr_flag("keyline_active", 1);
		self duplicate_render::update_dr_filters(localClientNum);
	}
}

/*
	Name: apothicon_entry_postfx
	Namespace: zm_genesis_apothican
	Checksum: 0x9C38C598
	Offset: 0xA78
	Size: 0x121
	Parameters: 7
	Flags: None
*/
function apothicon_entry_postfx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("apothicon_entry_postfx");
	self endon("apothicon_entry_postfx");
	if(newVal == 1)
	{
		if(IsDemoPlaying() && DemoIsAnyFreeMoveCamera())
		{
			return;
		}
		self thread function_e7a8756e(localClientNum);
		self thread postfx::playPostfxBundle("pstfx_gen_apothicon_swallow");
		playsound(0, "zmb_apothigod_mouth_start", (0, 0, 0));
	}
	else
	{
		playsound(0, "zmb_apothigod_mouth_eject", (0, 0, 0));
		self notify("apothicon_entry_complete");
	}
}

/*
	Name: function_e7a8756e
	Namespace: zm_genesis_apothican
	Checksum: 0x4B62CAC9
	Offset: 0xBA8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_e7a8756e(localClientNum)
{
	self util::waittill_any("apothicon_entry_postfx", "apothicon_entry_complete");
	self postfx::exitPostfxBundle();
}

/*
	Name: gas_fog_bank_switch
	Namespace: zm_genesis_apothican
	Checksum: 0xA8FAA3A7
	Offset: 0xC00
	Size: 0x13F
	Parameters: 7
	Flags: None
*/
function gas_fog_bank_switch(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		level.var_e8af7a2f = 1;
		for(localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++)
		{
			if(level.var_b7572a82)
			{
				SetWorldFogActiveBank(localClientNum, 8);
				continue;
			}
			SetWorldFogActiveBank(localClientNum, 4);
		}
	}
	else
	{
		for(localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++)
		{
			if(level.var_b7572a82)
			{
				SetWorldFogActiveBank(localClientNum, 2);
				continue;
			}
			SetWorldFogActiveBank(localClientNum, 1);
		}
		level.var_e8af7a2f = 0;
	}
}

/*
	Name: egg_spawn_fx
	Namespace: zm_genesis_apothican
	Checksum: 0xF845DA25
	Offset: 0xD48
	Size: 0xBD
	Parameters: 7
	Flags: None
*/
function egg_spawn_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.var_70a0d336 = PlayFXOnTag(localClientNum, level._effect["egg_spawn_fx"], self, "tag_origin");
	}
	else if(isdefined(self) && isdefined(self.var_70a0d336))
	{
		stopfx(localClientNum, self.var_70a0d336);
		self.var_70a0d336 = undefined;
	}
}

/*
	Name: gateworm_mtl
	Namespace: zm_genesis_apothican
	Checksum: 0x5A378EFD
	Offset: 0xE10
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function gateworm_mtl(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector2", 1, 0, 0);
}

