#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace namespace_62ef2c38;

/*
	Name: __init__sytem__
	Namespace: namespace_62ef2c38
	Checksum: 0xB21C2874
	Offset: 0x280
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_now_you_see_me", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: namespace_62ef2c38
	Checksum: 0xF98B2AA8
	Offset: 0x2C0
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_now_you_see_me", "activated", 2, undefined, undefined, &validation, &activation);
	bgb::function_336ffc4e("zm_bgb_now_you_see_me");
	if(!isdefined(level.var_d5c8b73c))
	{
		level.var_d5c8b73c = 111;
	}
	visionset_mgr::register_info("visionset", "zm_bgb_now_you_see_me", 1, level.var_d5c8b73c, 31, 1, &visionset_mgr::ramp_in_out_thread_per_player, 0);
	if(!isdefined(level.var_9cfc6d54))
	{
		level.var_9cfc6d54 = 111;
	}
	visionset_mgr::register_info("overlay", "zm_bgb_now_you_see_me", 1, level.var_9cfc6d54, 1, 1);
}

/*
	Name: validation
	Namespace: namespace_62ef2c38
	Checksum: 0xC8DCA0E6
	Offset: 0x3F0
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
	Namespace: namespace_62ef2c38
	Checksum: 0x6A0E9869
	Offset: 0x430
	Size: 0x1C7
	Parameters: 0
	Flags: None
*/
function activation()
{
	self endon("disconnect");
	self.b_is_designated_target = 1;
	self thread bgb::run_timer(10);
	self playsound("zmb_bgb_nysm_start");
	self PlayLoopSound("zmb_bgb_nysm_loop", 1);
	visionset_mgr::activate("visionset", "zm_bgb_now_you_see_me", self, 0.5, 9, 0.5);
	visionset_mgr::activate("overlay", "zm_bgb_now_you_see_me", self);
	ret = self util::waittill_any_timeout(9.5, "bgb_about_to_take_on_bled_out", "end_game", "bgb_update", "disconnect");
	self StopLoopSound(1);
	self playsound("zmb_bgb_nysm_end");
	if("timeout" != ret)
	{
		visionset_mgr::deactivate("visionset", "zm_bgb_now_you_see_me", self);
	}
	else
	{
		wait(0.5);
	}
	visionset_mgr::deactivate("overlay", "zm_bgb_now_you_see_me", self);
	self.b_is_designated_target = 0;
}

