#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace namespace_14ec45ff;

/*
	Name: __init__sytem__
	Namespace: namespace_14ec45ff
	Checksum: 0x98545D42
	Offset: 0x218
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_in_plain_sight", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_14ec45ff
	Checksum: 0xA5ABA10A
	Offset: 0x258
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
	bgb::register("zm_bgb_in_plain_sight", "activated", 2, undefined, undefined, &validation, &activation);
	bgb::function_4cda71bf("zm_bgb_in_plain_sight", 1);
	bgb::function_336ffc4e("zm_bgb_in_plain_sight");
	if(!isdefined(level.var_15e9ad1b))
	{
		level.var_15e9ad1b = 110;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_in_plain_sight", 1, level.var_15e9ad1b, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	if(!isdefined(level.var_121c0683))
	{
		level.var_121c0683 = 110;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_in_plain_sight", 1, level.var_121c0683, 1, 1);
}

/*
	Name: validation
	Namespace: namespace_14ec45ff
	Checksum: 0x3249E9B2
	Offset: 0x3A8
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
	Namespace: namespace_14ec45ff
	Checksum: 0x40E53E86
	Offset: 0x3E8
	Size: 0x1ED
	Parameters: 0
	Flags: None
*/
function activation()
{
	self endon("disconnect");
	self zm_utility::increment_ignoreme();
	self.bgb_in_plain_sight_active = 1;
	self playsound("zmb_bgb_plainsight_start");
	self PlayLoopSound("zmb_bgb_plainsight_loop", 1);
	self thread bgb::run_timer(10);
	visionset_mgr::activate("visionset", "zm_bgb_in_plain_sight", self, 0.5, 9, 0.5);
	visionset_mgr::activate("overlay", "zm_bgb_in_plain_sight", self);
	ret = self util::waittill_any_timeout(9.5, "bgb_about_to_take_on_bled_out", "end_game", "bgb_update", "disconnect");
	self StopLoopSound(1);
	self playsound("zmb_bgb_plainsight_end");
	if("timeout" != ret)
	{
		visionset_mgr::deactivate("visionset", "zm_bgb_in_plain_sight", self);
	}
	else
	{
		wait(0.5);
	}
	visionset_mgr::deactivate("overlay", "zm_bgb_in_plain_sight", self);
	self zm_utility::decrement_ignoreme();
	self.bgb_in_plain_sight_active = undefined;
}

