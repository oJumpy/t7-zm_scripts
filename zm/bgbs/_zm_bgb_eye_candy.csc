#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_128a1bda;

/*
	Name: __init__sytem__
	Namespace: namespace_128a1bda
	Checksum: 0xB32C977
	Offset: 0x418
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_eye_candy", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_128a1bda
	Checksum: 0x3A707045
	Offset: 0x458
	Size: 0x333
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_eye_candy", "activated");
	visionset_mgr::register_visionset_info("zm_bgb_eye_candy_vs_1", 21000, 31, undefined, "zm_bgb_candy_yellowz");
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_bgb_eye_candy_vs_1", 21000, 1, "pstfx_zm_bgb_eye_candy_yellow");
	duplicate_render::set_dr_filter_framebuffer("e_c_1", 35, "eye_candy_1", undefined, 0, "mc/zombie_candy_mode_yellow", 0);
	visionset_mgr::register_visionset_info("zm_bgb_eye_candy_vs_2", 21000, 31, undefined, "zm_bgb_candy_greenz");
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_bgb_eye_candy_vs_2", 21000, 1, "pstfx_zm_bgb_eye_candy_green");
	duplicate_render::set_dr_filter_framebuffer("e_c_2", 35, "eye_candy_2", undefined, 0, "mc/zombie_candy_mode_green", 0);
	visionset_mgr::register_visionset_info("zm_bgb_eye_candy_vs_3", 21000, 31, undefined, "zm_bgb_candy_purplez");
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_bgb_eye_candy_vs_3", 21000, 1, "pstfx_zm_bgb_eye_candy_purple");
	duplicate_render::set_dr_filter_framebuffer("e_c_3", 35, "eye_candy_3", undefined, 0, "mc/zombie_candy_mode_purple", 0);
	visionset_mgr::register_visionset_info("zm_bgb_eye_candy_vs_4", 21000, 31, undefined, "zm_bgb_candy_bluez");
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_bgb_eye_candy_vs_4", 21000, 1, "pstfx_zm_bgb_eye_candy_blue");
	duplicate_render::set_dr_filter_framebuffer("e_c_4", 35, "eye_candy_4", undefined, 0, "mc/zombie_candy_mode_blue", 0);
	n_bits = GetMinBitCountForNum(5);
	clientfield::register("toplayer", "eye_candy_render", 21000, n_bits, "int", &function_7021da92, 0, 0);
	clientfield::register("actor", "eye_candy_active", 21000, 1, "int", &function_697cc62, 0, 0);
	clientfield::register("vehicle", "eye_candy_active", 21000, 1, "int", &function_697cc62, 0, 0);
}

/*
	Name: function_7021da92
	Namespace: namespace_128a1bda
	Checksum: 0x84AC0683
	Offset: 0x798
	Size: 0x93
	Parameters: 7
	Flags: None
*/
function function_7021da92(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal > 0)
	{
		self.var_73021e86 = "eye_candy_" + newVal;
		self function_a358ec33(localClientNum);
	}
	else
	{
		self function_c1a20a24(localClientNum);
	}
}

/*
	Name: function_a358ec33
	Namespace: namespace_128a1bda
	Checksum: 0xD4BEE5D
	Offset: 0x838
	Size: 0xF9
	Parameters: 1
	Flags: None
*/
function function_a358ec33(localClientNum)
{
	var_307a62d0 = GetEntArray(localClientNum);
	foreach(entity in var_307a62d0)
	{
		if(isdefined(entity.var_d8bd114f) && entity.var_d8bd114f && isdefined(self.var_73021e86))
		{
			entity function_56029f33(localClientNum, 1, self.var_73021e86);
		}
	}
}

/*
	Name: function_c1a20a24
	Namespace: namespace_128a1bda
	Checksum: 0xB88F3161
	Offset: 0x940
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function function_c1a20a24(localClientNum)
{
	var_307a62d0 = GetEntArray(localClientNum);
	foreach(entity in var_307a62d0)
	{
		if(isdefined(entity.var_d8bd114f) && entity.var_d8bd114f)
		{
			entity function_56029f33(localClientNum, 0);
		}
	}
	self.var_73021e86 = undefined;
}

/*
	Name: function_697cc62
	Namespace: namespace_128a1bda
	Checksum: 0x722D2435
	Offset: 0xA38
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function function_697cc62(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	level flagsys::wait_till("duplicaterender_registry_ready");
	/#
		Assert(isdefined(self), "Dev Block strings are not supported");
	#/
	if(newVal == 0)
	{
		self.var_d8bd114f = 0;
		self function_56029f33(localClientNum, 0);
	}
	else
	{
		self.var_d8bd114f = 1;
		player = GetLocalPlayer(localClientNum);
		if(isdefined(player.var_73021e86))
		{
			self function_56029f33(localClientNum, 1, player.var_73021e86);
		}
	}
}

/*
	Name: function_56029f33
	Namespace: namespace_128a1bda
	Checksum: 0x743FDB2F
	Offset: 0xB68
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function function_56029f33(localClientNum, b_enabled, var_73021e86)
{
	if(isdefined(self.var_73021e86))
	{
		self duplicate_render::set_dr_flag(self.var_73021e86, 0);
		self.var_73021e86 = undefined;
	}
	if(isdefined(b_enabled) && b_enabled && isdefined(var_73021e86))
	{
		self duplicate_render::set_dr_flag(var_73021e86, 1);
		self.var_73021e86 = var_73021e86;
	}
	self duplicate_render::update_dr_filters(localClientNum);
}

