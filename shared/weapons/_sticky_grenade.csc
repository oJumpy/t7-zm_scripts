#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace sticky_grenade;

/*
	Name: __init__sytem__
	Namespace: sticky_grenade
	Checksum: 0x2F7CBAF1
	Offset: 0x1F8
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("sticky_grenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: sticky_grenade
	Checksum: 0x550C155C
	Offset: 0x238
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["grenade_light"] = "weapon/fx_equip_light_os";
	callback::add_weapon_type("sticky_grenade", &spawned);
}

/*
	Name: spawned
	Namespace: sticky_grenade
	Checksum: 0x90778741
	Offset: 0x288
	Size: 0x43
	Parameters: 1
	Flags: None
*/
function spawned(localClientNum)
{
	if(self isGrenadeDud())
	{
		return;
	}
	self thread fx_think(localClientNum);
}

/*
	Name: stop_sound_on_ent_shutdown
	Namespace: sticky_grenade
	Checksum: 0xC914722A
	Offset: 0x2D8
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function stop_sound_on_ent_shutdown(handle)
{
	self waittill("entityshutdown");
	stopSound(handle);
}

/*
	Name: fx_think
	Namespace: sticky_grenade
	Checksum: 0xA452FDC0
	Offset: 0x310
	Size: 0x20B
	Parameters: 1
	Flags: None
*/
function fx_think(localClientNum)
{
	self notify("light_disable");
	self endon("light_disable");
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	handle = self playsound(localClientNum, "wpn_semtex_countdown");
	self thread stop_sound_on_ent_shutdown(handle);
	interval = 0.3;
	for(;;)
	{
		self stop_light_fx(localClientNum);
		localPlayer = GetLocalPlayer(localClientNum);
		if(!localPlayer isEntityLinkedToTag(self, "j_head") && !localPlayer isEntityLinkedToTag(self, "j_elbow_le") && !localPlayer isEntityLinkedToTag(self, "j_spineupper"))
		{
			self start_light_fx(localClientNum);
		}
		self fullscreen_fx(localClientNum);
		util::server_wait(localClientNum, interval, 0.01, "player_switch");
		self util::waittill_dobj(localClientNum);
		interval = math::clamp(interval / 1.2, 0.08, 0.3);
	}
}

/*
	Name: start_light_fx
	Namespace: sticky_grenade
	Checksum: 0x1E1CD13D
	Offset: 0x528
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function start_light_fx(localClientNum)
{
	player = GetLocalPlayer(localClientNum);
	self.FX = PlayFXOnTag(localClientNum, level._effect["grenade_light"], self, "tag_fx");
}

/*
	Name: stop_light_fx
	Namespace: sticky_grenade
	Checksum: 0x42AB7A2C
	Offset: 0x5A0
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function stop_light_fx(localClientNum)
{
	if(isdefined(self.FX) && self.FX != 0)
	{
		stopfx(localClientNum, self.FX);
		self.FX = undefined;
	}
}

/*
	Name: sticky_indicator
	Namespace: sticky_grenade
	Checksum: 0x98E7F689
	Offset: 0x5F8
	Size: 0xD3
	Parameters: 2
	Flags: None
*/
function sticky_indicator(player, localClientNum)
{
	controllerModel = GetUIModelForController(localClientNum);
	stickyImageModel = CreateUIModel(controllerModel, "hudItems.stickyImage");
	SetUIModelValue(stickyImageModel, "hud_icon_stuck_semtex");
	player thread stick_indicator_watch_early_shutdown(stickyImageModel);
	while(isdefined(self))
	{
		wait(0.016);
	}
	SetUIModelValue(stickyImageModel, "blacktransparent");
	player notify("sticky_shutdown");
}

/*
	Name: stick_indicator_watch_early_shutdown
	Namespace: sticky_grenade
	Checksum: 0xCA91A046
	Offset: 0x6D8
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function stick_indicator_watch_early_shutdown(stickyImageModel)
{
	self endon("sticky_shutdown");
	self endon("entityshutdown");
	self waittill("player_flashback");
	SetUIModelValue(stickyImageModel, "blacktransparent");
}

/*
	Name: fullscreen_fx
	Namespace: sticky_grenade
	Checksum: 0x2D0EE09B
	Offset: 0x730
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function fullscreen_fx(localClientNum)
{
	player = GetLocalPlayer(localClientNum);
	if(isdefined(player))
	{
		if(player GetInKillcam(localClientNum))
		{
			return;
		}
		else if(player util::is_player_view_linked_to_entity(localClientNum))
		{
			return;
		}
	}
	if(self isFriendly(localClientNum))
	{
		return;
	}
	parent = self GetParentEntity();
	if(isdefined(parent) && parent == player)
	{
		parent PlayRumbleOnEntity(localClientNum, "buzz_high");
		if(GetDvarInt("ui_hud_hardcore") == 0)
		{
			self thread sticky_indicator(player, localClientNum);
		}
	}
}

