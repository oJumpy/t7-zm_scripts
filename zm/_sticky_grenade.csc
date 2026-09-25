#using scripts\codescripts\struct;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace _sticky_grenade;

/*
	Name: main
	Namespace: _sticky_grenade
	Checksum: 0xE389EF65
	Offset: 0x128
	Size: 0x1D
	Parameters: 0
	Flags: None
*/
function main()
{
	level._effect["grenade_light"] = "weapon/fx_equip_light_os";
}

/*
	Name: spawned
	Namespace: _sticky_grenade
	Checksum: 0x14E3A2CB
	Offset: 0x150
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
	Name: fx_think
	Namespace: _sticky_grenade
	Checksum: 0x39E3A1FC
	Offset: 0x1A0
	Size: 0x12B
	Parameters: 1
	Flags: None
*/
function fx_think(localClientNum)
{
	self notify("light_disable");
	self endon("entityshutdown");
	self endon("light_disable");
	self util::waittill_dobj(localClientNum);
	interval = 0.3;
	for(;;)
	{
		self stop_light_fx(localClientNum);
		self start_light_fx(localClientNum);
		self fullscreen_fx(localClientNum);
		self playsound(localClientNum, "wpn_semtex_alert");
		util::server_wait(localClientNum, interval, 0.01, "player_switch");
		interval = math::clamp(interval / 1.2, 0.08, 0.3);
	}
}

/*
	Name: start_light_fx
	Namespace: _sticky_grenade
	Checksum: 0x2D1DDC93
	Offset: 0x2D8
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
	Namespace: _sticky_grenade
	Checksum: 0xBD4EAE3A
	Offset: 0x350
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
	Name: fullscreen_fx
	Namespace: _sticky_grenade
	Checksum: 0xB8BF10A4
	Offset: 0x3A8
	Size: 0xF3
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
	if(self util::friend_not_foe(localClientNum))
	{
		return;
	}
	parent = self GetParentEntity();
	if(isdefined(parent) && parent == player)
	{
		parent PlayRumbleOnEntity(localClientNum, "buzz_high");
	}
}

