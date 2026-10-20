#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_traps;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_genesis_traps;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_traps
	Checksum: 0x7D27CFDF
	Offset: 0x5E0
	Size: 0x3B
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_traps", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_traps
	Checksum: 0xADFE041F
	Offset: 0x628
	Size: 0xF
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.b_trap_start_custom_vo = 1;
}

/*
	Name: __main__
	Namespace: zm_genesis_traps
	Checksum: 0x21259EF7
	Offset: 0x640
	Size: 0x83
	Parameters: 0
	Flags: None
*/
function __main__()
{
	level flag::wait_till("start_zombie_round_logic");
	precache_scripted_fx();
	a_t_traps = GetEntArray("t_flogger_trap", "targetname");
	Array::thread_all(a_t_traps, &function_835fd6d8);
}

/*
	Name: precache_scripted_fx
	Namespace: zm_genesis_traps
	Checksum: 0xA1D27A59
	Offset: 0x6D0
	Size: 0x71
	Parameters: 0
	Flags: None
*/
function precache_scripted_fx()
{
	level._effect["zapper"] = "dlc1/castle/fx_elec_trap_castle";
	level._effect["elec_md"] = "zombie/fx_elec_player_md_zmb";
	level._effect["elec_sm"] = "zombie/fx_elec_player_sm_zmb";
	level._effect["elec_torso"] = "zombie/fx_elec_player_torso_zmb";
}

/*
	Name: function_835fd6d8
	Namespace: zm_genesis_traps
	Checksum: 0x780BE34C
	Offset: 0x750
	Size: 0x2E3
	Parameters: 0
	Flags: None
*/
function function_835fd6d8()
{
	self flag::init("trap_active");
	self flag::init("trap_cooldown");
	self.zombie_cost = 1000;
	level.var_1183e023 = 0;
	self.a_e_switches = [];
	self.a_s_triggers = [];
	a_e_parts = GetEntArray(self.target, "targetname");
	for(i = 0; i < a_e_parts.size; i++)
	{
		if(isdefined(a_e_parts[i].script_noteworthy))
		{
			switch(a_e_parts[i].script_noteworthy)
			{
				case "pendulum":
				{
					self.e_pendulum = a_e_parts[i];
					self EnableLinkTo();
					self LinkTo(self.e_pendulum);
					break;
				}
				case "gears":
				{
					self.e_gears = a_e_parts[i];
					break;
				}
				case "switch":
				{
					self.a_e_switches[self.a_e_switches.size] = a_e_parts[i];
					break;
				}
			}
		}
	}
	a_s_parts = struct::get_array(self.target, "targetname");
	for(i = 0; i < a_s_parts.size; i++)
	{
		if(isdefined(a_s_parts[i].script_noteworthy))
		{
			switch(a_s_parts[i].script_noteworthy)
			{
				case "buy_trigger":
				{
					self.a_s_triggers[self.a_s_triggers.size] = a_s_parts[i];
					break;
				}
				case "motor_sound_left":
				{
					self.var_f1693315 = a_s_parts[i];
					break;
				}
				case "motor_sound_right":
				{
					self.var_736c69e7 = a_s_parts[i];
					break;
				}
			}
		}
	}
	self thread trap_move_switches();
	self TriggerEnable(0);
	Array::thread_all(self.a_s_triggers, &function_38d940ac, self);
}

/*
	Name: function_38d940ac
	Namespace: zm_genesis_traps
	Checksum: 0xCD3A2B81
	Offset: 0xA40
	Size: 0x20F
	Parameters: 1
	Flags: None
*/
function function_38d940ac(t_trap)
{
	s_unitrigger = self zm_unitrigger::create_unitrigger(&"ZOMBIE_NEED_POWER", 64, &function_dc9dafb8);
	s_unitrigger.require_look_at = 1;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_unitrigger, 1);
	s_unitrigger.t_trap = t_trap;
	s_unitrigger.script_int = t_trap.script_int;
	t_trap._trap_type = "flogger";
	while(1)
	{
		self waittill("trigger_activated", e_player);
		if(e_player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_player.IS_DRINKING > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_player))
		{
			continue;
		}
		if(e_player zm_score::can_player_purchase(1000))
		{
			e_player zm_score::minus_to_player_score(1000);
			t_trap thread function_157a698(self, e_player);
			t_trap.activated_by_player = e_player;
		}
		else
		{
			zm_utility::play_sound_at_pos("no_purchase", self.origin);
			if(isdefined(level.custom_generic_deny_vo_func))
			{
				e_player thread [[level.custom_generic_deny_vo_func]](1);
			}
			else
			{
				e_player zm_audio::create_and_play_dialog("general", "outofmoney");
			}
		}
	}
}

/*
	Name: function_dc9dafb8
	Namespace: zm_genesis_traps
	Checksum: 0xB65312AD
	Offset: 0xC58
	Size: 0x191
	Parameters: 1
	Flags: None
*/
function function_dc9dafb8(e_player)
{
	if(isdefined(e_player.zombie_vars["zombie_powerup_minigun_on"]) && e_player.zombie_vars["zombie_powerup_minigun_on"])
	{
		self setHintString(&"");
		return 0;
	}
	else if(isdefined(self.stub.script_int) && !level flag::get("power_on" + self.stub.script_int))
	{
		self setHintString(&"ZOMBIE_NEED_POWER");
		return 0;
	}
	else if(self.stub.t_trap flag::get("trap_active"))
	{
		self setHintString(&"ZOMBIE_TRAP_ACTIVE");
		return 0;
	}
	else if(self.stub.t_trap flag::get("trap_cooldown"))
	{
		self setHintString(&"ZOMBIE_TRAP_COOLDOWN");
		return 0;
	}
	else
	{
		self setHintString(&"ZOMBIE_BUTTON_BUY_TRAP", 1000);
		return 1;
	}
}

/*
	Name: trap_move_switches
	Namespace: zm_genesis_traps
	Checksum: 0x433DA91A
	Offset: 0xDF8
	Size: 0x277
	Parameters: 0
	Flags: None
*/
function trap_move_switches()
{
	for(i = 0; i < self.a_e_switches.size; i++)
	{
		self.a_e_switches[i] RotatePitch(-170, 0.5);
	}
	self.a_e_switches[0] waittill("rotatedone");
	if(isdefined(self.script_int) && !level flag::get("power_on" + self.script_int))
	{
		level flag::wait_till("power_on" + self.script_int);
	}
	self trap_lights_green();
	while(1)
	{
		self flag::wait_till("trap_active");
		self trap_lights_red();
		for(i = 0; i < self.a_e_switches.size; i++)
		{
			self.a_e_switches[i] RotatePitch(170, 0.5);
			self.a_e_switches[i] playsound("evt_switch_flip_trap");
		}
		self.a_e_switches[0] waittill("rotatedone");
		self flag::wait_till("trap_cooldown");
		for(i = 0; i < self.a_e_switches.size; i++)
		{
			self.a_e_switches[i] RotatePitch(-170, 0.5);
		}
		self.a_e_switches[0] waittill("rotatedone");
		self flag::wait_till_clear("trap_cooldown");
		self trap_lights_green();
	}
}

/*
	Name: trap_lights_red
	Namespace: zm_genesis_traps
	Checksum: 0x51CF7B6A
	Offset: 0x1078
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function trap_lights_red()
{
	if(isdefined(self.script_noteworthy))
	{
		exploder::exploder(self.script_noteworthy + "_red");
		exploder::stop_exploder(self.script_noteworthy + "_green");
	}
}

/*
	Name: trap_lights_green
	Namespace: zm_genesis_traps
	Checksum: 0xDE837D27
	Offset: 0x10E0
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function trap_lights_green()
{
	if(isdefined(self.script_noteworthy))
	{
		exploder::exploder(self.script_noteworthy + "_green");
		exploder::stop_exploder(self.script_noteworthy + "_red");
	}
}

/*
	Name: function_157a698
	Namespace: zm_genesis_traps
	Checksum: 0xB6286F6B
	Offset: 0x1148
	Size: 0x143
	Parameters: 2
	Flags: None
*/
function function_157a698(s_activate, e_player)
{
	self TriggerEnable(1);
	self flag::set("trap_active");
	playsoundatposition("zmb_flogger_motor_start_l", self.var_f1693315.origin);
	playsoundatposition("zmb_flogger_motor_start_r", self.var_736c69e7.origin);
	wait(0.5);
	self thread function_bb59d4d9(s_activate, e_player);
	self waittill("trap_done");
	self flag::clear("trap_active");
	self flag::set("trap_cooldown");
	self TriggerEnable(0);
	wait(45);
	self flag::clear("trap_cooldown");
}

/*
	Name: function_bb59d4d9
	Namespace: zm_genesis_traps
	Checksum: 0x7F61F5B2
	Offset: 0x1298
	Size: 0x219
	Parameters: 2
	Flags: None
*/
function function_bb59d4d9(s_activate, e_player)
{
	var_ffd9e7a0 = util::spawn_model("tag_origin", self.var_f1693315.origin);
	var_94be4c8f = util::spawn_model("tag_origin", self.var_736c69e7.origin);
	util::wait_network_frame();
	level notify("trap_activate", self);
	var_ffd9e7a0 PlayLoopSound("zmb_flogger_motor_lp_l");
	var_94be4c8f PlayLoopSound("zmb_flogger_motor_lp_r");
	self.e_pendulum notsolid();
	self thread function_1f2a0da5(s_activate, e_player);
	if(s_activate.script_string === "reverse")
	{
		n_rotations = -14040;
	}
	else
	{
		n_rotations = 14040;
	}
	self.e_gears RotatePitch(n_rotations, 30, 6, 6);
	self.e_pendulum RotatePitch(n_rotations, 30, 6, 6);
	level thread function_ec80dc42(self.e_pendulum);
	level thread function_e5b7e8b0(var_ffd9e7a0, var_94be4c8f);
	self.e_pendulum waittill("rotatedone");
	self.e_pendulum solid();
	self notify("trap_done");
}

/*
	Name: function_ec80dc42
	Namespace: zm_genesis_traps
	Checksum: 0x491C9211
	Offset: 0x14C0
	Size: 0x1BF
	Parameters: 1
	Flags: None
*/
function function_ec80dc42(e_pendulum)
{
	e_pendulum endon("rotatedone");
	var_feed8b5b = e_pendulum.angles[0];
	var_dea46db3 = e_pendulum.angles[0];
	firstTime = 1;
	while(1)
	{
		wait(0.05);
		var_feed8b5b = e_pendulum.angles[0];
		var_b6c309e9 = var_dea46db3 - var_feed8b5b;
		if(firstTime)
		{
			if(var_b6c309e9 >= 80)
			{
				e_pendulum playsound("zmb_flogger_blade_whoosh");
				firstTime = 0;
				var_dea46db3 = var_dea46db3 - 80;
			}
			else if(var_b6c309e9 <= -80)
			{
				e_pendulum playsound("zmb_flogger_blade_whoosh");
				firstTime = 0;
				var_dea46db3 = var_dea46db3 + 80;
			}
		}
		else if(var_b6c309e9 >= 180)
		{
			e_pendulum playsound("zmb_flogger_blade_whoosh");
			var_dea46db3 = var_dea46db3 - 180;
		}
		else if(var_b6c309e9 <= -180)
		{
			e_pendulum playsound("zmb_flogger_blade_whoosh");
			var_dea46db3 = var_dea46db3 + 180;
		}
	}
}

/*
	Name: function_e5b7e8b0
	Namespace: zm_genesis_traps
	Checksum: 0x13BC6868
	Offset: 0x1688
	Size: 0xC3
	Parameters: 2
	Flags: None
*/
function function_e5b7e8b0(var_ffd9e7a0, var_94be4c8f)
{
	wait(24);
	var_ffd9e7a0 StopLoopSound(4);
	var_ffd9e7a0 playsound("zmb_flogger_motor_stop_l");
	var_94be4c8f StopLoopSound(4);
	var_94be4c8f playsound("zmb_flogger_motor_stop_r");
	wait(5);
	var_ffd9e7a0 delete();
	var_94be4c8f delete();
}

/*
	Name: function_1f2a0da5
	Namespace: zm_genesis_traps
	Checksum: 0x862E9C00
	Offset: 0x1758
	Size: 0x8F
	Parameters: 2
	Flags: None
*/
function function_1f2a0da5(s_activate, e_player)
{
	self endon("trap_done");
	while(1)
	{
		self waittill("trigger", e_who);
		if(isPlayer(e_who))
		{
			e_who thread do_player_damage();
		}
		else
		{
			e_who thread function_af6b7901(s_activate, e_player);
		}
	}
}

/*
	Name: do_player_damage
	Namespace: zm_genesis_traps
	Checksum: 0x1DD40823
	Offset: 0x17F0
	Size: 0xFB
	Parameters: 0
	Flags: None
*/
function do_player_damage()
{
	self endon("death");
	self endon("disconnect");
	if(level.activePlayers.size == 1)
	{
		if(!(isdefined(self.b_no_trap_damage) && self.b_no_trap_damage))
		{
			self DoDamage(80, self.origin + VectorScale((0, 0, 1), 20));
		}
		self SetStance("crouch");
	}
	else if(!self laststand::player_is_in_laststand())
	{
		if(!(isdefined(self.b_no_trap_damage) && self.b_no_trap_damage))
		{
			self DoDamage(self.health + 100, self.origin + VectorScale((0, 0, 1), 20));
		}
	}
}

/*
	Name: function_af6b7901
	Namespace: zm_genesis_traps
	Checksum: 0x42CD2E1D
	Offset: 0x18F8
	Size: 0xBB
	Parameters: 2
	Flags: None
*/
function function_af6b7901(s_activate, e_player)
{
	self endon("death");
	if(self.archetype === "parasite")
	{
		self kill();
	}
	else if(self.archetype === "zombie")
	{
		level notify("flogger_killed_zombie", self, e_player);
		if(!isdefined(self.b_flung))
		{
			self thread do_launch(s_activate);
		}
	}
	if(isdefined(self.var_fbaea41d))
	{
		self thread [[self.var_fbaea41d]](e_player);
	}
}

/*
	Name: do_launch
	Namespace: zm_genesis_traps
	Checksum: 0x3AE67FD3
	Offset: 0x19C0
	Size: 0x1DB
	Parameters: 1
	Flags: None
*/
function do_launch(s_activate)
{
	self.b_flung = 1;
	self playsound("zmb_death_gibs");
	if(s_activate.script_string === "reverse")
	{
		x = randomIntRange(200, 250);
		y = randomIntRange(-35, 35);
		z = randomIntRange(95, 120);
	}
	else
	{
		x = randomIntRange(-250, -200);
		y = randomIntRange(-35, 35);
		z = randomIntRange(95, 120);
	}
	if(level.var_1183e023 > 8)
	{
		self do_zombie_explode();
		return;
	}
	self thread function_f5ad0ae6();
	self StartRagdoll();
	self LaunchRagdoll((x, y, z));
	util::wait_network_frame();
	self DoDamage(self.health, self.origin);
	level.zombie_total++;
}

/*
	Name: function_f5ad0ae6
	Namespace: zm_genesis_traps
	Checksum: 0xF22F1E3
	Offset: 0x1BA8
	Size: 0x1F
	Parameters: 0
	Flags: None
*/
function function_f5ad0ae6()
{
	level.var_1183e023++;
	self waittill("death");
	level.var_1183e023--;
}

/*
	Name: do_zombie_explode
	Namespace: zm_genesis_traps
	Checksum: 0xDC003B0F
	Offset: 0x1BD0
	Size: 0x93
	Parameters: 0
	Flags: Private
*/
function private do_zombie_explode()
{
	util::wait_network_frame();
	if(isdefined(self))
	{
		self zombie_utility::zombie_eye_glow_stop();
		self clientfield::increment("skull_turret_explode_fx");
		self ghost();
		self util::delay(0.25, undefined, &zm_utility::self_delete);
	}
}

