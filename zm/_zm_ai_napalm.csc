#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_ai_napalm;

/*
	Name: __init__sytem__
	Namespace: zm_ai_napalm
	Checksum: 0x24B0F94B
	Offset: 0x410
	Size: 0x33
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_napalm", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_napalm
	Checksum: 0x86BF967C
	Offset: 0x450
	Size: 0x23
	Parameters: 0
	Flags: None
*/
function __init__()
{
	init_clientfields();
	init_napalm_zombie();
}

/*
	Name: init_clientfields
	Namespace: zm_ai_napalm
	Checksum: 0x10590FFC
	Offset: 0x480
	Size: 0x123
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	clientfield::register("actor", "napalmwet", 21000, 1, "int", &napalm_zombie_wet_callback, 0, 0);
	clientfield::register("actor", "napalmexplode", 21000, 1, "int", &napalm_zombie_explode_callback, 0, 0);
	clientfield::register("actor", "isnapalm", 21000, 1, "int", &napalm_zombie_spawn, 0, 0);
	clientfield::register("toplayer", "napalm_pstfx_burn", 21000, 1, "int", &function_8b5f66c2, 0, 0);
}

/*
	Name: init_napalm_zombie
	Namespace: zm_ai_napalm
	Checksum: 0x7A32B6F3
	Offset: 0x5B0
	Size: 0x3B
	Parameters: 0
	Flags: None
*/
function init_napalm_zombie()
{
	level.napalmplayerwarningradiussqr = 400;
	level.napalmplayerwarningradiussqr = level.napalmplayerwarningradiussqr * level.napalmplayerwarningradiussqr;
	napalm_fx();
}

/*
	Name: napalm_fx
	Namespace: zm_ai_napalm
	Checksum: 0xB10B526C
	Offset: 0x5F8
	Size: 0xC5
	Parameters: 0
	Flags: None
*/
function napalm_fx()
{
	level._effect["napalm_fire_forearm"] = "dlc5/temple/fx_ztem_napalm_zombie_forearm";
	level._effect["napalm_fire_torso"] = "dlc5/temple/fx_ztem_napalm_zombie_torso";
	level._effect["napalm_distortion"] = "dlc5/temple/fx_ztem_napalm_zombie_heat";
	level._effect["napalm_fire_forearm_end"] = "dlc5/temple/fx_ztem_napalm_zombie_forearm_end";
	level._effect["napalm_fire_torso_end"] = "dlc5/temple/fx_ztem_napalm_zombie_torso_end";
	level._effect["napalm_steam"] = "dlc5/temple/fx_ztem_zombie_torso_steam_runner";
	level._effect["napalm_feet_steam"] = "dlc5/temple/fx_ztem_zombie_torso_steam_runner";
}

/*
	Name: napalm_zombie_spawn
	Namespace: zm_ai_napalm
	Checksum: 0x3FC63F46
	Offset: 0x6C8
	Size: 0x125
	Parameters: 7
	Flags: None
*/
function napalm_zombie_spawn(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		level.napalm_zombie = self;
		self.var_d88a44cf = 1;
		self thread set_footstep_override_for_napalm_zombie(1);
		self thread napalm_glow_normal(localClientNum);
		self thread _napalm_zombie_runeffects(localClientNum);
		self thread _napalm_zombie_runsteameffects(localClientNum);
		self thread function_dfc155a2(localClientNum);
	}
	else
	{
		self notify("stop_fx");
		self notify("napalm_killed");
		if(isdefined(self.steam_fx))
		{
			self.steam_fx delete();
		}
		level.napalm_zombie = undefined;
	}
}

/*
	Name: function_dfc155a2
	Namespace: zm_ai_napalm
	Checksum: 0xF98AEEED
	Offset: 0x7F8
	Size: 0x4F
	Parameters: 1
	Flags: None
*/
function function_dfc155a2(localClientNum)
{
	self endon("napalm_killed");
	while(isdefined(self))
	{
		self MapShaderConstant(localClientNum, 0, "scriptVector2", 1, 0, 0);
		wait(0.05);
	}
}

/*
	Name: _napalm_zombie_runsteameffects
	Namespace: zm_ai_napalm
	Checksum: 0x25553926
	Offset: 0x850
	Size: 0x193
	Parameters: 1
	Flags: None
*/
function _napalm_zombie_runsteameffects(client_num)
{
	self endon("napalm_killed");
	self endon("death");
	self endon("entityshutdown");
	while(1)
	{
		waterHeight = -15000;
		UNDERWATER = waterHeight > self.origin[2];
		if(UNDERWATER)
		{
			if(!isdefined(self.steam_fx))
			{
				effectEnt = spawn(client_num, self.origin, "script_model");
				effectEnt SetModel("tag_origin");
				PlayFXOnTag(client_num, level._effect["napalm_feet_steam"], effectEnt, "tag_origin");
				self.steam_fx = effectEnt;
			}
			origin = (self.origin[0], self.origin[1], waterHeight);
			self.steam_fx.origin = origin;
		}
		else if(isdefined(self.steam_fx))
		{
			self.steam_fx delete();
			self.steam_fx = undefined;
		}
		wait(0.1);
	}
}

/*
	Name: _napalm_zombie_runeffects
	Namespace: zm_ai_napalm
	Checksum: 0x4DAC8CCC
	Offset: 0x9F0
	Size: 0x2A5
	Parameters: 1
	Flags: None
*/
function _napalm_zombie_runeffects(localClientNum)
{
	self.var_61c885f9 = [];
	wait(1);
	var_b73afa37 = PlayFXOnTag(localClientNum, level._effect["napalm_fire_forearm"], self, "J_Wrist_RI");
	Array::add(self.var_61c885f9, var_b73afa37, 0);
	var_2848fc16 = PlayFXOnTag(localClientNum, level._effect["napalm_fire_forearm"], self, "J_Wrist_LE");
	Array::add(self.var_61c885f9, var_2848fc16, 0);
	var_f86ab686 = PlayFXOnTag(localClientNum, level._effect["napalm_fire_torso"], self, "J_SpineLower");
	Array::add(self.var_61c885f9, var_f86ab686, 0);
	var_19cf783f = PlayFXOnTag(localClientNum, level._effect["napalm_fire_forearm"], self, "J_Head");
	Array::add(self.var_61c885f9, var_19cf783f, 0);
	var_bc3301ad = PlayFXOnTag(localClientNum, level._effect["napalm_distortion"], self, "tag_origin");
	Array::add(self.var_61c885f9, var_bc3301ad, 0);
	self PlayLoopSound("evt_napalm_zombie_loop", 2);
	self util::waittill_any("stop_fx", "entityshutdown");
	if(isdefined(self))
	{
		self StopAllLoopSounds(0.25);
		for(i = 0; i < self.var_61c885f9.size; i++)
		{
			stopfx(localClientNum, self.var_61c885f9[i]);
		}
		self.var_61c885f9 = undefined;
	}
}

/*
	Name: napalm_zombie_explode_callback
	Namespace: zm_ai_napalm
	Checksum: 0x2BF20574
	Offset: 0xCA0
	Size: 0x6B
	Parameters: 7
	Flags: None
*/
function napalm_zombie_explode_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self thread napalm_glow_explode(localClientNum);
	self thread _zombie_runexplosionwindupeffects(localClientNum);
}

/*
	Name: function_8b5f66c2
	Namespace: zm_ai_napalm
	Checksum: 0x24A9141A
	Offset: 0xD18
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function function_8b5f66c2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self thread postfx::playPostfxBundle("pstfx_burn_loop");
	}
	else
	{
		self thread postfx::exitPostfxBundle();
	}
}

/*
	Name: _zombie_runexplosionwindupeffects
	Namespace: zm_ai_napalm
	Checksum: 0x89808B0F
	Offset: 0xDA0
	Size: 0x25D
	Parameters: 1
	Flags: None
*/
function _zombie_runexplosionwindupeffects(localClientNum)
{
	self.var_a8353e57 = [];
	var_ba4bf47b = PlayFXOnTag(localClientNum, level._effect["napalm_fire_forearm_end"], self, "J_Elbow_LE");
	Array::add(self.var_a8353e57, var_ba4bf47b, 0);
	var_968c6325 = PlayFXOnTag(localClientNum, level._effect["napalm_fire_forearm_end"], self, "J_Elbow_RI");
	Array::add(self.var_a8353e57, var_968c6325, 0);
	var_955eea4 = PlayFXOnTag(localClientNum, level._effect["napalm_fire_forearm_end"], self, "J_Clavicle_LE");
	Array::add(self.var_a8353e57, var_955eea4, 0);
	var_4d8c73aa = PlayFXOnTag(localClientNum, level._effect["napalm_fire_forearm_end"], self, "J_Clavicle_RI");
	Array::add(self.var_a8353e57, var_4d8c73aa, 0);
	var_f86ab686 = PlayFXOnTag(localClientNum, level._effect["napalm_fire_torso_end"], self, "J_SpineLower");
	Array::add(self.var_a8353e57, var_f86ab686, 0);
	self util::waittill_any("stop_fx", "entityshutdown");
	if(isdefined(self))
	{
		for(i = 0; i < self.var_a8353e57.size; i++)
		{
			stopfx(localClientNum, self.var_a8353e57[i]);
		}
		self.var_a8353e57 = undefined;
	}
}

/*
	Name: _napalm_zombie_runweteffects
	Namespace: zm_ai_napalm
	Checksum: 0xA5C631D9
	Offset: 0x1008
	Size: 0x8B
	Parameters: 1
	Flags: None
*/
function _napalm_zombie_runweteffects(localClientNum)
{
	var_f86ab686 = PlayFXOnTag(localClientNum, level._effect["napalm_steam"], self, "J_SpineLower");
	self util::waittill_any("stop_fx", "entityshutdown");
	if(isdefined(self))
	{
		stopfx(localClientNum, var_f86ab686);
	}
}

/*
	Name: set_footstep_override_for_napalm_zombie
	Namespace: zm_ai_napalm
	Checksum: 0x8F47DC1C
	Offset: 0x10A0
	Size: 0x6B
	Parameters: 1
	Flags: None
*/
function set_footstep_override_for_napalm_zombie(set)
{
	if(set)
	{
		level._footstepCBFuncs[self.archetype] = &function_3753bc33;
		self.step_sound = "zmb_napalm_step";
	}
	else
	{
		level._footstepCBFuncs[self.archetype] = undefined;
		self.step_sound = "zmb_napalm_step";
	}
}

/*
	Name: function_3753bc33
	Namespace: zm_ai_napalm
	Checksum: 0x78E6BDAF
	Offset: 0x1118
	Size: 0x73
	Parameters: 5
	Flags: None
*/
function function_3753bc33(localClientNum, pos, surface, Notetrack, bone)
{
	if(isdefined(self.var_d88a44cf) && self.var_d88a44cf)
	{
		PlayFXOnTag(localClientNum, level._effect["napalm_zombie_footstep"], self, bone);
	}
}

/*
	Name: player_napalm_radius_overlay_fade
	Namespace: zm_ai_napalm
	Checksum: 0xFE622337
	Offset: 0x1198
	Size: 0x1C7
	Parameters: 0
	Flags: None
*/
function player_napalm_radius_overlay_fade()
{
	self endon("death");
	self endon("disconnect");
	self endon("entityshutdown");
	prevfrac = 0;
	while(1)
	{
		frac = 0;
		if(!isdefined(level.napalm_zombie) || (isdefined(level.napalm_zombie.wet) && level.napalm_zombie.wet) || player_can_see_napalm(level.napalm_zombie))
		{
			frac = 0;
		}
		else
		{
			dist_to_napalm = DistanceSquared(self.origin, level.napalm_zombie.origin);
			if(dist_to_napalm < level.napalmplayerwarningradiussqr)
			{
				frac = level.napalmplayerwarningradiussqr - dist_to_napalm / level.napalmplayerwarningradiussqr;
				frac = frac * 1.1;
				if(frac > 1)
				{
					frac = 1;
				}
			}
		}
		delta = math::clamp(frac - prevfrac, -0.1, 0.1);
		frac = prevfrac + delta;
		prevfrac = frac;
		SetSavedDvar("r_flameScaler", frac);
		wait(0.1);
	}
}

/*
	Name: player_can_see_napalm
	Namespace: zm_ai_napalm
	Checksum: 0x18BF01B9
	Offset: 0x1368
	Size: 0x93
	Parameters: 1
	Flags: None
*/
function player_can_see_napalm(ent_napalm)
{
	trace = undefined;
	if(isdefined(level.napalm_zombie))
	{
		trace = bullettrace(self GetEye(), level.napalm_zombie.origin, 0, self);
		if(isdefined(trace) && trace["fraction"] < 0.85)
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: napalm_zombie_wet_callback
	Namespace: zm_ai_napalm
	Checksum: 0xA063C9B6
	Offset: 0x1408
	Size: 0x7B
	Parameters: 7
	Flags: None
*/
function napalm_zombie_wet_callback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		self napalm_start_wet_fx(localClientNum);
	}
	else
	{
		self napalm_end_wet_fx(localClientNum);
	}
}

/*
	Name: napalm_start_wet_fx
	Namespace: zm_ai_napalm
	Checksum: 0x5BE679B4
	Offset: 0x1490
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function napalm_start_wet_fx(client_num)
{
	self notify("stop_fx");
	self thread _napalm_zombie_runweteffects(client_num);
	self.wet = 1;
	self thread napalm_glow_wet(client_num);
	self thread set_footstep_override_for_napalm_zombie(0);
}

/*
	Name: napalm_end_wet_fx
	Namespace: zm_ai_napalm
	Checksum: 0xCA6756C3
	Offset: 0x1510
	Size: 0x73
	Parameters: 1
	Flags: None
*/
function napalm_end_wet_fx(client_num)
{
	self notify("stop_fx");
	self thread _napalm_zombie_runeffects(client_num);
	self.wet = 0;
	self thread napalm_glow_normal(client_num);
	self thread set_footstep_override_for_napalm_zombie(1);
}

/*
	Name: napalm_set_glow
	Namespace: zm_ai_napalm
	Checksum: 0x9C36257A
	Offset: 0x1590
	Size: 0x43
	Parameters: 2
	Flags: None
*/
function napalm_set_glow(client_num, glowval)
{
	self.glow_val = glowval;
	self SetShaderConstant(client_num, 0, 0, 0, 0, glowval);
}

/*
	Name: napalm_glow_normal
	Namespace: zm_ai_napalm
	Checksum: 0xC5BE5B7D
	Offset: 0x15E0
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function napalm_glow_normal(client_num)
{
	self thread napalm_glow_lerp(client_num, 2.5);
}

/*
	Name: napalm_glow_explode
	Namespace: zm_ai_napalm
	Checksum: 0x5EF8973E
	Offset: 0x1618
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function napalm_glow_explode(client_num)
{
	self thread napalm_glow_lerp(client_num, 10);
}

/*
	Name: napalm_glow_wet
	Namespace: zm_ai_napalm
	Checksum: 0x75EC393A
	Offset: 0x1650
	Size: 0x2B
	Parameters: 1
	Flags: None
*/
function napalm_glow_wet(client_num)
{
	self thread napalm_glow_lerp(client_num, 0.5);
}

/*
	Name: napalm_glow_lerp
	Namespace: zm_ai_napalm
	Checksum: 0x62E5C152
	Offset: 0x1688
	Size: 0x173
	Parameters: 2
	Flags: None
*/
function napalm_glow_lerp(client_num, glowval)
{
	self notify("glow_lerp");
	self endon("glow_lerp");
	self endon("death");
	self endon("entityshutdown");
	startVal = self.glow_val;
	endVal = glowval;
	if(isdefined(startVal))
	{
		delta = glowval - self.glow_val;
		lerpTime = 1000;
		startTime = GetRealTime();
		while(startTime + lerpTime > GetRealTime())
		{
			s = GetRealTime() - startTime / lerpTime;
			newVal = startVal + endVal - startVal * s;
			self napalm_set_glow(client_num, newVal);
			WaitRealTime(0.05);
		}
	}
	self napalm_set_glow(client_num, endVal);
}

