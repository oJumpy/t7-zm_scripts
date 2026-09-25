#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace speedburst;

/*
	Name: __init__sytem__
	Namespace: speedburst
	Checksum: 0x17D41454
	Offset: 0x2C8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_speed_burst", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: speedburst
	Checksum: 0x93C543C5
	Offset: 0x308
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("toplayer", "speed_burst", 1, 1, "int");
	ability_player::register_gadget_activation_callbacks(13, &gadget_speed_burst_on, &gadget_speed_burst_off);
	ability_player::register_gadget_possession_callbacks(13, &gadget_speed_burst_on_give, &gadget_speed_burst_on_take);
	ability_player::register_gadget_flicker_callbacks(13, &gadget_speed_burst_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(13, &gadget_speed_burst_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(13, &gadget_speed_burst_is_flickering);
	if(!isdefined(level.vsmgr_prio_visionset_speedburst))
	{
		level.vsmgr_prio_visionset_speedburst = 60;
	}
	visionset_mgr::register_info("visionset", "speed_burst", 1, level.vsmgr_prio_visionset_speedburst, 9, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
	callback::on_connect(&gadget_speed_burst_on_connect);
}

/*
	Name: gadget_speed_burst_is_inuse
	Namespace: speedburst
	Checksum: 0xDB301688
	Offset: 0x480
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function gadget_speed_burst_is_inuse(slot)
{
	return self flagsys::get("gadget_speed_burst_on");
}

/*
	Name: gadget_speed_burst_is_flickering
	Namespace: speedburst
	Checksum: 0x4B9CE329
	Offset: 0x4B8
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_speed_burst_is_flickering(slot)
{
	return self GadgetFlickering(slot);
}

/*
	Name: gadget_speed_burst_on_flicker
	Namespace: speedburst
	Checksum: 0xDE6B0911
	Offset: 0x4E8
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gadget_speed_burst_on_flicker(slot, weapon)
{
	self thread gadget_speed_burst_flicker(slot, weapon);
}

/*
	Name: gadget_speed_burst_on_give
	Namespace: speedburst
	Checksum: 0x7C825F71
	Offset: 0x528
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function gadget_speed_burst_on_give(slot, weapon)
{
	flagsys::set("speed_burst_on");
	self clientfield::set_to_player("speed_burst", 0);
}

/*
	Name: gadget_speed_burst_on_take
	Namespace: speedburst
	Checksum: 0x995C19E4
	Offset: 0x580
	Size: 0x4B
	Parameters: 2
	Flags: None
*/
function gadget_speed_burst_on_take(slot, weapon)
{
	flagsys::clear("speed_burst_on");
	self clientfield::set_to_player("speed_burst", 0);
}

/*
	Name: gadget_speed_burst_on_connect
	Namespace: speedburst
	Checksum: 0x99EC1590
	Offset: 0x5D8
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function gadget_speed_burst_on_connect()
{
}

/*
	Name: gadget_speed_burst_on
	Namespace: speedburst
	Checksum: 0x81291A6A
	Offset: 0x5E8
	Size: 0xC7
	Parameters: 2
	Flags: None
*/
function gadget_speed_burst_on(slot, weapon)
{
	self flagsys::set("gadget_speed_burst_on");
	self GadgetSetActivateTime(slot, GetTime());
	self clientfield::set_to_player("speed_burst", 1);
	visionset_mgr::activate("visionset", "speed_burst", self, 0.4, 0.1, 1.35);
	self.speedburstLastOnTime = GetTime();
	self.speedburstOn = 1;
	self.speedburstKill = 0;
}

/*
	Name: gadget_speed_burst_off
	Namespace: speedburst
	Checksum: 0x76B9A15
	Offset: 0x6B8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function gadget_speed_burst_off(slot, weapon)
{
	self notify("gadget_speed_burst_off");
	self flagsys::clear("gadget_speed_burst_on");
	self clientfield::set_to_player("speed_burst", 0);
	self.speedburstLastOnTime = GetTime();
	self.speedburstOn = 0;
	if(isalive(self) && (isdefined(self.speedburstKill) && self.speedburstKill) && isdefined(level.playGadgetSuccess))
	{
		self [[level.playGadgetSuccess]](weapon);
	}
	self.speedburstKill = 0;
}

/*
	Name: gadget_speed_burst_flicker
	Namespace: speedburst
	Checksum: 0x91476243
	Offset: 0x798
	Size: 0xCB
	Parameters: 2
	Flags: None
*/
function gadget_speed_burst_flicker(slot, weapon)
{
	self endon("disconnect");
	if(!self gadget_speed_burst_is_inuse(slot))
	{
		return;
	}
	eventTime = self._gadgets_player[slot].gadget_flickertime;
	self set_gadget_status("Flickering", eventTime);
	while(1)
	{
		if(!self GadgetFlickering(slot))
		{
			self set_gadget_status("Normal");
			return;
		}
		wait(0.5);
	}
}

/*
	Name: set_gadget_status
	Namespace: speedburst
	Checksum: 0x948E74E
	Offset: 0x870
	Size: 0x9B
	Parameters: 2
	Flags: None
*/
function set_gadget_status(status, time)
{
	timeStr = "";
	if(isdefined(time))
	{
		timeStr = "^3" + ", time: " + time;
	}
	if(GetDvarInt("scr_cpower_debug_prints") > 0)
	{
		self IPrintLnBold("Vision Speed burst: " + status + timeStr);
	}
}

