#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace damagefeedback;

/*
	Name: __init__
	Namespace: damagefeedback
	Checksum: 0xC1CDDCA
	Offset: 0x210
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&main);
	callback::on_connect(&on_player_connect);
}

/*
	Name: main
	Namespace: damagefeedback
	Checksum: 0x99EC1590
	Offset: 0x260
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function main()
{
}

/*
	Name: on_player_connect
	Namespace: damagefeedback
	Checksum: 0x1A5D1AC9
	Offset: 0x270
	Size: 0xD7
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self.hud_damagefeedback = newdamageindicatorhudelem(self);
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = 1;
	self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
	self.hitSoundTracker = 1;
}

/*
	Name: should_play_sound
	Namespace: damagefeedback
	Checksum: 0xD1F3C81D
	Offset: 0x350
	Size: 0x65
	Parameters: 1
	Flags: None
*/
function should_play_sound(mod)
{
	if(!isdefined(mod))
	{
		return 0;
	}
	switch(mod)
	{
		case "MOD_CRUSH":
		case "MOD_GRENADE_SPLASH":
		case "MOD_HIT_BY_OBJECT":
		case "MOD_MELEE":
		case "MOD_MELEE_ASSASSINATE":
		case "MOD_MELEE_WEAPON_BUTT":
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: updateDamageFeedback
	Namespace: damagefeedback
	Checksum: 0x2ECBF3A1
	Offset: 0x3C0
	Size: 0x26F
	Parameters: 3
	Flags: None
*/
function updateDamageFeedback(mod, inflictor, perkFeedback)
{
	if(!isPlayer(self) || SessionModeIsZombiesGame())
	{
		return;
	}
	if(should_play_sound(mod))
	{
		if(isdefined(inflictor) && isdefined(inflictor.soundMod))
		{
			switch(inflictor.soundMod)
			{
				case "player":
				{
					self thread playHitSound(mod, "mpl_hit_alert");
					break;
				}
				case "heli":
				{
					self thread playHitSound(mod, "mpl_hit_alert_air");
					break;
				}
				case "hpm":
				{
					self thread playHitSound(mod, "mpl_hit_alert_hpm");
					break;
				}
				case "taser_spike":
				{
					self thread playHitSound(mod, "mpl_hit_alert_taser_spike");
					break;
				}
				case "dog":
				case "straferun":
				{
					break;
				}
				case "default_loud":
				{
					self thread playHitSound(mod, "mpl_hit_heli_gunner");
					break;
				}
				case default:
				{
					self thread playHitSound(mod, "mpl_hit_alert_low");
					break;
				}
			}
		}
		else
		{
			self thread playHitSound(mod, "mpl_hit_alert_low");
		}
	}
	if(isdefined(perkFeedback))
	{
	}
	else
	{
		self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
	}
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime(1);
	self.hud_damagefeedback.alpha = 0;
}

/*
	Name: playHitSound
	Namespace: damagefeedback
	Checksum: 0x6F63D84D
	Offset: 0x638
	Size: 0x5F
	Parameters: 2
	Flags: None
*/
function playHitSound(mod, alert)
{
	self endon("disconnect");
	if(self.hitSoundTracker)
	{
		self.hitSoundTracker = 0;
		self playlocalsound(alert);
		wait(0.05);
		self.hitSoundTracker = 1;
	}
}

/*
	Name: updateSpecialDamageFeedback
	Namespace: damagefeedback
	Checksum: 0x9659774
	Offset: 0x6A0
	Size: 0xE9
	Parameters: 1
	Flags: None
*/
function updateSpecialDamageFeedback(hitEnt)
{
	if(!isPlayer(self))
	{
		return;
	}
	if(!isdefined(hitEnt))
	{
		return;
	}
	if(!isPlayer(hitEnt))
	{
		return;
	}
	wait(0.05);
	if(!isdefined(self.directionalHitArray))
	{
		self.directionalHitArray = [];
		hitEntNum = hitEnt GetEntityNumber();
		self.directionalHitArray[hitEntNum] = 1;
		self thread sendHitSpecialEventAtFrameEnd(hitEnt);
	}
	else
	{
		hitEntNum = hitEnt GetEntityNumber();
		self.directionalHitArray[hitEntNum] = 1;
	}
}

/*
	Name: sendHitSpecialEventAtFrameEnd
	Namespace: damagefeedback
	Checksum: 0xEEA33415
	Offset: 0x798
	Size: 0x17D
	Parameters: 1
	Flags: None
*/
function sendHitSpecialEventAtFrameEnd(hitEnt)
{
	self endon("disconnect");
	waittillframeend;
	enemysHit = 0;
	value = 1;
	entBitArray0 = 0;
	for(i = 0; i < 32; i++)
	{
		if(isdefined(self.directionalHitArray[i]) && self.directionalHitArray[i] != 0)
		{
			entBitArray0 = entBitArray0 + value;
			enemysHit++;
		}
		value = value * 2;
	}
	entBitArray1 = 0;
	for(i = 33; i < 64; i++)
	{
		if(isdefined(self.directionalHitArray[i]) && self.directionalHitArray[i] != 0)
		{
			entBitArray1 = entBitArray1 + value;
			enemysHit++;
		}
		value = value * 2;
	}
	if(enemysHit)
	{
		self directionalHitIndicator(entBitArray0, entBitArray1);
	}
	self.directionalHitArray = undefined;
	entBitArray0 = 0;
	entBitArray1 = 0;
}

