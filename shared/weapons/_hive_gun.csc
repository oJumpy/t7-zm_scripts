#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace hive_gun;

/*
	Name: init_shared
	Namespace: hive_gun
	Checksum: 0xA687986D
	Offset: 0x3A0
	Size: 0x1B
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level thread register();
}

/*
	Name: register
	Namespace: hive_gun
	Checksum: 0x72891D0A
	Offset: 0x3C8
	Size: 0xDB
	Parameters: 0
	Flags: None
*/
function register()
{
	clientfield::register("scriptmover", "firefly_state", 1, 3, "int", &firefly_state_change, 0, 0);
	clientfield::register("toplayer", "fireflies_attacking", 1, 1, "int", &fireflies_attacking, 0, 1);
	clientfield::register("toplayer", "fireflies_chasing", 1, 1, "int", &fireflies_chasing, 0, 1);
}

/*
	Name: getOtherTeam
	Namespace: hive_gun
	Checksum: 0x2A432276
	Offset: 0x4B0
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function getOtherTeam(team)
{
	if(team == "allies")
	{
		return "axis";
	}
	else if(team == "axis")
	{
		return "allies";
	}
	else
	{
		return "free";
	}
}

/*
	Name: fireflies_attacking
	Namespace: hive_gun
	Checksum: 0xF387E8A9
	Offset: 0x508
	Size: 0x10D
	Parameters: 7
	Flags: None
*/
function fireflies_attacking(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		self notify("stop_player_fx");
		if(self isLocalPlayer() && !self GetInKillcam(localClientNum))
		{
			FX = PlayFXOnCamera(localClientNum, "weapon/fx_ability_firefly_attack_1p", (0, 0, 0), (1, 0, 0), (0, 0, 1));
			self thread watch_player_fx_finished(localClientNum, FX);
		}
	}
	else
	{
		self notify("stop_player_fx");
	}
}

/*
	Name: fireflies_chasing
	Namespace: hive_gun
	Checksum: 0xA5D1AC2A
	Offset: 0x620
	Size: 0x15D
	Parameters: 7
	Flags: None
*/
function fireflies_chasing(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		self notify("stop_player_fx");
		if(self isLocalPlayer() && !self GetInKillcam(localClientNum))
		{
			FX = PlayFXOnCamera(localClientNum, "weapon/fx_ability_firefly_chase_1p", (0, 0, 0), (1, 0, 0), (0, 0, 1));
			sound = self PlayLoopSound("wpn_gelgun_hive_hunt_lp");
			self PlayRumbleLoopOnEntity(localClientNum, "firefly_chase_rumble_loop");
			self thread watch_player_fx_finished(localClientNum, FX, sound);
		}
	}
	else
	{
		self notify("stop_player_fx");
	}
}

/*
	Name: watch_player_fx_finished
	Namespace: hive_gun
	Checksum: 0x67FC62A1
	Offset: 0x788
	Size: 0xBB
	Parameters: 3
	Flags: None
*/
function watch_player_fx_finished(localClientNum, FX, sound)
{
	self util::waittill_any("entityshutdown", "stop_player_fx");
	if(isdefined(self))
	{
		self StopRumble(localClientNum, "firefly_chase_rumble_loop");
	}
	if(isdefined(FX))
	{
		stopfx(localClientNum, FX);
	}
	if(isdefined(sound) && isdefined(self))
	{
		self StopLoopSound(sound);
	}
}

/*
	Name: firefly_state_change
	Namespace: hive_gun
	Checksum: 0x184CFD32
	Offset: 0x850
	Size: 0x14D
	Parameters: 7
	Flags: None
*/
function firefly_state_change(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(!isdefined(self.initied))
	{
		self thread firefly_init(localClientNum);
		self.initied = 1;
	}
	switch(newVal)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			self FIREFLY_DEPLOYING(localClientNum);
			break;
		}
		case 2:
		{
			self FIREFLY_HUNTING(localClientNum);
			break;
		}
		case 3:
		{
			self FIREFLY_ATTACKING(localClientNum);
			break;
		}
		case 4:
		{
			self FIREFLY_LINK_ATTACKING(localClientNum);
			break;
		}
	}
}

/*
	Name: on_shutdown
	Namespace: hive_gun
	Checksum: 0x93F98983
	Offset: 0x9A8
	Size: 0xB3
	Parameters: 2
	Flags: None
*/
function on_shutdown(localClientNum, ent)
{
	if(isdefined(ent) && isdefined(ent.origin) && self === ent && (!isdefined(self.no_death_fx) && self.no_death_fx))
	{
		FX = playFX(localClientNum, "weapon/fx_hero_firefly_death", ent.origin, (0, 0, 1));
		SetFxTeam(localClientNum, FX, ent.team);
	}
}

/*
	Name: firefly_init
	Namespace: hive_gun
	Checksum: 0x51AAEE7F
	Offset: 0xA68
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function firefly_init(localClientNum)
{
	self callback::on_shutdown(&on_shutdown, self);
}

/*
	Name: FIREFLY_DEPLOYING
	Namespace: hive_gun
	Checksum: 0x4F834A09
	Offset: 0xAA0
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function FIREFLY_DEPLOYING(localClientNum)
{
	FX = playFX(localClientNum, "weapon/fx_hero_firefly_start", self.origin, anglesToUp(self.angles));
	SetFxTeam(localClientNum, FX, self.team);
}

/*
	Name: FIREFLY_HUNTING
	Namespace: hive_gun
	Checksum: 0x7BFF501F
	Offset: 0xB20
	Size: 0x83
	Parameters: 1
	Flags: None
*/
function FIREFLY_HUNTING(localClientNum)
{
	FX = PlayFXOnTag(localClientNum, "weapon/fx_hero_firefly_hunting", self, "tag_origin");
	SetFxTeam(localClientNum, FX, self.team);
	self thread firefly_watch_fx_finished(localClientNum, FX);
}

/*
	Name: firefly_watch_fx_finished
	Namespace: hive_gun
	Checksum: 0xC31B21CB
	Offset: 0xBB0
	Size: 0x63
	Parameters: 2
	Flags: None
*/
function firefly_watch_fx_finished(localClientNum, FX)
{
	self util::waittill_any("entityshutdown", "stop_effects");
	if(isdefined(FX))
	{
		stopfx(localClientNum, FX);
	}
}

/*
	Name: FIREFLY_ATTACKING
	Namespace: hive_gun
	Checksum: 0x2E3A5C2B
	Offset: 0xC20
	Size: 0x27
	Parameters: 1
	Flags: None
*/
function FIREFLY_ATTACKING(localClientNum)
{
	self notify("stop_effects");
	self.no_death_fx = 1;
}

/*
	Name: FIREFLY_LINK_ATTACKING
	Namespace: hive_gun
	Checksum: 0xDBACAAA3
	Offset: 0xC50
	Size: 0x8F
	Parameters: 1
	Flags: None
*/
function FIREFLY_LINK_ATTACKING(localClientNum)
{
	FX = playFX(localClientNum, "weapon/fx_hero_firefly_start_entity", self.origin, anglesToUp(self.angles));
	SetFxTeam(localClientNum, FX, self.team);
	self notify("stop_effects");
	self.no_death_fx = 1;
}

/*
	Name: gib_fx
	Namespace: hive_gun
	Checksum: 0xB1549DB5
	Offset: 0xCE8
	Size: 0xAB
	Parameters: 3
	Flags: None
*/
function gib_fx(localClientNum, fxFileName, gibFlag)
{
	fxTag = GibClientUtils::PlayerGibTag(localClientNum, gibFlag);
	if(isdefined(fxTag))
	{
		FX = PlayFXOnTag(localClientNum, fxFileName, self, fxTag);
		SetFxTeam(localClientNum, FX, getOtherTeam(self.team));
	}
}

/*
	Name: gib_corpse
	Namespace: hive_gun
	Checksum: 0xD2504F7C
	Offset: 0xDA0
	Size: 0x33
	Parameters: 2
	Flags: None
*/
function gib_corpse(localClientNum, value)
{
	self endon("entityshutdown");
	self thread watch_for_gib_notetracks(localClientNum);
}

/*
	Name: watch_for_gib_notetracks
	Namespace: hive_gun
	Checksum: 0xF782D03
	Offset: 0xDE0
	Size: 0x34D
	Parameters: 1
	Flags: None
*/
function watch_for_gib_notetracks(localClientNum)
{
	self endon("entityshutdown");
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	fxFileName = "weapon/fx_hero_firefly_attack_limb";
	bodyType = self GetCharacterBodyType();
	if(bodyType >= 0)
	{
		bodyTypeFields = GetCharacterFields(bodyType, CurrentSessionMode());
		if(isdefined(bodyTypeFields.digitalBlood))
		{
		}
		else if(0)
		{
			fxFileName = "weapon/fx_hero_firefly_attack_limb_reaper";
		}
	}
	arm_gib = 0;
	leg_gib = 0;
	while(1)
	{
		Notetrack = self util::waittill_any_return("gib_leftarm", "gib_leftleg", "gib_rightarm", "gib_rightleg", "entityshutdown");
		switch(Notetrack)
		{
			case "gib_rightarm":
			{
				arm_gib = arm_gib | 1;
				gib_fx(localClientNum, fxFileName, 16);
				self GibClientUtils::PlayerGibLeftArm(localClientNum);
				self SetCorpseGibState(leg_gib, arm_gib);
				break;
			}
			case "gib_leftarm":
			{
				arm_gib = arm_gib | 2;
				gib_fx(localClientNum, fxFileName, 32);
				self GibClientUtils::PlayerGibLeftArm(localClientNum);
				self SetCorpseGibState(leg_gib, arm_gib);
				break;
			}
			case "gib_rightleg":
			{
				leg_gib = leg_gib | 1;
				gib_fx(localClientNum, fxFileName, 128);
				self GibClientUtils::PlayerGibLeftLeg(localClientNum);
				self SetCorpseGibState(leg_gib, arm_gib);
				break;
			}
			case "gib_leftleg":
			{
				leg_gib = leg_gib | 2;
				gib_fx(localClientNum, fxFileName, 256);
				self GibClientUtils::PlayerGibLeftLeg(localClientNum);
				self SetCorpseGibState(leg_gib, arm_gib);
				break;
			}
			case default:
			{
				break;
			}
		}
	}
}

