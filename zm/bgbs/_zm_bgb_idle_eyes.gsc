#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_d5190444;

/*
	Name: __init__sytem__
	Namespace: namespace_d5190444
	Checksum: 0xF41D3D08
	Offset: 0x228
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_idle_eyes", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_d5190444
	Checksum: 0x694762A0
	Offset: 0x268
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_idle_eyes", "activated", 3, undefined, undefined, &validation, &activation);
	bgb::function_4cda71bf("zm_bgb_idle_eyes", 1);
	bgb::function_336ffc4e("zm_bgb_idle_eyes");
	if(!isdefined(level.var_c2d3ebc0))
	{
		level.var_c2d3ebc0 = 112;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_idle_eyes", 1, level.var_c2d3ebc0, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	if(!isdefined(level.var_384c0a48))
	{
		level.var_384c0a48 = 112;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_idle_eyes", 1, level.var_384c0a48, 1, 1);
}

/*
	Name: validation
	Namespace: namespace_d5190444
	Checksum: 0x1689CC01
	Offset: 0x3B8
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function validation()
{
	return !isdefined(self bgb::function_e2bcf80c()) && self bgb::function_e2bcf80c();
}

/*
	Name: activation
	Namespace: namespace_d5190444
	Checksum: 0xD30DE441
	Offset: 0x3F8
	Size: 0x29B
	Parameters: 0
	Flags: None
*/
function activation()
{
	self endon("disconnect");
	var_7092e170 = ArrayCopy(level.activePlayers);
	Array::thread_all(var_7092e170, &zm_utility::increment_ignoreme);
	self.bgb_idle_eyes_active = 1;
	if(!bgb::function_f345a8ce("zm_bgb_idle_eyes"))
	{
		if(isdefined(level.no_target_override))
		{
			if(!isdefined(level.var_4effcea9))
			{
				level.var_4effcea9 = level.no_target_override;
			}
			level.no_target_override = undefined;
		}
	}
	level thread function_1f57344e(self, var_7092e170);
	self playsound("zmb_bgb_idleeyes_start");
	self PlayLoopSound("zmb_bgb_idleeyes_loop", 1);
	self thread bgb::run_timer(31);
	visionset_mgr::activate("visionset", "zm_bgb_idle_eyes", self, 0.5, 30, 0.5);
	visionset_mgr::activate("overlay", "zm_bgb_idle_eyes", self);
	ret = self util::waittill_any_timeout(30.5, "bgb_about_to_take_on_bled_out", "end_game", "bgb_update", "disconnect");
	self StopLoopSound(1);
	self playsound("zmb_bgb_idleeyes_end");
	if("timeout" != ret)
	{
		visionset_mgr::deactivate("visionset", "zm_bgb_idle_eyes", self);
	}
	else
	{
		wait(0.5);
	}
	visionset_mgr::deactivate("overlay", "zm_bgb_idle_eyes", self);
	self.bgb_idle_eyes_active = undefined;
	self notify("hash_16ab3604");
	deactivate(var_7092e170);
}

/*
	Name: function_1f57344e
	Namespace: namespace_d5190444
	Checksum: 0xBFF2A7B7
	Offset: 0x6A0
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function function_1f57344e(var_e04844d6, var_7092e170)
{
	var_e04844d6 endon("hash_16ab3604");
	var_e04844d6 waittill("disconnect");
	deactivate(var_7092e170);
}

/*
	Name: deactivate
	Namespace: namespace_d5190444
	Checksum: 0x709C25E3
	Offset: 0x6F0
	Size: 0x8D
	Parameters: 1
	Flags: None
*/
function deactivate(var_7092e170)
{
	var_7092e170 = Array::remove_undefined(var_7092e170);
	Array::thread_all(var_7092e170, &zm_utility::decrement_ignoreme);
	if(bgb::function_72936116("zm_bgb_idle_eyes"))
	{
		return;
	}
	if(isdefined(level.var_4effcea9))
	{
		level.no_target_override = level.var_4effcea9;
		level.var_4effcea9 = undefined;
	}
}

