#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_traps;
#using scripts\zm\zm_cosmodrome_amb;

#namespace namespace_860ef124;

/*
	Name: init_traps
	Namespace: namespace_860ef124
	Checksum: 0xCDDB22DB
	Offset: 0x480
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function init_traps()
{
	level thread function_86339996();
	level thread centrifuge_init();
	level thread function_395fdbce();
}

/*
	Name: function_b16a68c0
	Namespace: namespace_860ef124
	Checksum: 0x5DEFFD6B
	Offset: 0x4D8
	Size: 0x8D
	Parameters: 2
	Flags: None
*/
function function_b16a68c0(arm, var_916d086e)
{
	claws = GetEntArray(var_916d086e, "targetname");
	for(i = 0; i < claws.size; i++)
	{
		claws[i] LinkTo(arm);
	}
}

/*
	Name: function_3b7290e2
	Namespace: namespace_860ef124
	Checksum: 0x8C47CCED
	Offset: 0x570
	Size: 0x85
	Parameters: 2
	Flags: None
*/
function function_3b7290e2(arm, var_916d086e)
{
	claws = GetEntArray(var_916d086e, "targetname");
	for(i = 0; i < claws.size; i++)
	{
		claws[i] Unlink();
	}
}

/*
	Name: function_86339996
	Namespace: namespace_860ef124
	Checksum: 0x620CADDF
	Offset: 0x600
	Size: 0x4C3
	Parameters: 0
	Flags: None
*/
function function_86339996()
{
	level flag::wait_till("start_zombie_round_logic");
	wait(1);
	var_1c8831d1 = struct::get("claw_l_retract", "targetname");
	var_30aae38f = struct::get("claw_r_retract", "targetname");
	var_3d6a412c = struct::get("claw_l_extend", "targetname");
	var_21791fa2 = struct::get("claw_r_extend", "targetname");
	level.var_eebefbf0 = var_1c8831d1.origin;
	level.var_c234410e = var_30aae38f.origin;
	level.var_ab813bf9 = var_3d6a412c.origin;
	level.var_56499fb7 = var_21791fa2.origin;
	level.var_82af40b9 = GetEnt("claw_arm_l", "targetname");
	level.var_36aa4be7 = GetEnt("claw_arm_r", "targetname");
	level.claw_arm_l = GetEnt("claw_l_arm", "targetname");
	function_b16a68c0(level.claw_arm_l, "claw_l");
	level.claw_arm_r = GetEnt("claw_r_arm", "targetname");
	function_b16a68c0(level.claw_arm_r, "claw_r");
	level.rocket = GetEnt("zombie_rocket", "targetname");
	var_547ac401 = GetEntArray(level.rocket.target, "targetname");
	for(i = 0; i < var_547ac401.size; i++)
	{
		var_547ac401[i] SetForceNoCull();
		var_547ac401[i] LinkTo(level.rocket);
	}
	level.var_ee72aac2 = GetEnt("lifter_body", "targetname");
	var_326829bb = GetEntArray(level.var_ee72aac2.target, "targetname");
	for(i = 0; i < var_326829bb.size; i++)
	{
		var_326829bb[i] LinkTo(level.var_ee72aac2);
	}
	level.var_3bc3f8d1 = GetEnt("lifter_arm", "targetname");
	level.var_413d861 = GetEntArray("lifter_clamp", "targetname");
	for(i = 0; i < level.var_413d861.size; i++)
	{
		level.var_413d861[i] LinkTo(level.var_3bc3f8d1);
	}
	level.rocket LinkTo(level.var_3bc3f8d1);
	level.var_3bc3f8d1 LinkTo(level.var_ee72aac2);
	level.var_be9553f1 = GetEnt("rocket_debris", "script_noteworthy");
	level.var_be9553f1 Hide();
	level thread function_6588791f();
}

/*
	Name: function_6588791f
	Namespace: namespace_860ef124
	Checksum: 0xFC356A73
	Offset: 0xAD0
	Size: 0x243
	Parameters: 0
	Flags: None
*/
function function_6588791f()
{
	start_spot = struct::get("rail_start_spot", "targetname");
	var_15ebca1f = struct::get("rail_dock_spot", "targetname");
	level.claw_arm_r moveto(level.var_c234410e, 0.05);
	level.claw_arm_l moveto(level.var_eebefbf0, 0.05);
	level.var_ee72aac2 moveto(start_spot.origin, 0.05);
	level.var_ee72aac2 waittill("movedone");
	level.var_3bc3f8d1 Unlink();
	level.var_3bc3f8d1 RotateTo(VectorScale((1, 0, 0), 13), 0.05);
	level.var_3bc3f8d1 waittill("rotatedone");
	function_b5bedb73();
	level waittill("power_on");
	wait(5);
	function_3015c292();
	level.var_3bc3f8d1 LinkTo(level.var_ee72aac2);
	level.var_ee72aac2 moveto(var_15ebca1f.origin, 10, 3, 3);
	level.var_ee72aac2 playsound("evt_rocket_roll");
	level.var_ee72aac2 waittill("movedone");
	level.var_3bc3f8d1 Unlink();
	function_7ce1fc24();
	function_b5bedb73();
}

/*
	Name: function_7ce1fc24
	Namespace: namespace_860ef124
	Checksum: 0x535BBD8
	Offset: 0xD20
	Size: 0x121
	Parameters: 0
	Flags: None
*/
function function_7ce1fc24()
{
	level thread function_d1419acd();
	level.var_3bc3f8d1 RotateTo(VectorScale((1, 0, 0), 90), 15, 3, 5);
	wait(16);
	level.rocket Unlink();
	level.rocket MoveZ(-20, 3);
	level.claw_arm_r playsound("evt_rocket_claw_arm");
	level.claw_arm_r moveto(level.var_56499fb7, 3);
	level.claw_arm_l moveto(level.var_ab813bf9, 3);
	level thread namespace_9dd378ec::play_cosmo_announcer_vox("vox_ann_rocket_anim");
	wait(3);
}

/*
	Name: function_eee1cbd0
	Namespace: namespace_860ef124
	Checksum: 0xCD16D319
	Offset: 0xE50
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function function_eee1cbd0()
{
	start_spot = struct::get("rail_start_spot", "targetname");
	level.var_3bc3f8d1 LinkTo(level.var_ee72aac2);
	offset = level.var_3bc3f8d1.origin - level.var_ee72aac2.origin;
	level.var_3bc3f8d1 Unlink();
	level.var_3bc3f8d1 RotateTo((0, 0, 0), 15);
	level.var_3bc3f8d1 moveto(start_spot.origin + offset, 15, 3, 3);
	level.var_ee72aac2 moveto(start_spot.origin, 15, 3, 3);
	wait(15);
	function_3b7290e2(level.claw_arm_l, "claw_l");
	function_3b7290e2(level.claw_arm_r, "claw_r");
}

/*
	Name: centrifuge_init
	Namespace: namespace_860ef124
	Checksum: 0x94096748
	Offset: 0xFC8
	Size: 0x24B
	Parameters: 0
	Flags: None
*/
function centrifuge_init()
{
	var_3ad29684 = GetEnt("trigger_centrifuge_damage", "targetname");
	var_abde0fe3 = GetEnt("rotating_trap_group1", "targetname");
	var_3ad29684 EnableLinkTo();
	var_3ad29684 LinkTo(var_abde0fe3);
	var_6c0c6027 = GetEnt("rotating_trap_collision", "targetname");
	/#
		/#
			Assert(isdefined(var_6c0c6027.target), "Dev Block strings are not supported");
		#/
	#/
	var_6c0c6027 LinkTo(GetEnt(var_6c0c6027.target, "targetname"));
	var_8aa1e590 = GetEntArray("origin_centrifuge_spinning_sound", "targetname");
	Array::thread_all(var_8aa1e590, &function_e0b3d0ff);
	level flag::wait_till("start_zombie_round_logic");
	var_abde0fe3 clientfield::set("COSMO_CENTRIFUGE_LIGHTS", 1);
	wait(4);
	var_abde0fe3 RotateYaw(720, 10, 0, 4.5);
	var_abde0fe3 waittill("rotatedone");
	var_abde0fe3 playsound("zmb_cent_end");
	var_abde0fe3 clientfield::set("COSMO_CENTRIFUGE_LIGHTS", 0);
	level thread function_6226d8bf();
}

/*
	Name: function_40732131
	Namespace: namespace_860ef124
	Checksum: 0xEB963764
	Offset: 0x1220
	Size: 0x449
	Parameters: 0
	Flags: None
*/
function function_40732131()
{
	self._trap_duration = 30;
	self._trap_cooldown_time = 60;
	/#
		if(GetDvarInt("Dev Block strings are not supported") >= 1)
		{
			self._trap_cooldown_time = 5;
		}
	#/
	centrifuge = self._trap_movers[0];
	old_angles = centrifuge.angles;
	self thread zm_traps::trig_update(centrifuge);
	for(i = 0; i < self._trap_movers.size; i++)
	{
		self._trap_movers[i] RotateYaw(360, 5, 4.5);
	}
	wait(2);
	self thread function_ff0615a5();
	wait(3);
	self PlayLoopSound("zmb_cent_mach_loop", 0.6);
	step = 3;
	for(t = 0; t < self._trap_duration;  = 0)
	{
		for(i = 0; i < self._trap_movers.size; i++)
		{
			self._trap_movers[i] RotateYaw(360, step);
		}
		wait(step);
	}
	end_angle = RandomInt(360);
	curr_angle = Int(centrifuge.angles[1]) % 360;
	if(end_angle < curr_angle)
	{
		end_angle = end_angle + 360;
	}
	degrees = end_angle - curr_angle;
	if(degrees > 0)
	{
		time = degrees / 360 * step;
		for(i = 0; i < self._trap_movers.size; i++)
		{
			self._trap_movers[i] RotateYaw(degrees, time);
		}
		wait(time);
	}
	self StopLoopSound(2);
	self playsound("zmb_cent_end");
	for(i = 0; i < self._trap_movers.size; i++)
	{
		self._trap_movers[i] RotateYaw(360, 5, 0, 4);
	}
	wait(5);
	self notify("trap_done", t + step);
	for(i = 0; i < self._trap_movers.size; i++)
	{
		self._trap_movers[i] RotateTo((0, end_angle % 360, 0), 1, 0, 0.9);
	}
	wait(1);
	self playsound("zmb_cent_lockdown");
	self notify("hash_6bde7592");
}

/*
	Name: function_6226d8bf
	Namespace: namespace_860ef124
	Checksum: 0xADE46C63
	Offset: 0x1678
	Size: 0x2B7
	Parameters: 0
	Flags: None
*/
function function_6226d8bf()
{
	var_11a40c45 = GetEnt("rotating_trap_group1", "targetname");
	var_c0ae568c = GetEnt("trigger_centrifuge_damage", "targetname");
	var_bd94ed95 = var_11a40c45.angles;
	while(1)
	{
		if(!isdefined(level.var_6708aa9c) || !level.var_6708aa9c)
		{
			var_b281129c = RandomInt(10);
			if(var_b281129c > 6)
			{
				level waittill("between_round_over");
			}
			else if(var_b281129c == 1)
			{
				level waittill("between_round_over");
				level waittill("between_round_over");
			}
			wait(randomIntRange(24, 90));
		}
		var_e14a0d12 = randomIntRange(3, 7) * 360;
		wait_time = randomIntRange(4, 7);
		level function_1e54c003(var_11a40c45);
		var_11a40c45 clientfield::set("COSMO_CENTRIFUGE_RUMBLE", 1);
		var_11a40c45 RotateYaw(var_e14a0d12, wait_time, 1, 2);
		var_c0ae568c thread function_ff0615a5();
		wait(3);
		var_11a40c45 StopLoopSound(4);
		var_11a40c45 playsound("zmb_cent_end");
		var_11a40c45 waittill("rotatedone");
		var_c0ae568c notify("trap_done");
		var_11a40c45 playsound("zmb_cent_lockdown");
		var_11a40c45 clientfield::set("COSMO_CENTRIFUGE_LIGHTS", 0);
		var_11a40c45 clientfield::set("COSMO_CENTRIFUGE_RUMBLE", 0);
	}
}

/*
	Name: function_1e54c003
	Namespace: namespace_860ef124
	Checksum: 0xADE3F95C
	Offset: 0x1938
	Size: 0xCB
	Parameters: 1
	Flags: None
*/
function function_1e54c003(var_20fc8f3f)
{
	var_20fc8f3f clientfield::set("COSMO_CENTRIFUGE_LIGHTS", 1);
	var_20fc8f3f playsound("zmb_cent_alarm");
	var_20fc8f3f playsound("vox_ann_centrifuge_spins_1");
	wait(1);
	var_20fc8f3f playsound("zmb_cent_start");
	wait(2);
	var_20fc8f3f PlayLoopSound("zmb_cent_mach_loop", 0.6);
	wait(1);
}

/*
	Name: function_ff0615a5
	Namespace: namespace_860ef124
	Checksum: 0xDA43A2EF
	Offset: 0x1A10
	Size: 0x1F7
	Parameters: 0
	Flags: None
*/
function function_ff0615a5()
{
	self endon("trap_done");
	self._trap_type = self.script_noteworthy;
	players = GetPlayers();
	while(1)
	{
		self waittill("trigger", ent);
		if(isPlayer(ent) && ent.health > 1)
		{
			if(ent GetStance() == "stand")
			{
				if(players.size == 1)
				{
					ent DoDamage(50, ent.origin + VectorScale((0, 0, 1), 20));
					ent SetStance("crouch");
					wait(1);
				}
				else
				{
					ent DoDamage(125, ent.origin + VectorScale((0, 0, 1), 20));
					ent SetStance("crouch");
				}
			}
		}
		else if(!isdefined(ent.marked_for_death))
		{
			ent.marked_for_death = 1;
			ent thread zm_traps::zombie_trap_death(self, RandomInt(100));
			ent playsound("zmb_cent_zombie_gib");
		}
	}
}

/*
	Name: function_e0b3d0ff
	Namespace: namespace_860ef124
	Checksum: 0x47535B22
	Offset: 0x1C10
	Size: 0x107
	Parameters: 0
	Flags: None
*/
function function_e0b3d0ff()
{
	/#
		/#
			Assert(isdefined(self.target), "Dev Block strings are not supported");
		#/
	#/
	if(!isdefined(self.target))
	{
		return;
	}
	self LinkTo(GetEnt(self.target, "targetname"));
	while(1)
	{
		level flag::wait_till("fuge_spining");
		self PlayLoopSound("zmb_cent_close_loop", 0.5);
		level flag::wait_till("fuge_slowdown");
		self StopLoopSound(2);
		wait(0.05);
	}
}

/*
	Name: function_d1419acd
	Namespace: namespace_860ef124
	Checksum: 0x7AF65900
	Offset: 0x1D20
	Size: 0x4B
	Parameters: 0
	Flags: None
*/
function function_d1419acd()
{
	level.var_ee72aac2 playsound("evt_rocket_set_main");
	wait(13.8);
	level.var_ee72aac2 playsound("evt_rocket_set_impact");
}

/*
	Name: function_395fdbce
	Namespace: namespace_860ef124
	Checksum: 0x28EDBF12
	Offset: 0x1D78
	Size: 0x18B
	Parameters: 0
	Flags: None
*/
function function_395fdbce()
{
	level flag::init("base_door_opened");
	var_d8468821 = undefined;
	traps = GetEntArray("zombie_trap", "targetname");
	for(i = 0; i < traps.size; i++)
	{
		if(isdefined(traps[i].script_string) && traps[i].script_string == "f2")
		{
			var_d8468821 = traps[i];
			var_d8468821 zm_traps::trap_set_string(&"ZOMBIE_NEED_POWER");
		}
	}
	level flag::wait_till("power_on");
	if(!level flag::get("base_entry_2_north_path"))
	{
		var_d8468821 zm_traps::trap_set_string(&"ZM_COSMODROME_DOOR_CLOSED");
	}
	level flag::wait_till("base_entry_2_north_path");
	level flag::set("base_door_opened");
}

/*
	Name: function_b5bedb73
	Namespace: namespace_860ef124
	Checksum: 0x9E920B2A
	Offset: 0x1F10
	Size: 0x195
	Parameters: 0
	Flags: None
*/
function function_b5bedb73()
{
	function_3b7290e2(level.claw_arm_l, "claw_l");
	function_3b7290e2(level.claw_arm_r, "claw_r");
	var_547ac401 = GetEntArray(level.rocket.target, "targetname");
	for(i = 0; i < var_547ac401.size; i++)
	{
		var_547ac401[i] Unlink();
	}
	var_326829bb = GetEntArray(level.var_ee72aac2.target, "targetname");
	for(i = 0; i < var_326829bb.size; i++)
	{
		var_326829bb[i] Unlink();
	}
	level.var_413d861 = GetEntArray("lifter_clamp", "targetname");
	for(i = 0; i < level.var_413d861.size; i++)
	{
		level.var_413d861[i] Unlink();
	}
}

/*
	Name: function_3015c292
	Namespace: namespace_860ef124
	Checksum: 0x44FCF602
	Offset: 0x20B0
	Size: 0x1D5
	Parameters: 0
	Flags: None
*/
function function_3015c292()
{
	function_b16a68c0(level.claw_arm_l, "claw_l");
	level.claw_arm_r = GetEnt("claw_r_arm", "targetname");
	function_b16a68c0(level.claw_arm_r, "claw_r");
	var_547ac401 = GetEntArray(level.rocket.target, "targetname");
	for(i = 0; i < var_547ac401.size; i++)
	{
		var_547ac401[i] LinkTo(level.rocket);
	}
	var_326829bb = GetEntArray(level.var_ee72aac2.target, "targetname");
	for(i = 0; i < var_326829bb.size; i++)
	{
		var_326829bb[i] LinkTo(level.var_ee72aac2);
	}
	level.var_413d861 = GetEntArray("lifter_clamp", "targetname");
	for(i = 0; i < level.var_413d861.size; i++)
	{
		level.var_413d861[i] LinkTo(level.var_3bc3f8d1);
	}
}

