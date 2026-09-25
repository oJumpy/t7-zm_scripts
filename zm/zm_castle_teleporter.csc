#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace namespace_fa1b0620;

/*
	Name: __init__sytem__
	Namespace: namespace_fa1b0620
	Checksum: 0x513EF45D
	Offset: 0x3E0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_teleporter", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_fa1b0620
	Checksum: 0x5814976E
	Offset: 0x420
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_transported("zm_castle", 1, 15, 2);
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_factory_teleport", 5000, 1, "pstfx_zm_castle_teleport");
	level thread setup_teleport_aftereffects();
	level thread wait_for_black_box();
	level thread wait_for_teleport_aftereffect();
	level._effect["ee_quest_time_travel_ready"] = "dlc1/castle/fx_demon_gate_rune_glow";
	duplicate_render::set_dr_filter_framebuffer("flashback", 90, "flashback_on", "", 0, "mc/mtl_glitch", 0);
	clientfield::register("world", "ee_quest_time_travel_ready", 5000, 1, "int", &function_ddac47c8, 0, 0);
	clientfield::register("toplayer", "ee_quest_back_in_time_teleport_fx", 5000, 1, "int", &function_f5cfa4d7, 0, 0);
	clientfield::register("toplayer", "ee_quest_back_in_time_postfx", 5000, 1, "int", &function_aa99fd7b, 0, 0);
	clientfield::register("toplayer", "ee_quest_back_in_time_sfx", 5000, 1, "int", &function_a932c4c, 0, 0);
}

/*
	Name: function_f5cfa4d7
	Namespace: namespace_fa1b0620
	Checksum: 0x9F36DF67
	Offset: 0x638
	Size: 0x9B
	Parameters: 7
	Flags: None
*/
function function_f5cfa4d7(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!oldVal || !IsDemoPlaying())
		{
			self thread postfx::playPostfxBundle("pstfx_zm_wormhole");
		}
	}
	else
	{
		self postfx::exitPostfxBundle();
	}
}

/*
	Name: function_aa99fd7b
	Namespace: namespace_fa1b0620
	Checksum: 0x8CD1628C
	Offset: 0x6E0
	Size: 0xD3
	Parameters: 7
	Flags: None
*/
function function_aa99fd7b(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(!oldVal || !IsDemoPlaying())
		{
			self thread postfx::playPostfxBundle("pstfx_backintime");
		}
	}
	else
	{
		self postfx::exitPostfxBundle();
	}
	self duplicate_render::set_dr_flag("flashback_on", newVal);
	self duplicate_render::update_dr_filters(localClientNum);
}

/*
	Name: function_a932c4c
	Namespace: namespace_fa1b0620
	Checksum: 0xF96B8119
	Offset: 0x7C0
	Size: 0x109
	Parameters: 7
	Flags: None
*/
function function_a932c4c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		playsound(0, "zmb_ee_timetravel_start", (0, 0, 0));
		self.var_6e4d8282 = self PlayLoopSound("zmb_ee_timetravel_lp", 3);
		level notify("hash_51d7bc7c", "null");
	}
	else if(isdefined(self.var_6e4d8282))
	{
		self StopLoopSound(self.var_6e4d8282, 1);
		playsound(0, "zmb_ee_timetravel_end", (0, 0, 0));
		level notify("hash_51d7bc7c", "rocket");
	}
}

/*
	Name: function_ddac47c8
	Namespace: namespace_fa1b0620
	Checksum: 0x8AC53D21
	Offset: 0x8D8
	Size: 0xF1
	Parameters: 7
	Flags: None
*/
function function_ddac47c8(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	var_55ff1a9f = struct::get_array("teleport_pad_center_effect", "targetname");
	foreach(var_f92e157f in var_55ff1a9f)
	{
		var_f92e157f thread function_74eb9e6a(localClientNum, newVal);
	}
}

/*
	Name: function_74eb9e6a
	Namespace: namespace_fa1b0620
	Checksum: 0x185EB609
	Offset: 0x9D8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function function_74eb9e6a(localClientNum, newVal)
{
	if(newVal == 1)
	{
		self.var_83ef00ec = playFX(localClientNum, level._effect["ee_quest_time_travel_ready"], self.origin);
		audio::playloopat("zmb_ee_timetravel_tele_lp", self.origin);
	}
	else if(isdefined(self.var_83ef00ec))
	{
		stopfx(localClientNum, self.var_83ef00ec);
		self.var_83ef00ec = undefined;
	}
	audio::stoploopat("zmb_ee_timetravel_tele_lp", self.origin);
}

/*
	Name: setup_teleport_aftereffects
	Namespace: namespace_fa1b0620
	Checksum: 0xB42D522B
	Offset: 0xAB8
	Size: 0x125
	Parameters: 0
	Flags: None
*/
function setup_teleport_aftereffects()
{
	util::waitforclient(0);
	level.teleport_ae_funcs = [];
	if(GetLocalPlayers().size == 1)
	{
		level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_fov;
	}
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_shellshock;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_shellshock_electric;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_bw_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_red_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_flashy_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_flare_vision;
}

/*
	Name: wait_for_black_box
	Namespace: namespace_fa1b0620
	Checksum: 0x259E4B73
	Offset: 0xBE8
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function wait_for_black_box()
{
	secondClientNum = -1;
	while(1)
	{
		level waittill("black_box_start", localClientNum);
		/#
			Assert(isdefined(localClientNum));
		#/
		savedVis = GetVisionSetNaked(localClientNum);
		playsound(0, "evt_teleport_2d_fnt", (0, 0, 0));
		visionSetNaked(localClientNum, "default", 0);
		while(secondClientNum != localClientNum)
		{
			level waittill("black_box_end", secondClientNum);
		}
		visionSetNaked(localClientNum, savedVis, 0);
	}
}

/*
	Name: wait_for_teleport_aftereffect
	Namespace: namespace_fa1b0620
	Checksum: 0x1E36CDC0
	Offset: 0xCF0
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function wait_for_teleport_aftereffect()
{
	while(1)
	{
		level waittill("tae", localClientNum);
		if(GetDvarString("castleAftereffectOverride") == "-1")
		{
			self thread [[level.teleport_ae_funcs[RandomInt(level.teleport_ae_funcs.size)]]](localClientNum);
		}
		else
		{
			self thread [[level.teleport_ae_funcs[Int(GetDvarString("castleAftereffectOverride"))]]](localClientNum);
		}
	}
}

/*
	Name: teleport_aftereffect_shellshock
	Namespace: namespace_fa1b0620
	Checksum: 0xE47F144F
	Offset: 0xDC0
	Size: 0x13
	Parameters: 1
	Flags: None
*/
function teleport_aftereffect_shellshock(localClientNum)
{
	wait(0.05);
}

/*
	Name: teleport_aftereffect_shellshock_electric
	Namespace: namespace_fa1b0620
	Checksum: 0xD0540E6A
	Offset: 0xDE0
	Size: 0x13
	Parameters: 1
	Flags: None
*/
function teleport_aftereffect_shellshock_electric(localClientNum)
{
	wait(0.05);
}

/*
	Name: teleport_aftereffect_fov
	Namespace: namespace_fa1b0620
	Checksum: 0xB268D3BE
	Offset: 0xE00
	Size: 0xD9
	Parameters: 1
	Flags: None
*/
function teleport_aftereffect_fov(localClientNum)
{
	/#
		println("Dev Block strings are not supported");
	#/
	start_fov = 30;
	end_fov = GetDvarFloat("cg_fov_default");
	duration = 0.5;
	for(i = 0; i < duration;  = 0)
	{
		fov = start_fov + end_fov - start_fov * i / duration;
		WaitRealTime(0.017);
	}
}

/*
	Name: teleport_aftereffect_bw_vision
	Namespace: namespace_fa1b0620
	Checksum: 0x28504CB0
	Offset: 0xEE8
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function teleport_aftereffect_bw_vision(localClientNum)
{
	/#
		println("Dev Block strings are not supported");
	#/
	savedVis = GetVisionSetNaked(localClientNum);
	visionSetNaked(localClientNum, "cheat_bw_invert_contrast", 0.4);
	wait(1.25);
	visionSetNaked(localClientNum, savedVis, 1);
}

/*
	Name: teleport_aftereffect_red_vision
	Namespace: namespace_fa1b0620
	Checksum: 0xFF6E298C
	Offset: 0xF90
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function teleport_aftereffect_red_vision(localClientNum)
{
	/#
		println("Dev Block strings are not supported");
	#/
	savedVis = GetVisionSetNaked(localClientNum);
	visionSetNaked(localClientNum, "zombie_turned", 0.4);
	wait(1.25);
	visionSetNaked(localClientNum, savedVis, 1);
}

/*
	Name: teleport_aftereffect_flashy_vision
	Namespace: namespace_fa1b0620
	Checksum: 0xED265C6D
	Offset: 0x1038
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function teleport_aftereffect_flashy_vision(localClientNum)
{
	/#
		println("Dev Block strings are not supported");
	#/
	savedVis = GetVisionSetNaked(localClientNum);
	visionSetNaked(localClientNum, "cheat_bw_invert_contrast", 0.1);
	wait(0.4);
	visionSetNaked(localClientNum, "cheat_bw_contrast", 0.1);
	wait(0.4);
	wait(0.4);
	wait(0.4);
	visionSetNaked(localClientNum, savedVis, 5);
}

/*
	Name: teleport_aftereffect_flare_vision
	Namespace: namespace_fa1b0620
	Checksum: 0xBB23A473
	Offset: 0x1120
	Size: 0x9B
	Parameters: 1
	Flags: None
*/
function teleport_aftereffect_flare_vision(localClientNum)
{
	/#
		println("Dev Block strings are not supported");
	#/
	savedVis = GetVisionSetNaked(localClientNum);
	visionSetNaked(localClientNum, "flare", 0.4);
	wait(1.25);
	visionSetNaked(localClientNum, savedVis, 1);
}

