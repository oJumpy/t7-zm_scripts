#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace explode;

/*
	Name: __init__sytem__
	Namespace: explode
	Checksum: 0x8D9235A8
	Offset: 0x198
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("explode", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: explode
	Checksum: 0x5B05BE23
	Offset: 0x1D8
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.dirt_enable_explosion = GetDvarInt("scr_dirt_enable_explosion", 1);
	level.dirt_enable_slide = GetDvarInt("scr_dirt_enable_slide", 1);
	level.dirt_enable_fall_damage = GetDvarInt("scr_dirt_enable_fall_damage", 1);
	callback::on_localplayer_spawned(&localplayer_spawned);
	/#
		level thread updateDvars();
	#/
}

/*
	Name: updateDvars
	Namespace: explode
	Checksum: 0xE604F422
	Offset: 0x298
	Size: 0x97
	Parameters: 0
	Flags: None
*/
function updateDvars()
{
	/#
		while(1)
		{
			level.dirt_enable_explosion = GetDvarInt("Dev Block strings are not supported", level.dirt_enable_explosion);
			level.dirt_enable_slide = GetDvarInt("Dev Block strings are not supported", level.dirt_enable_slide);
			level.dirt_enable_fall_damage = GetDvarInt("Dev Block strings are not supported", level.dirt_enable_fall_damage);
			wait(1);
		}
	#/
}

/*
	Name: localplayer_spawned
	Namespace: explode
	Checksum: 0x9E3309C9
	Offset: 0x338
	Size: 0xDB
	Parameters: 1
	Flags: None
*/
function localplayer_spawned(localClientNum)
{
	if(self != GetLocalPlayer(localClientNum))
	{
		return;
	}
	if(level.dirt_enable_explosion || level.dirt_enable_slide || level.dirt_enable_fall_damage)
	{
		filter::init_filter_sprite_dirt(self);
		filter::disable_filter_sprite_dirt(self, 5);
		if(level.dirt_enable_explosion)
		{
			self thread watchForExplosion(localClientNum);
		}
		if(level.dirt_enable_slide)
		{
			self thread watchForPlayerSlide(localClientNum);
		}
		if(level.dirt_enable_fall_damage)
		{
			self thread watchForPlayerFallDamage(localClientNum);
		}
	}
}

/*
	Name: watchForPlayerFallDamage
	Namespace: explode
	Checksum: 0xF7871B3F
	Offset: 0x420
	Size: 0x97
	Parameters: 1
	Flags: None
*/
function watchForPlayerFallDamage(localClientNum)
{
	self endon("entityshutdown");
	seed = 0;
	xDir = 0;
	yDir = 270;
	while(1)
	{
		self waittill("fall_damage");
		self thread dothedirty(localClientNum, xDir, yDir, 1, 1000, 500);
	}
}

/*
	Name: watchForPlayerSlide
	Namespace: explode
	Checksum: 0xF408B1CD
	Offset: 0x4C0
	Size: 0x1CF
	Parameters: 1
	Flags: None
*/
function watchForPlayerSlide(localClientNum)
{
	self endon("entityshutdown");
	seed = 0;
	self.wasPlayerSliding = 0;
	xDir = 0;
	yDir = 6000;
	while(1)
	{
		self.IsPlayerSliding = self IsPlayerSliding();
		if(self.IsPlayerSliding)
		{
			if(!self.wasPlayerSliding)
			{
				self notify("endTheDirty");
				seed = RandomFloatRange(0, 1);
			}
			filter::set_filter_sprite_dirt_opacity(self, 5, 1);
			filter::set_filter_sprite_dirt_seed_offset(self, 5, seed);
			filter::enable_filter_sprite_dirt(self, 5);
			filter::set_filter_sprite_dirt_source_position(self, 5, xDir, yDir, 1);
			filter::set_filter_sprite_dirt_elapsed(self, 5, getServerTime(localClientNum));
		}
		else if(self.wasPlayerSliding)
		{
			self thread dothedirty(localClientNum, xDir, yDir, 1, 300, 300);
		}
		self.wasPlayerSliding = self.IsPlayerSliding;
		wait(0.016);
	}
}

/*
	Name: dothedirty
	Namespace: explode
	Checksum: 0xF110AAE7
	Offset: 0x698
	Size: 0x203
	Parameters: 6
	Flags: None
*/
function dothedirty(localClientNum, right, up, Distance, dirtDuration, dirtFadeTime)
{
	self endon("entityshutdown");
	self notify("dothedirty");
	self endon("dothedirty");
	self endon("endTheDirty");
	filter::enable_filter_sprite_dirt(self, 5);
	filter::set_filter_sprite_dirt_seed_offset(self, 5, RandomFloatRange(0, 1));
	startTime = getServerTime(localClientNum);
	currentTime = startTime;
	for(elapsedTime = 0; elapsedTime < dirtDuration;  = 0)
	{
		if(elapsedTime > dirtDuration - dirtFadeTime)
		{
			filter::set_filter_sprite_dirt_opacity(self, 5, dirtDuration - elapsedTime / dirtFadeTime);
		}
		else
		{
			filter::set_filter_sprite_dirt_opacity(self, 5, 1);
		}
		filter::set_filter_sprite_dirt_source_position(self, 5, right, up, Distance);
		filter::set_filter_sprite_dirt_elapsed(self, 5, currentTime);
		wait(0.016);
		currentTime = getServerTime(localClientNum);
	}
	filter::disable_filter_sprite_dirt(self, 5);
}

/*
	Name: watchForExplosion
	Namespace: explode
	Checksum: 0xB6F42E6E
	Offset: 0x8A8
	Size: 0x3A7
	Parameters: 1
	Flags: None
*/
function watchForExplosion(localClientNum)
{
	self endon("entityshutdown");
	while(1)
	{
		level waittill("explode", localClientNum, position, mod, weapon, owner_cent);
		explosionDistance = Distance(self.origin, position);
		if(mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE_SPLASH" && explosionDistance < 600 && !GetInKillcam(localClientNum) && !IsThirdPerson(localClientNum))
		{
			cameraAngles = self GetCamAngles();
			if(!isdefined(cameraAngles))
			{
				continue;
			}
			forwardVec = VectorNormalize(AnglesToForward(cameraAngles));
			upvec = VectorNormalize(anglesToUp(cameraAngles));
			rightVec = VectorNormalize(AnglesToRight(cameraAngles));
			explosionVec = VectorNormalize(position - self GetCamPos());
			if(VectorDot(forwardVec, explosionVec) > 0)
			{
				trace = bullettrace(GetLocalClientEyePos(localClientNum), position, 0, self);
				if(trace["fraction"] >= 0.9)
				{
					uDot = -1 * VectorDot(explosionVec, upvec);
					rDot = VectorDot(explosionVec, rightVec);
					uDotAbs = Abs(uDot);
					rDotAbs = Abs(rDot);
					if(uDotAbs > rDotAbs)
					{
						if(uDot > 0)
						{
							uDot = 1;
						}
						else
						{
							uDot = -1;
						}
					}
					else if(rDot > 0)
					{
						rDot = 1;
					}
					else
					{
						rDot = -1;
					}
					self thread dothedirty(localClientNum, rDot, uDot, 1 - explosionDistance / 600, 2000, 500);
				}
			}
		}
	}
}

