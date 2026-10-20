#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace keepercompanionbehavior;

/*
	Name: main
	Namespace: keepercompanionbehavior
	Checksum: 0xD76E2ED8
	Offset: 0x4E0
	Size: 0x3AD
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	ai::add_archetype_spawn_function("keeper_companion", &function_bfd27b96);
	clientfield::register("allplayers", "being_keeper_revived", 15000, 1, "int", &function_802744a7, 0, 0);
	clientfield::register("actor", "keeper_reviving", 15000, 1, "int", &function_a9b854ea, 0, 0);
	clientfield::register("actor", "kc_effects", 15000, 1, "int", &keeper_fx, 0, 0);
	clientfield::register("world", "kc_callbox_lights", 15000, 2, "int", &function_b945954d, 0, 0);
	clientfield::register("actor", "keeper_ai_death_effect", 15000, 1, "int", &function_2935ac4d, 0, 0);
	clientfield::register("vehicle", "keeper_ai_death_effect", 15000, 1, "int", &function_2935ac4d, 0, 0);
	clientfield::register("scriptmover", "keeper_ai_spawn_tell", 15000, 1, "int", &function_fa8bf98f, 0, 0);
	clientfield::register("actor", "keeper_thunderwall", 15000, 1, "counter", &keeper_thunderwall, 0, 0);
	clientfield::register("scriptmover", "keeper_thunderwall_360", 15000, 1, "counter", &keeper_thunderwall_360, 0, 0);
	level._effect["dlc4/genesis/fx_keeperprot_revive_kp"] = "dlc4/genesis/fx_keeperprot_revive_kp";
	level._effect["dlc4/genesis/fx_keeperprot_revive_player"] = "dlc4/genesis/fx_keeperprot_revive_player";
	level._effect["dlc4/genesis/fx_keeperprot_underlit_amb"] = "dlc4/genesis/fx_keeperprot_underlit_amb";
	level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit"] = "dlc4/genesis/fx_keeperprot_cone_attack_hit";
	level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit_trails"] = "dlc4/genesis/fx_keeperprot_cone_attack_hit_trails";
	level._effect["dlc4/genesis/fx_keeperprot_spawn_tell"] = "dlc4/genesis/fx_keeperprot_spawn_tell";
	level._effect["dlc4/genesis/fx_keeperprot_energy_ball"] = "dlc4/genesis/fx_keeperprot_energy_ball";
	level._effect["dlc4/genesis/fx_keeperprot_cone_attack"] = "dlc4/genesis/fx_keeperprot_cone_attack";
	level._effect["dlc4/genesis/fx_keeperprot_360_attack"] = "dlc4/genesis/fx_keeperprot_360_attack";
}

/*
	Name: function_b945954d
	Namespace: keepercompanionbehavior
	Checksum: 0x6C98C685
	Offset: 0x898
	Size: 0x1A5
	Parameters: 7
	Flags: None
*/
function function_b945954d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	switch(newVal)
	{
		case 1:
		{
			exploder::exploder("lgt_companion_callbox_green");
			exploder::stop_exploder("lgt_companion_callbox_red");
			exploder::stop_exploder("lgt_companion_callbox_yellow");
			break;
		}
		case 2:
		{
			exploder::stop_exploder("lgt_companion_callbox_green");
			exploder::exploder("lgt_companion_callbox_red");
			exploder::stop_exploder("lgt_companion_callbox_yellow");
			break;
		}
		case 3:
		{
			exploder::stop_exploder("lgt_companion_callbox_green");
			exploder::stop_exploder("lgt_companion_callbox_red");
			exploder::exploder("lgt_companion_callbox_yellow");
			break;
		}
		case default:
		{
			exploder::stop_exploder("lgt_companion_callbox_green");
			exploder::stop_exploder("lgt_companion_callbox_red");
			exploder::stop_exploder("lgt_companion_callbox_yellow");
			break;
		}
	}
}

/*
	Name: function_bfd27b96
	Namespace: keepercompanionbehavior
	Checksum: 0x1C8E9184
	Offset: 0xA48
	Size: 0x23
	Parameters: 1
	Flags: None
*/
function function_bfd27b96(localClientNum)
{
	self thread function_8aaa4093(localClientNum);
}

/*
	Name: function_8aaa4093
	Namespace: keepercompanionbehavior
	Checksum: 0x57F357C
	Offset: 0xA78
	Size: 0x12F
	Parameters: 1
	Flags: None
*/
function function_8aaa4093(localClientNum)
{
	self endon("entityshutdown");
	self notify("hash_6f5d947d");
	self endon("hash_6f5d947d");
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
		n_delta_val = LerpFloat(0, 1, n_current_time / n_phase_in);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", n_delta_val);
	}
	while(!n_current_time < n_phase_in);
	s_timer notify("timer_done");
}

/*
	Name: function_55296393
	Namespace: keepercompanionbehavior
	Checksum: 0x6CA10925
	Offset: 0xBB0
	Size: 0x12F
	Parameters: 1
	Flags: None
*/
function function_55296393(localClientNum)
{
	self endon("entityshutdown");
	self notify("hash_6f5d947d");
	self endon("hash_6f5d947d");
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
		n_delta_val = LerpFloat(1, 0, n_current_time / n_phase_in);
		self MapShaderConstant(localClientNum, 0, "scriptVector2", n_delta_val);
	}
	while(!n_current_time < n_phase_in);
	s_timer notify("timer_done");
}

/*
	Name: keeper_fx
	Namespace: keepercompanionbehavior
	Checksum: 0x9301D8A
	Offset: 0xCE8
	Size: 0x183
	Parameters: 7
	Flags: None
*/
function keeper_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal === 1)
	{
		self.var_2afcd501 = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_underlit_amb"], self, "tag_origin");
		self.var_2a264f57 = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_energy_ball"], self, "tag_weapon_right");
		self.sndlooper = self PlayLoopSound("zmb_keeper_looper");
	}
	else if(isdefined(self.var_2afcd501))
	{
		deletefx(localClientNum, self.var_2afcd501, 1);
		self.var_2afcd501 = undefined;
	}
	if(isdefined(self.var_2a264f57))
	{
		deletefx(localClientNum, self.var_2a264f57, 1);
		self.var_2a264f57 = undefined;
	}
	self StopAllLoopSounds(1);
	self thread function_55296393(localClientNum);
}

/*
	Name: function_a9b854ea
	Namespace: keepercompanionbehavior
	Checksum: 0xA2BF5CE5
	Offset: 0xE78
	Size: 0xE3
	Parameters: 7
	Flags: Private
*/
function private function_a9b854ea(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_a9b854ea) && oldVal == 1 && newVal == 0)
	{
		stopfx(localClientNum, self.var_a9b854ea);
	}
	if(newVal === 1)
	{
		self.var_a9b854ea = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_revive_kp"], self, "tag_weapon_right");
		self playsound(0, "zmb_keeperprot_revive");
	}
}

/*
	Name: function_802744a7
	Namespace: keepercompanionbehavior
	Checksum: 0x2D7E6419
	Offset: 0xF68
	Size: 0xDB
	Parameters: 7
	Flags: Private
*/
function private function_802744a7(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.var_b4d5098) && oldVal == 1 && newVal == 0)
	{
		stopfx(localClientNum, self.var_b4d5098);
	}
	if(newVal === 1)
	{
		self playsound(0, "zmb_keeperprot_revive_player");
		self.var_b4d5098 = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_revive_player"], self, "j_spineupper");
	}
}

/*
	Name: keeper_thunderwall
	Namespace: keepercompanionbehavior
	Checksum: 0x1F6F1FEC
	Offset: 0x1050
	Size: 0xA7
	Parameters: 7
	Flags: None
*/
function keeper_thunderwall(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		FX = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack"], self, "tag_weapon_right");
	}
}

/*
	Name: keeper_thunderwall_360
	Namespace: keepercompanionbehavior
	Checksum: 0xD6ACDE6E
	Offset: 0x1100
	Size: 0x97
	Parameters: 7
	Flags: None
*/
function keeper_thunderwall_360(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		FX = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_360_attack"], self, "tag_origin");
	}
}

/*
	Name: function_2935ac4d
	Namespace: keepercompanionbehavior
	Checksum: 0x4F612082
	Offset: 0x11A0
	Size: 0x1E7
	Parameters: 7
	Flags: None
*/
function function_2935ac4d(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	self util::waittill_dobj(localClientNum);
	if(!isdefined(self))
	{
		return;
	}
	tag = "J_SpineUpper";
	if(self.type == "vehicle" || self.type == "helicopter" || self.type == "plane")
	{
		tag = "tag_origin";
	}
	if(newVal)
	{
		FX = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit"], self, tag);
		if(self.type != "vehicle" && self.type != "helicopter" && self.type != "plane")
		{
			FX = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit_trails"], self, "J_Wrist_LE");
			FX = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit_trails"], self, "J_Wrist_RI");
		}
		else
		{
			FX = PlayFXOnTag(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit_trails"], self, tag);
		}
	}
}

/*
	Name: function_fa8bf98f
	Namespace: keepercompanionbehavior
	Checksum: 0xC4747BBF
	Offset: 0x1390
	Size: 0xEB
	Parameters: 7
	Flags: None
*/
function function_fa8bf98f(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	self endon("entityshutdown");
	if(!isdefined(self))
	{
		return;
	}
	if(newVal)
	{
		self.var_7b3e5077 = playFX(localClientNum, level._effect["dlc4/genesis/fx_keeperprot_spawn_tell"], self.origin);
		playsound(0, "zmb_keeperprot_spawn_tell", self.origin);
	}
	else if(isdefined(self.var_7b3e5077))
	{
		stopfx(localClientNum, self.var_7b3e5077);
	}
}

/*
	Name: new_timer
	Namespace: keepercompanionbehavior
	Checksum: 0x71DEF7AB
	Offset: 0x1488
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
	Namespace: keepercompanionbehavior
	Checksum: 0xC0822774
	Offset: 0x14E8
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
	Namespace: keepercompanionbehavior
	Checksum: 0x9FFCD470
	Offset: 0x1558
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
	Namespace: keepercompanionbehavior
	Checksum: 0xA2707C0E
	Offset: 0x1570
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
	Namespace: keepercompanionbehavior
	Checksum: 0x76DD02BB
	Offset: 0x1588
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function reset_timer()
{
	self.n_time_current = 0;
}

