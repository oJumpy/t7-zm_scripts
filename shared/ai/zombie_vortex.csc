#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zombie_vortex;

/*
	Name: __init__sytem__
	Namespace: zombie_vortex
	Checksum: 0x8A20E7D8
	Offset: 0x2A8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vortex", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zombie_vortex
	Checksum: 0xBFD24842
	Offset: 0x2E8
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function __init__()
{
	visionset_mgr::register_visionset_info("zm_idgun_vortex" + "_visionset", 1, 30, undefined, "zm_idgun_vortex");
	visionset_mgr::register_overlay_info_style_speed_blur("zm_idgun_vortex" + "_blur", 1, 1, 0.08, 0.75, 0.9);
	clientfield::register("scriptmover", "vortex_start", 1, 2, "counter", &start_vortex, 0, 0);
	clientfield::register("allplayers", "vision_blur", 1, 1, "int", &function_a9cae3ef, 0, 0);
}

/*
	Name: start_vortex
	Namespace: zombie_vortex
	Checksum: 0xABC4AB6
	Offset: 0x408
	Size: 0x1F3
	Parameters: 7
	Flags: None
*/
function start_vortex(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self endon("disconnect");
	if(!isdefined(newVal) || newVal == 0)
	{
		return;
	}
	e_player = GetLocalPlayer(localClientNum);
	vposition = self.origin;
	newVal = newVal - oldVal;
	if(newVal == 2)
	{
		fx_vortex = "zombie/fx_idgun_vortex_ug_zod_zmb";
		fx_vortex_explosion = "zombie/fx_idgun_vortex_explo_ug_zod_zmb";
		n_vortex_time = 10;
	}
	else
	{
		fx_vortex = "zombie/fx_idgun_vortex_zod_zmb";
		fx_vortex_explosion = "zombie/fx_idgun_vortex_explo_zod_zmb";
		n_vortex_time = 5;
	}
	vortex_fx_handle = playFX(localClientNum, fx_vortex, vposition);
	SetFXIgnorePause(localClientNum, vortex_fx_handle, 1);
	playsound(0, "wpn_idgun_portal_start", vposition);
	audio::playloopat("wpn_idgun_portal_loop", vposition);
	self thread vortex_shake_and_rumble(localClientNum, vposition);
	self thread function_69096485(localClientNum, vortex_fx_handle, vposition, fx_vortex_explosion, n_vortex_time);
}

/*
	Name: vortex_shake_and_rumble
	Namespace: zombie_vortex
	Checksum: 0xADB9578F
	Offset: 0x608
	Size: 0x4F
	Parameters: 2
	Flags: None
*/
function vortex_shake_and_rumble(localClientNum, v_vortex_origin)
{
	self endon("vortex_stop");
	while(1)
	{
		self PlayRumbleOnEntity(localClientNum, "zod_idgun_vortex_interior");
		wait(0.075);
	}
}

/*
	Name: function_a9cae3ef
	Namespace: zombie_vortex
	Checksum: 0xEC471A75
	Offset: 0x660
	Size: 0x8B
	Parameters: 7
	Flags: None
*/
function function_a9cae3ef(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		EnableSpeedBlur(localClientNum, 0.1, 0.5, 0.75);
	}
	else
	{
		DisableSpeedBlur(localClientNum);
	}
}

/*
	Name: function_69096485
	Namespace: zombie_vortex
	Checksum: 0x51FF5B85
	Offset: 0x6F8
	Size: 0x243
	Parameters: 5
	Flags: None
*/
function function_69096485(localClientNum, vortex_fx_handle, vposition, fx_vortex_explosion, n_vortex_time)
{
	e_player = GetLocalPlayer(localClientNum);
	n_starttime = e_player getClientTime();
	n_currtime = e_player getClientTime() - n_starttime;
	n_vortex_time = n_vortex_time * 1000;
	while(isdefined(e_player) && n_currtime < n_vortex_time)
	{
		wait(0.05);
		if(isdefined(e_player))
		{
			n_currtime = e_player getClientTime() - n_starttime;
		}
	}
	stopfx(localClientNum, vortex_fx_handle);
	audio::stoploopat("wpn_idgun_portal_loop", vposition);
	playsound(0, "wpn_idgun_portal_stop", vposition);
	wait(0.15);
	self notify("vortex_stop");
	vortex_explosion_fx_handle = playFX(localClientNum, fx_vortex_explosion, vposition);
	SetFXIgnorePause(localClientNum, vortex_explosion_fx_handle, 1);
	playsound(0, "wpn_idgun_portal_explode", vposition);
	wait(0.05);
	if(isdefined(self))
	{
		self PlayRumbleOnEntity(localClientNum, "zod_idgun_vortex_shockwave");
	}
	function_a9cae3ef(localClientNum, undefined, 1);
	wait(0.1);
	function_a9cae3ef(localClientNum, undefined, 0);
}

