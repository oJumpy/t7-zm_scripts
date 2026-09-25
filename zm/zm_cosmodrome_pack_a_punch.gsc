#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\zm_cosmodrome;
#using scripts\zm\zm_cosmodrome_amb;
#using scripts\zm\zm_cosmodrome_traps;

#namespace namespace_caf9f66;

/*
	Name: pack_a_punch_main
	Namespace: namespace_caf9f66
	Checksum: 0xFBCE430C
	Offset: 0x5D8
	Size: 0x1AB
	Parameters: 0
	Flags: None
*/
function pack_a_punch_main()
{
	level flag::init("lander_a_used");
	level flag::init("lander_b_used");
	level flag::init("lander_c_used");
	level flag::init("launch_activated");
	level flag::init("launch_complete");
	level.var_dae473ca = 0;
	level.var_35e4c5d2 = GetEnt("rocket_room_bottom_door", "targetname");
	level.var_35e4c5d2.clip = GetEnt(level.var_35e4c5d2.target, "targetname");
	level.var_35e4c5d2.clip LinkTo(level.var_35e4c5d2);
	var_62a180b9 = GetEnt("trig_launch_rocket", "targetname");
	var_62a180b9 thread function_5879d337();
	level thread function_d1768dd1();
	level thread function_808b0397();
}

/*
	Name: function_d1768dd1
	Namespace: namespace_caf9f66
	Checksum: 0x8286DFC1
	Offset: 0x790
	Size: 0x14B
	Parameters: 0
	Flags: None
*/
function function_d1768dd1()
{
	if(GetDvarString("rocket_test") != "")
	{
		level flag::set("lander_a_used");
		level flag::set("lander_b_used");
		level flag::set("lander_c_used");
	}
	level flag::wait_till("lander_a_used");
	level flag::wait_till("lander_b_used");
	level flag::wait_till("lander_c_used");
	level thread function_aa54d23a();
	wait(4);
	level flag::wait_till("launch_complete");
	function_46ff5b62("punch activate");
	level thread function_c680451d();
}

/*
	Name: function_aa54d23a
	Namespace: namespace_caf9f66
	Checksum: 0x8BE524A0
	Offset: 0x8E8
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_aa54d23a()
{
	wait(5.5);
	namespace_860ef124::function_3015c292();
	level thread namespace_860ef124::function_d1419acd();
	level namespace_860ef124::function_eee1cbd0();
	namespace_860ef124::function_b5bedb73();
}

/*
	Name: function_808b0397
	Namespace: namespace_caf9f66
	Checksum: 0x88860F33
	Offset: 0x950
	Size: 0x49
	Parameters: 0
	Flags: None
*/
function function_808b0397()
{
	level waittill("new_lander_used");
	exploder::exploder("fxexp_5601");
	level waittill("new_lander_used");
	wait(6);
	level notify("hash_526ede95");
}

/*
	Name: function_da5288f1
	Namespace: namespace_caf9f66
	Checksum: 0xDA90F3C0
	Offset: 0x9A8
	Size: 0x63
	Parameters: 0
	Flags: None
*/
function function_da5288f1()
{
	move_dist = -228;
	level.var_35e4c5d2 MoveZ(move_dist, 1.5);
	level.var_35e4c5d2 waittill("movedone");
	level.var_35e4c5d2 disconnectpaths();
}

/*
	Name: function_c680451d
	Namespace: namespace_caf9f66
	Checksum: 0x92244C3E
	Offset: 0xA18
	Size: 0x1B3
	Parameters: 0
	Flags: None
*/
function function_c680451d()
{
	level flag::set("rocket_group");
	var_4cf008b0 = GetEnt("rocket_room_top_door", "targetname");
	var_4cf008b0.clip = GetEnt(var_4cf008b0.target, "targetname");
	var_4cf008b0.clip LinkTo(var_4cf008b0);
	var_4cf008b0 moveto(var_4cf008b0.origin + var_4cf008b0.script_vector, 1.5);
	level.var_35e4c5d2 moveto(level.var_35e4c5d2.origin + level.var_35e4c5d2.script_vector, 1.5);
	level.var_35e4c5d2.clip notsolid();
	var_4cf008b0 playsound("zmb_heavy_door_open");
	level.var_35e4c5d2.clip playsound("zmb_heavy_door_open");
	level.var_35e4c5d2 waittill("movedone");
	level.var_35e4c5d2.clip connectpaths();
}

/*
	Name: function_46ff5b62
	Namespace: namespace_caf9f66
	Checksum: 0xB125D487
	Offset: 0xBD8
	Size: 0x3B
	Parameters: 1
	Flags: None
*/
function function_46ff5b62(STR)
{
	/#
		if(isdefined(level.var_dae473ca) && level.var_dae473ca)
		{
			iprintln(STR);
		}
	#/
}

/*
	Name: function_5879d337
	Namespace: namespace_caf9f66
	Checksum: 0x875E9C6E
	Offset: 0xC20
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function function_5879d337()
{
	panel = GetEnt("rocket_launch_panel", "targetname");
	self UseTriggerRequireLookAt();
	self setHintString(&"ZOMBIE_NEED_POWER");
	self setcursorhint("HINT_NOICON");
	level waittill("Pack_A_Punch_on");
	self setHintString(&"ZM_COSMODROME_WAITING_AUTHORIZATION");
	level flag::wait_till("launch_activated");
	self setHintString(&"ZM_COSMODROME_LAUNCH_AVAILABLE");
	panel SetModel("p7_zm_asc_console_launch_key_full_green");
	/#
		self thread namespace_670cb61::function_620401c0(self.origin, "Dev Block strings are not supported", "Dev Block strings are not supported");
	#/
	self waittill("trigger", who);
	panel playsound("zmb_comp_activate");
	level thread namespace_9dd378ec::play_cosmo_announcer_vox("vox_ann_launch_button");
	level thread function_fae804e8();
	self delete();
}

/*
	Name: function_8010243c
	Namespace: namespace_caf9f66
	Checksum: 0x16DB88CA
	Offset: 0xDF0
	Size: 0x173
	Parameters: 0
	Flags: None
*/
function function_8010243c()
{
	level endon("hash_3f1deee4");
	level.var_2d489c29 = GetEnt("rocket_base_engine", "script_noteworthy");
	level.var_2d489c29 PlayLoopSound("zmb_rocket_launch", 0.1);
	wait(2);
	level.var_4ba14d27 = spawn("script_origin", (0, 0, 0));
	level.var_d999ddec = spawn("script_origin", (0, 0, 0));
	level.var_4ba14d27 PlayLoopSound("zmb_rocket_air_distf", 0.1);
	level.var_d999ddec PlayLoopSound("zmb_rocket_air_distr", 0.1);
	wait(22);
	level.var_2d489c29 StopLoopSound(1);
	wait(46);
	level.var_4ba14d27 StopLoopSound(1);
	level.var_d999ddec StopLoopSound(1);
	level thread function_aae7a344();
}

/*
	Name: function_aae7a344
	Namespace: namespace_caf9f66
	Checksum: 0x6BB114D3
	Offset: 0xF70
	Size: 0x5B
	Parameters: 0
	Flags: None
*/
function function_aae7a344()
{
	wait(5);
	if(isdefined(level.var_4ba14d27))
	{
		level.var_4ba14d27 delete();
	}
	if(isdefined(level.var_d999ddec))
	{
		level.var_d999ddec delete();
	}
}

/*
	Name: function_fae804e8
	Namespace: namespace_caf9f66
	Checksum: 0xCE6B568E
	Offset: 0xFD8
	Size: 0x1FB
	Parameters: 0
	Flags: None
*/
function function_fae804e8()
{
	level.var_36aa4be7 RotateYaw(60, 6);
	level.var_82af40b9 RotateYaw(-60, 6);
	level.var_82af40b9 playsound("zmb_rocket_disengage");
	level.var_82af40b9 playsound("zmb_rocket_start");
	wait(3);
	rocket_base = GetEnt("rocket_base_engine", "script_noteworthy");
	level thread function_8010243c();
	namespace_860ef124::function_b16a68c0(level.claw_arm_l, "claw_l");
	namespace_860ef124::function_b16a68c0(level.claw_arm_r, "claw_r");
	wait(2);
	for(i = 5; i > 0; i--)
	{
		level thread namespace_9dd378ec::play_cosmo_announcer_vox("vox_ann_launch_countdown_" + i, 1, 1);
		wait(1);
		if(i == 4)
		{
			level.claw_arm_r moveto(level.var_c234410e, 4);
			level.claw_arm_l moveto(level.var_eebefbf0, 4);
			exploder::exploder("fxexp_5602");
		}
	}
	function_c7ec6a1e();
}

/*
	Name: function_c7ec6a1e
	Namespace: namespace_caf9f66
	Checksum: 0xB4D5382C
	Offset: 0x11E0
	Size: 0x2F3
	Parameters: 0
	Flags: None
*/
function function_c7ec6a1e()
{
	var_547ac401 = GetEntArray(level.rocket.target, "targetname");
	for(i = 0; i < var_547ac401.size; i++)
	{
		var_547ac401[i] LinkTo(level.rocket);
	}
	level endon("hash_3f1deee4");
	rocket_base = GetEnt("rocket_base_engine", "script_noteworthy");
	exploder::stop_exploder("fxexp_5601");
	exploder::exploder("fxexp_5701");
	rocket_base clientfield::set("COSMO_ROCKET_FX", 1);
	level thread function_1187f9a0();
	wait(1);
	level thread namespace_9dd378ec::play_cosmo_announcer_vox("vox_ann_engines_firing", 1);
	level.rocket SetForceNoCull();
	level.rocket moveto(level.rocket.origin + VectorScale((0, 0, 1), 50000), 50, 45);
	wait(5);
	namespace_860ef124::function_3b7290e2(level.claw_arm_l, "claw_l");
	namespace_860ef124::function_3b7290e2(level.claw_arm_r, "claw_r");
	level thread function_ae1ee1a6();
	wait(5);
	level flag::set("launch_complete");
	level thread namespace_9dd378ec::play_cosmo_announcer_vox("vox_ann_after_launch");
	wait(20);
	level notify("hash_95b78d27");
	level.rocket waittill("movedone");
	var_547ac401 = GetEntArray(level.rocket.target, "targetname");
	for(i = 0; i < var_547ac401.size; i++)
	{
		var_547ac401[i] delete();
	}
	level.rocket delete();
}

/*
	Name: function_1187f9a0
	Namespace: namespace_caf9f66
	Checksum: 0x9B530CF2
	Offset: 0x14E0
	Size: 0x1C3
	Parameters: 0
	Flags: None
*/
function function_1187f9a0()
{
	level endon("hash_95b78d27");
	level endon("hash_8ad7ea66");
	while(isdefined(level.rocket))
	{
		players = GetPlayers();
		var_b7ebb0e7 = [];
		for(i = 0; i < players.size; i++)
		{
			if(DistanceSquared(players[i].origin, level.rocket.origin) < 30250000)
			{
				var_b7ebb0e7[var_b7ebb0e7.size] = players[i];
			}
		}
		if(var_b7ebb0e7.size < 1)
		{
			wait(0.1);
			continue;
		}
		Earthquake(RandomFloatRange(0.15, 0.35), RandomFloatRange(0.25, 0.5), level.rocket.origin, 5500);
		rumble = "slide_rumble";
		for(i = 0; i < var_b7ebb0e7.size; i++)
		{
			var_b7ebb0e7[i] PlayRumbleOnEntity(rumble);
		}
		wait(0.1);
	}
}

/*
	Name: function_ae1ee1a6
	Namespace: namespace_caf9f66
	Checksum: 0x6A08B6C5
	Offset: 0x16B0
	Size: 0x223
	Parameters: 0
	Flags: None
*/
function function_ae1ee1a6()
{
	level endon("hash_95b78d27");
	var_547ac401 = GetEntArray(level.rocket.target, "targetname");
	Array::thread_all(var_547ac401, &function_d85238b3);
	level.rocket thread function_d85238b3();
	level waittill("hash_3f1deee4");
	playsoundatposition("zmb_rocket_destroyed", (0, 0, 0));
	level.rocket thread rocket_explode();
	level.rocket thread function_f748bf98();
	ArrayRemoveValue(var_547ac401, level.var_be9553f1);
	level.var_be9553f1 Unlink();
	level.var_be9553f1 show();
	level.var_be9553f1 thread scene::Play("p7_fxanim_zm_asc_rocket_explode_debris_bundle", level.var_be9553f1);
	var_8094093b = GetEnt("rocket_base_engine", "script_noteworthy");
	var_8094093b clientfield::set("COSMO_ROCKET_FX", 0);
	for(i = 0; i < var_547ac401.size; i++)
	{
		var_547ac401[i] thread function_24d5fd7f();
	}
	wait(2);
	if(!level flag::get("launch_complete"))
	{
		level flag::set("launch_complete");
	}
}

/*
	Name: function_24d5fd7f
	Namespace: namespace_caf9f66
	Checksum: 0x1480AB46
	Offset: 0x18E0
	Size: 0x53
	Parameters: 0
	Flags: None
*/
function function_24d5fd7f()
{
	self Unlink();
	self ghost();
	wait(5);
	self delete();
}

/*
	Name: function_f748bf98
	Namespace: namespace_caf9f66
	Checksum: 0xB11A85BE
	Offset: 0x1940
	Size: 0x25B
	Parameters: 1
	Flags: None
*/
function function_f748bf98(num)
{
	trace = bullettrace(self.origin, self.origin + (randomIntRange(-100, 100), randomIntRange(-100, 100), -20000), 0, self);
	ground_pos = trace["position"] + VectorScale((0, 0, 1), 1.5);
	self moveto(ground_pos, 3);
	self RotateTo((randomIntRange(-360, 360), randomIntRange(-360, 360), randomIntRange(-360, 360)), 3.9);
	wait(3.9);
	Earthquake(RandomFloatRange(0.25, 0.45), RandomFloatRange(0.65, 0.75), self.origin, 5500);
	if(isdefined(num))
	{
		if(num == 0)
		{
			self playsound("zmb_rocket_top_crash");
		}
		else if(num == 1)
		{
			self playsound("zmb_rocket_bottom_crash");
		}
	}
	if(self == level.rocket)
	{
		PlayFXOnTag(level._effect["rocket_exp_2"], self, "tag_origin");
	}
	wait(1);
	self Hide();
	wait(10);
	self delete();
}

/*
	Name: function_d85238b3
	Namespace: namespace_caf9f66
	Checksum: 0xC50B2264
	Offset: 0x1BA8
	Size: 0x16B
	Parameters: 0
	Flags: None
*/
function function_d85238b3()
{
	level endon("hash_af9831cd");
	self SetCanDamage(1);
	self waittill("damage", dmg_amount, attacker, dir, point, dmg_type);
	if(isPlayer(attacker) && (dmg_type == "MOD_PROJECTILE" || dmg_type == "MOD_PROJECTILE_SPLASH" || dmg_type == "MOD_EXPLOSIVE" || dmg_type == "MOD_EXPLOSIVE_SPLASH" || dmg_type == "MOD_GRENADE" || dmg_type == "MOD_GRENADE_SPLASH"))
	{
		level notify("hash_3f1deee4");
		level.var_2d489c29 StopLoopSound(1);
		level.var_4ba14d27 StopLoopSound(1);
		level.var_d999ddec StopLoopSound(1);
		level thread function_aae7a344();
	}
}

/*
	Name: rocket_explode
	Namespace: namespace_caf9f66
	Checksum: 0xB2F89A8C
	Offset: 0x1D20
	Size: 0xAB
	Parameters: 0
	Flags: None
*/
function rocket_explode()
{
	PlayFXOnTag(level._effect["rocket_exp_1"], self, "tag_origin");
	self playsound("zmb_rocket_stage_1_exp");
	wait(2);
	var_6d564cb6 = struct::get("pressure_pad", "targetname");
	zm_powerups::specific_powerup_drop("double_points", var_6d564cb6.origin);
}

