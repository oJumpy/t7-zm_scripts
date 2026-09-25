#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace sticky_grenade;

/*
	Name: __init__sytem__
	Namespace: sticky_grenade
	Checksum: 0xF63BFE3B
	Offset: 0x1D0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spike_charge", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: sticky_grenade
	Checksum: 0xBA7CF905
	Offset: 0x210
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["spike_light"] = "weapon/fx_light_spike_launcher";
	callback::add_weapon_type("spike_launcher", &spawned);
	callback::add_weapon_type("spike_launcher_cpzm", &spawned);
	callback::add_weapon_type("spike_charge", &spawned_spike_charge);
}

/*
	Name: spawned
	Namespace: sticky_grenade
	Checksum: 0xD5BF0BF6
	Offset: 0x2B0
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function spawned(localClientNum)
{
	self thread fx_think(localClientNum);
}

/*
	Name: spawned_spike_charge
	Namespace: sticky_grenade
	Checksum: 0xF6DA891F
	Offset: 0x2E0
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function spawned_spike_charge(localClientNum)
{
	self thread fx_think(localClientNum);
	self thread spike_detonation(localClientNum);
}

/*
	Name: fx_think
	Namespace: sticky_grenade
	Checksum: 0x59FF6660
	Offset: 0x328
	Size: 0x10B
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
		util::server_wait(localClientNum, interval, 0.01, "player_switch");
		self util::waittill_dobj(localClientNum);
		interval = math::clamp(interval / 1.2, 0.08, 0.3);
	}
}

/*
	Name: start_light_fx
	Namespace: sticky_grenade
	Checksum: 0x4AD23D31
	Offset: 0x440
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function start_light_fx(localClientNum)
{
	player = GetLocalPlayer(localClientNum);
	self.FX = PlayFXOnTag(localClientNum, level._effect["spike_light"], self, "tag_fx");
}

/*
	Name: stop_light_fx
	Namespace: sticky_grenade
	Checksum: 0x37EDC037
	Offset: 0x4B8
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
	Name: spike_detonation
	Namespace: sticky_grenade
	Checksum: 0x501C98EF
	Offset: 0x510
	Size: 0x103
	Parameters: 1
	Flags: None
*/
function spike_detonation(localClientNum)
{
	spike_position = self.origin;
	while(isdefined(self))
	{
		wait(0.016);
	}
	if(!IsIGCActive(localClientNum))
	{
		player = GetLocalPlayer(localClientNum);
		explosion_distance = DistanceSquared(spike_position, player.origin);
		if(explosion_distance <= 450 * 450)
		{
			player thread postfx::playPostfxBundle("pstfx_dust_chalk");
		}
		if(explosion_distance <= 300 * 300)
		{
			player thread postfx::playPostfxBundle("pstfx_dust_concrete");
		}
	}
}

