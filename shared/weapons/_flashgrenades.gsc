#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace flashgrenades;

/*
	Name: init_shared
	Namespace: flashgrenades
	Checksum: 0xD8FAFA1F
	Offset: 0x180
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.sound_flash_start = "";
	level.sound_flash_loop = "";
	level.sound_flash_stop = "";
	callback::on_connect(&monitorFlash);
}

/*
	Name: flashRumbleLoop
	Namespace: flashgrenades
	Checksum: 0xFF5C74E
	Offset: 0x1E0
	Size: 0x7F
	Parameters: 1
	Flags: None
*/
function flashRumbleLoop(duration)
{
	self endon("stop_monitoring_flash");
	self endon("flash_rumble_loop");
	self notify("flash_rumble_loop");
	goalTime = GetTime() + duration * 1000;
	while(GetTime() < goalTime)
	{
		self PlayRumbleOnEntity("damage_heavy");
		wait(0.05);
	}
}

/*
	Name: monitorFlash_Internal
	Namespace: flashgrenades
	Checksum: 0xEFAB220D
	Offset: 0x268
	Size: 0x3E3
	Parameters: 4
	Flags: None
*/
function monitorFlash_Internal(amount_distance, amount_angle, attacker, direct_on_player)
{
	hurtAttacker = 0;
	hurtVictim = 1;
	duration = amount_distance * 3.5;
	min_duration = 2.5;
	max_self_duration = 2.5;
	if(duration < min_duration)
	{
		duration = min_duration;
	}
	if(isdefined(attacker) && attacker == self)
	{
		duration = duration / 3;
	}
	if(duration < 0.25)
	{
		return;
	}
	rumbleduration = undefined;
	if(duration > 2)
	{
		rumbleduration = 0.75;
	}
	else
	{
		rumbleduration = 0.25;
	}
	/#
		Assert(isdefined(self.team));
	#/
	if(level.teambased && isdefined(attacker) && isdefined(attacker.team) && attacker.team == self.team && attacker != self)
	{
		friendlyfire = [[level.figure_out_friendly_fire]](self);
		if(friendlyfire == 0)
		{
			return;
		}
		else if(friendlyfire == 1)
		{
		}
		else if(friendlyfire == 2)
		{
			duration = duration * 0.5;
			rumbleduration = rumbleduration * 0.5;
			hurtVictim = 0;
			hurtAttacker = 1;
		}
		else if(friendlyfire == 3)
		{
			duration = duration * 0.5;
			rumbleduration = rumbleduration * 0.5;
			hurtAttacker = 1;
		}
	}
	if(self hasPerk("specialty_flashprotection"))
	{
		duration = duration * 0.1;
		rumbleduration = rumbleduration * 0.1;
	}
	if(hurtVictim)
	{
		if(self util::mayApplyScreenEffect() || (!direct_on_player && self IsRemoteControlling()))
		{
			if(isdefined(attacker) && self != attacker && isPlayer(attacker))
			{
				attacker addweaponstat(GetWeapon("flash_grenade"), "hits", 1);
				attacker addweaponstat(GetWeapon("flash_grenade"), "used", 1);
			}
			self thread applyFlash(duration, rumbleduration, attacker);
		}
	}
	if(hurtAttacker)
	{
		if(attacker util::mayApplyScreenEffect())
		{
			attacker thread applyFlash(duration, rumbleduration, attacker);
		}
	}
}

/*
	Name: monitorFlash
	Namespace: flashgrenades
	Checksum: 0x2F99D114
	Offset: 0x658
	Size: 0x9F
	Parameters: 0
	Flags: None
*/
function monitorFlash()
{
	self endon("disconnect");
	self endon("killFlashMonitor");
	self.flashEndTime = 0;
	while(1)
	{
		self waittill("flashbang", amount_distance, amount_angle, attacker);
		if(!isalive(self))
		{
			continue;
		}
		self monitorFlash_Internal(amount_distance, amount_angle, attacker, 1);
	}
}

/*
	Name: monitorRCBombFlash
	Namespace: flashgrenades
	Checksum: 0xF4FE401A
	Offset: 0x700
	Size: 0xC7
	Parameters: 0
	Flags: None
*/
function monitorRCBombFlash()
{
	self endon("death");
	self.flashEndTime = 0;
	while(1)
	{
		self waittill("flashbang", amount_distance, amount_angle, attacker);
		driver = self GetSeatOccupant(0);
		if(!isdefined(driver) || !isalive(driver))
		{
			continue;
		}
		driver monitorFlash_Internal(amount_distance, amount_angle, attacker, 0);
	}
}

/*
	Name: applyFlash
	Namespace: flashgrenades
	Checksum: 0x5E910E82
	Offset: 0x7D0
	Size: 0x14D
	Parameters: 3
	Flags: None
*/
function applyFlash(duration, rumbleduration, attacker)
{
	if(!isdefined(self.flashDuration) || duration > self.flashDuration)
	{
		self.flashDuration = duration;
	}
	if(!isdefined(self.flashRumbleDuration) || rumbleduration > self.flashRumbleDuration)
	{
		self.flashRumbleDuration = rumbleduration;
	}
	self thread playFlashSound(duration);
	wait(0.05);
	if(isdefined(self.flashDuration))
	{
		if(self hasPerk("specialty_flashprotection") == 0)
		{
			self shellshock("flashbang", self.flashDuration, 0);
		}
		self.flashEndTime = GetTime() + self.flashDuration * 1000;
		self.lastFlashedBy = attacker;
	}
	if(isdefined(self.flashRumbleDuration))
	{
		self thread flashRumbleLoop(self.flashRumbleDuration);
	}
	self.flashDuration = undefined;
	self.flashRumbleDuration = undefined;
}

/*
	Name: playFlashSound
	Namespace: flashgrenades
	Checksum: 0xB469A9EE
	Offset: 0x928
	Size: 0x153
	Parameters: 1
	Flags: None
*/
function playFlashSound(duration)
{
	self endon("death");
	self endon("disconnect");
	flashSound = spawn("script_origin", (0, 0, 1));
	flashSound.origin = self.origin;
	flashSound LinkTo(self);
	flashSound thread deleteEntOnOwnerDeath(self);
	flashSound playsound(level.sound_flash_start);
	flashSound PlayLoopSound(level.sound_flash_loop);
	if(duration > 0.5)
	{
		wait(duration - 0.5);
	}
	flashSound playsound(level.sound_flash_start);
	flashSound StopLoopSound(0.5);
	wait(0.5);
	flashSound notify("delete");
	flashSound delete();
}

/*
	Name: deleteEntOnOwnerDeath
	Namespace: flashgrenades
	Checksum: 0x4D8194B
	Offset: 0xA88
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function deleteEntOnOwnerDeath(owner)
{
	self endon("delete");
	owner waittill("death");
	self delete();
}

