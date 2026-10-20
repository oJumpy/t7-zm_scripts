#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_callbacks;

#namespace zm_ai_margwa_elemental;

/*
	Name: init
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xF1A5B2F1
	Offset: 0x708
	Size: 0x409
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	callback::add_weapon_type("launcher_shadow_margwa", &function_894980af);
	clientfield::register("actor", "margwa_elemental_type", 15000, 3, "int", &function_1fb4e300, 0, 0);
	clientfield::register("actor", "margwa_defense_actor_appear_disappear_fx", 15000, 1, "int", &function_345693f6, 0, 0);
	clientfield::register("scriptmover", "play_margwa_fire_attack_fx", 15000, 1, "counter", &function_c46381fc, 0, 0);
	clientfield::register("scriptmover", "margwa_defense_hovering_fx", 15000, 3, "int", &function_abb174cf, 0, 0);
	clientfield::register("actor", "shadow_margwa_attack_portal_fx", 15000, 1, "int", &shadow_margwa_attack_portal_fx, 0, 0);
	clientfield::register("actor", "margwa_shock_fx", 15000, 1, "int", &death_ray_shock_fx, 0, 0);
	level._effect["margwa_fire_roar"] = "dlc4/genesis/fx_margwa_roar_fire";
	level._effect["margwa_fire_spawn"] = "dlc4/genesis/fx_margwa_spawn_fire";
	level._effect["margwa_fire_attack_explosion"] = "dlc4/genesis/fx_margwa_attack_fire";
	level._effect["margwa_fire_defense_disappear"] = "dlc4/genesis/fx_margwa_attack_fire";
	level._effect["margwa_fire_defense_appear"] = "dlc4/genesis/fx_margwa_attack_fire";
	level._effect["margwa_fire_defense_fireball"] = "zombie/fx_meatball_portal_sky_zod_zmb";
	level._effect["margwa_fire_head_hit"] = "dlc4/genesis/fx_margwa_head_shot_fire";
	level._effect["margwa_shadow_roar"] = "dlc4/genesis/fx_margwa_roar_shadow";
	level._effect["margwa_shadow_spawn"] = "dlc4/genesis/fx_margwa_spawn_shadow";
	level._effect["margwa_shadow_attack_portal_open"] = "dlc4/genesis/fx_margwa_portal_open_shadow";
	level._effect["margwa_shadow_attack_portal_loop"] = "dlc4/genesis/fx_margwa_portal_loop_shadow";
	level._effect["margwa_shadow_attack_portal_close"] = "dlc4/genesis/fx_margwa_portal_close_shadow";
	level._effect["margwa_shadow_defense_disappear"] = "dlc1/castle/fx_demon_gate_portal_open";
	level._effect["margwa_shadow_defense_appear"] = "dlc1/castle/fx_demon_gate_portal_open";
	level._effect["margwa_shadow_defense_ball"] = "smoke/fx_smk_barrel_30x30";
	level._effect["margwa_shadow_head_hit"] = "dlc4/genesis/fx_margwa_head_shot_shadow";
	level._effect["margwa_light_roar"] = "dlc4/genesis/fx_margwa_roar_light";
	level._effect["margwa_light_spawn"] = "dlc4/genesis/fx_margwa_spawn";
	level._effect["margwa_electric_roar"] = "dlc4/genesis/fx_margwa_roar_electricity";
	level._effect["margwa_electric_spawn"] = "dlc4/genesis/fx_margwa_spawn";
}

/*
	Name: function_1fb4e300
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xDECC5C06
	Offset: 0xB20
	Size: 0xFD
	Parameters: 7
	Flags: Private
*/
function private function_1fb4e300(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self util::waittill_dobj(localClientNum);
	switch(newVal)
	{
		case 1:
		{
			self function_fd0bfd3(localClientNum);
			break;
		}
		case 2:
		{
			self function_8a262a34(localClientNum);
			break;
		}
		case 3:
		{
			self function_78f9b77d(localClientNum);
			break;
		}
		case 4:
		{
			self function_ec63e97f(localClientNum);
			break;
		}
	}
}

/*
	Name: death_ray_shock_fx
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xF052BFF3
	Offset: 0xC28
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function death_ray_shock_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self stop_death_ray_shock_fx(localClientNum);
	if(newVal)
	{
		if(!isdefined(self.tesla_shock_fx))
		{
			tag = "J_SpineUpper";
			if(!self isai())
			{
				tag = "tag_origin";
			}
			self.tesla_shock_fx = PlayFXOnTag(localClientNum, level._effect["tesla_zombie_shock"], self, tag);
			self playsound(0, "zmb_electrocute_zombie");
		}
		if(IsDemoPlaying())
		{
			self thread function_7772592b(localClientNum);
		}
	}
}

/*
	Name: function_7772592b
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x3B93DCD7
	Offset: 0xD58
	Size: 0x4B
	Parameters: 1
	Flags: None
*/
function function_7772592b(localClientNum)
{
	self notify("stop_death_ray_shock_fx");
	self endon("stop_death_ray_shock_fx");
	level waittill("demo_jump");
	self stop_death_ray_shock_fx(localClientNum);
}

/*
	Name: stop_death_ray_shock_fx
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x32D3F892
	Offset: 0xDB0
	Size: 0x51
	Parameters: 1
	Flags: None
*/
function stop_death_ray_shock_fx(localClientNum)
{
	if(isdefined(self.tesla_shock_fx))
	{
		deletefx(localClientNum, self.tesla_shock_fx, 1);
		self.tesla_shock_fx = undefined;
	}
	self notify("stop_death_ray_shock_fx");
}

/*
	Name: function_fd0bfd3
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x123F4FC3
	Offset: 0xE10
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private function_fd0bfd3(localClientNum)
{
	self.margwa_roar_effect = level._effect["margwa_fire_roar"];
	self.margwa_spawn_effect = level._effect["margwa_fire_spawn"];
	self.margwa_head_hit_fx = level._effect["margwa_fire_head_hit"];
	self.margwa_play_spawn_effect = &function_740a099a;
}

/*
	Name: function_8a262a34
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x2D004102
	Offset: 0xE88
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private function_8a262a34(localClientNum)
{
	self.margwa_roar_effect = level._effect["margwa_electric_roar"];
	self.margwa_spawn_effect = level._effect["margwa_electric_spawn"];
}

/*
	Name: function_ec63e97f
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xAFE35AA0
	Offset: 0xED0
	Size: 0x6B
	Parameters: 1
	Flags: Private
*/
function private function_ec63e97f(localClientNum)
{
	self.margwa_roar_effect = level._effect["margwa_shadow_roar"];
	self.margwa_spawn_effect = level._effect["margwa_shadow_spawn"];
	self.margwa_head_hit_fx = level._effect["margwa_shadow_head_hit"];
	self.margwa_play_spawn_effect = &function_740a099a;
}

/*
	Name: function_78f9b77d
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x323CD0E
	Offset: 0xF48
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private function_78f9b77d(localClientNum)
{
	self.margwa_roar_effect = level._effect["margwa_light_roar"];
	self.margwa_spawn_effect = level._effect["margwa_light_spawn"];
}

/*
	Name: function_740a099a
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x2EB17811
	Offset: 0xF90
	Size: 0x33
	Parameters: 1
	Flags: Private
*/
function private function_740a099a(localClientNum)
{
	PlayFXOnTag(localClientNum, self.margwa_spawn_effect, self, "tag_origin");
}

/*
	Name: function_c46381fc
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x9A1BC5AB
	Offset: 0xFD0
	Size: 0x63
	Parameters: 7
	Flags: Private
*/
function private function_c46381fc(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	PlayFXOnTag(localClientNum, "dlc4/genesis/fx_margwa_attack_fire", self, "tag_origin");
}

/*
	Name: function_345693f6
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xF5A8F9A5
	Offset: 0x1040
	Size: 0x93
	Parameters: 7
	Flags: Private
*/
function private function_345693f6(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		playFX(localClientNum, level._effect["margwa_fire_defense_disappear"], self GetTagOrigin("j_spine_1"));
	}
}

/*
	Name: function_abb174cf
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xE4975A6
	Offset: 0x10E0
	Size: 0x2E3
	Parameters: 7
	Flags: Private
*/
function private function_abb174cf(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		PlayFXOnTag(localClientNum, level._effect["margwa_fire_defense_appear"], self, "tag_origin");
		self.var_aeae71fc = PlayFXOnTag(localClientNum, level._effect["margwa_fire_defense_fireball"], self, "tag_origin");
		self.var_dd81a0f6 = level._effect["margwa_fire_defense_appear"];
	}
	if(newVal == 2)
	{
		PlayFXOnTag(localClientNum, level._effect["margwa_fire_defense_appear"], self, "tag_origin");
		self.var_aeae71fc = PlayFXOnTag(localClientNum, level._effect["margwa_fire_defense_fireball"], self, "tag_origin");
		self.var_dd81a0f6 = level._effect["margwa_fire_defense_appear"];
	}
	if(newVal == 3)
	{
		PlayFXOnTag(localClientNum, level._effect["margwa_fire_defense_appear"], self, "tag_origin");
		self.var_aeae71fc = PlayFXOnTag(localClientNum, level._effect["margwa_fire_defense_fireball"], self, "tag_origin");
		self.var_dd81a0f6 = level._effect["margwa_fire_defense_appear"];
	}
	if(newVal == 4)
	{
		PlayFXOnTag(localClientNum, level._effect["margwa_shadow_defense_appear"], self, "tag_origin");
		self.var_aeae71fc = PlayFXOnTag(localClientNum, level._effect["margwa_shadow_defense_ball"], self, "tag_origin");
		self.var_dd81a0f6 = level._effect["margwa_shadow_defense_appear"];
	}
	if(newVal == 0 && isdefined(self.var_aeae71fc))
	{
		stopfx(localClientNum, self.var_aeae71fc);
		if(isdefined(self.var_dd81a0f6))
		{
			PlayFXOnTag(localClientNum, self.var_dd81a0f6, self, "tag_origin");
		}
	}
}

/*
	Name: shadow_margwa_attack_portal_fx
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x6AB63B7C
	Offset: 0x13D0
	Size: 0x293
	Parameters: 7
	Flags: Private
*/
function private shadow_margwa_attack_portal_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		vector = AnglesToForward(self.angles);
		portal_pos = self.origin + vector * 96 + VectorScale((0, 0, 1), 72);
		self.shadow_margwa_attack_portal_fx = playFX(localClientNum, level._effect["margwa_shadow_attack_portal_open"], portal_pos, vector);
		playsound(0, "zmb_margwa_shadow_portal_open", portal_pos);
		audio::playloopat("zmb_margwa_shadow_portal_lp", portal_pos);
		wait(0.45);
		if(isalive(self) && self clientfield::get("shadow_margwa_attack_portal_fx") == 1)
		{
			self.shadow_margwa_attack_portal_fx = playFX(localClientNum, level._effect["margwa_shadow_attack_portal_loop"], portal_pos, vector);
		}
	}
	if(newVal == 0 && isdefined(self.shadow_margwa_attack_portal_fx))
	{
		vector = AnglesToForward(self.angles);
		portal_pos = self.origin + vector * 96 + VectorScale((0, 0, 1), 72);
		if(isdefined(self.shadow_margwa_attack_portal_fx))
		{
			stopfx(localClientNum, self.shadow_margwa_attack_portal_fx);
		}
		playsound(0, "zmb_margwa_shadow_portal_close", portal_pos);
		audio::stoploopat("zmb_margwa_shadow_portal_lp", portal_pos);
		playFX(localClientNum, level._effect["margwa_shadow_attack_portal_close"], portal_pos, vector);
	}
}

/*
	Name: function_894980af
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xE59A765E
	Offset: 0x1670
	Size: 0x7B
	Parameters: 1
	Flags: None
*/
function function_894980af(localClientNum)
{
	self util::waittill_dobj(localClientNum);
	skull = self;
	if(isdefined(skull))
	{
		skull useanimtree(-1);
		skull SetAnim("ai_zm_dlc4_chomper_shadow_margwa_projectile");
	}
}

