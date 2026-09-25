#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_flashback;

/*
	Name: __init__sytem__
	Namespace: _gadget_flashback
	Checksum: 0x5D2A0D9F
	Offset: 0x3A0
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
	Namespace: _gadget_flashback
	Checksum: 0x5D4D7917
	Offset: 0x3E0
	Size: 0x143
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("scriptmover", "flashback_trail_fx", 1, 1, "int", &set_flashback_trail_fx, 0, 0);
	clientfield::register("playercorpse", "flashback_clone", 1, 1, "int", &clone_flashback_changed, 0, 0);
	clientfield::register("allplayers", "flashback_activated", 1, 1, "int", &flashback_activated, 0, 0);
	visionset_mgr::register_overlay_info_style_postfx_bundle("flashback_warp", 1, 1, "pstfx_flashback_warp", 0.8);
	duplicate_render::set_dr_filter_framebuffer("flashback", 90, "flashback_on", "", 0, "mc/mtl_glitch", 0);
}

/*
	Name: flashback_activated
	Namespace: _gadget_flashback
	Checksum: 0x271CC57E
	Offset: 0x530
	Size: 0x133
	Parameters: 7
	Flags: None
*/
function flashback_activated(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self notify("player_flashback");
	player = GetLocalPlayer(localClientNum);
	isFirstPerson = !IsThirdPerson(localClientNum) && player == self;
	if(newVal)
	{
		if(isFirstPerson)
		{
			self playsound(localClientNum, "mpl_flashback_reappear_plr");
		}
		else
		{
			self endon("entityshutdown");
			self util::waittill_dobj(localClientNum);
			self playsound(localClientNum, "mpl_flashback_reappear_npc");
			PlayTagFXSet(localClientNum, "gadget_flashback_3p_off", self);
		}
	}
}

/*
	Name: set_flashback_trail_fx
	Namespace: _gadget_flashback
	Checksum: 0x293D556B
	Offset: 0x670
	Size: 0x173
	Parameters: 7
	Flags: None
*/
function set_flashback_trail_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	player = GetLocalPlayer(localClientNum);
	isFirstPerson = !IsThirdPerson(localClientNum) && isdefined(self.owner) && isdefined(player) && self.owner == player;
	if(newVal)
	{
		if(isFirstPerson)
		{
			player playsound(localClientNum, "mpl_flashback_disappear_plr");
		}
		else
		{
			self endon("entityshutdown");
			self util::waittill_dobj(localClientNum);
			self playsound(localClientNum, "mpl_flashback_disappear_npc");
			PlayFXOnTag(localClientNum, "player/fx_plyr_flashback_demat", self, "tag_origin");
			PlayFXOnTag(localClientNum, "player/fx_plyr_flashback_trail", self, "tag_origin");
		}
	}
}

/*
	Name: clone_flashback_changed
	Namespace: _gadget_flashback
	Checksum: 0xD2C1EFEA
	Offset: 0x7F0
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function clone_flashback_changed(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal)
	{
		self clone_flashback_changed_event(localClientNum, newVal);
	}
}

/*
	Name: clone_fade
	Namespace: _gadget_flashback
	Checksum: 0xD789A522
	Offset: 0x860
	Size: 0x13B
	Parameters: 1
	Flags: None
*/
function clone_fade(localClientNum)
{
	self endon("entityshutdown");
	startTime = getServerTime(localClientNum);
	while(1)
	{
		currentTime = getServerTime(localClientNum);
		elapsedTime = currentTime - startTime;
		elapsedTime = float(elapsedTime / 1000);
		if(elapsedTime < 1)
		{
			amount = 1 - elapsedTime / 1;
			self MapShaderConstant(localClientNum, 0, "scriptVector3", 1, 1, 0, amount);
		}
		else
		{
			self MapShaderConstant(localClientNum, 0, "scriptVector3", 1, 1, 0, 0);
			break;
		}
		wait(0.016);
	}
}

/*
	Name: clone_flashback_changed_event
	Namespace: _gadget_flashback
	Checksum: 0x35D10CE2
	Offset: 0x9A8
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function clone_flashback_changed_event(localClientNum, armorStatusNew)
{
	if(armorStatusNew)
	{
		self duplicate_render::set_dr_flag("flashback_on", 1);
		self duplicate_render::update_dr_filters(localClientNum);
		self clone_fade(localClientNum);
	}
}

