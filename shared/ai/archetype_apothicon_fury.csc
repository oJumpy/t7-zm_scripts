#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace apothiconFuryBehavior;

/*
	Name: main
	Namespace: apothiconFuryBehavior
	Checksum: 0x9FC5252D
	Offset: 0x3F0
	Size: 0x261
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	ai::add_archetype_spawn_function("apothicon_fury", &apothiconSpawnSetup);
	if(ai::shouldRegisterClientFieldForArchetype("apothicon_fury"))
	{
		clientfield::register("actor", "fury_fire_damage", 15000, GetMinBitCountForNum(7), "counter", &apothiconFireDamageEffect, 0, 0);
		clientfield::register("actor", "furious_level", 15000, 1, "int", &apothiconFuriousModeEffect, 0, 0);
		clientfield::register("actor", "bamf_land", 15000, 1, "counter", &apothiconBamfLandEffect, 0, 0);
		clientfield::register("actor", "apothicon_fury_death", 15000, 2, "int", &apothiconFuryDeath, 0, 0);
		clientfield::register("actor", "juke_active", 15000, 1, "int", &apothiconJukeActive, 0, 0);
	}
	level._effect["dlc4/genesis/fx_apothicon_fury_impact"] = "dlc4/genesis/fx_apothicon_fury_impact";
	level._effect["dlc4/genesis/fx_apothicon_fury_breath"] = "dlc4/genesis/fx_apothicon_fury_breath";
	level._effect["dlc4/genesis/fx_apothicon_fury_teleport_impact"] = "dlc4/genesis/fx_apothicon_fury_teleport_impact";
	level._effect["dlc4/genesis/fx_apothicon_fury_smk_body"] = "dlc4/genesis/fx_apothicon_fury_smk_body";
	level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"] = "dlc4/genesis/fx_apothicon_fury_foot_amb";
	level._effect["dlc4/genesis/fx_apothicon_fury_death"] = "dlc4/genesis/fx_apothicon_fury_death";
}

/*
	Name: apothiconSpawnSetup
	Namespace: apothiconFuryBehavior
	Checksum: 0x2E26B10F
	Offset: 0x660
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function apothiconSpawnSetup(localClientNum)
{
	self thread apothiconSpawnShader(localClientNum);
	self apothiconStartLoopingEffects(localClientNum);
}

/*
	Name: apothiconStartLoopingEffects
	Namespace: apothiconFuryBehavior
	Checksum: 0xAE17E177
	Offset: 0x6A8
	Size: 0x191
	Parameters: 1
	Flags: None
*/
function apothiconStartLoopingEffects(localClientNum)
{
	self.loopingEffects = [];
	self.loopingEffects[0] = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_apothicon_fury_breath"], self, "j_head");
	self.loopingEffects[1] = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_apothicon_fury_smk_body"], self, "j_spine4");
	self.loopingEffects[2] = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"], self, "j_ball_le");
	self.loopingEffects[3] = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"], self, "j_ball_ri");
	self.loopingEffects[4] = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"], self, "j_wrist_le");
	self.loopingEffects[5] = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"], self, "j_wrist_ri");
}

/*
	Name: apothiconStopLoopingEffects
	Namespace: apothiconFuryBehavior
	Checksum: 0xEF114DAF
	Offset: 0x848
	Size: 0x99
	Parameters: 1
	Flags: None
*/
function apothiconStopLoopingEffects(localClientNum)
{
	foreach(FX in self.loopingEffects)
	{
		KillFX(localClientNum, FX);
	}
}

/*
	Name: apothiconSpawnShader
	Namespace: apothiconFuryBehavior
	Checksum: 0x29456767
	Offset: 0x8F0
	Size: 0x117
	Parameters: 1
	Flags: None
*/
function apothiconSpawnShader(localClientNum)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	s_timer = new_timer(localClientNum);
	n_phase_in = 1;
	do
	{
		util::server_wait(localClientNum, 0.11);
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = LerpFloat(0, 0.01, n_current_time / n_phase_in);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", n_delta_val);
	}
	while(!n_current_time < n_phase_in);
	s_timer notify("timer_done");
}

/*
	Name: apothiconJukeActive
	Namespace: apothiconFuryBehavior
	Checksum: 0x431D689
	Offset: 0xA10
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function apothiconJukeActive(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		playsound(0, "zmb_fury_bamf_teleport_in", self.origin);
		self apothiconStartLoopingEffects(localClientNum);
	}
	else
	{
		playsound(0, "zmb_fury_bamf_teleport_out", self.origin);
		self apothiconStopLoopingEffects(localClientNum);
	}
}

/*
	Name: apothiconFireDamageEffect
	Namespace: apothiconFuryBehavior
	Checksum: 0xF91D4DF8
	Offset: 0xB08
	Size: 0x2A7
	Parameters: 7
	Flags: None
*/
function apothiconFireDamageEffect(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	tag = undefined;
	if(newVal == 6)
	{
		tag = Array::random(Array("J_Hip_RI", "J_Knee_RI"));
	}
	if(newVal == 7)
	{
		tag = Array::random(Array("J_Hip_LE", "J_Knee_LE"));
	}
	else if(newVal == 4)
	{
		tag = Array::random(Array("J_Shoulder_RI", "J_Shoulder_RI_tr", "J_Elbow_RI"));
	}
	else if(newVal == 5)
	{
		tag = Array::random(Array("J_Shoulder_LE", "J_Shoulder_LE_tr", "J_Elbow_LE"));
	}
	else if(newVal == 3)
	{
		tag = Array::random(Array("J_MainRoot"));
	}
	else if(newVal == 2)
	{
		tag = Array::random(Array("J_SpineUpper", "J_Clavicle_RI", "J_Clavicle_LE"));
	}
	else
	{
		tag = Array::random(Array("J_Neck", "J_Head", "J_Helmet"));
	}
	FX = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_apothicon_fury_impact"], self, tag);
}

/*
	Name: apothiconFuryDeath
	Namespace: apothiconFuryBehavior
	Checksum: 0x613EEF8F
	Offset: 0xDB8
	Size: 0x2EB
	Parameters: 7
	Flags: None
*/
function apothiconFuryDeath(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal == 1)
	{
		s_timer = new_timer(localClientNum);
		n_phase_in = 1;
		self.removingFireShader = 1;
		do
		{
			util::server_wait(localClientNum, 0.11);
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = LerpFloat(1, 0.1, n_current_time / n_phase_in);
			self MapShaderConstant(localClientNum, 0, "scriptVector2", n_delta_val);
		}
		while(!n_current_time < n_phase_in);
		s_timer notify("timer_done");
		self.removingFireShader = 0;
	}
	else if(newVal == 2)
	{
		if(!isdefined(self))
		{
			return;
		}
		PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_apothicon_fury_death"], self, "j_spine4");
		self apothiconStopLoopingEffects(localClientNum);
		n_phase_in = 0.3;
		s_timer = new_timer(localClientNum);
		stopTime = GetTime() + n_phase_in * 1000;
		do
		{
			util::server_wait(localClientNum, 0.11);
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = LerpFloat(1, 0, n_current_time / n_phase_in);
			self MapShaderConstant(localClientNum, 0, "scriptVector0", n_delta_val);
		}
		while(!(n_current_time < n_phase_in && GetTime() <= stopTime));
		s_timer notify("timer_done");
		self MapShaderConstant(localClientNum, 0, "scriptVector0", 0);
	}
}

/*
	Name: apothiconFuriousModeEffect
	Namespace: apothiconFuryBehavior
	Checksum: 0xF6935C58
	Offset: 0x10B0
	Size: 0x14F
	Parameters: 7
	Flags: None
*/
function apothiconFuriousModeEffect(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		s_timer = new_timer(localClientNum);
		n_phase_in = 2;
		do
		{
			util::server_wait(localClientNum, 0.11);
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = LerpFloat(0.1, 1, n_current_time / n_phase_in);
			self MapShaderConstant(localClientNum, 0, "scriptVector2", n_delta_val);
		}
		while(!n_current_time < n_phase_in);
		s_timer notify("timer_done");
	}
}

/*
	Name: new_timer
	Namespace: apothiconFuryBehavior
	Checksum: 0x8B1CAEBD
	Offset: 0x1208
	Size: 0x57
	Parameters: 1
	Flags: None
*/
function new_timer(localClientNum)
{
	s_timer = spawnstruct();
	s_timer.n_time_current = 0;
	s_timer thread timer_increment_loop(localClientNum, self);
	return s_timer;
}

/*
	Name: timer_increment_loop
	Namespace: apothiconFuryBehavior
	Checksum: 0x36624892
	Offset: 0x1268
	Size: 0x67
	Parameters: 2
	Flags: None
*/
function timer_increment_loop(localClientNum, entity)
{
	entity endon("entityshutdown");
	self endon("timer_done");
	while(isdefined(self))
	{
		util::server_wait(localClientNum, 0.016);
		self.n_time_current = self.n_time_current + 0.016;
	}
}

/*
	Name: get_time
	Namespace: apothiconFuryBehavior
	Checksum: 0xD4B6B984
	Offset: 0x12D8
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function get_time()
{
	return self.n_time_current * 1000;
}

/*
	Name: get_time_in_seconds
	Namespace: apothiconFuryBehavior
	Checksum: 0x628F4955
	Offset: 0x12F0
	Size: 0x9
	Parameters: 0
	Flags: None
*/
function get_time_in_seconds()
{
	return self.n_time_current;
}

/*
	Name: reset_timer
	Namespace: apothiconFuryBehavior
	Checksum: 0x3194B06
	Offset: 0x1308
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function reset_timer()
{
	self.n_time_current = 0;
}

/*
	Name: apothiconBamfLandEffect
	Namespace: apothiconFuryBehavior
	Checksum: 0xEF3B58BE
	Offset: 0x1320
	Size: 0x11B
	Parameters: 7
	Flags: None
*/
function apothiconBamfLandEffect(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_apothicon_fury_teleport_impact"], self, "tag_origin");
	}
	player = GetLocalPlayer(localClientNum);
	player Earthquake(0.5, 1.4, self.origin, 375);
	PlayRumbleOnPosition(localClientNum, "apothicon_fury_land", self.origin);
}

