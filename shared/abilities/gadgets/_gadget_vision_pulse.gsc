#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\abilities\gadgets\_gadget_camo;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_vision_pulse;

/*
	Name: __init__sytem__
	Namespace: _gadget_vision_pulse
	Checksum: 0xAE6A0676
	Offset: 0x330
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
	Namespace: _gadget_vision_pulse
	Checksum: 0xF61282E1
	Offset: 0x370
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(6, &gadget_vision_pulse_on, &gadget_vision_pulse_off);
	ability_player::register_gadget_possession_callbacks(6, &gadget_vision_pulse_on_give, &gadget_vision_pulse_on_take);
	ability_player::register_gadget_flicker_callbacks(6, &gadget_vision_pulse_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(6, &gadget_vision_pulse_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(6, &gadget_vision_pulse_is_flickering);
	callback::on_connect(&gadget_vision_pulse_on_connect);
	callback::on_spawned(&gadget_vision_pulse_on_spawn);
	clientfield::register("toplayer", "vision_pulse_active", 1, 1, "int");
	if(!isdefined(level.vsmgr_prio_visionset_visionpulse))
	{
		level.vsmgr_prio_visionset_visionpulse = 61;
	}
	visionset_mgr::register_info("visionset", "vision_pulse", 1, level.vsmgr_prio_visionset_visionpulse, 12, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
}

/*
	Name: gadget_vision_pulse_is_inuse
	Namespace: _gadget_vision_pulse
	Checksum: 0x7D450A1C
	Offset: 0x508
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function gadget_vision_pulse_is_inuse(slot)
{
	return self flagsys::get("gadget_vision_pulse_on");
}

/*
	Name: gadget_vision_pulse_is_flickering
	Namespace: _gadget_vision_pulse
	Checksum: 0xAD0BE0E1
	Offset: 0x540
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_vision_pulse_is_flickering(slot)
{
	return self GadgetFlickering(slot);
}

/*
	Name: gadget_vision_pulse_on_flicker
	Namespace: _gadget_vision_pulse
	Checksum: 0xC7215618
	Offset: 0x570
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gadget_vision_pulse_on_flicker(slot, weapon)
{
	self thread gadget_vision_pulse_flicker(slot, weapon);
}

/*
	Name: gadget_vision_pulse_on_give
	Namespace: _gadget_vision_pulse
	Checksum: 0x9806817F
	Offset: 0x5B0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_vision_pulse_on_give(slot, weapon)
{
}

/*
	Name: gadget_vision_pulse_on_take
	Namespace: _gadget_vision_pulse
	Checksum: 0xC012E195
	Offset: 0x5D0
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_vision_pulse_on_take(slot, weapon)
{
}

/*
	Name: gadget_vision_pulse_on_connect
	Namespace: _gadget_vision_pulse
	Checksum: 0x99EC1590
	Offset: 0x5F0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function gadget_vision_pulse_on_connect()
{
}

/*
	Name: gadget_vision_pulse_on_spawn
	Namespace: _gadget_vision_pulse
	Checksum: 0x2BAC4722
	Offset: 0x600
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function gadget_vision_pulse_on_spawn()
{
	self.visionPulseActivateTime = 0;
	self.visionPulseArray = [];
	self.visionPulseOrigin = undefined;
	self.visionPulseOriginArray = [];
	if(isdefined(self._pulse_ent))
	{
		self._pulse_ent delete();
	}
}

/*
	Name: gadget_vision_pulse_ramp_hold_func
	Namespace: _gadget_vision_pulse
	Checksum: 0xBD564A9C
	Offset: 0x660
	Size: 0x2B
	Parameters: 0
	Flags: None
*/
function gadget_vision_pulse_ramp_hold_func()
{
	self util::waittill_any_timeout(5, "ramp_out_visionset");
}

/*
	Name: gadget_vision_pulse_watch_death
	Namespace: _gadget_vision_pulse
	Checksum: 0x8444D48
	Offset: 0x698
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function gadget_vision_pulse_watch_death()
{
	self notify("vision_pulse_watch_death");
	self endon("vision_pulse_watch_death");
	self endon("disconnect");
	self waittill("death");
	visionset_mgr::deactivate("visionset", "vision_pulse", self);
	if(isdefined(self._pulse_ent))
	{
		self._pulse_ent delete();
	}
}

/*
	Name: gadget_vision_pulse_watch_emp
	Namespace: _gadget_vision_pulse
	Checksum: 0x22298A1B
	Offset: 0x728
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function gadget_vision_pulse_watch_emp()
{
	self notify("vision_pulse_watch_emp");
	self endon("vision_pulse_watch_emp");
	self endon("disconnect");
	while(1)
	{
		if(self IsEmpJammed())
		{
			visionset_mgr::deactivate("visionset", "vision_pulse", self);
			self notify("emp_vp_jammed");
			break;
		}
		wait(0.05);
	}
	if(isdefined(self._pulse_ent))
	{
		self._pulse_ent delete();
	}
}

/*
	Name: gadget_vision_pulse_on
	Namespace: _gadget_vision_pulse
	Checksum: 0xC768C0D7
	Offset: 0x7E8
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function gadget_vision_pulse_on(slot, weapon)
{
	if(isdefined(self._pulse_ent))
	{
		return;
	}
	self flagsys::set("gadget_vision_pulse_on");
	self thread gadget_vision_pulse_start(slot, weapon);
	visionset_mgr::activate("visionset", "vision_pulse", self, 0.25, &gadget_vision_pulse_ramp_hold_func, 0.75);
	self thread gadget_vision_pulse_watch_death();
	self thread gadget_vision_pulse_watch_emp();
	self clientfield::set_to_player("vision_pulse_active", 1);
}

/*
	Name: gadget_vision_pulse_off
	Namespace: _gadget_vision_pulse
	Checksum: 0xD588ACC0
	Offset: 0x8E0
	Size: 0x53
	Parameters: 2
	Flags: None
*/
function gadget_vision_pulse_off(slot, weapon)
{
	self flagsys::clear("gadget_vision_pulse_on");
	self clientfield::set_to_player("vision_pulse_active", 0);
}

/*
	Name: gadget_vision_pulse_start
	Namespace: _gadget_vision_pulse
	Checksum: 0xAA4E3154
	Offset: 0x940
	Size: 0x37B
	Parameters: 2
	Flags: None
*/
function gadget_vision_pulse_start(slot, weapon)
{
	self endon("disconnect");
	self endon("death");
	self endon("emp_vp_jammed");
	wait(0.1);
	if(isdefined(self._pulse_ent))
	{
		return;
	}
	self._pulse_ent = spawn("script_model", self.origin);
	self._pulse_ent SetModel("tag_origin");
	self GadgetSetEntity(slot, self._pulse_ent);
	self GadgetSetActivateTime(slot, GetTime());
	self set_gadget_vision_pulse_status("Activated");
	self.visionPulseActivateTime = GetTime();
	enemyArray = level.players;
	gadget = GetWeapon("gadget_vision_pulse");
	visionPulseArray = ArraySort(enemyArray, self._pulse_ent.origin, 1, undefined, gadget.gadget_pulse_max_range);
	self.visionPulseOrigin = self._pulse_ent.origin;
	self.visionPulseArray = [];
	self.visionPulseOriginArray = [];
	spottedEnemy = 0;
	self.visionPulseSpottedEnemy = [];
	self.visionPulseSpottedEnemyTime = GetTime();
	for(i = 0; i < visionPulseArray.size; i++)
	{
		if(visionPulseArray[i] _gadget_camo::camo_is_inuse() == 0)
		{
			self.visionPulseArray[self.visionPulseArray.size] = visionPulseArray[i];
			self.visionPulseOriginArray[self.visionPulseOriginArray.size] = visionPulseArray[i].origin;
			if(isalive(visionPulseArray[i]) && visionPulseArray[i].team != self.team)
			{
				spottedEnemy = 1;
				self.visionPulseSpottedEnemy[self.visionPulseSpottedEnemy.size] = visionPulseArray[i];
			}
		}
	}
	self wait_until_is_done(slot, self._gadgets_player[slot].gadget_pulse_duration);
	if(spottedEnemy && isdefined(level.playGadgetSuccess))
	{
		self [[level.playGadgetSuccess]](weapon);
	}
	else
	{
		self playsoundtoplayer("gdt_vision_pulse_no_hits", self);
		self notify("ramp_out_visionset");
	}
	self set_gadget_vision_pulse_status("Done");
	self._pulse_ent delete();
}

/*
	Name: wait_until_is_done
	Namespace: _gadget_vision_pulse
	Checksum: 0x3832DAC6
	Offset: 0xCC8
	Size: 0x5D
	Parameters: 2
	Flags: None
*/
function wait_until_is_done(slot, timePulse)
{
	startTime = GetTime();
	while(1)
	{
		wait(0.25);
		currentTime = GetTime();
		if(currentTime > startTime + timePulse)
		{
			return;
		}
	}
}

/*
	Name: gadget_vision_pulse_flicker
	Namespace: _gadget_vision_pulse
	Checksum: 0x4E5FE86B
	Offset: 0xD30
	Size: 0xEB
	Parameters: 2
	Flags: None
*/
function gadget_vision_pulse_flicker(slot, weapon)
{
	self endon("disconnect");
	time = GetTime();
	if(!self gadget_vision_pulse_is_inuse(slot))
	{
		return;
	}
	eventTime = self._gadgets_player[slot].gadget_flickertime;
	self set_gadget_vision_pulse_status("^1" + "Flickering.", eventTime);
	while(1)
	{
		if(!self GadgetFlickering(slot))
		{
			set_gadget_vision_pulse_status("^2" + "Normal");
			return;
		}
		wait(0.25);
	}
}

/*
	Name: set_gadget_vision_pulse_status
	Namespace: _gadget_vision_pulse
	Checksum: 0xD4C6C904
	Offset: 0xE28
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function set_gadget_vision_pulse_status(status, time)
{
	timeStr = "";
	if(isdefined(time))
	{
		timeStr = "^3" + ", time: " + time;
	}
	if(GetDvarInt("scr_cpower_debug_prints") > 0)
	{
		self IPrintLnBold("Vision Pulse:" + status + timeStr);
	}
}

