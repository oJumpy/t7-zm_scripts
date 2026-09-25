#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace burnplayer;

/*
	Name: __init__sytem__
	Namespace: burnplayer
	Checksum: 0xFDDB2FCD
	Offset: 0x190
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("burnplayer", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: burnplayer
	Checksum: 0x6B2ED257
	Offset: 0x1D0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function __init__()
{
	clientfield::register("allplayers", "burn", 1, 1, "int");
	clientfield::register("playercorpse", "burned_effect", 1, 1, "int");
}

/*
	Name: SetPlayerBurning
	Namespace: burnplayer
	Checksum: 0x580DCDD8
	Offset: 0x240
	Size: 0xDB
	Parameters: 5
	Flags: None
*/
function SetPlayerBurning(duration, interval, damagePerInterval, attacker, weapon)
{
	self clientfield::set("burn", 1);
	self thread WatchBurnTimer(duration);
	self thread WatchBurnDamage(interval, damagePerInterval, attacker, weapon);
	self thread WatchForWater();
	self thread WatchBurnFinished();
	self PlayLoopSound("chr_burn_loop_overlay");
}

/*
	Name: TakingBurnDamage
	Namespace: burnplayer
	Checksum: 0x2A0C6C92
	Offset: 0x328
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function TakingBurnDamage(eAttacker, weapon, sMeansOfDeath)
{
	if(isdefined(self.doing_scripted_burn_damage))
	{
		self.doing_scripted_burn_damage = undefined;
		return;
	}
	if(weapon == level.weaponNone)
	{
		return;
	}
	if(weapon.burnDuration == 0)
	{
		return;
	}
	self SetPlayerBurning(weapon.burnDuration / 1000, weapon.burnDamageInterval / 1000, weapon.burnDamage, eAttacker, weapon);
}

/*
	Name: WatchBurnFinished
	Namespace: burnplayer
	Checksum: 0xA5DF9B0B
	Offset: 0x3E0
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function WatchBurnFinished()
{
	self endon("disconnect");
	self util::waittill_any("death", "burn_finished");
	self clientfield::set("burn", 0);
	self StopLoopSound(1);
}

/*
	Name: WatchBurnTimer
	Namespace: burnplayer
	Checksum: 0x911E5ABE
	Offset: 0x458
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function WatchBurnTimer(duration)
{
	self notify("BurnPlayer_WatchBurnTimer");
	self endon("BurnPlayer_WatchBurnTimer");
	self endon("disconnect");
	self endon("death");
	wait(duration);
	self notify("burn_finished");
}

/*
	Name: WatchBurnDamage
	Namespace: burnplayer
	Checksum: 0xBEAC297D
	Offset: 0x4B8
	Size: 0xC1
	Parameters: 4
	Flags: None
*/
function WatchBurnDamage(interval, damage, attacker, weapon)
{
	if(damage == 0)
	{
		return;
	}
	self endon("disconnect");
	self endon("death");
	self endon("BurnPlayer_WatchBurnTimer");
	self endon("burn_finished");
	while(1)
	{
		wait(interval);
		self.doing_scripted_burn_damage = 1;
		self DoDamage(damage, self.origin, attacker, undefined, undefined, "MOD_BURNED", 0, weapon);
		self.doing_scripted_burn_damage = undefined;
	}
}

/*
	Name: WatchForWater
	Namespace: burnplayer
	Checksum: 0x46395752
	Offset: 0x588
	Size: 0x5F
	Parameters: 0
	Flags: None
*/
function WatchForWater()
{
	self endon("disconnect");
	self endon("death");
	self endon("burn_finished");
	while(1)
	{
		if(self IsPlayerUnderwater())
		{
			self notify("burn_finished");
		}
		wait(0.05);
	}
}

