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

#namespace flashback;

/*
	Name: __init__sytem__
	Namespace: flashback
	Checksum: 0xEB9AB937
	Offset: 0x350
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_flashback", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: flashback
	Checksum: 0x334CA8D3
	Offset: 0x390
	Size: 0x20B
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "flashback_trail_fx", 1, 1, "int");
	clientfield::register("playercorpse", "flashback_clone", 1, 1, "int");
	clientfield::register("allplayers", "flashback_activated", 1, 1, "int");
	ability_player::register_gadget_activation_callbacks(16, &gadget_flashback_on, &gadget_flashback_off);
	ability_player::register_gadget_possession_callbacks(16, &gadget_flashback_on_give, &gadget_flashback_on_take);
	ability_player::register_gadget_flicker_callbacks(16, &gadget_flashback_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(16, &gadget_flashback_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(16, &gadget_flashback_is_flickering);
	ability_player::register_gadget_primed_callbacks(16, &gadget_flashback_is_primed);
	callback::on_connect(&gadget_flashback_on_connect);
	callback::on_spawned(&gadget_flashback_spawned);
	if(!isdefined(level.vsmgr_prio_overlay_flashback_warp))
	{
		level.vsmgr_prio_overlay_flashback_warp = 27;
	}
	visionset_mgr::register_info("overlay", "flashback_warp", 1, level.vsmgr_prio_overlay_flashback_warp, 1, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
}

/*
	Name: gadget_flashback_spawned
	Namespace: flashback
	Checksum: 0x37403A6E
	Offset: 0x5A8
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function gadget_flashback_spawned()
{
	self clientfield::set("flashback_activated", 0);
}

/*
	Name: gadget_flashback_is_inuse
	Namespace: flashback
	Checksum: 0xE9BDCBE4
	Offset: 0x5D8
	Size: 0x29
	Parameters: 1
	Flags: None
*/
function gadget_flashback_is_inuse(slot)
{
	return self flagsys::get("gadget_flashback_on");
}

/*
	Name: gadget_flashback_is_flickering
	Namespace: flashback
	Checksum: 0x9925899B
	Offset: 0x610
	Size: 0x21
	Parameters: 1
	Flags: None
*/
function gadget_flashback_is_flickering(slot)
{
	return self GadgetFlickering(slot);
}

/*
	Name: gadget_flashback_on_flicker
	Namespace: flashback
	Checksum: 0x4693D28E
	Offset: 0x640
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_flashback_on_flicker(slot, weapon)
{
}

/*
	Name: gadget_flashback_on_give
	Namespace: flashback
	Checksum: 0x3065EF30
	Offset: 0x660
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_flashback_on_give(slot, weapon)
{
}

/*
	Name: gadget_flashback_on_take
	Namespace: flashback
	Checksum: 0x8C62A649
	Offset: 0x680
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_flashback_on_take(slot, weapon)
{
}

/*
	Name: gadget_flashback_on_connect
	Namespace: flashback
	Checksum: 0x99EC1590
	Offset: 0x6A0
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function gadget_flashback_on_connect()
{
}

/*
	Name: clone_watch_death
	Namespace: flashback
	Checksum: 0xA4337A8B
	Offset: 0x6B0
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function clone_watch_death()
{
	self endon("death");
	wait(1);
	self clientfield::set("flashback_clone", 0);
	self ghost();
}

/*
	Name: debug_star
	Namespace: flashback
	Checksum: 0xFB4C2FD1
	Offset: 0x708
	Size: 0x8B
	Parameters: 3
	Flags: None
*/
function debug_star(origin, seconds, color)
{
	/#
		if(!isdefined(seconds))
		{
			seconds = 1;
		}
		if(!isdefined(color))
		{
			color = (1, 0, 0);
		}
		frames = Int(20 * seconds);
		debugstar(origin, frames, color);
	#/
}

/*
	Name: drop_unlinked_grenades
	Namespace: flashback
	Checksum: 0x98C08DCC
	Offset: 0x7A0
	Size: 0xC9
	Parameters: 1
	Flags: None
*/
function drop_unlinked_grenades(linkedGrenades)
{
	waittillframeend;
	foreach(grenade in linkedGrenades)
	{
		grenade launch((RandomFloatRange(-5, 5), RandomFloatRange(-5, 5), 5));
	}
}

/*
	Name: unlink_grenades
	Namespace: flashback
	Checksum: 0xFDA47A9C
	Offset: 0x878
	Size: 0x18B
	Parameters: 1
	Flags: None
*/
function unlink_grenades(oldpos)
{
	radius = 32;
	origin = oldpos;
	grenades = GetEntArray("grenade", "classname");
	radiusSq = radius * radius;
	linkedGrenades = [];
	foreach(grenade in grenades)
	{
		if(DistanceSquared(origin, grenade.origin) < radiusSq)
		{
			if(isdefined(grenade.stuckToPlayer) && grenade.stuckToPlayer == self)
			{
				grenade Unlink();
				linkedGrenades[linkedGrenades.size] = grenade;
			}
		}
	}
	thread drop_unlinked_grenades(linkedGrenades);
}

/*
	Name: gadget_flashback_on
	Namespace: flashback
	Checksum: 0x3EF755F4
	Offset: 0xA10
	Size: 0x263
	Parameters: 2
	Flags: None
*/
function gadget_flashback_on(slot, weapon)
{
	self flagsys::set("gadget_flashback_on");
	self GadgetSetActivateTime(slot, GetTime());
	visionset_mgr::activate("overlay", "flashback_warp", self, 0.8, 0.8);
	self.flashbackTime = GetTime();
	self notify("flashback");
	clone = self CreateFlashbackClone();
	clone thread clone_watch_death();
	clone clientfield::set("flashback_clone", 1);
	self thread watchClientfields();
	oldpos = self GetTagOrigin("j_spineupper");
	offset = oldpos - self.origin;
	self unlink_grenades(oldpos);
	newpos = self flashbackstart(weapon) + offset;
	self notsolid();
	if(isdefined(newpos) && isdefined(oldpos))
	{
		self thread flashbackTrailFx(slot, weapon, oldpos, newpos);
		flashbackTrailImpact(newpos, oldpos, 8);
		flashbackTrailImpact(oldpos, newpos, 8);
		if(isdefined(level.playGadgetSuccess))
		{
			self [[level.playGadgetSuccess]](weapon, "flashbackSuccessDelay");
		}
	}
	self thread deactivateFlashbackWarpAfterTime(0.8);
}

/*
	Name: watchClientfields
	Namespace: flashback
	Checksum: 0xF40A13F
	Offset: 0xC80
	Size: 0x7B
	Parameters: 0
	Flags: None
*/
function watchClientfields()
{
	self endon("death");
	self endon("disconnect");
	util::wait_network_frame();
	self clientfield::set("flashback_activated", 1);
	util::wait_network_frame();
	self clientfield::set("flashback_activated", 0);
}

/*
	Name: flashbackTrailImpact
	Namespace: flashback
	Checksum: 0xA25BB3A9
	Offset: 0xD08
	Size: 0xFB
	Parameters: 3
	Flags: None
*/
function flashbackTrailImpact(startPos, endPos, recursionDepth)
{
	recursionDepth--;
	if(recursionDepth <= 0)
	{
		return;
	}
	trace = bullettrace(startPos, endPos, 0, self);
	if(trace["fraction"] < 1 && trace["normal"] != (0, 0, 0))
	{
		playFX("player/fx_plyr_flashback_trail_impact", trace["position"], trace["normal"]);
		newStartPos = trace["position"] - trace["normal"];
		/#
		#/
		flashbackTrailImpact(newStartPos, endPos, recursionDepth);
	}
}

/*
	Name: deactivateFlashbackWarpAfterTime
	Namespace: flashback
	Checksum: 0xA85B71E7
	Offset: 0xE10
	Size: 0x53
	Parameters: 1
	Flags: None
*/
function deactivateFlashbackWarpAfterTime(time)
{
	self endon("disconnect");
	self util::waittill_any_timeout(time, "death");
	visionset_mgr::deactivate("overlay", "flashback_warp", self);
}

/*
	Name: flashbackTrailFx
	Namespace: flashback
	Checksum: 0xA43000FC
	Offset: 0xE70
	Size: 0x1E3
	Parameters: 4
	Flags: None
*/
function flashbackTrailFx(slot, weapon, oldpos, newpos)
{
	dirVec = newpos - oldpos;
	if(dirVec == (0, 0, 0))
	{
		dirVec = (0, 0, 1);
	}
	dirVec = VectorNormalize(dirVec);
	angles = VectorToAngles(dirVec);
	fxOrg = spawn("script_model", oldpos, 0, angles);
	fxOrg.angles = angles;
	fxOrg SetOwner(self);
	fxOrg SetModel("tag_origin");
	fxOrg clientfield::set("flashback_trail_fx", 1);
	util::wait_network_frame();
	tagPos = self GetTagOrigin("j_spineupper");
	fxOrg moveto(tagPos, 0.1);
	fxOrg waittill("movedone");
	wait(1);
	fxOrg clientfield::set("flashback_trail_fx", 0);
	util::wait_network_frame();
	fxOrg delete();
}

/*
	Name: gadget_flashback_is_primed
	Namespace: flashback
	Checksum: 0xA715D4C6
	Offset: 0x1060
	Size: 0x13
	Parameters: 2
	Flags: None
*/
function gadget_flashback_is_primed(slot, weapon)
{
}

/*
	Name: gadget_flashback_off
	Namespace: flashback
	Checksum: 0xC39375B2
	Offset: 0x1080
	Size: 0x83
	Parameters: 2
	Flags: None
*/
function gadget_flashback_off(slot, weapon)
{
	self flagsys::clear("gadget_flashback_on");
	self solid();
	self flashbackfinish();
	if(level.gameEnded)
	{
		self FreezeControls(1);
	}
}

