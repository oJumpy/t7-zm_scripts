#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace spike_charge_siegebot;

/*
	Name: __init__sytem__
	Namespace: spike_charge_siegebot
	Checksum: 0x1AB6F6E8
	Offset: 0x210
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spike_charge_siegebot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: spike_charge_siegebot
	Checksum: 0xE9FE437F
	Offset: 0x250
	Size: 0xE3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["spike_charge_siegebot_light"] = "light/fx_light_red_spike_charge_os";
	callback::add_weapon_type("spike_charge_siegebot", &spawned);
	callback::add_weapon_type("spike_charge_siegebot_theia", &spawned);
	callback::add_weapon_type("siegebot_launcher_turret", &spawned);
	callback::add_weapon_type("siegebot_launcher_turret_theia", &spawned);
	callback::add_weapon_type("siegebot_javelin_turret", &spawned);
}

/*
	Name: spawned
	Namespace: spike_charge_siegebot
	Checksum: 0x2589692D
	Offset: 0x340
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function spawned(localClientNum)
{
	self thread fx_think(localClientNum);
}

/*
	Name: fx_think
	Namespace: spike_charge_siegebot
	Checksum: 0x52FF7FB3
	Offset: 0x370
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
		self playsound(localClientNum, "wpn_semtex_alert");
		util::server_wait(localClientNum, interval, 0.01, "player_switch");
		self util::waittill_dobj(localClientNum);
		interval = math::clamp(interval / 1.2, 0.08, 0.3);
	}
}

/*
	Name: start_light_fx
	Namespace: spike_charge_siegebot
	Checksum: 0xB2ADAA4C
	Offset: 0x4A8
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function start_light_fx(localClientNum)
{
	player = GetLocalPlayer(localClientNum);
	self.FX = PlayFXOnTag(localClientNum, level._effect["spike_charge_siegebot_light"], self, "tag_fx");
}

/*
	Name: stop_light_fx
	Namespace: spike_charge_siegebot
	Checksum: 0x8BFB3149
	Offset: 0x520
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

