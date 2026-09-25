#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

#namespace smokegrenade;

/*
	Name: init_shared
	Namespace: smokegrenade
	Checksum: 0xA4898F3B
	Offset: 0x270
	Size: 0x8B
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.willyPeteDamageRadius = 300;
	level.willyPeteDamageHeight = 128;
	level.smokeGrenadeDuration = 8;
	level.smokeGrenadeDissipation = 4;
	level.smokeGrenadeTotalTime = level.smokeGrenadeDuration + level.smokeGrenadeDissipation;
	level.fx_smokegrenade_single = "smoke_center";
	level.smoke_grenade_triggers = [];
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: watchSmokeGrenadeDetonation
	Namespace: smokegrenade
	Checksum: 0xF9D8A67C
	Offset: 0x308
	Size: 0x133
	Parameters: 5
	Flags: None
*/
function watchSmokeGrenadeDetonation(owner, statWeapon, grenadeWeaponName, duration, totalTime)
{
	self endon("trophy_destroyed");
	owner addweaponstat(statWeapon, "used", 1);
	self waittill("explode", position, surface);
	oneFoot = VectorScale((0, 0, 1), 12);
	startPos = position + oneFoot;
	smokeWeapon = GetWeapon(grenadeWeaponName);
	smokeDetonate(owner, statWeapon, smokeWeapon, position, 128, totalTime, duration);
	damageEffectArea(owner, startPos, smokeWeapon.explosionRadius, level.willyPeteDamageHeight, undefined);
}

/*
	Name: smokeDetonate
	Namespace: smokegrenade
	Checksum: 0x9273D07C
	Offset: 0x448
	Size: 0x15F
	Parameters: 7
	Flags: None
*/
function smokeDetonate(owner, statWeapon, smokeWeapon, position, radius, effectLifetime, smokeBlockDuration)
{
	dir_up = (0, 0, 1);
	ent = SpawnTimedFX(smokeWeapon, position, dir_up, effectLifetime);
	ent SetTeam(owner.team);
	ent SetOwner(owner);
	ent thread smokeBlockSight(radius);
	ent thread spawnSmokeGrenadeTrigger(smokeBlockDuration);
	if(isdefined(owner))
	{
		owner.smokeGrenadeTime = GetTime();
		owner.smokeGrenadePosition = position;
	}
	thread playSmokeSound(position, smokeBlockDuration, statWeapon.projSmokeStartSound, statWeapon.projSmokeEndSound, statWeapon.projSmokeLoopSound);
	return ent;
}

/*
	Name: damageEffectArea
	Namespace: smokegrenade
	Checksum: 0xD0AEF74C
	Offset: 0x5B0
	Size: 0x9B
	Parameters: 5
	Flags: None
*/
function damageEffectArea(owner, position, radius, height, killCamEnt)
{
	effectArea = spawn("trigger_radius", position, 0, radius, height);
	if(isdefined(level.dogsOnFlashDogs))
	{
		owner thread [[level.dogsOnFlashDogs]](effectArea);
	}
	effectArea delete();
}

/*
	Name: smokeBlockSight
	Namespace: smokegrenade
	Checksum: 0xF846A3DC
	Offset: 0x658
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function smokeBlockSight(radius)
{
	self endon("death");
	while(1)
	{
		FxBlockSight(self, radius);
		/#
			if(GetDvarInt("Dev Block strings are not supported", 0))
			{
				sphere(self.origin, 128, (1, 0, 0), 0.25, 0, 10, 15);
			}
		#/
		wait(0.75);
	}
}

/*
	Name: spawnSmokeGrenadeTrigger
	Namespace: smokegrenade
	Checksum: 0xDF98B74C
	Offset: 0x6F8
	Size: 0x11B
	Parameters: 1
	Flags: None
*/
function spawnSmokeGrenadeTrigger(duration)
{
	team = self.team;
	trigger = spawn("trigger_radius", self.origin, 0, 128, 128);
	if(!isdefined(level.smoke_grenade_triggers))
	{
		level.smoke_grenade_triggers = [];
	}
	else if(!IsArray(level.smoke_grenade_triggers))
	{
		level.smoke_grenade_triggers = Array(level.smoke_grenade_triggers);
	}
	level.smoke_grenade_triggers[level.smoke_grenade_triggers.size] = trigger;
	self util::waittill_any_timeout(duration, "death");
	ArrayRemoveValue(level.smoke_grenade_triggers, trigger);
	trigger delete();
}

/*
	Name: IsInSmokeGrenade
	Namespace: smokegrenade
	Checksum: 0xAB5B5D76
	Offset: 0x820
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function IsInSmokeGrenade()
{
	foreach(trigger in level.smoke_grenade_triggers)
	{
		if(self istouching(trigger))
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: on_player_spawned
	Namespace: smokegrenade
	Checksum: 0x32980ACC
	Offset: 0x8C0
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon("disconnect");
	self thread begin_other_grenade_tracking();
}

/*
	Name: begin_other_grenade_tracking
	Namespace: smokegrenade
	Checksum: 0x5B9A858F
	Offset: 0x8F0
	Size: 0xEF
	Parameters: 0
	Flags: None
*/
function begin_other_grenade_tracking()
{
	self endon("death");
	self endon("disconnect");
	self notify("smokeTrackingStart");
	self endon("smokeTrackingStart");
	weapon_smoke = GetWeapon("willy_pete");
	for(;;)
	{
		self waittill("grenade_fire", grenade, weapon, cookTime);
		if(grenade util::isHacked())
		{
			continue;
		}
		if(weapon.rootweapon == weapon_smoke)
		{
			grenade thread watchSmokeGrenadeDetonation(self, weapon_smoke, level.fx_smokegrenade_single, level.smokeGrenadeDuration, level.smokeGrenadeTotalTime);
		}
	}
}

/*
	Name: playSmokeSound
	Namespace: smokegrenade
	Checksum: 0x175271AF
	Offset: 0x9E8
	Size: 0x13B
	Parameters: 5
	Flags: None
*/
function playSmokeSound(position, duration, startSound, stopSound, loopSound)
{
	smokeSound = spawn("script_origin", (0, 0, 1));
	smokeSound.origin = position;
	if(isdefined(startSound))
	{
		smokeSound playsound(startSound);
	}
	if(isdefined(loopSound))
	{
		smokeSound PlayLoopSound(loopSound);
	}
	if(duration > 0.5)
	{
		wait(duration - 0.5);
	}
	if(isdefined(stopSound))
	{
		thread sound::play_in_space(stopSound, position);
	}
	smokeSound StopLoopSound(0.5);
	wait(0.5);
	smokeSound delete();
}

