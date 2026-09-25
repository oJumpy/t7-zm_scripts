#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_factory_teleporter;

/*
	Name: __init__sytem__
	Namespace: zm_factory_teleporter
	Checksum: 0x2C0DC174
	Offset: 0x1B0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_factory_teleporter", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_factory_teleporter
	Checksum: 0x3DFBB13E
	Offset: 0x1F0
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_factory_teleport", 1, 1, "pstfx_zm_der_teleport");
	level thread setup_teleport_aftereffects();
	level thread wait_for_black_box();
	level thread wait_for_teleport_aftereffect();
}

/*
	Name: setup_teleport_aftereffects
	Namespace: zm_factory_teleporter
	Checksum: 0x85DB533D
	Offset: 0x270
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
	Namespace: zm_factory_teleporter
	Checksum: 0xBB9A0535
	Offset: 0x3A0
	Size: 0xD7
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
	Namespace: zm_factory_teleporter
	Checksum: 0xD5C5543F
	Offset: 0x480
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function wait_for_teleport_aftereffect()
{
	while(1)
	{
		level waittill("tae", localClientNum);
		if(GetDvarString("factoryAftereffectOverride") == "-1")
		{
			self thread [[level.teleport_ae_funcs[RandomInt(level.teleport_ae_funcs.size)]]](localClientNum);
		}
		else
		{
			self thread [[level.teleport_ae_funcs[Int(GetDvarString("factoryAftereffectOverride"))]]](localClientNum);
		}
	}
}

/*
	Name: teleport_aftereffect_shellshock
	Namespace: zm_factory_teleporter
	Checksum: 0xE2575983
	Offset: 0x550
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
	Namespace: zm_factory_teleporter
	Checksum: 0xCAC0E792
	Offset: 0x570
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
	Namespace: zm_factory_teleporter
	Checksum: 0x16725859
	Offset: 0x590
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
	Namespace: zm_factory_teleporter
	Checksum: 0xAD5D515
	Offset: 0x678
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
	Namespace: zm_factory_teleporter
	Checksum: 0x1A38C860
	Offset: 0x720
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
	Namespace: zm_factory_teleporter
	Checksum: 0x840A0575
	Offset: 0x7C8
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
	Namespace: zm_factory_teleporter
	Checksum: 0xC483D9CF
	Offset: 0x8B0
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

