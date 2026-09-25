#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace audio;

/*
	Name: __init__sytem__
	Namespace: audio
	Checksum: 0x4BE1C835
	Offset: 0x2A0
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: audio
	Checksum: 0x41388FBE
	Offset: 0x2E0
	Size: 0xEB
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_spawned(&sndResetSoundSettings);
	callback::on_spawned(&missileLockWatcher);
	callback::on_spawned(&missileFireWatcher);
	callback::on_player_killed(&on_player_killed);
	callback::on_vehicle_spawned(&vehicleSpawnContext);
	level thread register_clientfields();
	level thread sndChyronWatcher();
	level thread sndIGCskipWatcher();
}

/*
	Name: register_clientfields
	Namespace: audio
	Checksum: 0xDB621717
	Offset: 0x3D8
	Size: 0x213
	Parameters: 0
	Flags: None
*/
function register_clientfields()
{
	clientfield::register("world", "sndMatchSnapshot", 1, 2, "int");
	clientfield::register("world", "sndFoleyContext", 1, 1, "int");
	clientfield::register("scriptmover", "sndRattle", 1, 1, "int");
	clientfield::register("toplayer", "sndMelee", 1, 1, "int");
	clientfield::register("vehicle", "sndSwitchVehicleContext", 1, 3, "int");
	clientfield::register("toplayer", "sndCCHacking", 1, 2, "int");
	clientfield::register("toplayer", "sndTacRig", 1, 1, "int");
	clientfield::register("toplayer", "sndLevelStartSnapOff", 1, 1, "int");
	clientfield::register("world", "sndIGCsnapshot", 1, 4, "int");
	clientfield::register("world", "sndChyronLoop", 1, 1, "int");
	clientfield::register("world", "sndZMBFadeIn", 1, 1, "int");
}

/*
	Name: sndChyronWatcher
	Namespace: audio
	Checksum: 0x2AA593FA
	Offset: 0x5F8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function sndChyronWatcher()
{
	level waittill("chyron_menu_open");
	level clientfield::set("sndChyronLoop", 1);
	level waittill("chyron_menu_closed");
	level clientfield::set("sndChyronLoop", 0);
}

/*
	Name: sndIGCskipWatcher
	Namespace: audio
	Checksum: 0x9624EC8B
	Offset: 0x660
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function sndIGCskipWatcher()
{
	while(1)
	{
		level waittill("scene_skip_sequence_started");
		music::setmusicstate("death");
	}
}

/*
	Name: sndResetSoundSettings
	Namespace: audio
	Checksum: 0xDE1B5159
	Offset: 0x6A0
	Size: 0x43
	Parameters: 0
	Flags: None
*/
function sndResetSoundSettings()
{
	self clientfield::set_to_player("sndMelee", 0);
	self util::clientNotify("sndDEDe");
}

/*
	Name: on_player_killed
	Namespace: audio
	Checksum: 0x8F4BB61E
	Offset: 0x6F0
	Size: 0x33
	Parameters: 0
	Flags: None
*/
function on_player_killed()
{
	if(!(isdefined(self.killcam) && self.killcam))
	{
		self util::clientNotify("sndDED");
	}
}

/*
	Name: vehicleSpawnContext
	Namespace: audio
	Checksum: 0x53079A11
	Offset: 0x730
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function vehicleSpawnContext()
{
	self clientfield::set("sndSwitchVehicleContext", 1);
}

/*
	Name: sndUpdateVehicleContext
	Namespace: audio
	Checksum: 0x9B5D4E34
	Offset: 0x760
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function sndUpdateVehicleContext(added)
{
	if(!isdefined(self.sndOccupants))
	{
		self.sndOccupants = 0;
	}
	if(added)
	{
		self.sndOccupants++;
	}
	else
	{
		self.sndOccupants--;
		if(self.sndOccupants < 0)
		{
			self.sndOccupants = 0;
		}
	}
	self clientfield::set("sndSwitchVehicleContext", self.sndOccupants + 1);
}

/*
	Name: PlayTargetMissileSound
	Namespace: audio
	Checksum: 0x6C7FCCF5
	Offset: 0x7F0
	Size: 0xA9
	Parameters: 2
	Flags: None
*/
function PlayTargetMissileSound(alias, looping)
{
	self notify("stop_target_missile_sound");
	self endon("stop_target_missile_sound");
	self endon("disconnect");
	self endon("death");
	if(isdefined(alias))
	{
		time = soundgetplaybacktime(alias) * 0.001;
		if(time > 0)
		{
			do
			{
				self playlocalsound(alias);
				wait(time);
			}
			while(!looping);
		}
	}
}

/*
	Name: missileLockWatcher
	Namespace: audio
	Checksum: 0xAC6D5BD3
	Offset: 0x8A8
	Size: 0x12D
	Parameters: 0
	Flags: None
*/
function missileLockWatcher()
{
	self endon("death");
	self endon("disconnect");
	if(!self flag::exists("playing_stinger_fired_at_me"))
	{
		self flag::init("playing_stinger_fired_at_me", 0);
		continue;
	}
	self flag::clear("playing_stinger_fired_at_me");
	while(1)
	{
		self waittill("missile_lock", attacker, weapon);
		if(!flag::get("playing_stinger_fired_at_me"))
		{
			self thread PlayTargetMissileSound(weapon.lockonTargetLockedSound, weapon.lockonTargetLockedSoundLoops);
			self util::waittill_any("stinger_fired_at_me", "missile_unlocked", "death");
			self notify("stop_target_missile_sound");
		}
	}
}

/*
	Name: missileFireWatcher
	Namespace: audio
	Checksum: 0xD9FCB40F
	Offset: 0x9E0
	Size: 0xF7
	Parameters: 0
	Flags: None
*/
function missileFireWatcher()
{
	self endon("death");
	self endon("disconnect");
	while(1)
	{
		self waittill("stinger_fired_at_me", missile, weapon, attacker);
		waittillframeend;
		self flag::set("playing_stinger_fired_at_me");
		self thread PlayTargetMissileSound(weapon.lockonTargetFiredOnSound, weapon.lockonTargetFiredOnSoundLoops);
		missile util::waittill_any("projectile_impact_explode", "death");
		self notify("stop_target_missile_sound");
		self flag::clear("playing_stinger_fired_at_me");
	}
}

/*
	Name: unlockFrontendMusic
	Namespace: audio
	Checksum: 0xEE899BB9
	Offset: 0xAE0
	Size: 0xFB
	Parameters: 2
	Flags: None
*/
function unlockFrontendMusic(unlockName, allplayers)
{
	if(!isdefined(allplayers))
	{
		allplayers = 1;
	}
	if(isdefined(allplayers) && allplayers)
	{
		if(isdefined(level.players) && level.players.size > 0)
		{
			foreach(player in level.players)
			{
				player UnlockSongByAlias(unlockName);
			}
		}
	}
	else
	{
		self UnlockSongByAlias(unlockName);
	}
}

