#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace gadget_vision_pulse;

/*
	Name: __init__sytem__
	Namespace: gadget_vision_pulse
	Checksum: 0xDE1BB0C0
	Offset: 0x308
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_vision_pulse", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: gadget_vision_pulse
	Checksum: 0x8E431CF7
	Offset: 0x348
	Size: 0x113
	Parameters: 0
	Flags: None
*/
function __init__()
{
	if(!SessionModeIsCampaignGame())
	{
		callback::on_localplayer_spawned(&on_localplayer_spawned);
		duplicate_render::set_dr_filter_offscreen("reveal_en", 50, "reveal_enemy", undefined, 2, "mc/hud_outline_model_z_red", 1);
		duplicate_render::set_dr_filter_offscreen("reveal_self", 50, "reveal_self", undefined, 2, "mc/hud_outline_model_z_red_alpha", 1);
	}
	clientfield::register("toplayer", "vision_pulse_active", 1, 1, "int", &vision_pulse_changed, 0, 1);
	visionset_mgr::register_visionset_info("vision_pulse", 1, 12, undefined, "vision_puls_bw");
}

/*
	Name: on_localplayer_spawned
	Namespace: gadget_vision_pulse
	Checksum: 0x1F280E98
	Offset: 0x468
	Size: 0xAB
	Parameters: 1
	Flags: None
*/
function on_localplayer_spawned(localClientNum)
{
	if(self == GetLocalPlayer(localClientNum))
	{
		self.vision_pulse_owner = undefined;
		filter::init_filter_vision_pulse(localClientNum);
		self GadgetPulseResetReveal();
		self set_reveal_self(localClientNum, 0);
		self set_reveal_enemy(localClientNum, 0);
		self thread watch_emped(localClientNum);
	}
}

/*
	Name: watch_emped
	Namespace: gadget_vision_pulse
	Checksum: 0x8B95A0EB
	Offset: 0x520
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function watch_emped(localClientNum)
{
	self endon("entityshutdown");
	while(1)
	{
		if(self IsEmpJammed())
		{
			self thread disableShader(localClientNum, 0);
			self notify("emp_jammed_vp");
			break;
		}
		wait(0.016);
	}
}

/*
	Name: disableShader
	Namespace: gadget_vision_pulse
	Checksum: 0xC3EDC67E
	Offset: 0x5A0
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function disableShader(localClientNum, duration)
{
	self endon("startVPShader");
	self endon("death");
	self endon("entityshutdown");
	self notify("disableVPShader");
	self endon("disableVPShader");
	wait(duration);
	filter::disable_filter_vision_pulse(localClientNum, 3);
}

/*
	Name: watch_world_pulse_end
	Namespace: gadget_vision_pulse
	Checksum: 0x89838CCB
	Offset: 0x618
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function watch_world_pulse_end(localClientNum)
{
	self notify("watchworldpulseend");
	self endon("watchworldpulseend");
	self util::waittill_any("entityshutdown", "death", "emp_jammed_vp");
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 0, getvisionpulsemaxradius(localClientNum) + 1);
}

/*
	Name: do_vision_world_pulse
	Namespace: gadget_vision_pulse
	Checksum: 0x396E281D
	Offset: 0x6B0
	Size: 0x32B
	Parameters: 1
	Flags: None
*/
function do_vision_world_pulse(localClientNum)
{
	self endon("entityshutdown");
	self endon("death");
	self notify("startVPShader");
	self thread watch_world_pulse_end(localClientNum);
	filter::enable_filter_vision_pulse(localClientNum, 3);
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 1, 1);
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 2, 0.08);
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 3, 0);
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 4, 1);
	startTime = getServerTime(localClientNum);
	wait(0.016);
	amount = 1;
	irisAmount = 0;
	pulsemaxradius = 0;
	while(getServerTime(localClientNum) - startTime < 2000)
	{
		elapsedTime = getServerTime(localClientNum) - startTime * 1;
		if(elapsedTime < 200)
		{
			irisAmount = elapsedTime / 200;
		}
		else if(elapsedTime < 2000 * 0.6)
		{
			irisAmount = 1 - elapsedTime / 1000;
		}
		else
		{
			irisAmount = 0;
		}
		amount = 1 - elapsedTime / 2000;
		pulseRadius = getvisionpulseradius(localClientNum);
		pulsemaxradius = getvisionpulsemaxradius(localClientNum);
		filter::set_filter_vision_pulse_constant(localClientNum, 3, 0, pulseRadius);
		filter::set_filter_vision_pulse_constant(localClientNum, 3, 3, irisAmount);
		filter::set_filter_vision_pulse_constant(localClientNum, 3, 11, pulsemaxradius);
		wait(0.016);
	}
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 0, pulsemaxradius + 1);
	self thread disableShader(localClientNum, 4);
}

/*
	Name: vision_pulse_owner_valid
	Namespace: gadget_vision_pulse
	Checksum: 0x448F12A2
	Offset: 0x9E8
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function vision_pulse_owner_valid(owner)
{
	if(isdefined(owner) && owner isPlayer() && isalive(owner))
	{
		return 1;
	}
	return 0;
}

/*
	Name: watch_vision_pulse_owner_death
	Namespace: gadget_vision_pulse
	Checksum: 0x8A0FB79F
	Offset: 0xA40
	Size: 0xF5
	Parameters: 1
	Flags: None
*/
function watch_vision_pulse_owner_death(localClientNum)
{
	self endon("entityshutdown");
	self endon("death");
	self endon("finished_local_pulse");
	self notify("watch_vision_pulse_owner_death");
	self endon("watch_vision_pulse_owner_death");
	owner = self.vision_pulse_owner;
	if(vision_pulse_owner_valid(owner))
	{
		owner util::waittill_any("entityshutdown", "death");
	}
	self notify("vision_pulse_owner_death");
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 7, 0);
	self thread disableShader(localClientNum, 4);
	self.vision_pulse_owner = undefined;
}

/*
	Name: do_vision_local_pulse
	Namespace: gadget_vision_pulse
	Checksum: 0x7FD14468
	Offset: 0xB40
	Size: 0x299
	Parameters: 1
	Flags: None
*/
function do_vision_local_pulse(localClientNum)
{
	self endon("entityshutdown");
	self endon("death");
	self endon("vision_pulse_owner_death");
	self notify("startVPShader");
	self notify("startLocalPulse");
	self endon("startLocalPulse");
	self thread watch_vision_pulse_owner_death(localClientNum);
	origin = getrevealpulseorigin(localClientNum);
	filter::enable_filter_vision_pulse(localClientNum, 3);
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 5, 0.4);
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 6, 0.0001);
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 8, origin[0]);
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 9, origin[1]);
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 7, 1);
	startTime = getServerTime(localClientNum);
	while(getServerTime(localClientNum) - startTime < 4000)
	{
		if(getServerTime(localClientNum) - startTime < 2000)
		{
			pulseRadius = getServerTime(localClientNum) - startTime / 2000 * 2000;
		}
		filter::set_filter_vision_pulse_constant(localClientNum, 3, 10, pulseRadius);
		wait(0.016);
	}
	filter::set_filter_vision_pulse_constant(localClientNum, 3, 7, 0);
	self thread disableShader(localClientNum, 4);
	self notify("finished_local_pulse");
	self.vision_pulse_owner = undefined;
}

/*
	Name: vision_pulse_changed
	Namespace: gadget_vision_pulse
	Checksum: 0x5966EA40
	Offset: 0xDE8
	Size: 0xA3
	Parameters: 7
	Flags: None
*/
function vision_pulse_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		if(self == GetLocalPlayer(localClientNum))
		{
			if(IsDemoPlaying() && (bNewEnt || oldVal == newVal))
			{
				return;
			}
			self thread do_vision_world_pulse(localClientNum);
		}
	}
}

/*
	Name: do_reveal_enemy_pulse
	Namespace: gadget_vision_pulse
	Checksum: 0x5D4B6B41
	Offset: 0xE98
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function do_reveal_enemy_pulse(localClientNum)
{
	self endon("entityshutdown");
	self endon("death");
	self notify("startEnemyPulse");
	self endon("startEnemyPulse");
	startTime = getServerTime(localClientNum);
	currTime = startTime;
	self MapShaderConstant(localClientNum, 0, "scriptVector7", 0, 0, 0, 0);
	while(currTime - startTime < 4000)
	{
		if(currTime - startTime > 3500)
		{
			value = float(currTime - startTime - 3500 / 500);
			self MapShaderConstant(localClientNum, 0, "scriptVector7", value, 0, 0, 0);
		}
		wait(0.016);
		currTime = getServerTime(localClientNum);
	}
}

/*
	Name: set_reveal_enemy
	Namespace: gadget_vision_pulse
	Checksum: 0xF31AB4C3
	Offset: 0xFF8
	Size: 0x5B
	Parameters: 2
	Flags: None
*/
function set_reveal_enemy(localClientNum, on_off)
{
	if(on_off)
	{
		self thread do_reveal_enemy_pulse(localClientNum);
	}
	self duplicate_render::update_dr_flag(localClientNum, "reveal_enemy", on_off);
}

/*
	Name: set_reveal_self
	Namespace: gadget_vision_pulse
	Checksum: 0xA14C93CD
	Offset: 0x1060
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function set_reveal_self(localClientNum, on_off)
{
	if(on_off && self == GetLocalPlayer(localClientNum))
	{
		self thread do_vision_local_pulse(localClientNum);
	}
	else if(!on_off)
	{
		filter::set_filter_vision_pulse_constant(localClientNum, 3, 7, 0);
	}
}

/*
	Name: gadget_visionpulse_reveal
	Namespace: gadget_vision_pulse
	Checksum: 0x82DDD9A2
	Offset: 0x10F0
	Size: 0x163
	Parameters: 2
	Flags: None
*/
function gadget_visionpulse_reveal(localClientNum, bReveal)
{
	self notify("gadget_visionpulse_changed");
	player = GetLocalPlayer(localClientNum);
	if(!isdefined(self.visionPulseRevealSelf) && player == self)
	{
		self.visionPulseRevealSelf = 0;
	}
	if(!isdefined(self.visionPulseReveal))
	{
		self.visionPulseReveal = 0;
	}
	if(player == self)
	{
		owner = self gadgetpulsegetowner(localClientNum);
		if(self.visionPulseRevealSelf != bReveal || (isdefined(self.vision_pulse_owner) && isdefined(owner) && self.vision_pulse_owner != owner))
		{
			self.vision_pulse_owner = owner;
			self.visionPulseRevealSelf = bReveal;
			self set_reveal_self(localClientNum, bReveal);
		}
	}
	else if(self.visionPulseReveal != bReveal)
	{
		self.visionPulseReveal = bReveal;
		self set_reveal_enemy(localClientNum, bReveal);
	}
}

