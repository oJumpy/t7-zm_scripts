#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_stalingrad_util;
#using scripts\zm\zm_stalingrad_vo;

#namespace namespace_b205ff9c;

/*
	Name: main
	Namespace: namespace_b205ff9c
	Checksum: 0xD62C8D92
	Offset: 0x3C0
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function main()
{
	level waittill("start_zombie_round_logic");
	level flag::init("finger_trap_on");
	level flag::init("finger_trap_cooldown");
	level function_7715178d();
}

/*
	Name: function_7715178d
	Namespace: namespace_b205ff9c
	Checksum: 0x5A7B180B
	Offset: 0x430
	Size: 0xB3
	Parameters: 0
	Flags: None
*/
function function_7715178d()
{
	level thread scene::init("p7_fxanim_zm_stal_finger_trap_bundle");
	level.var_79dbe0dd = [];
	scene::add_scene_func("p7_fxanim_zm_stal_finger_trap_bundle", &function_2d729696, "init");
	var_bbadd4a4 = struct::get_array("finger_trap_activate", "targetname");
	Array::thread_all(var_bbadd4a4, &function_eeb24547);
}

/*
	Name: function_2d729696
	Namespace: namespace_b205ff9c
	Checksum: 0x232797B3
	Offset: 0x4F0
	Size: 0x123
	Parameters: 1
	Flags: None
*/
function function_2d729696(a_ents)
{
	wait(1);
	t_left = GetEnt("finger_damage_trig_left", "targetname");
	t_right = GetEnt("finger_damage_trig_right", "targetname");
	level.var_79dbe0dd[0] = t_right;
	level.var_79dbe0dd[1] = t_left;
	t_left EnableLinkTo();
	t_right EnableLinkTo();
	t_left LinkTo(a_ents["trap_finger_left"], "tag_mid_animate");
	t_right LinkTo(a_ents["trap_finger_right"], "tag_mid_animate");
}

/*
	Name: function_eeb24547
	Namespace: namespace_b205ff9c
	Checksum: 0x7D967A72
	Offset: 0x620
	Size: 0x73
	Parameters: 0
	Flags: None
*/
function function_eeb24547()
{
	self zm_unitrigger::create_unitrigger("", 64, &function_512d92f4);
	self.s_unitrigger.hint_parm1 = 1500;
	self.s_unitrigger.require_look_at = 0;
	self thread function_891da2d8();
}

/*
	Name: function_512d92f4
	Namespace: namespace_b205ff9c
	Checksum: 0xF6D0E464
	Offset: 0x6A0
	Size: 0x14F
	Parameters: 1
	Flags: None
*/
function function_512d92f4(e_player)
{
	if(e_player.IS_DRINKING > 0)
	{
		self setHintString("");
		return 0;
	}
	else if(!level flag::get("power_on"))
	{
		self setHintString(&"ZOMBIE_NEED_POWER");
		return 0;
	}
	else if(level flag::get("finger_trap_on"))
	{
		self setHintString(&"ZOMBIE_TRAP_ACTIVE");
		return 0;
	}
	else if(level flag::get("finger_trap_cooldown"))
	{
		self setHintString(&"ZM_STALINGRAD_TRAP_COOLDOWN");
		return 0;
	}
	else
	{
		self setHintString(&"ZM_STALINGRAD_FINGER_TRAP", self.stub.hint_parm1);
	}
	return 1;
}

/*
	Name: function_891da2d8
	Namespace: namespace_b205ff9c
	Checksum: 0xB1DF054E
	Offset: 0x7F8
	Size: 0x1BF
	Parameters: 0
	Flags: None
*/
function function_891da2d8()
{
	while(1)
	{
		if(level flag::get("finger_trap_cooldown"))
		{
			level flag::wait_till_clear("finger_trap_cooldown");
		}
		self waittill("trigger_activated", e_who);
		if(!level flag::get("finger_trap_on") && !level flag::get("finger_trap_cooldown"))
		{
			if(!e_who zm_score::can_player_purchase(1500))
			{
				zm_utility::play_sound_at_pos("no_purchase", self.origin);
				e_who zm_audio::create_and_play_dialog("general", "outofmoney");
			}
			else
			{
				level flag::set("finger_trap_on");
				e_who clientfield::increment_to_player("interact_rumble");
				e_who notify("hash_ad9aba38");
				e_who zm_score::minus_to_player_score(1500);
				self namespace_48c05c81::function_903f6b36(1);
				level function_ec450f14(e_who);
				self namespace_48c05c81::function_903f6b36(0);
			}
		}
	}
}

/*
	Name: function_ec450f14
	Namespace: namespace_b205ff9c
	Checksum: 0xE368B4F4
	Offset: 0x9C0
	Size: 0x13B
	Parameters: 1
	Flags: None
*/
function function_ec450f14(var_3778532a)
{
	var_3778532a thread namespace_dcf9c464::function_c0914f1b();
	Array::run_all(level.var_79dbe0dd, &TriggerEnable, 1);
	Array::thread_all(level.var_79dbe0dd, &function_f5af37c6, var_3778532a);
	level function_88a65f39();
	Array::run_all(level.var_79dbe0dd, &TriggerEnable, 0);
	level flag::clear("finger_trap_on");
	level flag::set("finger_trap_cooldown");
	/#
		level endon("hash_f8b849b9");
	#/
	wait(90);
	level flag::clear("finger_trap_cooldown");
}

/*
	Name: function_88a65f39
	Namespace: namespace_b205ff9c
	Checksum: 0x749C5D48
	Offset: 0xB08
	Size: 0x6B
	Parameters: 0
	Flags: None
*/
function function_88a65f39()
{
	n_start_time = GetTime();
	for(n_total_time = 0; n_total_time < 15;  = 0)
	{
		level scene::Play("p7_fxanim_zm_stal_finger_trap_bundle");
	}
}

/*
	Name: function_f5af37c6
	Namespace: namespace_b205ff9c
	Checksum: 0x93EA2543
	Offset: 0xB80
	Size: 0x1AF
	Parameters: 1
	Flags: None
*/
function function_f5af37c6(var_3778532a)
{
	level endon("hash_46e86024");
	while(1)
	{
		self waittill("trigger", e_who);
		if(!(isdefined(e_who.var_bd3a4420) && e_who.var_bd3a4420))
		{
			if(e_who.health <= 20000)
			{
				if(!isPlayer(e_who) && isdefined(var_3778532a))
				{
					var_3778532a notify("hash_2637f64f");
					var_3778532a zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_TRAP");
				}
				if(e_who.archetype === "zombie")
				{
					e_who thread zombie_utility::zombie_gut_explosion();
				}
			}
			else if(!isPlayer(e_who))
			{
				e_who.var_bd3a4420 = 1;
				e_who thread function_fe885d6b();
			}
			if(isPlayer(e_who) && e_who IsSliding())
			{
				continue;
			}
			e_who DoDamage(20000, e_who.origin, self, undefined, "none", "MOD_IMPACT");
		}
	}
}

/*
	Name: function_fe885d6b
	Namespace: namespace_b205ff9c
	Checksum: 0x19714132
	Offset: 0xD38
	Size: 0x21
	Parameters: 0
	Flags: None
*/
function function_fe885d6b()
{
	self endon("death");
	wait(0.25);
	self.var_bd3a4420 = undefined;
}

/*
	Name: function_ddb9991b
	Namespace: namespace_b205ff9c
	Checksum: 0x4F86FD8A
	Offset: 0xD68
	Size: 0x93
	Parameters: 0
	Flags: None
*/
function function_ddb9991b()
{
	/#
		if(!level flag::get("Dev Block strings are not supported"))
		{
			level flag::set("Dev Block strings are not supported");
			level flag::clear("Dev Block strings are not supported");
			level notify("hash_f8b849b9");
			level function_ec450f14(level.players[0]);
		}
	#/
}

/*
	Name: function_fc99caf5
	Namespace: namespace_b205ff9c
	Checksum: 0xA66C5527
	Offset: 0xE08
	Size: 0x51
	Parameters: 0
	Flags: None
*/
function function_fc99caf5()
{
	/#
		if(level flag::get("Dev Block strings are not supported"))
		{
			level flag::clear("Dev Block strings are not supported");
			level notify("hash_f8b849b9");
		}
	#/
}

