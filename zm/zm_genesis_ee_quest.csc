#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_teleporter;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_ee_quest;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_ee_quest
	Checksum: 0x560DFAF5
	Offset: 0x450
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_ee_quest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_ee_quest
	Checksum: 0x669FDCBE
	Offset: 0x490
	Size: 0x2E5
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("world", "ee_quest_state", 15000, GetMinBitCountForNum(13), "int", &function_e70dbcc6, 0, 0);
	clientfield::register("scriptmover", "ghost_entity", 15000, 1, "int", &function_2b5ef9a6, 0, 0);
	clientfield::register("scriptmover", "electric_charge", 15000, 1, "int", &function_ede1c539, 0, 0);
	clientfield::register("scriptmover", "grand_tour_found_toy_fx", 15000, 1, "int", &function_52d5d371, 0, 0);
	clientfield::register("scriptmover", "sophia_transition_fx", 15000, 1, "int", &sophia_transition_fx, 0, 0);
	clientfield::register("allplayers", "sophia_follow", 15000, 3, "int", &function_272c5fb, 0, 0);
	clientfield::register("scriptmover", "sophia_eye_on", 15000, 1, "int", &sophia_eye_on, 0, 0);
	clientfield::register("allplayers", "sophia_delete_local", 15000, 1, "int", &sophia_delete_local, 0, 0);
	clientfield::register("world", "GenesisEndGameEEScreen", 15000, 1, "int", &genesisendgameee, 0, 0);
	duplicate_render::set_dr_filter_framebuffer("zod_ghost", 90, "zod_ghost", undefined, 0, "mc/hud_zod_ghost", 0);
	level._effect["electric_charge"] = "electric/fx_elec_arc_med_loop_hacktower";
}

/*
	Name: function_e70dbcc6
	Namespace: zm_genesis_ee_quest
	Checksum: 0x79E851A6
	Offset: 0x780
	Size: 0xA5
	Parameters: 7
	Flags: None
*/
function function_e70dbcc6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level notify("hash_e70dbcc6");
	level endon("hash_e70dbcc6");
	switch(newVal)
	{
		case 7:
		{
			break;
		}
		case 8:
		{
			break;
		}
		case 9:
		{
			break;
		}
		case 10:
		{
			break;
		}
		case 12:
		{
			break;
		}
	}
}

/*
	Name: function_2b5ef9a6
	Namespace: zm_genesis_ee_quest
	Checksum: 0xB7A52EBA
	Offset: 0x830
	Size: 0x73
	Parameters: 7
	Flags: None
*/
function function_2b5ef9a6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self duplicate_render::set_dr_flag("zod_ghost", newVal);
	self duplicate_render::update_dr_filters(localClientNum);
}

/*
	Name: function_ede1c539
	Namespace: zm_genesis_ee_quest
	Checksum: 0x9D1043A
	Offset: 0x8B0
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function function_ede1c539(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_ebad8041))
	{
		deletefx(localClientNum, self.var_ebad8041, 0);
		self.var_ebad8041 = undefined;
	}
	if(newVal == 1)
	{
		self.var_ebad8041 = PlayFXOnTag(localClientNum, level._effect["electric_charge"], self, "tag_origin");
	}
}

/*
	Name: function_52d5d371
	Namespace: zm_genesis_ee_quest
	Checksum: 0x8C699C1F
	Offset: 0x970
	Size: 0xD5
	Parameters: 7
	Flags: None
*/
function function_52d5d371(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playFX(localClientNum, level._effect["ee_toy_found"], self.origin);
		self.var_22c9fb1a = PlayFXOnTag(localClientNum, level._effect["shadow_rq_chomper_light"], self, "tag_origin");
	}
	else
	{
		deletefx(localClientNum, self.var_22c9fb1a, 0);
		self.var_22c9fb1a = undefined;
	}
}

/*
	Name: sophia_transition_fx
	Namespace: zm_genesis_ee_quest
	Checksum: 0x137C0FA
	Offset: 0xA50
	Size: 0xB5
	Parameters: 7
	Flags: None
*/
function sophia_transition_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self.n_fx = PlayFXOnTag(localClientNum, level._effect["sophia_transition"], self, "tag_origin");
	}
	else if(isdefined(self.n_fx))
	{
		deletefx(localClientNum, self.n_fx, 0);
		self.n_fx = undefined;
	}
}

/*
	Name: function_272c5fb
	Namespace: zm_genesis_ee_quest
	Checksum: 0x5589E835
	Offset: 0xB10
	Size: 0x1A3
	Parameters: 7
	Flags: None
*/
function function_272c5fb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	level endon("sophia_delete");
	var_1c7b6837 = GetEnt(localClientNum, "sophia_eye", "targetname");
	if(!isdefined(var_1c7b6837))
	{
		s_sophia = struct::get("ee_beam_sophia", "targetname");
		var_1c7b6837 = util::spawn_model(localClientNum, "p7_zm_gen_dark_arena_sphere", s_sophia.origin, s_sophia.angles);
		var_1c7b6837.targetname = "sophia_eye";
		var_1c7b6837 MapShaderConstant(localClientNum, 0, "scriptVector2", 1, 0, 0);
	}
	level notify("hash_deeb3634");
	wait(0.5);
	if(!isdefined(var_1c7b6837))
	{
		return;
	}
	if(newVal == 0)
	{
		var_1c7b6837 RotateTo((0, 0, 0), 0.5);
	}
	else
	{
		level.var_9a736d20 = 1;
		var_1c7b6837 thread function_36666e11(self);
	}
}

/*
	Name: sophia_eye_on
	Namespace: zm_genesis_ee_quest
	Checksum: 0xD3126C43
	Offset: 0xCC0
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function sophia_eye_on(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self MapShaderConstant(localClientNum, 0, "scriptVector2", 1, 0, 0);
}

/*
	Name: function_36666e11
	Namespace: zm_genesis_ee_quest
	Checksum: 0xE66D3847
	Offset: 0xD30
	Size: 0xEF
	Parameters: 1
	Flags: None
*/
function function_36666e11(e_player)
{
	level endon("demo_jump");
	level endon("hash_deeb3634");
	e_player endon("death");
	self endon("entityshutdown");
	while(isdefined(e_player))
	{
		var_c746e6bf = e_player GetTagOrigin("j_head");
		var_933e0d32 = VectorToAngles(var_c746e6bf - self.origin);
		var_933e0d32 = (var_933e0d32[0], var_933e0d32[1], var_933e0d32[2]);
		self RotateTo(var_933e0d32, 0.1);
		wait(0.1);
	}
}

/*
	Name: sophia_delete_local
	Namespace: zm_genesis_ee_quest
	Checksum: 0x56574BF4
	Offset: 0xE28
	Size: 0xB3
	Parameters: 7
	Flags: None
*/
function sophia_delete_local(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_1c7b6837 = GetEnt(localClientNum, "sophia_eye", "targetname");
	if(isdefined(var_1c7b6837))
	{
		var_1c7b6837 RotateTo((0, 0, 0), 0.2);
		var_1c7b6837 delete();
	}
}

/*
	Name: genesisendgameee
	Namespace: zm_genesis_ee_quest
	Checksum: 0x85835E3F
	Offset: 0xEE8
	Size: 0x83
	Parameters: 7
	Flags: None
*/
function genesisendgameee(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	SetUIModelValue(CreateUIModel(GetUIModelForController(localClientNum), "GenesisEndGameEE"), 1);
}

