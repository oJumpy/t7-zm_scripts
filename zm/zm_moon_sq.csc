#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_fx;

#namespace zm_moon_sq;

/*
	Name: init_clientfields
	Namespace: zm_moon_sq
	Checksum: 0xB3AD3C70
	Offset: 0x4B8
	Size: 0x44B
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	level._ctt_targets = [];
	zm_sidequests::register_sidequest_icon("vril", 21000);
	zm_sidequests::register_sidequest_icon("anti115", 21000);
	zm_sidequests::register_sidequest_icon("generator", 21000);
	zm_sidequests::register_sidequest_icon("cgenerator", 21000);
	zm_sidequests::register_sidequest_icon("wire", 21000);
	zm_sidequests::register_sidequest_icon("datalog", 21000);
	clientfield::register("world", "raise_rockets", 21000, 1, "counter", &function_14b62279, 0, 0);
	clientfield::register("world", "rocket_launch", 21000, 1, "counter", &rocket_launch, 0, 0);
	clientfield::register("world", "rocket_explode", 21000, 1, "counter", &rocket_explode, 0, 0);
	clientfield::register("world", "charge_tank_1", 21000, 1, "counter", &function_4df9054c, 0, 0);
	clientfield::register("world", "charge_tank_2", 21000, 1, "counter", &function_c0007487, 0, 0);
	clientfield::register("world", "charge_tank_cleanup", 21000, 1, "counter", &function_94570121, 0, 0);
	clientfield::register("world", "sam_vo_rumble", 21000, 1, "int", &sam_vo_rumble, 0, 0);
	clientfield::register("world", "charge_vril_init", 21000, 1, "int", &function_334865c, 0, 0);
	clientfield::register("world", "sq_wire_init", 21000, 1, "int", &function_224816ac, 0, 0);
	clientfield::register("world", "sam_init", 21000, 1, "int", &sam_init, 0, 0);
	n_bits = GetMinBitCountForNum(4);
	clientfield::register("world", "vril_generator", 21000, n_bits, "int", &function_bd20fe8, 0, 0);
	clientfield::register("world", "sam_end_rumble", 21000, 1, "int", &function_b134b86c, 0, 0);
}

/*
	Name: rocket_test
	Namespace: zm_moon_sq
	Checksum: 0x1787F7B3
	Offset: 0x910
	Size: 0x5
	Parameters: 0
	Flags: None
*/
function rocket_test()
{
	return;
}

/*
	Name: function_94570121
	Namespace: zm_moon_sq
	Checksum: 0x930E7D30
	Offset: 0x920
	Size: 0x47
	Parameters: 7
	Flags: None
*/
function function_94570121(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level._ctt_targets = [];
}

/*
	Name: dest_debug
	Namespace: zm_moon_sq
	Checksum: 0x3586D40A
	Offset: 0x970
	Size: 0x4D
	Parameters: 1
	Flags: None
*/
function dest_debug(dest)
{
	while(1)
	{
		/#
			print3d(dest, "Dev Block strings are not supported", VectorScale((1, 0, 0), 255), 30);
		#/
		wait(1);
	}
}

/*
	Name: vision_wobble
	Namespace: zm_moon_sq
	Checksum: 0x8BB418F4
	Offset: 0x9C8
	Size: 0x1EB
	Parameters: 0
	Flags: None
*/
function vision_wobble()
{
	SetDvar("r_poisonFX_debug_amount", 0);
	SetDvar("r_poisonFX_debug_enable", 1);
	SetDvar("r_poisonFX_pulse", 2);
	SetDvar("r_poisonFX_warpX", -0.3);
	SetDvar("r_poisonFX_warpY", 0.15);
	SetDvar("r_poisonFX_dvisionA", 0);
	SetDvar("r_poisonFX_dvisionX", 0);
	SetDvar("r_poisonFX_dvisionY", 0);
	SetDvar("r_poisonFX_blurMin", 0);
	SetDvar("r_poisonFX_blurMax", 3);
	delta = 0.064;
	amount = 1;
	SetDvar("r_poisonFX_debug_amount", amount);
	WaitRealTime(3);
	while(amount > 0)
	{
		amount = max(amount - delta, 0);
		SetDvar("r_poisonFX_debug_amount", amount);
		wait(0.016);
	}
	SetDvar("r_poisonFX_debug_amount", 0);
	SetDvar("r_poisonFX_debug_enable", 0);
}

/*
	Name: soul_swap
	Namespace: zm_moon_sq
	Checksum: 0x1FE40261
	Offset: 0xBC0
	Size: 0x25D
	Parameters: 7
	Flags: None
*/
function soul_swap(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	if(bNewEnt)
	{
		return;
	}
	if(!newVal)
	{
		return;
	}
	if(GetLocalPlayers().size == 1)
	{
		level thread vision_wobble();
	}
	for(i = 0; i < GetLocalPlayers().size; i++)
	{
		e = spawn(i, self.origin + VectorScale((0, 0, 1), 24), "script_model");
		e SetModel("tag_origin");
		if(i == 0)
		{
			e playsound(0, "zmb_squest_soul_leave");
		}
		e thread ctt_trail_runner(i, "soul_swap_trail", level._sam.origin + VectorScale((0, 0, 1), 24));
		e = spawn(i, level._sam.origin + VectorScale((0, 0, 1), 24), "script_model");
		e SetModel("tag_origin");
		if(i == 0)
		{
			e playsound(0, "zmb_squest_soul_leave");
		}
		e thread ctt_trail_runner(i, "soul_swap_trail", self.origin + VectorScale((0, 0, 1), 24));
	}
}

/*
	Name: ctt_trail_runner
	Namespace: zm_moon_sq
	Checksum: 0x558491B7
	Offset: 0xE28
	Size: 0xB3
	Parameters: 3
	Flags: None
*/
function ctt_trail_runner(localClientNum, fx_name, dest)
{
	PlayFXOnTag(localClientNum, level._effect[fx_name], self, "tag_origin");
	self moveto(dest, 0.5);
	self waittill("movedone");
	playsound(0, "zmb_squest_soul_impact", dest);
	self delete();
}

/*
	Name: zombie_release_soul
	Namespace: zm_moon_sq
	Checksum: 0xB518D361
	Offset: 0xEE8
	Size: 0x263
	Parameters: 7
	Flags: None
*/
function zombie_release_soul(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	closest = undefined;
	min_dist = 99980001;
	for(i = 0; i < level._ctt_targets.size; i++)
	{
		dist = DistanceSquared(self.origin, level._ctt_targets[i].origin);
		if(dist < min_dist)
		{
			min_dist = dist;
			closest = level._ctt_targets[i];
		}
	}
	if(isdefined(closest))
	{
		/#
			println("Dev Block strings are not supported" + self.origin + "Dev Block strings are not supported" + closest.origin);
		#/
		for(i = 0; i < GetLocalPlayers().size; i++)
		{
			e = spawn(i, self.origin + VectorScale((0, 0, 1), 24), "script_model");
			e SetModel("tag_origin");
			if(i == 0)
			{
				e playsound(0, "zmb_squest_soul_leave");
			}
			e thread ctt_trail_runner(i, "fx_weak_sauce_trail", closest.origin - VectorScale((0, 0, 1), 12));
		}
	}
	else
	{
		println("Dev Block strings are not supported");
	}
	/#
	#/
}

/*
	Name: build_ctt_targets
	Namespace: zm_moon_sq
	Checksum: 0xCEDDB7AB
	Offset: 0x1158
	Size: 0x1E7
	Parameters: 2
	Flags: None
*/
function build_ctt_targets(tank_names, second_names)
{
	ret_array = [];
	tanks = struct::get_array(tank_names, "targetname");
	/#
		println("Dev Block strings are not supported");
	#/
	for(i = 0; i < tanks.size; i++)
	{
		tank = tanks[i];
		capacitor = struct::get(tank.target, "targetname");
		s_target = struct::get(capacitor.target, "targetname");
		ret_array[ret_array.size] = s_target;
	}
	if(isdefined(second_names))
	{
		tanks = struct::get_array(second_names, "targetname");
		for(i = 0; i < tanks.size; i++)
		{
			tank = tanks[i];
			capacitor = struct::get(tank.target, "targetname");
			s_target = struct::get(capacitor.target, "targetname");
			ret_array[ret_array.size] = s_target;
		}
	}
	return ret_array;
}

/*
	Name: function_334865c
	Namespace: zm_moon_sq
	Checksum: 0xE37A84EE
	Offset: 0x1348
	Size: 0x11D
	Parameters: 7
	Flags: None
*/
function function_334865c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		targs = struct::get_array("sq_cp_final", "targetname");
		for(i = 0; i < targs.size; i++)
		{
			targ = targs[i];
			var_93d55a25 = util::spawn_model(localClientNum, targ.model, targ.origin, targ.angles);
			var_93d55a25 playsound(localClientNum, "evt_clank");
		}
	}
}

/*
	Name: function_224816ac
	Namespace: zm_moon_sq
	Checksum: 0x6F84C5F0
	Offset: 0x1470
	Size: 0xDB
	Parameters: 7
	Flags: None
*/
function function_224816ac(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		targ = struct::get("sq_wire_final", "targetname");
		var_93d55a25 = util::spawn_model(localClientNum, targ.model, targ.origin, targ.angles);
		var_93d55a25 playsound(localClientNum, "evt_start_old_computer");
	}
}

/*
	Name: sam_rise_and_bob
	Namespace: zm_moon_sq
	Checksum: 0xC97E5AFC
	Offset: 0x1558
	Size: 0x14F
	Parameters: 1
	Flags: None
*/
function sam_rise_and_bob(struct)
{
	endPos = struct::get(struct.target, "targetname");
	self moveto(endPos.origin, 3);
	self waittill("movedone");
	start_z = self.origin;
	amplitude = 7;
	frequency = 75;
	t = 0;
	level._sam = self;
	while(1)
	{
		normalized_wave_height = sin(frequency * t);
		wave_height_z = amplitude * normalized_wave_height;
		self.origin = start_z + (0, 0, wave_height_z);
		t = t + 0.016;
		wait(0.016);
	}
}

/*
	Name: sam_init
	Namespace: zm_moon_sq
	Checksum: 0xEC7F178A
	Offset: 0x16B0
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function sam_init(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		targ = struct::get("sq_sam", "targetname");
		var_93d55a25 = util::spawn_model(localClientNum, targ.model, targ.origin, targ.angles);
		playFX(localClientNum, level._effect["lght_marker_flare"], targ.origin);
		var_93d55a25 thread sam_rise_and_bob(targ);
		var_93d55a25 PlayLoopSound("evt_samantha_reveal_loop", 1);
	}
}

/*
	Name: bob_vg
	Namespace: zm_moon_sq
	Checksum: 0xCE9E6F97
	Offset: 0x17E0
	Size: 0xDF
	Parameters: 0
	Flags: None
*/
function bob_vg()
{
	self endon("death");
	start_z = self.origin;
	amplitude = 2;
	frequency = 100;
	t = 0;
	while(1)
	{
		normalized_wave_height = sin(frequency * t);
		wave_height_z = amplitude * normalized_wave_height;
		self.origin = start_z + (0, 0, wave_height_z);
		t = t + 0.016;
		wait(0.016);
	}
}

/*
	Name: function_bd20fe8
	Namespace: zm_moon_sq
	Checksum: 0xEE4A25CB
	Offset: 0x18C8
	Size: 0x2F1
	Parameters: 7
	Flags: None
*/
function function_bd20fe8(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	targ = struct::get("sq_charge_vg_pos", "targetname");
	if(!isdefined(level.a_ents))
	{
		level.a_ents = [];
	}
	switch(newVal)
	{
		case 1:
		{
			var_93d55a25 = util::spawn_model(localClientNum, targ.model, targ.origin, targ.angles);
			var_93d55a25 thread bob_vg();
			level.a_ents[level.a_ents.size] = var_93d55a25;
			break;
		}
		case 2:
		{
			for(i = 0; i < level.a_ents.size; i++)
			{
				PlayFXOnTag(localClientNum, level._effect["vrill_glow"], level.a_ents[i], "tag_origin");
			}
			break;
		}
		case 3:
		{
			for(j = 0; j < level.a_ents.size; j++)
			{
				level.a_ents[j] delete();
			}
			level.a_ents = [];
			break;
		}
		case 4:
		{
			var_dbd86497 = struct::get("sq_vg_final", "targetname");
			level.a_ents = [];
			var_93d55a25 = util::spawn_model(localClientNum, var_dbd86497.model, var_dbd86497.origin, var_dbd86497.angles);
			level.a_ents[level.a_ents.size] = var_93d55a25;
			for(i = 0; i < level.a_ents.size; i++)
			{
				PlayFXOnTag(localClientNum, level._effect["vrill_glow"], level.a_ents[i], "tag_origin");
			}
			level._override_eye_fx = level._effect["blue_eyes"];
			break;
		}
	}
}

/*
	Name: function_4df9054c
	Namespace: zm_moon_sq
	Checksum: 0xCF01B906
	Offset: 0x1BC8
	Size: 0x5B
	Parameters: 7
	Flags: None
*/
function function_4df9054c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level._ctt_targets = build_ctt_targets("sq_first_tank");
}

/*
	Name: function_c0007487
	Namespace: zm_moon_sq
	Checksum: 0x9499ED76
	Offset: 0x1C30
	Size: 0x63
	Parameters: 7
	Flags: None
*/
function function_c0007487(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level._ctt_targets = build_ctt_targets("sq_second_tank", "sq_first_tank");
}

/*
	Name: function_b134b86c
	Namespace: zm_moon_sq
	Checksum: 0xD58008BB
	Offset: 0x1CA0
	Size: 0x75
	Parameters: 7
	Flags: None
*/
function function_b134b86c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 1)
	{
		level thread do_sr_rumble(localClientNum);
	}
	else
	{
		level notify("hash_f9b2abc9");
	}
}

/*
	Name: do_sr_rumble
	Namespace: zm_moon_sq
	Checksum: 0xC650302B
	Offset: 0x1D20
	Size: 0x137
	Parameters: 1
	Flags: None
*/
function do_sr_rumble(localClientNum)
{
	level endon("hash_f9b2abc9");
	var_845cd5d1 = struct::get("pyramid_walls_retract", "targetname");
	while(1)
	{
		a_players = GetLocalPlayers();
		for(i = 0; i < a_players.size; i++)
		{
			if(!isdefined(a_players[i]))
			{
				continue;
			}
			if(DistanceSquared(var_845cd5d1.origin, a_players[i].origin) < 562500)
			{
				a_players[i] PlayRumbleOnEntity(localClientNum, "slide_rumble");
			}
		}
		wait(RandomFloatRange(0.05, 0.15));
	}
}

/*
	Name: sam_vo_rumble
	Namespace: zm_moon_sq
	Checksum: 0xAA1A7B90
	Offset: 0x1E60
	Size: 0x8D
	Parameters: 7
	Flags: None
*/
function sam_vo_rumble(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		Array::thread_all(GetLocalPlayers(), &function_9b1295b1, localClientNum);
	}
	else
	{
		level notify("hash_306cf2d4");
	}
}

/*
	Name: function_9b1295b1
	Namespace: zm_moon_sq
	Checksum: 0xD533178D
	Offset: 0x1EF8
	Size: 0xAF
	Parameters: 1
	Flags: None
*/
function function_9b1295b1(localClientNum)
{
	self endon("disconnect");
	level endon("hash_306cf2d4");
	while(1)
	{
		self Earthquake(RandomFloatRange(0.2, 0.25), 5, self.origin, 100);
		self PlayRumbleOnEntity(localClientNum, "slide_rumble");
		wait(RandomFloatRange(0.1, 0.15));
	}
}

/*
	Name: function_14b62279
	Namespace: zm_moon_sq
	Checksum: 0xBFDD5E48
	Offset: 0x1FB0
	Size: 0x69
	Parameters: 7
	Flags: None
*/
function function_14b62279(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level thread do_rr_rumble();
	wait(4.5);
	level notify("_stop_rr");
}

/*
	Name: do_rr_rumble
	Namespace: zm_moon_sq
	Checksum: 0xFECA1520
	Offset: 0x2028
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function do_rr_rumble()
{
	level endon("_stop_rr");
	while(1)
	{
		for(i = 0; i < level.localPlayers.size; i++)
		{
			player = GetLocalPlayers()[i];
			if(!isdefined(player))
			{
				continue;
			}
			player Earthquake(RandomFloatRange(0.15, 0.2), 5, player.origin, 100);
			player PlayRumbleOnEntity(i, "slide_rumble");
		}
		wait(RandomFloatRange(0.1, 0.15));
	}
}

/*
	Name: rocket_launch
	Namespace: zm_moon_sq
	Checksum: 0x921B9621
	Offset: 0x2130
	Size: 0x65
	Parameters: 7
	Flags: None
*/
function rocket_launch(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level thread do_rl_rumble();
	wait(6);
	level notify("_stop_rl");
}

/*
	Name: do_rl_rumble
	Namespace: zm_moon_sq
	Checksum: 0xFB2814C2
	Offset: 0x21A0
	Size: 0xFF
	Parameters: 0
	Flags: None
*/
function do_rl_rumble()
{
	level endon("_stop_rl");
	while(1)
	{
		for(i = 0; i < level.localPlayers.size; i++)
		{
			player = GetLocalPlayers()[i];
			if(!isdefined(player))
			{
				continue;
			}
			player Earthquake(RandomFloatRange(0.26, 0.31), 5, player.origin, 100);
			player PlayRumbleOnEntity(i, "damage_light");
		}
		wait(RandomFloatRange(0.1, 0.15));
	}
}

/*
	Name: rocket_explode
	Namespace: zm_moon_sq
	Checksum: 0x91AFDD3B
	Offset: 0x22A8
	Size: 0x75
	Parameters: 7
	Flags: None
*/
function rocket_explode(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level._dte_done = 1;
	wait(3.5);
	level thread do_de_rumble();
	wait(4);
	level notify("_stop_de");
}

/*
	Name: do_de_rumble
	Namespace: zm_moon_sq
	Checksum: 0x793E2651
	Offset: 0x2328
	Size: 0x1BF
	Parameters: 0
	Flags: None
*/
function do_de_rumble()
{
	level endon("_stop_de");
	for(i = 0; i < level.localPlayers.size; i++)
	{
		player = GetLocalPlayers()[i];
		if(!isdefined(player))
		{
			continue;
		}
		player Earthquake(RandomFloatRange(0.4, 0.45), 5, player.origin, 100);
		player PlayRumbleOnEntity(i, "damage_heavy");
	}
	wait(0.2);
	while(1)
	{
		for(i = 0; i < level.localPlayers.size; i++)
		{
			player = GetLocalPlayers()[i];
			if(!isdefined(player))
			{
				continue;
			}
			player Earthquake(RandomFloatRange(0.35, 0.4), 5, player.origin, 100);
			player PlayRumbleOnEntity(i, "damage_light");
		}
		wait(RandomFloatRange(0.1, 0.15));
	}
}

/*
	Name: function_38a2773c
	Namespace: zm_moon_sq
	Checksum: 0x74636DAE
	Offset: 0x24F0
	Size: 0x123
	Parameters: 7
	Flags: None
*/
function function_38a2773c(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(localClientNum != 0)
	{
		return;
	}
	var_8c15cb32 = struct::get("sd_bowl", "targetname");
	e_origin = util::spawn_model(localClientNum, "tag_origin", self.origin + VectorScale((0, 0, 1), 24));
	if(localClientNum == 0)
	{
		e_origin playsound(localClientNum, "zmb_squest_soul_leave");
	}
	e_origin thread ctt_trail_runner(localClientNum, "fx_weak_sauce_trail", var_8c15cb32.origin - VectorScale((0, 0, 1), 12));
}

